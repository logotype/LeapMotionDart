import "package:leap_motion/vm.dart";

void main() {
  new WebSocketHacker().connect("ws://echo.websocket.org").then((socket) {
    socket.listen((data) {
      print(data);
    });
    
    socket.add("Hello World");
  });
}