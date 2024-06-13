import 'package:fashion/core/util/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links/uni_links.dart';

//? How To Use
// in main
// await UniLinksService.init();

class UniLinksService {
  static Future<void> init({checkActualVersion = false}) async {
    // This is used for cases when: APP is not running and the user clicks on a link.
    try {
      final Uri? uri = await getInitialUri();
      _uniLinkHandler(uri: uri);
    } on PlatformException {
      if (kDebugMode) {
        ePrint("(PlatformException) Failed to receive initial uri.");
      }
    } on FormatException catch (error) {
      if (kDebugMode) {
        ePrint(
            "(FormatException) Malformed Initial URI received. Error: $error");
      }
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    uriLinkStream.listen(
      (Uri? uri) => _uniLinkHandler(uri: uri),
      onError: (error) {
        if (kDebugMode) ePrint('UniLinks onUriLink error: $error');
      },
    );
  }

  static Future<void> _uniLinkHandler({required Uri? uri}) async {
    if (uri == null /* || uri.queryParameters.isEmpty*/) return;
    // Map<String, String> params = uri.queryParameters;
    ePrint(uri.toString());
    // String itemId = params['itemId'] ?? '';
    // ePrint(itemId.toString());
    // if (receivedPromoId.isEmpty) return;
  }
}
