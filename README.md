LeapMotionDart
=================

This is the Dart framework for working with Leap Motion.

Leap Motion is a motion-control software and hardware company developing the world's most powerful and sensitive 3D motion-control and motion-sensing technology.

[leapmotion.com](http://www.leapmotion.com)

A new language by Google, with tools and libraries, for structured web app engineering. The Dart language is familiar and easy to learn. It's class based and object oriented, without being dogmatic. Performance is good and getting better. Dart apps are fastest in the Dart VM, but they can be speedy even after compilation to JavaScript.

[dartlang.org](http://www.dartlang.org)

Quick start
-----------

Clone the repo, `git clone git://github.com/logotype/LeapMotionDart.git`.

Import the library and create an instance of the Controller class. What you'll get from the `LEAPMOTION_FRAME` handler is a `Frame` instance,
with strongly typed properties such as `Hands`, `Pointables`, `Direction`, `Gestures` and more:

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
            print( "Hand pitch:" + LeapUtil.toDegrees(direction.pitch) + " degrees, " + "roll:" + LeapUtil.toDegrees(normal.roll) + " degrees, " + "yaw:" + LeapUtil.toDegrees(direction.yaw) + " degrees\n" );
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
                    print( "Circle id:" + circle.id.toString() + ", " + circle.state.toString() + ", progress:" + circle.progress.toString() + ", radius:" + circle.radius.toString() + ", angle:" + LeapUtil.toDegrees(sweptAngle) + ", " + clockwiseness );
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

Example output:

    Frame id:1125277, timestamp:14800590398, hands:1, fingers:5, tools:0, gestures:5
    Hand has 5 fingers, average finger tip position:[Vector3 x:4.767591999999996 y:129.5072 z:-28.39772]
    Hand sphere radius:136.979 mm, palm position:[Vector3 x:19.067 y:127.976 z:42.0272]
    Hand pitch:6.500235603666339 degrees, roll:6.0708401144239925 degrees, yaw:-9.621146044782972 degrees
    Circle id:27, 2, progress:3.92605, radius:43.2705, angle:13.417199999999967, counterclockwise
    Circle id:25, 2, progress:3.90497, radius:40.3004, angle:13.489199999999961, counterclockwise

Optionally, you can simply call `controller.frame()` e.g. in your main loop, or implement the `Listener` interface for callbacks.

Authors
-------

**Victor Norgren**

+ http://twitter.com/logotype
+ http://github.com/logotype
+ http://logotype.se

Copyright and license
---------------------

Copyright © 2013 logotype

Author: Victor Norgren

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:  The above copyright
notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE. 
