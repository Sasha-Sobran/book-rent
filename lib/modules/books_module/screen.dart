import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';
import 'package:library_kursach/modules/books_module/widgets/book_row.dart';

class BooksScreen extends StatelessWidget {
  static const path = '/books';

  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BooksCubit()..init(),
      child: BlocBuilder<BooksCubit, BookState>(
        builder:
            (context, state) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Управління книгами'),
                          Text('Книг у каталозі: ${state.books.length}'),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => context.read<BooksCubit>().addBook(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Додати книгу'),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey[300]),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.books.length,
                      itemBuilder:
                          (context, index) =>
                              BookRow(book: state.books[index]),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
