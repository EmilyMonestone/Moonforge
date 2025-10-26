enum ReturnStatus { success, failure, warning, info }

class ReturnMessage<T> {
  final ReturnStatus status;
  final String? message;
  final T? data;

  ReturnMessage({required this.status, this.message, this.data});

  /// Success factory constructor
  /// [message] is an optional message describing the success
  /// [data] is an optional data payload of type T
  /// Example:
  /// ```dart
  /// ReturnMessage<Campaign>.success("Campaign created successfully", campaign);
  /// ```
  ReturnMessage.success(this.message, [this.data])
    : status = ReturnStatus.success;

  ReturnMessage.failure(this.message, [this.data])
    : status = ReturnStatus.failure;

  ReturnMessage.warning(this.message, [this.data])
    : status = ReturnStatus.warning;

  ReturnMessage.info(this.message, [this.data]) : status = ReturnStatus.info;

  @override
  String toString() {
    return 'ReturnMessage(status: $status, message: $message)';
  }
}
