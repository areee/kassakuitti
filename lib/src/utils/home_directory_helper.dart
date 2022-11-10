import 'dart:io';

/// Returns user's home directory.
String getUserHomeDirectory() {
  // Source: https://stackoverflow.com/a/25498458

  String? homeDirectory;
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS || Platform.isLinux) {
    homeDirectory = envVars['HOME'];
  } else if (Platform.isWindows) {
    homeDirectory = envVars['UserProfile'];
  }

  // Throw an exception if the home directory is not found.
  if (homeDirectory == null) {
    throw Exception('Home directory not found.');
  }

  return homeDirectory;
}

/// Replaces tilde with user's home directory if it exists.
String replaceTildeWithHomeDirectory(String path) {
  if (path.startsWith('~')) {
    return path.replaceFirst('~', getUserHomeDirectory());
  } else {
    return path;
  }
}
