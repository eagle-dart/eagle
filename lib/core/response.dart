import 'dart:convert';
import 'dart:io';

class Response {
  final HttpResponse _httpResponse;
  bool isClosed = false;

  Response(this._httpResponse);

  void status(int statusCode) {
    _httpResponse.statusCode = statusCode;
  }

  void send(String message) {
    if (!isClosed) {
      _httpResponse.write(message);
      close();
    }
  }

  void json(Map<String, dynamic> data) {
    if (!isClosed) {
      _httpResponse.headers.contentType = ContentType.json;
      _httpResponse.write(jsonEncode(data));
      close();
    }
  }

  void close() {
    if (!isClosed) {
      _httpResponse.close();
      isClosed = true;
    }
  }
}
