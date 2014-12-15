library LeapMotion.WebSocket;

import "dart:async";

abstract class WebSocket {
  Future connect(String url);
  
  void add(String data);
  Stream<String> stream();
  Stream onDisconnect();
}