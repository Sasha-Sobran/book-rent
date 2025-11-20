import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';

class BookRow extends StatelessWidget {
  final Book book;

  const BookRow({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.book_outlined, size: 20, color: Colors.blue),
        Text(book.title),
        Text(book.author),
        Row(
          children: [
            IconButton(onPressed: () => context.read<BooksCubit>().editBook(book), icon: const Icon(Icons.edit)),
            IconButton(onPressed: () => context.read<BooksCubit>().deleteBook(book), icon: const Icon(Icons.delete)),
          ],
        ),
      ],
    );
  }
}