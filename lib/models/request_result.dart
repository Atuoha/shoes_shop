import 'success.dart';

class RequestResult {
  final Success? success;
  final String? errorMessage;

  RequestResult({this.success, this.errorMessage});

  factory RequestResult.success(Success? success) => RequestResult(success:success,errorMessage: null);

  factory RequestResult.error(String errorMessage) =>
      RequestResult(success:null, errorMessage: errorMessage);
}
