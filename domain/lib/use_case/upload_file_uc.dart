import 'dart:io';

import 'package:domain/data_repository/files_data_repository.dart';
import 'package:flutter/foundation.dart';

import 'use_case.dart';

class UploadFileUC extends UseCase<UploadFileUCParams, void> {
  UploadFileUC({
    @required this.filesRepository,
  }) : assert(filesRepository != null);

  final FilesDataRepository filesRepository;

  @override
  Future<void> getRawFuture({UploadFileUCParams params}) =>
      filesRepository.uploadFile(params.file).catchError((error) {
        print('erro no UC: ' + error.toString());
        throw error;
      });
}

class UploadFileUCParams {
  const UploadFileUCParams({@required this.file,}) : assert(file != null);

  final File file;
}