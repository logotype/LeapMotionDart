part of LeapMotionDart;

/**
 * The Controller class is your main interface to the Leap Motion Controller.
 *
 * Create an instance of this Controller class to access frames of tracking
 * data and configuration information. Frame data can be polled at any time using
 * the <code>Controller::frame()</code> function. Call <code>frame()</code> or <code>frame(0)</code>
 * to get the most recent frame. Set the history parameter to a positive integer
 * to access previous frames. A controller stores up to 60 frames in its frame history.
 *
 * Polling is an appropriate strategy for applications which already have an
 * intrinsic update loop, such as a game. You can also implement the Leap::Listener
 * interface to handle events as they occur. The Leap Motion dispatches events to the listener
 * upon initialization and exiting, on connection changes, and when a new frame
 * of tracking data is available. When these events occur, the controller object
 * invokes the appropriate callback function defined in the Listener interface.
 *
 * To access frames of tracking data as they become available:
 *
 * <ul>
 * <li>Implement the Listener interface and override the <code>Listener::onFrame()</code> function.</li>
 * <li>In your <code>Listener::onFrame()</code> function, call the <code>Controller::frame()</code> function to access the newest frame of tracking data.</li>
 * <li>To start receiving frames, create a Controller object and add event listeners to the <code>Controller::addEventListener()</code> function.</li>
 * </ul>
 *
 * When an instance of a Controller object has been initialized,
 * it calls the <code>Listener::onInit()</code> function when the listener is ready for use.
 * When a connection is established between the controller and the Leap,
 * the controller calls the <code>Listener::onConnect()</code> function. At this point,
 * your application will start receiving frames of data. The controller calls
 * the <code>Listener::onFrame()</code> function each time a new frame is available.
 * If the controller loses its connection with the Leap Motion software or
 * device for any reason, it calls the <code>Listener::onDisconnect()</code> function.
 * If the listener is removed from the controller or the controller is destroyed,
 * it calls the <code>Listener::onExit()</code> function. At that point, unless the listener
 * is added to another controller again, it will no longer receive frames of tracking data.
 *
 * @author logotype
 *
 */
class Controller extends EventDispatcher
{
  /**
   * @private
   * The Listener subclass instance.
   */
  Listener _listener;

  /**
   * @private
   * History of frame of tracking data from the Leap Motion.
   */
  List<Frame> frameHistory = new List<Frame>();

  /**
   * Most recent received Frame.
   */
  Frame _latestFrame;

  /**
   * Socket connection.
   */
  WebSocket connection;

  /**
   * @private
   * Reports whether this Controller is connected to the Leap Motion Controller.
   */
  bool _isConnected = false;

  /**
   * @private
   * Reports whether gestures is enabled.
   */
  bool _isGesturesEnabled = false;

  /**
   * Constructs a Controller object.
   * [host] IP or hostname of the computer running the Leap Motion software.
   * (currently only supported for socket connections).
   *
   */
  Controller( { String host: null } )
  {
    _listener = new DefaultListener();

    if( host != null )
    {
      connection = new WebSocket( "ws://" + host + ":6437/v4.json" );
    }
    else
    {
      connection = new WebSocket( "ws://localhost:6437/v4.json" );
    }

    _listener.onInit( this );
    
    connection.onOpen.listen( ( Event event )
    {
      _isConnected = true;
      _listener.onConnect( this );
      connection.sendString( "{ \"focused\": true }" );
    });

    connection.onClose.listen( ( CloseEvent event )
    {
      _isConnected = false;
      _listener.onDisconnect( this );
    });

    connection.onMessage.listen( ( MessageEvent event )
    {
      int i;
      Map json;
      Frame currentFrame;
      Hand hand;
      Pointable pointable;
      Gesture gesture;
      bool isTool;
      int length;
      int type;

      json = JSON.JSON.decode( event.data );
      
      if( json["id"] == null )
      {
        return;
      }

      currentFrame = new Frame();
      currentFrame.controller = this;

      // Hands
      if ( json["hands"] != null )
      {
        i = 0;
        length = json["hands"].length;
        for ( i = 0; i < length; i++ )
        {
          hand = new Hand();
          hand.frame = currentFrame;
          hand.direction = new Vector3( json["hands"][ i ]["direction"][ 0 ], json["hands"][ i ]["direction"][ 1 ], json["hands"][ i ]["direction"][ 2 ] );
          hand.id = json["hands"][ i ]["id"];
          hand.palmNormal = new Vector3( json["hands"][ i ]["palmNormal"][ 0 ], json["hands"][ i ]["palmNormal"][ 1 ], json["hands"][ i ]["palmNormal"][ 2 ] );
          hand.palmPosition = new Vector3( json["hands"][ i ]["palmPosition"][ 0 ], json["hands"][ i ]["palmPosition"][ 1 ], json["hands"][ i ]["palmPosition"][ 2 ] );
          hand.stabilizedPalmPosition = new Vector3( json["hands"][ i ]["stabilizedPalmPosition"][ 0 ], json["hands"][ i ]["stabilizedPalmPosition"][ 1 ], json["hands"][ i ]["stabilizedPalmPosition"][ 2 ] );
          hand.palmVelocity = new Vector3( json["hands"][ i ]["palmPosition"][ 0 ], json["hands"][ i ]["palmPosition"][ 1 ], json["hands"][ i ]["palmPosition"][ 2 ] );
          hand.rotation = new Matrix( x: new Vector3( json["hands"][ i ]["r"][ 0 ][ 0 ], json["hands"][ i ]["r"][ 0 ][ 1 ], json["hands"][ i ]["r"][ 0 ][ 2 ] ), y: new Vector3( json["hands"][ i ]["r"][ 1 ][ 0 ], json["hands"][ i ]["r"][ 1 ][ 1 ], json["hands"][ i ]["r"][ 1 ][ 2 ] ), z: new Vector3( json["hands"][ i ]["r"][ 2 ][ 0 ], json["hands"][ i ]["r"][ 2 ][ 1 ], json["hands"][ i ]["r"][ 2 ][ 2 ] ) );
          hand.scaleFactorNumber = json["hands"][ i ]["s"];
          hand.sphereCenter = new Vector3( json["hands"][ i ]["sphereCenter"][ 0 ], json["hands"][ i ]["sphereCenter"][ 1 ], json["hands"][ i ]["sphereCenter"][ 2 ] );
          hand.sphereRadius = json["hands"][ i ]["sphereRadius"];
          hand.timeVisible = json["hands"][ i ]["timeVisible"];
          hand.translationVector = new Vector3( json["hands"][ i ]["t"][ 0 ], json["hands"][ i ]["t"][ 1 ], json["hands"][ i ]["t"][ 2 ] );
          currentFrame.hands.add( hand );
        }
      }

      currentFrame.id = json["id"];
      currentFrame.currentFramesPerSecond = json["currentFramesPerSecond"];

      // InteractionBox
      if ( json["interactionBox"] != null )
      {
        currentFrame.interactionBox = new InteractionBox();
        currentFrame.interactionBox.center = new Vector3( json["interactionBox"]["center"][ 0 ], json["interactionBox"]["center"][ 1 ], json["interactionBox"]["center"][ 2 ] );
        currentFrame.interactionBox.width = json["interactionBox"]["size"][ 0 ];
        currentFrame.interactionBox.height = json["interactionBox"]["size"][ 1 ];
        currentFrame.interactionBox.depth = json["interactionBox"]["size"][ 2 ];
      }

      // Pointables
      if ( json["pointables"] != null )
      {
        i = 0;
        length = json["pointables"].length;
        for ( i = 0; i < length; i++ )
        {
          isTool = json["pointables"][ i ]["tool"];
          if ( isTool )
            pointable = new Tool();
          else
            pointable = new Finger();

          pointable.frame = currentFrame;
          pointable.id = json["pointables"][ i ]["id"];
          pointable.hand = Controller.getHandByID( currentFrame, json["pointables"][ i ]["handId"] );
          pointable.length = json["pointables"][ i ]["length"];
          pointable.direction = new Vector3( json["pointables"][ i ]["direction"][ 0 ], json["pointables"][ i ]["direction"][ 1 ], json["pointables"][ i ]["direction"][ 2 ] );
          pointable.tipPosition = new Vector3( json["pointables"][ i ]["tipPosition"][ 0 ], json["pointables"][ i ]["tipPosition"][ 1 ], json["pointables"][ i ]["tipPosition"][ 2 ] );
          pointable.stabilizedTipPosition = new Vector3( json["pointables"][ i ]["stabilizedTipPosition"][ 0 ], json["pointables"][ i ]["stabilizedTipPosition"][ 1 ], json["pointables"][ i ]["stabilizedTipPosition"][ 2 ] );
          pointable.tipVelocity = new Vector3( json["pointables"][ i ]["tipVelocity"][ 0 ], json["pointables"][ i ]["tipVelocity"][ 1 ], json["pointables"][ i ]["tipVelocity"][ 2 ] );
          pointable.touchDistance = json["pointables"][ i ]["touchDistance"];
          pointable.timeVisible = json["pointables"][ i ]["timeVisible"];
          currentFrame.pointables.add( pointable );

          switch( json["pointables"][ i ]["touchZone"] )
          {
            case "hovering":
              pointable.touchZone = Pointable.ZONE_HOVERING;
              break;
            case "touching":
              pointable.touchZone = Pointable.ZONE_TOUCHING;
              break;
            default:
              pointable.touchZone = Pointable.ZONE_NONE;
              break;
          }

          if ( pointable.hand != null )
            pointable.hand.pointables.add( pointable );

          if ( isTool )
          {
            pointable.isTool = true;
            pointable.isFinger = false;
            pointable.width = json["pointables"][ i ]["width"];
            currentFrame.tools.add( pointable );
            if ( pointable.hand != null )
              pointable.hand.toolsVector.add( pointable );
          }
          else
          {
            pointable.isTool = false;
            pointable.isFinger = true;
            currentFrame.fingers.add( pointable );
            if ( pointable.hand != null )
              pointable.hand.fingerList.add( pointable );
          }
        }
      }

      // Gestures
      if ( json["gestures"] != null )
      {
        i = 0;
        length = json["gestures"].length;
        for ( i = 0; i < length; i++ )
        {
          switch( json["gestures"][ i ]["type"] )
          {
            case "circle":
              gesture = new CircleGesture();
              type = Gesture.TYPE_CIRCLE;
              CircleGesture circle = gesture;

              circle.center = new Vector3( json["gestures"][ i ]["center"][ 0 ], json["gestures"][ i ]["center"][ 1 ], json["gestures"][ i ]["center"][ 2 ] );
              circle.normal = new Vector3( json["gestures"][ i ]["normal"][ 0 ], json["gestures"][ i ]["normal"][ 1 ], json["gestures"][ i ]["normal"][ 2 ] );
              circle.progress = json["gestures"][ i ]["progress"];
              circle.radius = json["gestures"][ i ]["radius"];
              break;

            case "swipe":
              gesture = new SwipeGesture();
              type = Gesture.TYPE_SWIPE;

              SwipeGesture swipe = gesture;

              swipe.startPosition = new Vector3( json["gestures"][ i ]["startPosition"][ 0 ], json["gestures"][ i ]["startPosition"][ 1 ], json["gestures"][ i ]["startPosition"][ 2 ] );
              swipe.position = new Vector3( json["gestures"][ i ]["position"][ 0 ], json["gestures"][ i ]["position"][ 1 ], json["gestures"][ i ]["position"][ 2 ] );
              swipe.direction = new Vector3( json["gestures"][ i ]["direction"][ 0 ], json["gestures"][ i ]["direction"][ 1 ], json["gestures"][ i ]["direction"][ 2 ] );
              swipe.speed = json["gestures"][ i ]["speed"];
              break;

            case "screenTap":
              gesture = new ScreenTapGesture();
              type = Gesture.TYPE_SCREEN_TAP;

              ScreenTapGesture screenTap = gesture;
              screenTap.position = new Vector3( json["gestures"][ i ]["position"][ 0 ], json["gestures"][ i ]["position"][ 1 ], json["gestures"][ i ]["position"][ 2 ] );
              screenTap.direction = new Vector3( json["gestures"][ i ]["direction"][ 0 ], json["gestures"][ i ]["direction"][ 1 ], json["gestures"][ i ]["direction"][ 2 ] );
              screenTap.progress = json["gestures"][ i ]["progress"];
              break;

            case "keyTap":
              gesture = new KeyTapGesture();
              type = Gesture.TYPE_KEY_TAP;

              KeyTapGesture keyTap = gesture;
              keyTap.position = new Vector3( json["gestures"][ i ]["position"][ 0 ], json["gestures"][ i ]["position"][ 1 ], json["gestures"][ i ]["position"][ 2 ] );
              keyTap.direction = new Vector3( json["gestures"][ i ]["direction"][ 0 ], json["gestures"][ i ]["direction"][ 1 ], json["gestures"][ i ]["direction"][ 2 ] );
              keyTap.progress = json["gestures"][ i ]["progress"];
              break;

            default:
              throw( "unkown gesture type" );
          }

          int j = 0;
          int lengthInner = 0;

          if( json["gestures"][ i ]["handIds"] != null )
          {
            j = 0;
            lengthInner = json["gestures"][ i ]["handIds"].length;
            for( j = 0; j < lengthInner; ++j )
            {
              Hand gestureHand = Controller.getHandByID( currentFrame, json["gestures"][ i ]["handIds"][ j ] );
              gesture.hands.add( gestureHand );
            }
          }

          if( json["gestures"][ i ]["pointableIds"] != null )
          {
            j = 0;
            lengthInner = json["gestures"][ i ]["pointableIds"].length;
            for( j = 0; j < lengthInner; ++j )
            {
              Pointable gesturePointable = Controller.getPointableByID( currentFrame, json["gestures"][ i ]["pointableIds"][ j ] );
              if( gesturePointable != null )
              {
                gesture.pointables.add( gesturePointable );
              }
            }
            if( gesture is CircleGesture && gesture.pointables.length > 0 )
            {
              gesture.pointable = gesture.pointables[ 0 ];
            }
          }

          gesture.frame = currentFrame;
          gesture.id = json["gestures"][ i ]["id"];
          gesture.duration = json["gestures"][ i ]["duration"];
          gesture.durationSeconds = gesture.duration / 1000000;

          switch( json["gestures"][ i ]["state"] )
          {
            case "start":
              gesture.state = Gesture.STATE_START;
              break;
            case "update":
              gesture.state = Gesture.STATE_UPDATE;
              break;
            case "stop":
              gesture.state = Gesture.STATE_STOP;
              break;
            default:
              gesture.state = Gesture.STATE_INVALID;
          }

          gesture.type = type;

          currentFrame.gesturesVector.add( gesture );
        }
      }

      // Rotation (since last frame), interpolate for smoother motion
      if ( json["r"] != null )
        currentFrame.rotation = new Matrix( x: new Vector3( json["r"][ 0 ][ 0 ], json["r"][ 0 ][ 1 ], json["r"][ 0 ][ 2 ] ), y: new Vector3( json["r"][ 1 ][ 0 ], json["r"][ 1 ][ 1 ], json["r"][ 1 ][ 2 ] ), z: new Vector3( json["r"][ 2 ][ 0 ], json["r"][ 2 ][ 1 ], json["r"][ 2 ][ 2 ] ) );

      // Scale factor (since last frame), interpolate for smoother motion
      currentFrame.scaleFactorNumber = json["s"];

      // Translation (since last frame), interpolate for smoother motion
      if ( json["t"] != null )
        currentFrame.translationVector = new Vector3( json["t"][ 0 ], json["t"][ 1 ], json["t"][ 2 ] );

      // Timestamp
      currentFrame.timestamp = json["timestamp"];

      // Add frame to history
      if ( frameHistory.length > 59 )
        frameHistory.removeRange( 59, frameHistory.length );

      frameHistory.insert( 0, _latestFrame );
      _latestFrame = currentFrame;
      _listener.onFrame( this, _latestFrame );
    });
  }

  /**
   * Finds a Hand object by ID.
  *
   * [frame] The Frame object in which the Hand contains
   * [id] The ID of the Hand object
   * [return] The Hand object if found, otherwise null
  *
   */
  static Hand getHandByID( Frame frame, int id )
  {
    Hand returnValue;
    int i = 0;

    for( i = 0; i < frame.hands.length; i++ )
    {
      if ( frame.hands[ i ].id == id )
      {
        returnValue = frame.hands[ i ];
        break;
      }
    }
    return returnValue;
  }

  /**
   * Finds a Pointable object by ID.
   *
   * [frame] The Frame object in which the Pointable contains
   * [id] The ID of the Pointable object
   * [return] The Pointable object if found, otherwise null
  *
   */
  static Pointable getPointableByID( Frame frame, int id )
  {
    Pointable returnValue;
    int i = 0;

    for( i = 0; i < frame.pointables.length; i++ )
    {
      if ( frame.pointables[ i ].id == id )
      {
        returnValue = frame.pointables[ i ];
        break;
      }
    }
    return returnValue;
  }
  
  /**
   * Returns a frame of tracking data from the Leap Motion.
   *
   * Use the optional history parameter to specify which frame to retrieve.
   * Call <code>frame()</code> or <code>frame(0)</code> to access the most recent frame;
   * call <code>frame(1)</code> to access the previous frame, and so on. If you use a history value
   * greater than the number of stored frames, then the controller returns
   * an invalid frame.
   *
   * [history] The age of the frame to return, counting backwards from
   * the most recent frame (0) into the past and up to the maximum age (59).
   *
   * [return] The specified frame; or, if no history parameter is specified,
   * the newest frame. If a frame is not available at the specified
   * history position, an invalid Frame is returned.
   *
   */
  Frame frame( { int history: 0 } )
  {
    if( history >= frameHistory.length )
      return Frame.invalid();
    else
      return frameHistory[ history ];
  }
  
  /**
   * Update the object that receives direct updates from the Leap Motion Controller.
  *
   * The default listener will make the controller dispatch flash events.
   * You can override this behaviour, by implementing the IListener interface
   * in your own classes, and use this method to set the listener to your
   * own implementation.
   */
  void setListener( Listener listener )
  {
    _listener = listener;
  }

  /**
   * Enables or disables reporting of a specified gesture type.
   *
   * By default, all gesture types are disabled. When disabled, gestures of
   * the disabled type are never reported and will not appear in the frame
   * gesture list.
   *
   * As a performance optimization, only enable recognition for the types
   * of movements that you use in your application.
   *
   * [type] The type of gesture to enable or disable. Must be a member of the Gesture::Type enumeration.
   * [enable] True, to enable the specified gesture type; False, to disable.
   *
   */
  void enableGesture( { int type, bool enable: true } )
  {
    if( enable )
    {
      _isGesturesEnabled = true;
      connection.sendString( "{ \"enableGestures\": true }" );
    }
    else
    {
      _isGesturesEnabled = false;
      connection.sendString( "{ \"enableGestures\": false }" );
    }
  }

  /**
   * Reports whether the specified gesture type is enabled.
   *
   * [type] The Gesture.TYPE parameter.
   * [return] True, if the specified type is enabled; false, otherwise.
   *
   */
  bool isGestureEnabled( int type ) => _isGesturesEnabled;

  /**
   * Reports whether this Controller is connected to the Leap Motion Controller.
   *
   * When you first create a Controller object, <code>isConnected()</code> returns false.
   * After the controller finishes initializing and connects to
   * the Leap, <code>isConnected()</code> will return true.
   *
   * You can either handle the onConnect event using a event listener
   * or poll the <code>isConnected()</code> function if you need to wait for your
   * application to be connected to the Leap Motion before performing
   * some other operation.
   *
   * [return] True, if connected; false otherwise.
   *
   */
  bool isConnected() => _isConnected;
}