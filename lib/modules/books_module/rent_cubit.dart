import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/common_api.dart';
import 'package:library_kursach/api/readers_api.dart';
import 'package:library_kursach/api/rents_api.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/app_env.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/models/reader.dart';
import 'package:library_kursach/models/settings.dart';

class RentState {
  final bool isLoading;
  final bool isSubmitting;
  final List<Reader> readers;
  final List<ReaderCategory> categories;
  final Reader? selectedReader;
  final int loanDays;
  final double dailyRate;
  final double totalPrice;
  final int discount;
  final int deposit;
  final String? error;

  const RentState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.readers = const [],
    this.categories = const [],
    this.selectedReader,
    this.loanDays = 14,
    this.dailyRate = 0,
    this.totalPrice = 0,
    this.discount = 0,
    this.deposit = 0,
    this.error,
  });

  RentState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Reader>? readers,
    List<ReaderCategory>? categories,
    Reader? selectedReader,
    int? loanDays,
    double? dailyRate,
    double? totalPrice,
    int? discount,
    int? deposit,
    String? error,
  }) {
    return RentState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      readers: readers ?? this.readers,
      categories: categories ?? this.categories,
      selectedReader: selectedReader ?? this.selectedReader,
      loanDays: loanDays ?? this.loanDays,
      dailyRate: dailyRate ?? this.dailyRate,
      totalPrice: totalPrice ?? this.totalPrice,
      discount: discount ?? this.discount,
      deposit: deposit ?? this.deposit,
      error: error,
    );
  }
}

class RentCubit extends Cubit<RentState> {
  RentCubit({required this.book, double? dailyRatePercent})
      : _dailyRatePercent =
            dailyRatePercent ?? GetItService().instance<AppEnv>().rentDailyRatePercent,
        super(RentState(deposit: book.price.round())) {
    _recalculate();
  }

  final Book book;
  final double _dailyRatePercent;

  final _rentsApi = GetItService().instance<RentsApi>();
  final _readersApi = GetItService().instance<ReadersApi>();
  final _commonApi = GetItService().instance<CommonApi>();

  Future<void> init() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final readers = await _readersApi.getReaders();
      final categories = await _commonApi.getReaderCategories();
      emit(state.copyWith(
        readers: readers,
        categories: categories,
        isLoading: false,
        error: null,
      ));
      _recalculate();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Не вдалося завантажити дані'));
    }
  }

  void selectReader(Reader? reader) {
    emit(state.copyWith(selectedReader: reader));
    _recalculate();
  }

  void setLoanDays(int days) {
    if (days <= 0) {
      emit(state.copyWith(error: 'Тривалість має бути більшою за 0'));
      return;
    }
    emit(state.copyWith(loanDays: days, error: null));
    _recalculate();
  }

  Future<String?> submit() async {
    final reader = state.selectedReader;
    if (reader == null) {
      return 'Оберіть читача';
    }
    if (state.loanDays <= 0) {
      return 'Вкажіть коректну тривалість прокату';
    }
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await _rentsApi.createRent(
        bookId: book.id,
        readerId: reader.id,
        loanDays: state.loanDays,
      );
      emit(state.copyWith(isSubmitting: false));
      return null;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
      return 'Помилка створення ренту';
    }
  }

  void _recalculate() {
    final discount = _discountForSelected();
    final dailyRateBase = book.price * _dailyRatePercent;
    final dailyRate = dailyRateBase * (1 - discount / 100);
    final total = dailyRate * state.loanDays;
    emit(state.copyWith(
      discount: discount,
      dailyRate: dailyRate,
      totalPrice: total,
      deposit: book.price.round(),
    ));
  }

  int _discountForSelected() {
    final readerCatId = state.selectedReader?.readerCategoryId;
    if (readerCatId == null) return 0;
    return state.categories.firstWhere(
      (c) => c.id == readerCatId,
      orElse: () => ReaderCategory(id: readerCatId, name: '', discountPercentage: 0),
    ).discountPercentage;
  }
}


