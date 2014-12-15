library LeapMotion.Browser;

import "dart:io";
import "dart:async";
import "websocket.dart" as WS;

export "leap_motion.dart";

class VMWebSocket extends WS.WebSocket {
  WebSocket _sock;
  
  @override
  void add(String data) {
    _sock.add(data);
  }

  @override
  Future connect(String url) {
    return WebSocket.connect(url).then((sock) {
      _sock = sock;
    });
  }

  @override
  Stream<String> stream() {
    return _sock;
  }

  @override
  Stream onDisconnect() {
    return _sock.done.asStream();
  }
}