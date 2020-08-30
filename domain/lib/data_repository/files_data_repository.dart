import 'dart:io';

abstract class FilesDataRepository {
  Future<String> uploadFile(File file);
}