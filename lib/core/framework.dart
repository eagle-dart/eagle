import 'dart:io';
import 'request.dart';
import 'response.dart';

typedef Handler = void Function(Request req, Response res);

class EagleApi {
  final _routes = <String, Map<String, Handler>>{};
  final _middlewares = <Handler>[];

  // Middleware registration
  void use(Handler middleware) {
    _middlewares.add(middleware);
  }

  // Route registration methods
  void get(String path, Handler handler) {
    _addRoute('GET', path, handler);
  }

  void post(String path, Handler handler) {
    _addRoute('POST', path, handler);
  }

  void put(String path, Handler handler) {
    _addRoute('PUT', path, handler);
  }

  void delete(String path, Handler handler) {
    _addRoute('DELETE', path, handler);
  }

  // Internal method to register routes
  void _addRoute(String method, String path, Handler handler) {
    _routes.putIfAbsent(path, () => {})[method] = handler;
  }

  // Start the server
  Future<void> listen(int port) async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print('Server running on http://localhost:$port');

    await for (var request in server) {
      final req = Request(request);
      final res = Response(request.response);

      // Run through middleware chain
      for (var middleware in _middlewares) {
        middleware(req, res);
        if (res.isClosed) break;
      }

      if (!res.isClosed) {
        final method = request.method;
        final path = request.uri.path;
        final handler = _routes[path]?[method];

        if (handler != null) {
          handler(req, res);
        } else {
          res
            ..status(404)
            ..send('Not Found');
        }
      }
    }
  }
}
