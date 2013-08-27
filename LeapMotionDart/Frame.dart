part of LeapMotionDart;

/**
 * The Frame class represents a set of hand and finger tracking
 * data detected in a single frame.
 *
 * The Leap Motion detects hands, fingers and tools within the tracking area,
 * reporting their positions, orientations and motions in frames at
 * the Leap Motion frame rate.
 *
 * Access Frame objects through a listener of a Leap Motion Controller.
 * Add a listener to receive events when a new Frame is available.
 *
 * @author logotype
 *
 */
class Frame
{
  /**
   * The current framerate (in frames per second) of the Leap Motion Controller.
   * This value may fluctuate depending on available computing resources,
   * activity within the device field of view, software tracking settings,
   * and other factors.
   * An estimate of frames per second of the Leap Motion Controller.
   */
  num currentFramesPerSecond;
  
  /**
   * @private
   * The list of Finger objects detected in this frame, given in arbitrary order.<br/>
   * The list can be empty if no fingers are detected.
   */
  FingerList fingerList = new FingerList();
  
  /**
   * @private
   * The list of Hand objects detected in this frame, given in arbitrary order.<br/>
   * The list can be empty if no hands are detected.
   */
  List<Hand> handsVector = new List<Hand>();

  /**
   * @private
   * The Pointable object with the specified ID in this frame.
   *
   * Use the <code>Frame.pointable()</code> function to retrieve the Pointable
   * object from this frame using an ID value obtained from a previous frame.
   * This function always returns a Pointable object, but if no finger
   * or tool with the specified ID is present, an invalid Pointable
   * object is returned.
   *
   * Note that ID values persist across frames, but only until tracking
   * of a particular object is lost. If tracking of a finger or tool is
   * lost and subsequently regained, the new Pointable object representing
   * that finger or tool may have a different ID than that representing
   * the finger or tool in an earlier frame.
   *
   * @see [Pointable]
   *
   */
  List<Pointable> pointablesVector = new List<Pointable>();

  /**
   * @private
   * The gestures recognized or continuing in this frame.
   *
   * Circle and swipe gestures are updated every frame.
   * Tap gestures only appear in the list when they start.
   */
  List<Gesture> gesturesVector = new List<Gesture>();

  /**
   * A unique ID for this Frame.
   * Consecutive frames processed by the Leap Motion have consecutive increasing values.
   */
  int id;
  
  /**
   * The current InteractionBox for the frame.
   * See the InteractionBox class documentation for more details on how this class should be used.
   * @see [InteractionBox]
   */
  InteractionBox interactionBox;

  /**
   * The frame capture time in microseconds elapsed since the Leap Motion started.
   */
  num timestamp;

  /**
   * @private
   * The list of Tool objects detected in this frame, given in arbitrary order.
   *
   * @see [Tool]
   */
  List<Tool> toolsVector = new List<Tool>();

  /**
   * Rotation matrix.
   */
  Matrix rotation;

  /**
   * @private
   * Scale factor since last Frame.
   */
  num scaleFactorNumber;

  /**
   * @private
   * Translation since last Frame.
   */
  Vector3 translationVector;

  /**
   * @private
   * Reference to the Controller which created this object.
   */
  Controller controller;

  /**
   * Constructs a Frame object.
   *
   * Frame instances created with this constructor are invalid.
   * Get valid Frame objects by calling the <code>LeapMotion.frame()</code> function.
   *
   */
  Frame()
  {
  }

  /**
   * The Hand object with the specified ID in this frame.
   *
   * Use the <code>Frame.hand()</code> function to retrieve the Hand object
   * from this frame using an ID value obtained from a previous frame.
   * This function always returns a Hand object, but if no hand
   * with the specified ID is present, an invalid Hand object is returned.
   *
   * Note that ID values persist across frames, but only until tracking
   * of a particular object is lost. If tracking of a hand is lost
   * and subsequently regained, the new Hand object representing
   * that physical hand may have a different ID than that
   * representing the physical hand in an earlier frame.
   *
   * [id] The ID value of a Hand object from a previous frame.
   * [return] The Hand object with the matching ID if one exists
   * in this frame; otherwise, an invalid Hand object is returned.
   * @see [Hand]
   *
   */
  Hand hand( int id )
  {
    int i = 0;
    int length = handsVector.length;

    for( i; i < length; ++i )
    {
      if( handsVector[ i ].id == id )
      {
        return handsVector[ i ];
      }
    }

    return Hand.invalid();
  }

  /**
   * The list of Hand objects detected in this frame,
   * given in arbitrary order.
   *
   * The list can be empty if no hands are detected.
   * [return] The Hand vector containing all Hand objects detected in this frame.
   *
   */
  List<Hand> get hands => handsVector;

  /**
   * The Finger object with the specified ID in this frame.
   *
   * Use the <code>Frame.finger()</code> function to retrieve the Finger
   * object from this frame using an ID value obtained from a
   * previous frame. This function always returns a Finger object,
   * but if no finger with the specified ID is present, an
   * invalid Finger object is returned.
   *
   * Note that ID values persist across frames, but only until
   * tracking of a particular object is lost. If tracking of a
   * finger is lost and subsequently regained, the new Finger
   * object representing that physical finger may have a different
   * ID than that representing the finger in an earlier frame.
   *
   * [id] The ID value of a Finger object from a previous frame.
   * [return] The Finger object with the matching ID if one exists
   * in this frame; otherwise, an invalid Finger object is returned.
   * @see [Finger]
   *
   */
  Finger finger( int id )
  {
    int i = 0;
    int length = fingerList.length;

    for( i; i < length; ++i )
    {
      if( fingerList[ i ].id == id )
      {
        return fingerList[ i ];
      }
    }

    return Finger.invalid();
  }

  /**
   * The list of Finger objects detected in this frame,
   * given in arbitrary order.
   *
   * The list can be empty if no fingers are detected.
   * [return] The Finger vector containing all Finger objects detected in this frame.
   *
   */
  FingerList get fingers => fingerList;

  /**
   * The Tool object with the specified ID in this frame.
   *
   * Use the <code>Frame.tool()</code> function to retrieve the Tool
   * object from this frame using an ID value obtained from
   * a previous frame. This function always returns a Tool
   * object, but if no tool with the specified ID is present,
   * an invalid Tool object is returned.
   *
   * Note that ID values persist across frames, but only until
   * tracking of a particular object is lost. If tracking of a
   * tool is lost and subsequently regained, the new Tool
   * object representing that tool may have a different ID
   * than that representing the tool in an earlier frame.
   *
   * [id] The ID value of a Tool object from a previous frame.
   * [return] The Tool object with the matching ID if one exists in
   * this frame; otherwise, an invalid Tool object is returned.
   * @see [Tool]
   *
   */
  Tool tool( int id )
  {
    int i = 0;
    int length = toolsVector.length;

    for( i; i < length; ++i )
    {
      if( toolsVector[ i ].id == id )
      {
        return toolsVector[ i ];
      }
    }

    return Tool.invalid();
  }

  /**
   * The list of Tool objects detected in this frame,
   * given in arbitrary order.
   *
   * The list can be empty if no tools are detected.
   * [return] The ToolList containing all Tool objects detected in this frame.
   *
   */
  List<Tool> get tools => toolsVector;

  /**
   * The Pointable object with the specified ID in this frame.
   *
   * Use the <code>Frame.pointable()</code> function to retrieve the Pointable
   * object from this frame using an ID value obtained from a previous frame.
   * This function always returns a Pointable object, but if no finger
   * or tool with the specified ID is present, an invalid
   * Pointable object is returned.
   *
   * Note that ID values persist across frames, but only until tracking
   * of a particular object is lost. If tracking of a finger or tool is
   * lost and subsequently regained, the new Pointable object representing
   * that finger or tool may have a different ID than that representing
   * the finger or tool in an earlier frame.
   *
   * [id] The ID value of a Pointable object from a previous frame.
   * [return] The Pointable object with the matching ID if one exists
   * in this frame; otherwise, an invalid Pointable object is returned.
   *
   */
  Pointable pointable( int id )
  {
    int i = 0;
    int length = pointablesVector.length;

    for( i; i < length; ++i )
    {
      if( pointablesVector[ i ].id == id )
      {
        return pointablesVector[ i ];
      }
    }

    return Pointable.invalid();
  }

  /**
   * The list of Pointable objects (fingers and tools) detected in this
   * frame, given in arbitrary order.
   *
   * The list can be empty if no fingers or tools are detected.
   *
   * [return] The Pointable vector containing all Pointable objects
   * detected in this frame.
   */
  List<Pointable> get pointables => pointablesVector;

  /**
   * The Gesture object with the specified ID in this frame.
   *
   * Use the <code>Frame.gesture()</code> function to return a Gesture object in this frame
   * using an ID obtained in an earlier frame. The function always returns a
   * Gesture object, but if there was no update for the gesture in this frame,
   * then an invalid Gesture object is returned.
   *
   * All Gesture objects representing the same recognized movement share the same ID.
   *
   * [id] The ID of an Gesture object from a previous frame.
   * [return] The Gesture object in the frame with the specified ID if one
   * exists; Otherwise, an Invalid Gesture object.
   *
   */
  Gesture gesture( int id )
  {
    int i = 0;
    int length = gesturesVector.length;

    for( i; i < length; ++i )
    {
      if( gesturesVector[ i ].id == id )
      {
        return gesturesVector[ i ];
      }
    }

    return Gesture.invalid();
  }

  /**
   * Returns a Gesture vector containing all gestures that have occured
   * since the specified frame.
   *
   * If no frame is specifed, the gestures recognized or continuing in
   * this frame will be returned.
   *
   * [sinceFrame] An earlier Frame object. The starting frame must
   * still be in the frame history cache, which has a default length of 60 frames.
   * [return] The list of gestures.
   *
   */
  List<Gesture> gestures( { Frame sinceFrame: null } )
  {
    if( !isValid() )
      return [];

    if( sinceFrame == null )
    {
      // The gestures recognized or continuing in this frame.
      return gesturesVector;
    }
    else
    {
      if( !sinceFrame.isValid() )
        return new List<Gesture>();

      // Returns a Gesture vector containing all gestures that have occured since the specified frame.
      List<Gesture> gesturesSinceFrame = new List<Gesture>();
      int i = 0;
      int j = 0;

      for( i; i < controller.frameHistory.length; ++i )
      {
        for( j; j < controller.frameHistory[ i ].gesturesVector.length; ++j )
          gesturesSinceFrame.add( controller.frameHistory[ i ].gesturesVector[ j ] );

        if( sinceFrame == controller.frameHistory[ i ] )
          break;
      }

      return gesturesSinceFrame;
    }
  }

  /**
   * The axis of rotation derived from the overall rotational
   * motion between the current frame and the specified frame.
   *
   * The returned direction vector is normalized.
   *
   * The Leap Motion derives frame rotation from the relative change
   * in position and orientation of all objects detected in
   * the field of view.
   *
   * If either this frame or sinceFrame is an invalid Frame
   * object, or if no rotation is detected between the
   * two frames, a zero vector is returned.
   *
   * [sinceFrame] The starting frame for computing the relative rotation.
   * [return] A normalized direction Vector representing the axis of the
   * heuristically determined rotational change between the current
   * frame and that specified in the sinceFrame parameter.
   *
   */
  Vector3 rotationAxis( Frame sinceFrame )
  {
    if( sinceFrame && sinceFrame.rotation )
    {
      Vector3 vector = new Vector3( rotation.zBasis.y - sinceFrame.rotation.yBasis.z, rotation.xBasis.z - sinceFrame.rotation.zBasis.x, rotation.yBasis.x - sinceFrame.rotation.xBasis.y );
      return vector.normalized();
    }
    else
    {
      return new Vector3( 0.0, 0.0, 0.0 );
    }
  }

  /**
   * The angle of rotation around the rotation axis derived from the
   * overall rotational motion between the current frame and the specified frame.
   *
   * The returned angle is expressed in radians measured clockwise around
   * the rotation axis (using the right-hand rule) between the
   * start and end frames. The value is always between 0 and pi radians (0 and 180 degrees).
   *
   * The Leap Motion derives frame rotation from the relative change in position
   * and orientation of all objects detected in the field of view.
   *
   * If either this frame or sinceFrame is an invalid Frame object,
   * then the angle of rotation is zero.
   *
   * [sinceFrame] The starting frame for computing the relative rotation.
   * [axis] Optional. The axis to measure rotation around.
   * [return] A positive value containing the heuristically determined rotational
   * change between the current frame and that specified in the sinceFrame parameter.
   *
   */
  num rotationAngle( { Frame sinceFrame, Vector3 axis: null } )
  {
    if( !isValid() || !sinceFrame.isValid() )
      return 0.0;

    num returnValue = 0.0;
    Matrix rotationSinceFrameMatrix = rotationMatrix( sinceFrame );
    num cs = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z - 1 ) * 0.5;
    num angle = Math.acos( cs );
    returnValue = angle.isNaN ? 0.0 : angle;

    if( axis != null )
    {
      Vector3 rotAxis = rotationAxis( sinceFrame );
      returnValue *= rotAxis.dot( axis.normalized() );
    }

    return returnValue;
  }

  /**
   * The transform matrix expressing the rotation derived from
   * the change in orientation of this hand, and any associated
   * fingers and tools, between the current frame and the specified frame.
   *
   * If a corresponding Hand object is not found in sinceFrame,
   * or if either this frame or sinceFrame are invalid Frame objects,
   * then this method returns an identity matrix.
   *
   */
  Matrix rotationMatrix( Frame sinceFrame )
  {
    if( sinceFrame && sinceFrame.rotation )
    {
      return sinceFrame.rotation * new Matrix( x: new Vector3( this.rotation.xBasis.x, this.rotation.yBasis.x, this.rotation.zBasis.x ), y: new Vector3( this.rotation.xBasis.y, this.rotation.yBasis.y, this.rotation.zBasis.y ), z: new Vector3( this.rotation.xBasis.z, this.rotation.yBasis.z, this.rotation.zBasis.z ) );
    }
    else
    {
      return Matrix.identity();
    }
  }

  /**
   * The scale factor derived from the overall motion between the
   * current frame and the specified frame.
   *
   * The scale factor is always positive. A value of 1.0 indicates no
   * scaling took place. Values between 0.0 and 1.0 indicate contraction
   * and values greater than 1.0 indicate expansion.
   *
   * The Leap Motion derives scaling from the relative inward or outward
   * motion of all objects detected in the field of view (independent
   * of translation and rotation).
   *
   * If either this frame or sinceFrame is an invalid Frame object,
   * then this method returns 1.0.
   *
   * [sinceFrame] The starting frame for computing the relative scaling.
   * [return] A positive value representing the heuristically determined
   * scaling change ratio between the current frame and that specified
   * in the sinceFrame parameter.
   *
   */
  num scaleFactor( Frame sinceFrame )
  {
    if( sinceFrame && sinceFrame.scaleFactorNumber )
      return Math.exp( scaleFactorNumber - sinceFrame.scaleFactorNumber );
    else
      return 1.0;
  }

  /**
   * The change of position derived from the overall linear motion
   * between the current frame and the specified frame.
   *
   * The returned translation vector provides the magnitude and
   * direction of the movement in millimeters.
   *
   * The Leap Motion derives frame translation from the linear motion
   * of all objects detected in the field of view.
   *
   * If either this frame or sinceFrame is an invalid Frame object,
   * then this method returns a zero vector.
   *
   * [sinceFrame] The starting frame for computing the translation.
   * [return] A Vector representing the heuristically determined change
   * in hand position between the current frame and that specified
   * in the sinceFrame parameter.
   *
   */
  Vector3 translation( Frame sinceFrame )
  {
    if( sinceFrame.translationVector != null )
      return new Vector3( translationVector.x - sinceFrame.translationVector.x, translationVector.y - sinceFrame.translationVector.y, translationVector.z - sinceFrame.translationVector.z );
    else
      return new Vector3( 0.0, 0.0, 0.0 );
  }

  /**
   * Compare Frame object equality.
   *
   * Two Frame objects are equal if and only if both Frame objects
   * represent the exact same frame of tracking data and both
   * Frame objects are valid.
   *
   * [other] The Frame to compare with.
   * [return] True; if equal. False otherwise.
   *
   */
  operator ==( Frame other )
  {
    if( id != other.id || !isValid() || other.isValid() )
      return false;

    return true;
  }

  /**
   * Reports whether this Frame instance is valid.
   *
   * A valid Frame is one generated by the LeapMotion object that contains
   * tracking data for all detected entities. An invalid Frame contains
   * no actual tracking data, but you can call its functions without risk
   * of a null pointer exception. The invalid Frame mechanism makes it
   * more convenient to track individual data across the frame history.
   *
   * For example, you can invoke: <code>var finger:Finger = leap.frame(n).finger(fingerID);</code>
   * for an arbitrary Frame history value, "n", without first checking whether
   * frame(n) returned a null object.<br/>
   * (You should still check that the returned Finger instance is valid.)
   *
   * [return] True, if this is a valid Frame object; false otherwise.
   *
   */
  bool isValid()
  {
    if( id == null )
      return false;

    return true;
  }

  /**
   * Returns an invalid Frame object.
   *
   * You can use the instance returned by this function in comparisons
   * testing whether a given Frame instance is valid or invalid.
   * (You can also use the <code>Frame.isValid()</code> function.)
   *
   * [return] The invalid Frame instance.
   *
   */
  static Frame invalid() => new Frame();

  /**
   * Suppress compiler warning for operator overloads.
   *
   */
   int get hashCode => super.hashCode;
}