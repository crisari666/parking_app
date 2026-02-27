import 'package:flutter/material.dart';

class SnackbarService {
  static final SnackbarService _instance = SnackbarService._internal();
  factory SnackbarService() => _instance;
  SnackbarService._internal();

  static SnackbarService get instance => _instance;

  BuildContext? _scaffoldContext;
  GlobalKey<ScaffoldMessengerState>? _rootMessengerKey;

  /// Registers the root ScaffoldMessenger key (from MaterialApp). Use in main() so
  /// snackbars work from any route (e.g. Login, Setup) when MainPage is not mounted.
  void registerRootMessengerKey(GlobalKey<ScaffoldMessengerState> key) {
    _rootMessengerKey = key;
  }

  /// Initializes the service with the scaffold context (e.g. from MainPage).
  /// When MainPage is visible, this context is used so all snackbars use the same scope.
  void init(BuildContext context) {
    _scaffoldContext = context;
  }

  /// Clears the stored context. Call from MainPage.dispose().
  void clearContext() {
    _scaffoldContext = null;
  }

  ScaffoldMessengerState? get _messenger {
    if (_scaffoldContext != null && _scaffoldContext!.mounted) {
      return ScaffoldMessenger.maybeOf(_scaffoldContext!);
    }
    return _rootMessengerKey?.currentState;
  }

  /// Shows a snackbar with the given message and optional configuration.
  /// Clears the entire snackbar queue first so only this one is shown (single dismiss).
  void showSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    bool showDismissAction = true,
    VoidCallback? onDismiss,
  }) {
    final messenger = _messenger;
    if (messenger == null) return;

    // Clear all queued snackbars so only this one shows (avoids stacking / multiple dismiss taps)
    messenger.clearSnackBars();

    // Show the new snackbar
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: behavior,
        action: showDismissAction
            ? SnackBarAction(
                label: 'Dismiss',
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  onDismiss?.call();
                },
              )
            : null,
      ),
    );
  }

  /// Shows a success snackbar with green background
  void showSuccessSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      message: message,
      duration: duration,
      backgroundColor: Colors.green,
      onDismiss: onDismiss,
    );
  }

  /// Shows an error snackbar with red background
  void showErrorSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      message: message,
      duration: duration,
      backgroundColor: Colors.red,
      onDismiss: onDismiss,
    );
  }

  /// Shows a warning snackbar with orange background
  void showWarningSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      message: message,
      duration: duration,
      backgroundColor: Colors.orange,
      onDismiss: onDismiss,
    );
  }

  /// Shows an info snackbar with blue background
  void showInfoSnackbar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
  }) {
    showSnackbar(
      message: message,
      duration: duration,
      backgroundColor: Colors.blue,
      onDismiss: onDismiss,
    );
  }
}
