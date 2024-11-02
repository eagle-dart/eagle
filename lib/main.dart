import 'package:eagle_api/core/framework.dart';
import 'package:eagle_api/utils/env_loader.dart';

Future<void> main(List<String> args) async {
  final app = EagleApi();
  AppEnv.load('.env');

  app.get('/', (req, res) async {
    res.json({
      'todos': [
        {'id': 1, 'title': 'Learn Dart', 'completed': false},
        {'id': 2, 'title': 'Build a Web App', 'completed': true}
      ]
    });
  });

  app.get('/test', (req, res) async {
    res.json({'message': 'test response'});
  });

  app.post('/data', (req, res) async {
    final data = await req.json();
    res.json({'received': data});
  });

  int port = int.parse(AppEnv.get('PORT', defaultValue: '3000'));
  app.listen(port);
}
