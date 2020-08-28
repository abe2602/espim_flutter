import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/presentation/common/input_status_vm.dart';
import 'package:flutter_app/presentation/common/sensem_colors.dart';

class FormTextField extends StatelessWidget {
  const FormTextField(
      {@required this.statusStream,
      @required this.labelText,
      Key key,
      this.boxColor,
      this.textEditingController,
      this.focusNode,
      this.emptyErrorMessage,
      this.invalidErrorMessage,
      this.keyboardType,
      this.textInputAction,
      this.onChanged,
      this.onEditingComplete,
      this.obscureText = false,
      this.initialValue})
      : assert(statusStream != null),
        assert(labelText != null),
        assert(
            (initialValue != null && textEditingController != null) ||
                initialValue == null,
            'If an initial value is provided, '
            'so must a TextEditingController!'),
        super(key: key);

  final Stream<InputStatusVM> statusStream; //InputStatus do form
  //Útil quando queremos ter um callback(ação) sempre que o texto muda
  final TextEditingController textEditingController;
  final FocusNode focusNode; //possibilita obter o foco
  final String emptyErrorMessage;
  final String invalidErrorMessage;
  final String labelText;
  final TextInputType keyboardType; //tipo do teclado
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged; //novo valor do form
  final VoidCallback onEditingComplete; //O que fazer quando acabar de editar
  final bool obscureText;
  final Color boxColor;
  final String initialValue; //valor inicial, se for null, é ""

  ///StreamBuilder ouve a stream que foi declarada no bloc. A partir dela,
  ///sabemos qual é o estado atual do inputText (undefined, invalid, empty ou
  ///valid). A partir desse estado, decidimos o que fazer
  @override
  Widget build(BuildContext context) => StreamBuilder<InputStatusVM>(
        stream: statusStream,
        initialData: InputStatusVM.undefined,
        builder: (context, snapshot) {
          final status = snapshot.data;
          if (status == InputStatusVM.undefined && initialValue != null) {
            textEditingController
              ..text = initialValue
              ..selection =
                  TextSelection.collapsed(offset: initialValue.length);

            onChanged(initialValue);
          }

          final errorMessage = (status == InputStatusVM.invalid)
              ? (invalidErrorMessage ?? S.of(context).invalidFieldError)
              : ((status == InputStatusVM.empty)
                  ? (emptyErrorMessage ?? S.of(context).emptyFieldError)
                  : null);

          ///Depois que fazemos as verificações, retornamos o novo TextField
          ///com , ou sem, erro.
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: boxColor ?? SenSemColors.primaryColor,
                width: 1,
              ),
            ),
            child: TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                //labelText: labelText,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                //errorText: errorMessage,
              ),
              maxLines: 6,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onEditingComplete: onEditingComplete,
              onChanged: onChanged,
              obscureText: obscureText,
            ),
          );
        },
      );
}
