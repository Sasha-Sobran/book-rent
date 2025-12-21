import 'package:library_kursach/models/user.dart';

class PermissionUtils {
  static bool canManageBooks(User? user) {
    return user?.isLibrarian == true;
  }

  static bool canEditBook(User? user, int? librarianLibraryId, int bookLibraryId) {
    return user?.isLibrarian == true &&
        librarianLibraryId != null &&
        bookLibraryId == librarianLibraryId;
  }

  static bool canSeeReaders(User? user) {
    return user?.isLibrarian == true;
  }

  static bool canManageRents(User? user) {
    return user?.isLibrarian == true;
  }

  static bool canEditUser(User? currentUser, User? targetUser) {
    if (currentUser == null) return false;
    return currentUser.isRoot == true;
  }

  static bool canDeleteUser(User? targetUser) {
    return targetUser?.role != 'root';
  }

  static bool isRoot(User? user) {
    return user?.isRoot == true;
  }
}

