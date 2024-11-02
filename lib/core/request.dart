import 'dart:convert';
import 'dart:io';

class Request {
  final HttpRequest _httpRequest;

  Request(this._httpRequest);

  String get method => _httpRequest.method;
  Uri get uri => _httpRequest.uri;
  HttpHeaders get headers => _httpRequest.headers;

  Future<Map<String, dynamic>> json() async {
    final content = await utf8.decodeStream(_httpRequest);
    return jsonDecode(content);
  }
}
