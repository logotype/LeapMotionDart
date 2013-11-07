import 'dart:html';
import '../LeapMotionDart.dart';

class InterfaceSample implements Listener
{
  Controller controller;
  Stopwatch watch = new Stopwatch();
  int framesNumber = 0;
  
  InterfaceSample()
  {
    controller = new Controller();
    controller.setListener( this );
  }
  
  void onInit( Controller controller )
  {
    print( "onInit" );
  }
  
  void onConnect( Controller controller )
  {
    print( "onConnect" );
    controller.enableGesture( type: Gesture.TYPE_SWIPE );
    controller.enableGesture( type: Gesture.TYPE_CIRCLE );
    controller.enableGesture( type: Gesture.TYPE_SCREEN_TAP );
    controller.enableGesture( type: Gesture.TYPE_KEY_TAP );
    watch.start();
  }
  
  void onDisconnect( Controller controller )
  {
    querySelector('#status').text = 'onDisconnect';
  }
  
  void onExit( Controller controller )
  {
    querySelector('#status').text = 'onExit';
  }
  
  void onFocusGained( Controller controller )
  {
    querySelector('#status').text = 'onFocusGained';
  }
  
  void onFocusLost( Controller controller )
  {
    querySelector('#status').text = 'onFocusLost';
  }
  
  void onFrame( Controller controller, Frame frame )
  {
    framesNumber++;
    
    if ( watch.elapsedMilliseconds > 1000 )
    {
      querySelector('#status').text = "Data FPS: " + ( (( framesNumber / ( watch.elapsedMilliseconds / 1000 ) ) * 10.0 ) / 10.0 ).toString();
      framesNumber = 0;
      watch.stop();
      watch.reset();
      watch.start();
    }
  }
}

main() {
  querySelector('#status').text = 'Initializing...';
  InterfaceSample interfaceSample = new InterfaceSample();
}