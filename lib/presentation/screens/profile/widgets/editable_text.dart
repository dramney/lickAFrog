import 'package:flutter/material.dart';

class EditableTextField extends StatelessWidget {
  final String value;
  final bool isEditing;
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onEdit;
  final TextStyle? textStyle;

  const EditableTextField({
    super.key,
    required this.value,
    required this.isEditing,
    required this.controller,
    required this.onSave,
    required this.onEdit,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return isEditing
        ? Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: TextField(
            controller: controller,
            style: textStyle,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.white),
          onPressed: onSave,
        ),
      ],
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: textStyle),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
