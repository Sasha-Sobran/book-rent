import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/models/book.dart';

class BooksCubit extends Cubit<BookState> {
  BooksCubit()
    : super(
        BookState(
          books: [
            Book(id: 1, title: 'Book 1', author: 'Author 1'),
            Book(id: 2, title: 'Book 2', author: 'Author 2'),
          ],
        ),
      );

  void getBooks() {
    state.books;
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
      state.copyWith(
        books: state.books.where((b) => b.id != book.id).toList(),
      ),
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
