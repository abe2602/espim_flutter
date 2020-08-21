// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialsRM _$CredentialsRMFromJson(Map<String, dynamic> json) {
  return CredentialsRM(
    secretKey: json['awsSecretAccessKey'] as String,
    url: json['s3URL'] as String,
    accessKey: json['awsAccessKeyId'] as String,
    bucketName: json['bucketName'] as String,
    folderName: json['folderName'] as String,
  );
}

Map<String, dynamic> _$CredentialsRMToJson(CredentialsRM instance) =>
    <String, dynamic>{
      'awsSecretAccessKey': instance.secretKey,
      's3URL': instance.url,
      'awsAccessKeyId': instance.accessKey,
      'bucketName': instance.bucketName,
      'folderName': instance.folderName,
    };
