library LeapMotion.Browser;

import "dart:html";
import "dart:async";
import "websocket.dart" as WS;

export "leap_motion.dart";

class BrowserWebSocket extends WS.WebSocket {
  WebSocket _sock;
  
  @override
  void add(String data) {
    _sock.sendString(data);
  }

  @override
  Future connect(String url) {
    _sock = new WebSocket(url);
    var completer = new Completer();
    _sock.onOpen.listen((e) {
      completer.complete();
    });
    return completer.future;
  }

  @override
  Stream<String> stream() {
    return _sock.onMessage.map((it) => it.data);
  }

  @override
  Stream onDisconnect() {
    return _sock.onClose;
  }
}