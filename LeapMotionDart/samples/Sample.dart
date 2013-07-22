import 'dart:math' as Math;
import '../LeapMotionDart.dart';

class InterfaceSample implements Listener
{
  Controller controller;

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
  }
  
  void onDisconnect( Controller controller )
  {
    print( "onDisconnect" );
  }
  
  void onExit( Controller controller )
  {
    print( "onExit" );
  }
    
  void onFrame( Controller controller, Frame frame )
  {
    print("Frame id:" + frame.id.toString() + ", timestamp:" + frame.timestamp.toString() + ", hands:" + frame.hands.length.toString() + ", fingers:" + frame.fingers.length.toString() + ", tools:" + frame.tools.length.toString() + ", gestures:" + frame.gestures().length.toString() );

    if (frame.hands.length > 0) {
        // Get the first hand
        Hand hand = frame.hands[0];

        // Check if the hand has any fingers
        List<Finger> fingers = hand.fingersVector;
        if ( fingers.length > 0 ) {
            // Calculate the hand's average finger tip position
            Vector3 avgPos = Vector3.zero();
            for ( int i = 0; i <fingers.length; i++ )
                avgPos = avgPos + fingers[ i ].tipPosition;

            avgPos = avgPos / fingers.length.toDouble();
            print( "Hand has " + fingers.length.toString() + " fingers, average finger tip position:" + avgPos.toString() );
        }

        // Get the hand's sphere radius and palm position
        print( "Hand sphere radius:" + hand.sphereRadius.toString() + " mm, palm position:" + hand.palmPosition.toString() );

        // Get the hand's normal vector and direction
        Vector3 normal = hand.palmNormal;
        Vector3 direction = hand.direction;

        // Calculate the hand's pitch, roll, and yaw angles
        print( "Hand pitch:" + LeapUtil.toDegrees( direction.pitch ).toString() + " degrees, " + "roll:" + LeapUtil.toDegrees( normal.roll ).toString() + " degrees, " + "yaw:" + LeapUtil.toDegrees( direction.yaw ).toString() + " degrees\n" );
    }

    List<Gesture> gestures = frame.gestures();
    for (int i = 0; i <gestures.length; i++) {
        Gesture gesture = gestures[ i ];

        switch ( gesture.type ) {
            case Gesture.TYPE_CIRCLE:
                CircleGesture circle = gesture as CircleGesture;

                // Calculate clock direction using the angle between circle normal and pointable
                String clockwiseness;
                if ( circle.pointable.direction.angleTo(circle.normal) <= Math.PI / 4 ) {
                    // Clockwise if angle is less than 90 degrees
                    clockwiseness = "clockwise";
                } else {
                    clockwiseness = "counterclockwise";
                }

                // Calculate angle swept since last frame
                double sweptAngle = 0.0;
                if (circle.state != Gesture.STATE_START) {
                    Gesture previousGesture = controller.frame( history: 1 ).gesture( circle.id );
                    if (previousGesture.isValid()) {
                        CircleGesture previousUpdate = ( controller.frame( history: 1 ).gesture( circle.id ) as CircleGesture );
                        sweptAngle = ( circle.progress - previousUpdate.progress ) * 2 * Math.PI;
                    }
                }
                print( "Circle id:" + circle.id.toString() + ", " + circle.state.toString() + ", progress:" + circle.progress.toString() + ", radius:" + circle.radius.toString() + ", angle:" + LeapUtil.toDegrees( sweptAngle ).toString() + ", " + clockwiseness );
                break;
            case Gesture.TYPE_SWIPE:
                SwipeGesture swipe = gesture as SwipeGesture;
                print( "Swipe id:" + swipe.id.toString() + ", " + swipe.state.toString() + ", position:" + swipe.position.toString() + ", direction:" + swipe.direction.toString() + ", speed:" + swipe.speed.toString() );
                break;
            case Gesture.TYPE_SCREEN_TAP:
                ScreenTapGesture screenTap = gesture as ScreenTapGesture;
                print( "Screen Tap id:" + screenTap.id.toString() + ", " + screenTap.state.toString() + ", position:" + screenTap.position.toString() + ", direction:" + screenTap.direction.toString() );
                break;
            case Gesture.TYPE_KEY_TAP:
                KeyTapGesture keyTap = gesture as KeyTapGesture;
                print( "Key Tap id:" + keyTap.id.toString() + ", " + keyTap.state.toString() + ", position:" + keyTap.position.toString() + ", direction:" + keyTap.direction.toString() );
                break;
        }
    }
  }
}