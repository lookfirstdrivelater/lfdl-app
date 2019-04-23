import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lfdl_app/MultiSelectDialog.dart';


void _showMultiSelect(BuildContext context) async {
  final items = <MultiSelectDialogItem<int>>[
    MultiSelectDialogItem(1, 'Dog'),
    MultiSelectDialogItem(2, 'Cat'),
    MultiSelectDialogItem(3, 'Mouse'),
  ];

  final selectedValues = await showDialog<Set<int>>(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(
        items: items,
        initialSelectedValues: [1, 3].toSet(),
      );
    },
  );

  print(selectedValues);
}