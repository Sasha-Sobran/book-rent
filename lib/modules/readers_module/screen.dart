import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/readers_module/cubit.dart';
import 'package:library_kursach/modules/readers_module/views/readers_header.dart';
import 'package:library_kursach/modules/readers_module/views/readers_list.dart';

class ReadersModuleScreen extends StatelessWidget {
  static const path = '/readers';

  const ReadersModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReadersCubit()..init(context),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ReadersHeader(),
            ),
            Expanded(child: ReadersList()),
          ],
        ),
      ),
    );
  }
}