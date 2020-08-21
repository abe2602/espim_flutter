import 'dart:io';

import 'package:domain/data_repository/files_data_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/remote/data_source/files_rds.dart';

class FilesRepository implements FilesDataRepository{
  const FilesRepository({
    @required this.filesRDS,
  }) : assert(filesRDS != null);

  final FilesRDS filesRDS;

  @override
  Future<void> uploadFile(File file) => filesRDS.uploadFile(file);

}