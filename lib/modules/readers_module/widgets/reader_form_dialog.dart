import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/common_api.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/models/reader.dart';
import 'package:library_kursach/models/settings.dart';
import 'package:library_kursach/modules/readers_module/cubit.dart';

class ReaderFormDialog extends StatefulWidget {
  final Reader? reader;

  const ReaderFormDialog({super.key, this.reader});

  @override
  State<ReaderFormDialog> createState() => _ReaderFormDialogState();
}

class _ReaderFormDialogState extends State<ReaderFormDialog> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  List<ReaderCategory> _categories = [];
  int? _selectedCategoryId;
  bool _isLoading = true;

  bool get isEditing => widget.reader != null;

  @override
  void initState() {
    super.initState();
    if (widget.reader != null) {
      _nameController.text = widget.reader!.name;
      _surnameController.text = widget.reader!.surname;
      _phoneController.text = widget.reader!.phoneNumber ?? '';
      _addressController.text = widget.reader!.address ?? '';
      _selectedCategoryId = widget.reader!.readerCategoryId;
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final api = GetItService().instance<CommonApi>();
    _categories = await api.getReaderCategories();
    setState(() => _isLoading = false);
  }

  void _submit() {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || surname.isEmpty || phone.isEmpty || address.isEmpty || _selectedCategoryId == null) {
      AppSnackbar.error(context, 'Заповніть всі поля та виберіть категорію');
      return;
    }

    final cubit = context.read<ReadersCubit>();
    if (isEditing) {
      cubit.updateReader(
        context,
        widget.reader!.id,
        name: name,
        surname: surname,
        phoneNumber: phone,
        address: address,
        readerCategoryId: _selectedCategoryId,
      );
    } else {
      cubit.createReader(
        context,
        name: name,
        surname: surname,
        phoneNumber: phone,
        address: address,
        readerCategoryId: _selectedCategoryId,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEditing ? 'Редагувати читача' : 'Новий читач', style: AppTextStyles.h3),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _surnameController,
                    decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Прізвище'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Ім\'я'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: AppDecorations.inputWithIcon(Icons.phone_outlined, 'Телефон'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: AppDecorations.inputWithIcon(Icons.location_on_outlined, 'Адреса'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<int?>(
                    value: _selectedCategoryId,
                    decoration: AppDecorations.inputWithIcon(Icons.category_outlined, 'Категорія'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Без категорії')),
                      ..._categories.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.name} (${c.discountPercentage}% знижка)'),
                      )),
                    ],
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                  ),
            const SizedBox(height: 24),
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
    );
  }
}

