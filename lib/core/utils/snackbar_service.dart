import 'package:flutter/material.dart';

class SnackbarService {
  static final SnackbarService _instance = SnackbarService._internal();
  factory SnackbarService() => _instance;
  SnackbarService._internal();

  static SnackbarService get instance => _instance;

  /// Shows a snackbar with the given message and optional configuration
  void showSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool showDismissAction = true,
    VoidCallback? onDismiss,
  }) {
    // Check if context is still mounted
    if (!context.mounted) return;
    
    // Hide any existing snackbar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the new snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: behavior,
        action: showDismissAction
            ? SnackBarAction(
                label: 'Dismiss',
                onPressed: () {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onDismiss?.call();
                  }
                },
              )
            : null,
      ),
    );
  }

  /// Shows a success snackbar with green background
  void showSuccessSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: Colors.green,
      onDismiss: onDismiss,
    );
  }

  /// Shows an error snackbar with red background
  void showErrorSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: Colors.red,
      onDismiss: onDismiss,
    );
  }

  /// Shows a warning snackbar with orange background
  void showWarningSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: Colors.orange,
      onDismiss: onDismiss,
    );
  }

  /// Shows an info snackbar with blue background
  void showInfoSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: Colors.blue,
      onDismiss: onDismiss,
    );
  }
} 