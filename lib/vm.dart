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
    var controller = new StreamController.broadcast();
    _sock.listen((data) {
      if (data is String) {
        controller.add(data);
      }
    });
    return controller.stream;
  }

  @override
  Stream onDisconnect() {
    return _sock.done.asStream();
  }
}