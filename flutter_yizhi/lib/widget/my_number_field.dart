import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../res/colors.dart';

class MyNumberField extends StatelessWidget {
  const MyNumberField({super.key,
        this.hintText = '请输入',
        this.maxLength = 1,
        required this.controller,
        required this.nodeText});

  final String? hintText;
  final TextEditingController controller;
  final FocusNode nodeText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        height: 1,
        textBaseline:
        TextBaseline.alphabetic,
        fontSize: 16,
      ),
      textAlignVertical:
      TextAlignVertical.center,
      cursorColor: Colours.app_main,
      focusNode: nodeText,
      controller: controller,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      maxLength: maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
      ],
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.only(bottom: 16),
        hintText: hintText,
        counterText: '',
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
