import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';
import 'package:image_picker/image_picker.dart';

class MediaInterventionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MediaInterventionPageState();
}

class MediaInterventionPageState extends State<MediaInterventionPage> {
  File _imageFile;

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await ImagePicker.pickImage(source: imageSource);
      setState(() {
        _imageFile = imageFile;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Acompanhamentos'),
          backgroundColor: const Color(0xff125193),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.topLeft,
                transform: Matrix4.translationValues(0, -30, 0),
                child: Text('Tarefa x de x'),
              ),
              Container(
                transform: Matrix4.translationValues(0, -50, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).upload_files,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        captureImage(ImageSource.camera);
                      },
                      child: _imageFile == null
                          ? Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 18),
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width,
                                  color: SenSemColors.lightGray2,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Image.asset('images/file.png'),
                                    ),
                                    Text(
                                      S.of(context).upload_files_action_label,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: SenSemColors.mediumGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : CameraFile(
                              cameraFile: _imageFile,
                              changeFileAction: () {
                                captureImage(ImageSource.camera);
                              },
                            ),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: _imageFile == null ? null : () {},
                color: SenSemColors.aquaGreen,
                disabledColor: SenSemColors.disabledLightGray,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    S.of(context).next,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class CameraFile extends StatelessWidget {
  const CameraFile({
    @required this.cameraFile,
    @required this.changeFileAction,
  }) : assert(cameraFile != null);

  final File cameraFile;
  final Function changeFileAction;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 18),
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                color: SenSemColors.lightGray2,
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 2,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.file(cameraFile),
                    ),
                  ),
                  Text(
                    cameraFile.path.split('/').last,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ],
          ),
          FlatButton(
            onPressed: changeFileAction,
            color: SenSemColors.lightRoyalBlue,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              alignment: Alignment.bottomCenter,
              child: Text(
                S.of(context).change_file_label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
}
