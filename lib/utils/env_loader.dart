import 'dart:io';

class AppEnv {
  static final Map<String, String> _env = {};

  /// Loads environment variables from the specified .env file path.
  static void load(String filePath) {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception("The .env file does not exist at path: $filePath");
    }

    // Read file line by line and parse each line as key-value pairs
    for (var line in file.readAsLinesSync()) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final index = line.indexOf('=');
      if (index == -1) continue;

      final key = line.substring(0, index).trim();
      final value = line.substring(index + 1).trim();

      _env[key] = value;
    }
  }

  /// Retrieves the value of the specified environment variable.
  /// If the key doesn't exist, returns the [defaultValue].
  static String get(String key, {String defaultValue = ''}) {
    return _env[key] ?? defaultValue;
  }
}
