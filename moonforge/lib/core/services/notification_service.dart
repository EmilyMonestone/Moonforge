import 'package:flutter/material.dart';
import 'package:moonforge/core/constants/ui_constants.dart';
import 'package:toastification/toastification.dart';

/// Global instance of the NotificationService
final notification = NotificationService();

/// A service for showing notifications using toastification.
///
/// This service provides a simple API for showing notifications with standard types
/// (success, error, info, warning) using toastification.
///
/// You can use this service in two ways:
/// 1. Using the static methods: `NotificationService.showSuccess(...)`
/// 2. Using the singleton instance: `notification.success(...)`
class NotificationService {
  /// Singleton instance
  static final NotificationService _instance = NotificationService._internal();

  /// Factory constructor to return the singleton instance
  factory NotificationService() => _instance;

  /// Internal constructor
  NotificationService._internal();

  /// The singleton instance
  static NotificationService get instance => _instance;

  /// Instance method for showing a success notification
  void success(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.successDuration,
  }) {
    showSuccess(
      context,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Instance method for showing an error notification
  void error(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.errorDuration,
  }) {
    showError(
      context,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Instance method for showing an info notification
  void info(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.infoDuration,
  }) {
    showInfo(
      context,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Instance method for showing a warning notification
  void warning(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.warningDuration,
  }) {
    showWarning(
      context,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Instance method for showing a file saved notification
  void fileSaved(
    BuildContext context, {
    required String filePath,
    Duration duration = NotificationConstants.successDuration,
  }) {
    showFileSaved(context, filePath: filePath, duration: duration);
  }

  /// Instance method for showing a file error notification
  void fileError(
    BuildContext context, {
    required String error,
    Duration duration = NotificationConstants.errorDuration,
  }) {
    showFileError(context, error: error, duration: duration);
  }

  /// Instance method for showing a PDF save error notification
  void pdfSaveError(
    BuildContext context, {
    required String error,
    Duration duration = NotificationConstants.longDuration,
  }) {
    showPdfSaveError(context, error: error, duration: duration);
  }

  /// Instance method for showing a PDF generation progress notification
  ToastificationItem pdfGenerationProgress(
    BuildContext context, {
    required int patientCount,
  }) {
    return showPdfGenerationProgress(context, patientCount: patientCount);
  }

  /// Instance method for showing a PDF generation success notification
  void pdfGenerationSuccess(
    BuildContext context, {
    required int patientCount,
    required String successMessage,
    Duration duration = NotificationConstants.successDuration,
  }) {
    showPdfGenerationSuccess(
      context,
      patientCount: patientCount,
      successMessage: successMessage,
      duration: duration,
    );
  }

  /// Instance method for showing a custom notification
  void custom(
    BuildContext context, {
    required ToastificationType type,
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.defaultDuration,
  }) {
    showCustom(
      context,
      type: type,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Shows a success notification.
  ///
  /// [context] The build context.
  /// [title] The title of the notification.
  /// [description] The description of the notification.
  /// [duration] The duration of the notification. Defaults to 4 seconds.
  static void showSuccess(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.successDuration,
  }) {
    _showNotification(
      context,
      type: ToastificationType.success,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Shows an error notification.
  ///
  /// [context] The build context.
  /// [title] The title of the notification.
  /// [description] The description of the notification.
  /// [duration] The duration of the notification. Defaults to 6 seconds.
  static void showError(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.errorDuration,
  }) {
    _showNotification(
      context,
      type: ToastificationType.error,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Shows an info notification.
  ///
  /// [context] The build context.
  /// [title] The title of the notification.
  /// [description] The description of the notification.
  /// [duration] The duration of the notification. Defaults to 4 seconds.
  static void showInfo(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.infoDuration,
  }) {
    _showNotification(
      context,
      type: ToastificationType.info,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Shows a warning notification.
  ///
  /// [context] The build context.
  /// [title] The title of the notification.
  /// [description] The description of the notification.
  /// [duration] The duration of the notification. Defaults to 5 seconds.
  static void showWarning(
    BuildContext context, {
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.warningDuration,
  }) {
    _showNotification(
      context,
      type: ToastificationType.warning,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Shows a file saved notification.
  ///
  /// [context] The build context.
  /// [filePath] The path of the saved file.
  /// [duration] The duration of the notification. Defaults to 4 seconds.
  static void showFileSaved(
    BuildContext context, {
    required String filePath,
    Duration duration = NotificationConstants.successDuration,
  }) {
    _showNotification(
      context,
      type: ToastificationType.success,
      title: const Text('Datei gespeichert'),
      description: Text('Datei gespeichert unter: $filePath'),
      duration: duration,
    );
  }

  /// Shows a file error notification.
  ///
  /// [context] The build context.
  /// [error] The error message.
  /// [duration] The duration of the notification. Defaults to 6 seconds.
  static void showFileError(
    BuildContext context, {
    required String error,
    Duration duration = NotificationConstants.errorDuration,
  }) {
    _showNotification(
      context,
      type: ToastificationType.error,
      title: const Text('Fehler'),
      description: Text('Fehler beim Herunterladen der Datei: $error'),
      duration: duration,
    );
  }

  /// Shows a PDF save error notification.
  ///
  /// [context] The build context.
  /// [error] The error message.
  /// [duration] The duration of the notification. Defaults to 6 seconds.
  static void showPdfSaveError(
    BuildContext context, {
    required String error,
    Duration duration = NotificationConstants.longDuration,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: const Text('Fehler beim Speichern'),
      description: Text('Fehler beim Speichern der PDF-Datei: $error'),
      autoCloseDuration: duration,
      pauseOnHover: true,
      dragToClose: true,
      backgroundColor: colorScheme.errorContainer,
      foregroundColor: colorScheme.onErrorContainer,
      primaryColor: colorScheme.error,
    );
  }

  /// Shows a PDF generation progress notification.
  ///
  /// [context] The build context.
  /// [patientCount] The number of patients being processed.
  /// Returns a ToastificationItem that can be used to update or dismiss the notification.
  static ToastificationItem showPdfGenerationProgress(
    BuildContext context, {
    required int patientCount,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.fillColored,
      title: const Text('PDF wird generiert'),
      description: Text('$patientCount Patient:innen werden verarbeitet...'),
      alignment: Alignment.topRight,
      autoCloseDuration: null,
      // Don't auto-close
      showProgressBar: true,
      dragToClose: true,
      closeOnClick: false,
      pauseOnHover: true,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      primaryColor: colorScheme.primary,
    );
  }

  /// Shows a PDF generation success notification.
  ///
  /// [context] The build context.
  /// [patientCount] The number of patients processed.
  /// [successMessage] The success message.
  /// [duration] The duration of the notification. Defaults to 4 seconds.
  static void showPdfGenerationSuccess(
    BuildContext context, {
    required int patientCount,
    required String successMessage,
    Duration duration = NotificationConstants.successDuration,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text('PDF erfolgreich generiert'),
      description: Text(
        '$patientCount Patient:innen verarbeitet. $successMessage',
      ),
      autoCloseDuration: duration,
      pauseOnHover: true,
      dragToClose: true,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      primaryColor: colorScheme.primary,
    );
  }

  /// Shows a custom notification.
  ///
  /// [context] The build context.
  /// [type] The type of the notification.
  /// [title] The title of the notification.
  /// [description] The description of the notification.
  /// [duration] The duration of the notification. Defaults to 4 seconds.
  static void showCustom(
    BuildContext context, {
    required ToastificationType type,
    required Widget title,
    Widget? description,
    Duration duration = NotificationConstants.defaultDuration,
  }) {
    _showNotification(
      context,
      type: type,
      title: title,
      description: description,
      duration: duration,
    );
  }

  /// Shows a notification using toastification.
  ///
  /// [context] The build context.
  /// [type] The type of the notification.
  /// [title] The title of the notification.
  /// [description] The description of the notification.
  /// [duration] The duration of the notification.
  static void _showNotification(
    BuildContext context, {
    required ToastificationType type,
    required Widget title,
    Widget? description,
    required Duration duration,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    // Set colors based on notification type
    late Color backgroundColor;
    late Color foregroundColor;
    late Color primaryColor;

    switch (type) {
      case ToastificationType.success:
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        primaryColor = colorScheme.primary;
        break;
      case ToastificationType.error:
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        primaryColor = colorScheme.error;
        break;
      case ToastificationType.info:
        backgroundColor = colorScheme.secondaryContainer;
        foregroundColor = colorScheme.onSecondaryContainer;
        primaryColor = colorScheme.secondary;
        break;
      case ToastificationType.warning:
        backgroundColor = colorScheme.tertiaryContainer;
        foregroundColor = colorScheme.onTertiaryContainer;
        primaryColor = colorScheme.tertiary;
        break;
    }

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      title: title,
      description: description,
      autoCloseDuration: duration,
      pauseOnHover: true,
      dragToClose: true,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      primaryColor: primaryColor,
    );
  }
}
