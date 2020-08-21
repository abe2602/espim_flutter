import 'dart:io';

abstract class FilesDataRepository {
  Future<void> uploadFile(File file);
}