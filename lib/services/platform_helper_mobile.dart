import 'dart:io' show Platform;

bool isMobilePlatform() {
  return Platform.isAndroid || Platform.isIOS;
}
