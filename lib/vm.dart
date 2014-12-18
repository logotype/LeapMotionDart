library LeapMotion.VM;

import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "dart:math";
import "package:crypto/crypto.dart";
import "dart:async";
import "websocket.dart" as WS;

export "leap_motion.dart";

// Dart VM sends headers in lowercase which causes problems. So I am going to do the HTTP stuff all myself
class WebSocketHacker {
  Future<Socket> createSocket(String url, Map<String, String> headers) {
    var uri = Uri.parse(url);
    var completer = new Completer();
    Socket.connect(uri.host, uri.port).then((socket) {
      socket.write("GET ${uri.path} HTTP/1.1\r\n");
      for (var key in headers.keys) {
        socket.write("${key}: ${headers[key]}\r\n");
      }
      socket.write("\r\n");
      
      new Future.delayed(new Duration(milliseconds: 250), () {
        completer.complete(socket);
      });
    });
    
    return completer.future;
  }
  
  Future<WebSocket> connect(String url) {
    Random random = new Random();
    // Generate 16 random bytes.
    Uint8List nonceData = new Uint8List(16);
    for (int i = 0; i < 16; i++) {
      nonceData[i] = random.nextInt(256);
    }
    String nonce = CryptoUtils.bytesToBase64(nonceData);
    return createSocket(url, {
      "Host": Uri.parse(url).host,
      "Upgrade": "websocket",
      "Connection": "Upgrade",
      "Sec-WebSocket-Key": nonce,
      "Sec-WebSocket-Version": "13",
      "Cache-Control": "no-cache",
      "Pragma": "no-cache",
      "Accept-Language": "en-US,en;q=0.8",
      "User-Agent": "Dart",
      "Accept": "*/*"
    }).then((socket) {
      var completer = new Completer();
      var sub;
      var decoder = new Utf8Decoder(allowMalformed: true);
      sub = socket.listen((data) {
        var d = decoder.convert(data);
        var split = d.split("\r\n\r\n\r\n");
        var extra;
        if (split.length > 1) {
          extra = split[1].codeUnits;
        }
        var detached = new _DetachedSocket(socket, new _HttpDetachedIncoming(sub, extra));
        completer.complete(detached);
      });
      return completer.future;
    }).then((socket) {
      return new WebSocket.fromUpgradedSocket(socket, serverSide: false);
    });
  }
}

class VMWebSocket extends WS.WebSocket {
  WebSocket _sock;
  
  @override
  void add(String data) {
    _sock.add(data);
  }

  @override
  Future connect(String url) {
    return new WebSocketHacker().connect(url).then((sock) {
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

class _HttpDetachedIncoming extends Stream<List<int>> {
  final StreamSubscription subscription;
  final List<int> bufferedData;

  _HttpDetachedIncoming(this.subscription, this.bufferedData);

  StreamSubscription<List<int>> listen(void onData(List<int> event),
                                       {Function onError,
                                        void onDone(),
                                        bool cancelOnError}) {
    if (subscription != null) {
      subscription
        ..onData(onData)
        ..onError(onError)
        ..onDone(onDone);
      if (bufferedData == null) {
        return subscription..resume();
      }
      return new _HttpDetachedStreamSubscription(subscription,
                                                 bufferedData,
                                                 onData)
        ..resume();
    } else {
      return new Stream.fromIterable(bufferedData)
          .listen(onData,
                  onError: onError,
                  onDone: onDone,
                  cancelOnError: cancelOnError);
    }
  }
}

class _HttpDetachedStreamSubscription implements StreamSubscription<List<int>> {
  StreamSubscription<List<int>> _subscription;
  List<int> _injectData;
  bool _isCanceled = false;
  int _pauseCount = 1;
  Function _userOnData;
  bool _scheduled = false;

  _HttpDetachedStreamSubscription(this._subscription,
                                  this._injectData,
                                  this._userOnData);

  bool get isPaused => _subscription.isPaused;

  Future asFuture([futureValue]) => _subscription.asFuture(futureValue);

  Future cancel() {
    _isCanceled = true;
    _injectData = null;
    return _subscription.cancel();
  }

  void onData(void handleData(List<int> data)) {
    _userOnData = handleData;
    _subscription.onData(handleData);
  }

  void onDone(void handleDone()) {
    _subscription.onDone(handleDone);
  }

  void onError(Function handleError) {
    _subscription.onError(handleError);
  }

  void pause([Future resumeSignal]) {
    if (_injectData == null) {
      _subscription.pause(resumeSignal);
    } else {
      _pauseCount++;
      if (resumeSignal != null) {
        resumeSignal.whenComplete(resume);
      }
    }
  }

  void resume() {
    if (_injectData == null) {
      _subscription.resume();
    } else {
      _pauseCount--;
      _maybeScheduleData();
    }
  }

  void _maybeScheduleData() {
    if (_scheduled) return;
    if (_pauseCount != 0) return;
    _scheduled = true;
    scheduleMicrotask(() {
      _scheduled = false;
      if (_pauseCount > 0 || _isCanceled) return;
      var data = _injectData;
      _injectData = null;
      // To ensure that 'subscription.isPaused' is false, we resume the
      // subscription here. This is fine as potential events are delayed.
      _subscription.resume();
      if (_userOnData != null) {
        _userOnData(data);
      }
    });
  }
}


class _DetachedSocket extends Stream<List<int>> implements Socket {
  final Stream<List<int>> _incoming;
  final _socket;

  _DetachedSocket(this._socket, this._incoming);

  StreamSubscription<List<int>> listen(void onData(List<int> event),
                                       {Function onError,
                                        void onDone(),
                                        bool cancelOnError}) {
    return _incoming.listen(onData,
                            onError: onError,
                            onDone: onDone,
                            cancelOnError: cancelOnError);
  }

  Encoding get encoding => _socket.encoding;

  void set encoding(Encoding value) {
    _socket.encoding = value;
  }

  void write(Object obj) => _socket.write(obj);

  void writeln([Object obj = ""]) => _socket.writeln(obj);

  void writeCharCode(int charCode) => _socket.writeCharCode(charCode);

  void writeAll(Iterable objects, [String separator = ""]) {
    _socket.writeAll(objects, separator);
  }

  void add(List<int> bytes) => _socket.add(bytes);

  void addError(error, [StackTrace stackTrace]) =>
      _socket.addError(error, stackTrace);

  Future<Socket> addStream(Stream<List<int>> stream) {
    return _socket.addStream(stream);
  }

  void destroy() => _socket.destroy();

  Future flush() => _socket.flush();

  Future close() => _socket.close();

  Future<Socket> get done => _socket.done;

  int get port => _socket.port;

  InternetAddress get address => _socket.address;

  InternetAddress get remoteAddress => _socket.remoteAddress;

  int get remotePort => _socket.remotePort;

  bool setOption(SocketOption option, bool enabled) {
    return _socket.setOption(option, enabled);
  }

  Map _toJSON(bool ref) => _socket._toJSON(ref);
  void set _owner(owner) { _socket._owner = owner; }
}