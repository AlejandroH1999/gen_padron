import 'package:flutter/material.dart';

class TextInputWidgets {
  static Widget buildTextField(
      String labelText, TextEditingController controller,
      {required double borderRadius,
      required BorderSide borderSide,
      required Icon prefixIcon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
