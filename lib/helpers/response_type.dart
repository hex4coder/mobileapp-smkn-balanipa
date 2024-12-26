enum ResponseType {
  success,
  error
}

class Response {
  String message;
  ResponseType status;
  dynamic data;

  Response({required this.message, required this.status, this.data});

  static Response success(String message, [dynamic data]) {
    return Response(message: message, status: ResponseType.success, data: data);
  }

  static Response error(String message) {
    return Response(message: message, status: ResponseType.error, data: null);
  }

}
