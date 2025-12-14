import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/utils/image_utils.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/models/library.dart';
import 'package:library_kursach/models/settings.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';

class BookFormDialog extends StatefulWidget {
  final Book? book;
  const BookFormDialog({super.key, this.book});

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _GenrePicker extends StatefulWidget {
  const _GenrePicker({
    required this.genres,
    required this.selectedIds,
    required this.newGenres,
    required this.onChanged,
  });

  final List<Genre> genres;
  final List<int> selectedIds;
  final List<String> newGenres;
  final void Function(List<int> ids, List<String> newOnes) onChanged;

  @override
  State<_GenrePicker> createState() => _GenrePickerState();
}

class _GenrePickerState extends State<_GenrePicker> {
  Future<void> _openPicker() async {
    final result = await showDialog<_TaxonomyResult>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final selected = widget.selectedIds.toSet();
        final newOnes = widget.newGenres.toList();
        String search = '';
        return StatefulBuilder(
          builder: (ctx, setModal) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Додати жанр'),
            content: SizedBox(
              width: 480,
              height: 420,
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) => setModal(() => search = v),
                    decoration: AppDecorations.inputWithIcon(Icons.search, 'Пошук жанру'),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Додати новий жанр'),
                          onTap: () async {
                            final name = await _showAddDialog(ctx, 'Новий жанр');
                            if (name != null && name.trim().isNotEmpty) {
                              setModal(() {
                                newOnes.add(name.trim());
                              });
                            }
                          },
                        ),
                        const Divider(),
                        ...widget.genres
                            .where((g) => g.name.toLowerCase().contains(search.toLowerCase()))
                            .map((g) {
                          final selectedFlag = selected.contains(g.id);
                          return CheckboxListTile(
                            value: selectedFlag,
                            onChanged: (_) {
                              setModal(() {
                                if (selectedFlag) {
                                  selected.remove(g.id);
                                } else {
                                  selected.add(g.id);
                                }
                              });
                            },
                            title: Text(g.name),
                          );
                        }),
                        if (newOnes.isNotEmpty) const Divider(),
                        ...newOnes.map((name) {
                          return CheckboxListTile(
                            value: true,
                            onChanged: (_) {},
                            title: Text('$name (new)'),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setModal(() {
                                  newOnes.remove(name);
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(_TaxonomyResult(selectedIds: [], newItems: [])),
                child: const Text('Скинути'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(
                  _TaxonomyResult(
                    selectedIds: selected.toList(),
                    newItems: newOnes,
                  ),
                ),
                style: AppButtons.primary(),
                child: const Text('Готово'),
              ),
            ],
          ),
        );
      },
    );
    if (result != null) {
      widget.onChanged(result.selectedIds, result.newItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      ...widget.genres.where((g) => widget.selectedIds.contains(g.id)).map((g) => g.name),
      ...widget.newGenres.map((n) => '$n (new)'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Жанри', style: AppTextStyles.caption),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Додати жанр до книги'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: AppColors.border.withValues(alpha: 0.7)),
          ),
          onPressed: _openPicker,
        ),
        if (labels.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ...widget.genres.where((g) => widget.selectedIds.contains(g.id)).map(
                    (g) => Chip(
                      label: Text(g.name),
                      onDeleted: () {
                        final ids = [...widget.selectedIds]..remove(g.id);
                        widget.onChanged(ids, widget.newGenres);
                      },
                    ),
                  ),
              ...widget.newGenres.map(
                    (n) => Chip(
                      label: Text('$n (new)'),
                      onDeleted: () {
                        final news = [...widget.newGenres]..remove(n);
                        widget.onChanged(widget.selectedIds, news);
                      },
                    ),
                  ),
            ],
          ),
        ],
      ],
    );
  }

  Future<String?> _showAddDialog(BuildContext context, String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Назва'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }
}

class _CategoryPicker extends StatefulWidget {
  const _CategoryPicker({
    required this.categories,
    required this.selectedIds,
    required this.newCategories,
    required this.onChanged,
  });

  final List<Category> categories;
  final List<int> selectedIds;
  final List<String> newCategories;
  final void Function(List<int> ids, List<String> newOnes) onChanged;

  @override
  State<_CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<_CategoryPicker> {
  Future<void> _openPicker() async {
    final result = await showDialog<_TaxonomyResult>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final selected = widget.selectedIds.toSet();
        final newOnes = widget.newCategories.toList();
        String search = '';
        return StatefulBuilder(
          builder: (ctx, setModal) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text('Додати категорію'),
            content: SizedBox(
              width: 480,
              height: 420,
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) => setModal(() => search = v),
                    decoration: AppDecorations.inputWithIcon(Icons.search, 'Пошук категорії'),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Додати нову категорію'),
                          onTap: () async {
                            final name = await _showAddDialog(ctx, 'Нова категорія');
                            if (name != null && name.trim().isNotEmpty) {
                              setModal(() {
                                newOnes.add(name.trim());
                              });
                            }
                          },
                        ),
                        const Divider(),
                        ...widget.categories
                            .where((c) => c.name.toLowerCase().contains(search.toLowerCase()))
                            .map((c) {
                          final selectedFlag = selected.contains(c.id);
                          return CheckboxListTile(
                            value: selectedFlag,
                            onChanged: (_) {
                              setModal(() {
                                if (selectedFlag) {
                                  selected.remove(c.id);
                                } else {
                                  selected.add(c.id);
                                }
                              });
                            },
                            title: Text(c.name),
                          );
                        }),
                        if (newOnes.isNotEmpty) const Divider(),
                        ...newOnes.map((name) {
                          return CheckboxListTile(
                            value: true,
                            onChanged: (_) {},
                            title: Text('$name (new)'),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setModal(() {
                                  newOnes.remove(name);
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(_TaxonomyResult(selectedIds: [], newItems: [])),
                child: const Text('Скинути'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(
                  _TaxonomyResult(
                    selectedIds: selected.toList(),
                    newItems: newOnes,
                  ),
                ),
                style: AppButtons.primary(),
                child: const Text('Готово'),
              ),
            ],
          ),
        );
      },
    );
    if (result != null) {
      widget.onChanged(result.selectedIds, result.newItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      ...widget.categories.where((c) => widget.selectedIds.contains(c.id)).map((c) => c.name),
      ...widget.newCategories.map((n) => '$n (new)'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Категорії', style: AppTextStyles.caption),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Додати категорію до книги'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: AppColors.border.withValues(alpha: 0.7)),
          ),
          onPressed: _openPicker,
        ),
        if (labels.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ...widget.categories.where((c) => widget.selectedIds.contains(c.id)).map(
                    (c) => Chip(
                      label: Text(c.name),
                      onDeleted: () {
                        final ids = [...widget.selectedIds]..remove(c.id);
                        widget.onChanged(ids, widget.newCategories);
                      },
                    ),
                  ),
              ...widget.newCategories.map(
                    (n) => Chip(
                      label: Text('$n (new)'),
                      onDeleted: () {
                        final news = [...widget.newCategories]..remove(n);
                        widget.onChanged(widget.selectedIds, news);
                      },
                    ),
                  ),
            ],
          ),
        ],
      ],
    );
  }

  Future<String?> _showAddDialog(BuildContext context, String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Назва'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }
}

class _TaxonomyResult {
  _TaxonomyResult({required this.selectedIds, required this.newItems});
  final List<int> selectedIds;
  final List<String> newItems;
}
class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController();
  final _yearController = TextEditingController();
  final _quantityController = TextEditingController();
  Library? _selectedLibrary;
  List<int> _selectedGenreIds = [];
  List<String> _newGenres = [];
  List<int> _selectedCategoryIds = [];
  List<String> _newCategories = [];
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  bool _genresTouched = false;
  bool _categoriesTouched = false;

  bool get isEditing => widget.book != null;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _priceController.text = widget.book!.price.toString();
      _yearController.text = widget.book!.publishYear;
      _quantityController.text = widget.book!.quantity.toString();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLibrary();
      _initCategoriesAndGenres();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _initLibrary() {
    final cubit = context.read<BooksCubit>();
    final state = cubit.state;
    _selectedLibrary = state.selectedLibrary;
    if (_selectedLibrary == null && widget.book != null) {
      _selectedLibrary = Library(
        id: widget.book!.libraryId,
        name: widget.book!.libraryName ?? 'Бібліотека',
        address: '',
        cityName: null,
        cityId: 0,
        phoneNumber: '',
      );
    }
  }

  void _initCategoriesAndGenres() {
    if (widget.book == null) return;
    
    final cubit = context.read<BooksCubit>();
    final state = cubit.state;
    
    _selectedCategoryIds = state.categories
        .where((c) => widget.book!.categories.contains(c.name))
        .map((c) => c.id)
        .toList();
    
    _selectedGenreIds = state.genres
        .where((g) => widget.book!.genres.contains(g.name))
        .map((g) => g.id)
        .toList();
    
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLibrary == null) {
      AppSnackbar.error(context, 'Бібліотеку не знайдено');
      return;
    }

    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final price = double.parse(_priceController.text.trim());
    final year = _yearController.text.trim();
    final quantity = int.parse(_quantityController.text.trim());
    final libraryId = _selectedLibrary!.id;

    final cubit = context.read<BooksCubit>();

    if (isEditing) {
      await cubit.updateBook(
        context,
        widget.book!.id,
        title: title,
        author: author,
        price: price,
        publishYear: year,
        quantity: quantity,
        libraryId: libraryId,
        genreIds: _genresTouched ? _selectedGenreIds : null,
        newGenres: _genresTouched ? _newGenres : null,
        categoryIds: _categoriesTouched ? _selectedCategoryIds : null,
        newCategories: _categoriesTouched ? _newCategories : null,
      );
      
      if (_selectedImage != null && _selectedImageBytes != null) {
        await cubit.uploadBookImage(
          context,
          widget.book!.id,
          _selectedImage!.path,
          _selectedImageBytes,
          _selectedImage!.name,
        );
      }
    } else {
      final createdBook = await cubit.createBook(
        context,
        title: title,
        author: author,
        price: price,
        publishYear: year,
        quantity: quantity,
        genreIds: _selectedGenreIds,
        newGenres: _newGenres,
        categoryIds: _selectedCategoryIds,
        newCategories: _newCategories,
      );
      
      if (_selectedImage != null && _selectedImageBytes != null && createdBook != null) {
        await cubit.uploadBookImage(
          context,
          createdBook.id,
          _selectedImage!.path,
          _selectedImageBytes,
          _selectedImage!.name,
        );
      }
    }
    
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildImagePicker() {
    final currentImageUrl = ImageUtils.buildImageUrl(widget.book?.imageUrl);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Фото книги', style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Row(
          children: [
            if (currentImageUrl.isNotEmpty && _selectedImage == null) ...[
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    currentImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (_selectedImage != null && _selectedImageBytes != null) ...[
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.memory(
                          _selectedImageBytes!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.image_outlined),
                label: Text(_selectedImage != null ? 'Змінити фото' : 'Вибрати фото'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: AppColors.border.withValues(alpha: 0.7)),
                ),
                onPressed: _pickImage,
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() {
                  _selectedImage = null;
                  _selectedImageBytes = null;
                }),
                tooltip: 'Видалити вибране фото',
              ),
            ],
          ],
        ),
        if (isEditing && _selectedImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Фото буде завантажено після збереження',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImage = image;
        _selectedImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEditing ? 'Редагувати книгу' : 'Нова книга', style: AppTextStyles.h3),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: AppDecorations.inputWithIcon(Icons.title_outlined, 'Назва'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Обовʼязково' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorController,
                decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Автор'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Обовʼязково' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: AppDecorations.inputWithIcon(Icons.price_change_outlined, 'Ціна(застава)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final val = double.tryParse(v ?? '');
                        if (val == null || val < 0) return 'Невірна ціна';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      decoration: AppDecorations.inputWithIcon(Icons.calendar_today_outlined, 'Рік'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Обовʼязково' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                decoration: AppDecorations.inputWithIcon(Icons.inventory_2_outlined, 'Кількість'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final val = int.tryParse(v ?? '');
                  if (val == null || val < 0) return 'Невірна кількість';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _GenrePicker(
                genres: context.read<BooksCubit>().state.genres,
                selectedIds: _selectedGenreIds,
                newGenres: _newGenres,
                onChanged: (ids, news) => setState(() {
                  _selectedGenreIds = ids;
                  _newGenres = news;
                  _genresTouched = true;
                }),
              ),
              const SizedBox(height: 12),
              _CategoryPicker(
                categories: context.read<BooksCubit>().state.categories,
                selectedIds: _selectedCategoryIds,
                newCategories: _newCategories,
                onChanged: (ids, news) => setState(() {
                  _selectedCategoryIds = ids;
                  _newCategories = news;
                  _categoriesTouched = true;
                }),
              ),
              const SizedBox(height: 16),
              _buildImagePicker(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submit,
                    style: AppButtons.primary(),
                    child: Text(isEditing ? 'Зберегти' : 'Створити'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

