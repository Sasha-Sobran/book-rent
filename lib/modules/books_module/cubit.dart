import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/books_api.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/book.dart';

class BooksCubit extends Cubit<BookState> {
  BooksCubit() : super(BookState(books: []));

  final _booksApi = GetItService().instance<BooksApi>();

  void init() {
    getBooks();
  }

  void getBooks() {
    _booksApi.getBooks().then(
      (books) {
        emit(state.copyWith(books: books));
      },
      onError: (error) {
        emit(state.copyWith(books: []));
      },
    );
  }

  void addBook() {
    emit(
      state.copyWith(
        books: [
          ...state.books,
          Book(
            id: state.books.length + 1,
            title: 'Book ${state.books.length + 1}',
            author: 'Author ${state.books.length + 1}',
          ),
        ],
      ),
    );
  }

  void editBook(Book book) {
    emit(
      state.copyWith(
        books: state.books.map((b) => b.id == book.id ? book : b).toList(),
      ),
    );
  }

  void deleteBook(Book book) {
    emit(
      state.copyWith(books: state.books.where((b) => b.id != book.id).toList()),
    );
  }
}

class BookState {
  final List<Book> books;

  BookState({required this.books});

  copyWith({List<Book>? books}) {
    return BookState(books: books ?? this.books);
  }
}
