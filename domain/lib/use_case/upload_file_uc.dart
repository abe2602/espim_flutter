import 'dart:io';

import 'package:domain/data_repository/files_data_repository.dart';
import 'package:flutter/foundation.dart';

import 'use_case.dart';

class UploadFileUC extends UseCase<UploadFileUCParams, String> {
  UploadFileUC({
    @required this.filesRepository,
  }) : assert(filesRepository != null);

  final FilesDataRepository filesRepository;

  @override
  Future<String> getRawFuture({UploadFileUCParams params}) =>
      filesRepository.uploadFile(params.file);
}

class UploadFileUCParams {
  const UploadFileUCParams({@required this.file,}) : assert(file != null);

  final File file;
}