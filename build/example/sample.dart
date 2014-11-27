import 'dart:math' as Math;
import 'package:leap_motion/leap_motion.dart';

class Sample
{
  Controller controller;

  Sample()
  {
    controller = new Controller();
    controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnected );
    controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
  }
  
  void onConnected( LeapEvent event )
  {
    print( "connected" );
    controller.enableGesture( type: Gesture.TYPE_CIRCLE, enable: true );
    controller.enableGesture( type: Gesture.TYPE_SWIPE, enable: true );
    controller.enableGesture( type: Gesture.TYPE_SCREEN_TAP, enable: true );
    controller.enableGesture( type: Gesture.TYPE_KEY_TAP, enable: true );
  }
  
  void onFrame( LeapEvent event )
  {
    Frame frame = event.frame;
    
    print( "Frame id:" + frame.id.toString() + ", timestamp:" + frame.timestamp.toString() + ", hands:" + frame.hands.length.toString() + ", fingers:" + frame.fingers.length.toString() + ", tools:" + frame.tools.length.toString() + ", gestures:" + frame.gestures().length.toString() );

    if ( frame.hands.length > 0 ) {
        // Get the first hand
        Hand hand = frame.hands[0];

        // Check if the hand has any fingers
        FingerList fingers = hand.fingerList;
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
                if ( circle.state != Gesture.STATE_START ) {
                    Gesture previousGesture = controller.frame( history: 1 ).gesture( circle.id );
                    if ( previousGesture.isValid() ) {
                        sweptAngle = ( circle.progress - ( previousGesture as CircleGesture ).progress ) * 2 * Math.PI;
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

main()
{
  Sample sample = new Sample();
}