import 'package:library_kursach/models/user.dart';

class PermissionUtils {
  static bool canManageBooks(User? user) {
    return user?.isLibrarian == true || user?.isAdmin == true || user?.isRoot == true;
  }

  static bool canEditBook(User? user, int? librarianLibraryId, int bookLibraryId) {
    return user?.isLibrarian == true &&
        librarianLibraryId != null &&
        bookLibraryId == librarianLibraryId;
  }

  static bool canSeeReaders(User? user) {
    return user?.isLibrarian == true || user?.isAdmin == true || user?.isRoot == true;
  }

  static bool canManageRents(User? user) {
    return user?.isLibrarian == true || user?.isAdmin == true || user?.isRoot == true;
  }

  static bool canEditUser(User? currentUser, User? targetUser) {
    if (currentUser == null) return false;
    if (currentUser.isRoot) return true;
    if (currentUser.isAdmin && targetUser?.role != 'root') return true;
    return false;
  }

  static bool canDeleteUser(User? targetUser) {
    return targetUser?.role != 'root';
  }

  static bool isAdminOrRoot(User? user) {
    return user?.isAdmin == true || user?.isRoot == true;
  }
}

