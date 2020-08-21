import 'dart:io';

import 'package:aws_s3_client/aws_s3_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/data/remote/model/credentials_rm.dart';

class FilesRDS {
  const FilesRDS({
    @required this.dio,
  }) : assert(dio != null);

  final Dio dio;

  Future<void> uploadFile(File file) =>
      dio.get('s3Credentials/').then((credentials) {
        final awsCredentials = CredentialsRM.fromJson(credentials.data);

        final spaces = Spaces(
          region: 'sa-east-1',
          accessKey: awsCredentials.accessKey,
          secretKey: awsCredentials.secretKey,
        );

        final bucket = spaces.bucket(awsCredentials.bucketName);

        return bucket.uploadFile(
            '${awsCredentials.folderName}/${file.path.split('/').last}',
            file.readAsBytesSync(),
            'multipart/form-data',
            Permissions.public);
      });
}
