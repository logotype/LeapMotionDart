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
      sock.pingInterval = new Duration(milliseconds: 500);
      _sock = sock;
    });
  }

  @override
  Stream<String> stream() {
    return _sock.where((it) => it is String).asBroadcastStream();
  }

  @override
  Stream onDisconnect() {
    return _sock.done.asStream();
  }
}