import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: SenSemColors.primaryColor,
          title: const Text(
            'Settings',
          ),
        ),
        body: const Text('SETTTIINNNGSSSSSSSS'),
      );
}
