import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'credentials_rm.g.dart';

@JsonSerializable()
class CredentialsRM {
  const CredentialsRM({
    @required this.secretKey,
    @required this.url,
    @required this.accessKey,
    @required this.bucketName,
    @required this.folderName,
  })  : assert(secretKey != null),
        assert(url != null),
        assert(accessKey != null),
        assert(bucketName != null),
        assert(folderName != null);

  factory CredentialsRM.fromJson(Map<String, dynamic> parsedJson) =>
      _$CredentialsRMFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$CredentialsRMToJson(this);

  @JsonKey(name: 'awsSecretAccessKey')
  final String secretKey;

  @JsonKey(name: 's3URL')
  final String url;

  @JsonKey(name: 'awsAccessKeyId')
  final String accessKey;

  @JsonKey(name: 'bucketName')
  final String bucketName;

  @JsonKey(name: 'folderName')
  final String folderName;
}
