import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.book_outlined, size: 140, color: Colors.blue),
          Text(book.title),
          Text(book.author),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () => context.read<BooksCubit>().editBook(book), icon: const Icon(Icons.edit)),
              IconButton(onPressed: () => context.read<BooksCubit>().deleteBook(book), icon: const Icon(Icons.delete)),
            ],
          )
        ],
      ),
    );
  }
}
