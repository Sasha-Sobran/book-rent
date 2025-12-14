class Rent {
  final int id;
  final int bookId;
  final String bookTitle;
  final int readerId;
  final String readerName;
  final DateTime rentDate;
  final DateTime expectedReturnDate;
  final DateTime? returnDate;
  final double rentPrice;
  final int depositPrice;
  final double penaltiesAmount;
  final double totalAmount;
  final String status;
  final int librarianId;

  Rent({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.readerId,
    required this.readerName,
    required this.rentDate,
    required this.expectedReturnDate,
    required this.returnDate,
    required this.rentPrice,
    required this.depositPrice,
    required this.penaltiesAmount,
    required this.totalAmount,
    required this.status,
    required this.librarianId,
  });

  factory Rent.fromJson(Map<String, dynamic> json) => Rent(
        id: json['id'],
        bookId: json['book_id'],
        bookTitle: json['book_title'],
        readerId: json['reader_id'],
        readerName: json['reader_name'],
        rentDate: DateTime.parse(json['rent_date']),
        expectedReturnDate: DateTime.parse(json['expected_return_date']),
        returnDate: json['return_date'] != null ? DateTime.parse(json['return_date']) : null,
        rentPrice: (json['rent_price'] as num).toDouble(),
        depositPrice: json['deposit_price'],
        penaltiesAmount: (json['penalties_amount'] as num?)?.toDouble() ?? 0,
        totalAmount: (json['total_amount'] as num?)?.toDouble() ?? ((json['rent_price'] as num).toDouble()),
        status: json['status'],
        librarianId: json['librarian_id'],
      );
}


