import 'dart:html';
import 'dart:math' as Math;
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
    query('#status').text = 'onDisconnect';
  }
  
  void onExit( Controller controller )
  {
    query('#status').text = 'onExit';
  }
  
  void onFocusGained( Controller controller )
  {
    query('#status').text = 'onFocusGained';
  }
  
  void onFocusLost( Controller controller )
  {
    query('#status').text = 'onFocusLost';
  }
  
  void onFrame( Controller controller, Frame frame )
  {
    framesNumber++;
    
    if ( watch.elapsedMilliseconds > 1000 )
    {
      query('#status').text = "Data FPS: " + ( (( framesNumber / watch.elapsedMilliseconds ) * 10.0 ) / 10.0 ).toString();
      framesNumber = 0;
    }
  }
}

main() {
  query('#status').text = 'Initializing...';
  InterfaceSample interfaceSample = new InterfaceSample();
}