import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSnackbar(BuildContext context, String message) {
  showTopSnackBar(
    context as OverlayState,
    CustomSnackBar.success(
      message: message,
      backgroundColor: Colors.green,
      textStyle: TextStyle(color: Colors.white),
      
    ),
  );
}
