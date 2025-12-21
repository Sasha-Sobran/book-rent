import 'dart:typed_data';

import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/books_api.dart';
import 'package:library_kursach/api/common_api.dart';
import 'package:library_kursach/api/libraries_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/models/library.dart';
import 'package:library_kursach/models/settings.dart';

class BooksCubit extends Cubit<BookState> {
  BooksCubit() : super(BookState());

  final _booksApi = GetItService().instance<BooksApi>();
  final _librariesApi = GetItService().instance<LibrariesApi>();
  final _commonApi = GetItService().instance<CommonApi>();
  final searchController = TextEditingController();

  void init() {
    loadLibrariesAndBooks();
  }

  Future<(List<Genre>, List<Category>)> _reloadTaxonomies() async {
    final genres = await _commonApi.getGenres();
    final categories = await _commonApi.getCategories();
    return (genres, categories);
  }

  Future<void> loadLibrariesAndBooks() async {
    emit(state.copyWith(isLoadingLibraries: true, isLoading: true));
    try {
      final appCubit = GetItService().instance<AppCubit>();
      final user = appCubit.state.user;
      final isLibrarian = user?.isLibrarian == true;
      
      final myLib = await _librariesApi.getMyLibrary();
      final libs = await _librariesApi.getLibraries();
      final genres = await _commonApi.getGenres();
      final categories = await _commonApi.getCategories();
      
      Library? selected;
      if (isLibrarian) {
        selected = myLib;
        if (selected == null && libs.isNotEmpty) {
          selected = libs.first;
        }
      } else {
        selected = null;
      }
      
      emit(
        state.copyWith(
          libraries: libs,
          selectedLibrary: selected,
          myLibraryId: myLib?.id,
          isLoadingLibraries: false,
          genres: genres,
          categories: categories,
        ),
      );
      await getBooks(libraryId: selected?.id);
    } on DioError catch (e) {
      emit(
        state.copyWith(
          isLoadingLibraries: false,
          isLoading: false,
          error: e.message,
        ),
      );
    }
  }

  Future<void> getBooks({
    int? libraryId,
    String? search,
    List<int>? categoryIds,
    List<int>? genreIds,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      final books = await _booksApi.getBooks(
        libraryId: libraryId ?? state.selectedLibrary?.id,
        search: search ?? state.searchQuery,
        categoryIds: categoryIds ?? state.selectedCategoryIds,
        genreIds: genreIds ?? state.selectedGenreIds,
      );
      emit(state.copyWith(books: books, isLoading: false));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> selectLibrary(Library? library) async {
    emit(
      state.copyWith(
        selectedLibrary: library,
        clearSelectedLibrary: library == null,
      ),
    );
    await getBooks(libraryId: library?.id);
  }

  Future<void> filterByQuery(String query) async {
    emit(state.copyWith(searchQuery: query));
    await getBooks(search: query);
  }

  Future<void> filterByGenres(List<int> genreIds) async {
    emit(state.copyWith(selectedGenreIds: genreIds));
    await getBooks(genreIds: genreIds);
  }

  Future<void> filterByCategories(List<int> categoryIds) async {
    emit(state.copyWith(selectedCategoryIds: categoryIds));
    await getBooks(categoryIds: categoryIds);
  }

  Future<void> resetFilters() async {
    searchController.clear();
    emit(
      state.copyWith(
        selectedGenreIds: const [],
        selectedCategoryIds: const [],
        searchQuery: '',
        resetTick: state.resetTick + 1,
      ),
    );
    await getBooks(search: '', categoryIds: const [], genreIds: const []);
  }

  Future<Book?> createBook(
    BuildContext context, {
    required String title,
    required String author,
    required double price,
    required String publishYear,
    required int quantity,
    List<int>? categoryIds,
    List<int>? genreIds,
    List<String>? newCategories,
    List<String>? newGenres,
  }) async {
    try {
      final libraryId = state.selectedLibrary?.id ?? state.myLibraryId;
      if (libraryId == null) {
        if (context.mounted) {
          AppSnackbar.error(context, 'Бібліотеку не знайдено');
        }
        return null;
      }
      final book = await _booksApi.createBook(
        title: title,
        author: author,
        price: price,
        publishYear: publishYear,
        quantity: quantity,
        categoryIds: categoryIds,
        genreIds: genreIds,
        newCategories: newCategories,
        newGenres: newGenres,
      );
      final updatedTaxonomies = await _reloadTaxonomies();
      emit(
        state.copyWith(
          books: [...state.books, book],
          genres: updatedTaxonomies.$1,
          categories: updatedTaxonomies.$2,
        ),
      );
      if (context.mounted) AppSnackbar.success(context, 'Книгу додано');
      return book;
    } on DioError catch (e) {
      if (context.mounted) {
        AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
      }
      return null;
    }
  }

  Future<void> updateBook(
    BuildContext context,
    int id, {
    String? title,
    String? author,
    double? price,
    String? publishYear,
    int? quantity,
    int? libraryId,
    List<int>? categoryIds,
    List<int>? genreIds,
    List<String>? newCategories,
    List<String>? newGenres,
  }) async {
    try {
      final updated = await _booksApi.updateBook(
        id,
        title: title,
        author: author,
        price: price,
        publishYear: publishYear,
        quantity: quantity,
        libraryId: libraryId,
        categoryIds: categoryIds,
        genreIds: genreIds,
        newCategories: newCategories,
        newGenres: newGenres,
      );
      final updatedTaxonomies = await _reloadTaxonomies();
      emit(
        state.copyWith(
          books: state.books.map((b) => b.id == id ? updated : b).toList(),
          genres: updatedTaxonomies.$1,
          categories: updatedTaxonomies.$2,
        ),
      );
      if (context.mounted) AppSnackbar.success(context, 'Книгу оновлено');
    } on DioError catch (e) {
      if (context.mounted) {
        AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
      }
    }
  }

  Future<void> deleteBook(BuildContext context, int id) async {
    try {
      await _booksApi.deleteBook(id);
      emit(
        state.copyWith(books: state.books.where((b) => b.id != id).toList()),
      );
      if (context.mounted) AppSnackbar.success(context, 'Книгу видалено');
    } on DioError catch (e) {
      if (context.mounted) {
        AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
      }
    }
  }

  Future<void> uploadBookImage(BuildContext context, int bookId, String imagePath, [Uint8List? imageBytes, String? fileName]) async {
    try {
      final imageUrl = await _booksApi.uploadBookImage(bookId, imagePath, imageBytes, fileName);
      emit(
        state.copyWith(
          books: state.books.map((b) => b.id == bookId 
            ? Book(
                id: b.id,
                title: b.title,
                author: b.author,
                price: b.price,
                publishYear: b.publishYear,
                quantity: b.quantity,
                libraryId: b.libraryId,
                libraryName: b.libraryName,
                libraryCityName: b.libraryCityName,
                imageUrl: imageUrl,
                categories: b.categories,
                genres: b.genres,
              )
            : b).toList(),
        ),
      );
      if (context.mounted) AppSnackbar.success(context, 'Фото завантажено');
    } on DioError catch (e) {
      if (context.mounted) {
        AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка завантаження фото');
      }
    }
  }
}

class BookState {
  final List<Book> books;
  final bool isLoading;
  final bool isLoadingLibraries;
  final String? error;
  final List<Library> libraries;
  final Library? selectedLibrary;
  final int? myLibraryId;
  final List<Genre> genres;
  final List<Category> categories;
  final List<int> selectedGenreIds;
  final List<int> selectedCategoryIds;
  final String searchQuery;
  final int resetTick;

  BookState({
    this.books = const [],
    this.isLoading = false,
    this.isLoadingLibraries = false,
    this.error,
    this.libraries = const [],
    this.selectedLibrary,
    this.myLibraryId,
    this.genres = const [],
    this.categories = const [],
    this.selectedGenreIds = const [],
    this.selectedCategoryIds = const [],
    this.searchQuery = '',
    this.resetTick = 0,
  });

  BookState copyWith({
    List<Book>? books,
    bool? isLoading,
    bool? isLoadingLibraries,
    String? error,
    List<Library>? libraries,
    Library? selectedLibrary,
    bool clearSelectedLibrary = false,
    int? myLibraryId,
    List<Genre>? genres,
    List<Category>? categories,
    List<int>? selectedGenreIds,
    List<int>? selectedCategoryIds,
    String? searchQuery,
    int? resetTick,
  }) {
    return BookState(
      books: books ?? this.books,
      isLoading: isLoading ?? this.isLoading,
      isLoadingLibraries: isLoadingLibraries ?? this.isLoadingLibraries,
      error: error,
      libraries: libraries ?? this.libraries,
      selectedLibrary:
          clearSelectedLibrary
              ? null
              : (selectedLibrary ?? this.selectedLibrary),
      myLibraryId: myLibraryId ?? this.myLibraryId,
      genres: genres ?? this.genres,
      categories: categories ?? this.categories,
      selectedGenreIds: selectedGenreIds ?? this.selectedGenreIds,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      searchQuery: searchQuery ?? this.searchQuery,
      resetTick: resetTick ?? this.resetTick,
    );
  }
}
