import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simgle_login_proj/Shared/delegates.dart';

class NotificationHelper {
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black,
    ActionDelegate<void>? action,
    String actionLabel = "Undo",
  }) {ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor,
        action: action != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: () {
                  action(null);
                },
              )
            : null,
      ),
    );
  }


  static void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "OK",
    String? cancelText, // Cancel butonu için isteğe bağlı metin
    ActionDelegate<void>? onConfirm, // Confirm için callback
    ActionDelegate<void>? onCancel, // Cancel için callback
  }) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          // Cancel butonu yalnızca cancelText sağlanmışsa gösterilir
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel(null);
              },
              child: Text(cancelText),
            ),
          // Confirm butonu
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm(null);
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static void showBottomSheet({
    required BuildContext context,
    required Widget content,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => content,
    );
  }

  static Future<void> showCustomDialog(
      {required BuildContext context, required Widget content}) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: content,
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  size: 24.0,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
