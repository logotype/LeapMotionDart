part of LeapMotionDart;

/**
 * The Hand class reports the physical characteristics of a detected hand.
 *
 * Hand tracking data includes a palm position and velocity; vectors for
 * the palm normal and direction to the fingers; properties of a sphere fit
 * to the hand; and lists of the attached fingers and tools.
 *
 * Note that Hand objects can be invalid, which means that they do not
 * contain valid tracking data and do not correspond to a physical entity.
 * Invalid Hand objects can be the result of asking for a Hand object using
 * an ID from an earlier frame when no Hand objects with that ID exist in
 * the current frame. A Hand object created from the Hand constructor is
 * also invalid. Test for validity with the <code>Hand.isValid()</code> function.
 *
 * @author logotype
 *
 */
class Hand
{
  /**
   * The direction from the palm position toward the fingers.
   *
   * The direction is expressed as a unit vector pointing in the same
   * direction as the directed line from the palm position to the fingers.
   */
  Vector3 direction;

  /**
   * @private
   * The list of Finger objects detected in this frame that are attached
   * to this hand, given in arbitrary order.
   * @see [Finger]
   */
  FingerList fingerList = new FingerList();

  /**
   * The Frame associated with this Hand.
   * @see [Frame]
   */
  Frame frame = Frame.invalid();

  /**
   * A unique ID assigned to this Hand object, whose value remains
   * the same across consecutive frames while the tracked hand remains visible.
   *
   * If tracking is lost (for example, when a hand is occluded by another
   * hand or when it is withdrawn from or reaches the edge of the Leap Motion field
   * of view), the Leap Motion may assign a new ID when it detects the hand in a future frame.
   *
   * Use the ID value with the <code>Frame.hand()</code> function to find this Hand object
   * in future frames.
   */
  int id;

  /**
   * The normal vector to the palm.
   */
  Vector3 palmNormal;

  /**
   * The center position of the palm in millimeters from the Leap Motion origin.
   */
  Vector3 palmPosition;

  /**
   * The stabilized palm position of this Hand.
   * Smoothing and stabilization is performed in order to make this value more suitable for interaction with 2D content.
   * A modified palm position of this Hand object with some additional smoothing and stabilization applied. 
   */
  Vector3 stabilizedPalmPosition;
  
  /**
   * The duration of time this Hand has been visible to the Leap Motion Controller.
   * The duration (in seconds) that this Hand has been tracked. 
   */
  num timeVisible;
  
  /**
   * The rate of change of the palm position in millimeters/second.
   */
  Vector3 palmVelocity;

  /**
   * @private
   * The list of Pointable objects (fingers and tools) detected in this
   * frame that are associated with this hand, given in arbitrary order.
   *
   * The list can be empty if no fingers or tools associated with this hand are detected.
   * Use the <code>Pointable.isFinger()</code> function to determine whether or not an item in the
   * list represents a finger. Use the <code>Pointable.isTool()</code> function to determine
   * whether or not an item in the list represents a tool. You can also get
   * only fingers using the <code>Hand.fingers()</code> function or only tools using
   * the <code>Hand.tools()</code> function.
   *
   * @see [Pointable]
   *
   */
  List<Pointable> pointablesVector = new List<Pointable>();

  /**
   * The center of a sphere fit to the curvature of this hand.
   */
  Vector3 sphereCenter;
  /**
   * The radius of a sphere fit to the curvature of this hand.
   */
  num sphereRadius;

  /**
   * @private
   * The list of Tool objects detected in this frame that are held by this hand, given in arbitrary order.
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
   * Constructs a Hand object.
   *
   * An uninitialized hand is considered invalid.
   *
   * Get valid Hand objects from a Frame object.
   *
   */
  Hand()
  {
  }

  /**
   * Reports whether this is a valid Hand object.
   * [return] True, if this Hand object contains valid tracking data.
   *
   */
  bool isValid()
  {
    if( ( direction != null && direction.isValid() ) && ( palmNormal != null && palmNormal.isValid() ) && ( palmPosition != null && palmPosition.isValid() ) && ( palmVelocity != null && palmVelocity.isValid() ) && ( sphereCenter != null && sphereCenter.isValid() ) )
      return true;

    return false;
  }

  /**
   * Compare Hand object equality/inequality.
   *
   * Two Hand objects are equal if and only if both Hand objects
   * represent the exact same physical hand in the same frame
   * and both Hand objects are valid.
   *
   * [other] The Hand object to compare with.
   * [returns] True; if equal. False otherwise.
   *
   */
  operator ==( Hand other )
  {
    if( id == other.id && frame == other.frame && isValid() && other.isValid() )
      return true;

    return false;
  }

  /**
   * The Finger object with the specified ID attached to this hand.
   *
   * Use the <code>Hand.finger()</code> function to retrieve a Finger object attached
   * to this hand using an ID value obtained from a previous frame.
   * This function always returns a Finger object, but if no finger
   * with the specified ID is present, an invalid Finger object is returned.
   *
   * Note that ID values persist across frames, but only until tracking of
   * a particular object is lost. If tracking of a finger is lost and
   * subsequently regained, the new Finger object representing that
   * finger may have a different ID than that representing the finger in an earlier frame.
   *
   * [id] The ID value of a Finger object from a previous frame.
   * [return] The Finger object with the matching ID if one exists for
   * this hand in this frame; otherwise, an invalid Finger object is returned.
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
   * The list of Finger objects detected in this hand,
   * given in arbitrary order.
   *
   * The list can be empty if no fingers are detected.
   * [return] The Finger vector containing all Finger objects detected in this hand.
   *
   */
  FingerList fingers() => fingerList;

  /**
   * The Tool object with the specified ID held by this hand.
   *
   * Use the <code>Hand.tool()</code> function to retrieve a Tool object held
   * by this hand using an ID value obtained from a previous frame.
   * This function always returns a Tool object, but if no tool
   * with the specified ID is present, an invalid Tool object is returned.
   *
   * Note that ID values persist across frames, but only until
   * tracking of a particular object is lost. If tracking of a tool
   * is lost and subsequently regained, the new Tool object
   * representing that tool may have a different ID than that
   * representing the tool in an earlier frame.
   *
   * [id] The ID value of a Tool object from a previous frame.
   * [return] The Tool object with the matching ID if one exists for
   * this hand in this frame; otherwise, an invalid Tool object is returned.
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
   * The list of Tool objects detected in this hand,
   * given in arbitrary order.
   *
   * The list can be empty if no tools are detected.
   * [return] The ToolList containing all Tool objects detected in this hand.
   *
   */
  List<Tool> tools() => toolsVector;

  /**
   * The Pointable object with the specified ID associated with this hand.
   *
   * Use the <code>Hand.pointable()</code> function to retrieve a Pointable object
   * associated with this hand using an ID value obtained from a previous frame.
   * This function always returns a Pointable object, but if no finger or
   * tool with the specified ID is present, an invalid Pointable object is returned.
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
   * hand, given in arbitrary order.
   *
   * The list can be empty if no fingers or tools are detected.
   *
   * [return] The Pointable vector containing all Pointable objects
   * detected in this hand.
   */
  List<Pointable> get pointables => pointablesVector;

  /**
   * The axis of rotation derived from the change in orientation
   * of this hand, and any associated fingers and tools,
   * between the current frame and the specified frame.
   *
   * The returned direction vector is normalized.
   *
   * If a corresponding Hand object is not found in sinceFrame,
   * or if either this frame or sinceFrame are invalid Frame objects,
   * then this method returns a zero vector.
   *
   * [sinceFrame] The starting frame for computing the relative rotation.
   * [return] A normalized direction Vector representing the heuristically
   * determined axis of rotational change of the hand between the current
   * frame and that specified in the sinceFrame parameter.
   * @see [Vector3]
   *
   */
  Vector3 rotationAxis( Frame sinceFrame )
  {
    if( sinceFrame.hand( id ) != null )
    {
      return new Vector3( rotation.zBasis.y - sinceFrame.hand( id ).rotation.yBasis.z, rotation.xBasis.z - sinceFrame.hand( id ).rotation.zBasis.x, rotation.yBasis.x - sinceFrame.hand( id ).rotation.xBasis.y ).normalized();
    }
    else
    {
      return new Vector3( 0.0, 0.0, 0.0 );
    }
  }

  /**
   * The angle of rotation around the rotation axis derived from the
   * change in orientation of this hand, and any associated fingers
   * and tools, between the current frame and the specified frame.
   *
   * The returned angle is expressed in radians measured clockwise
   * around the rotation axis (using the right-hand rule) between the
   * start and end frames. The value is always between 0 and pi radians
   * (0 and 180 degrees).
   *
   * If a corresponding Hand object is not found in sinceFrame,
   * or if either this frame or sinceFrame are invalid Frame objects,
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
    if( !isValid() || !sinceFrame.hand( id ).isValid() )
      return 0.0;

    num returnValue = 0.0;
    Matrix rotationSinceFrameMatrix = rotationMatrix( sinceFrame );
    num cs = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z - 1 ) * 0.5;
    num angle = Math.acos( cs );
    returnValue = angle.isNaN ? 0.0 : angle;

    if( axis != null )
    {
      Vector3 rotAxis = rotationAxis( sinceFrame.hand( id ).frame );
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
   * [sinceFrame]
   * [return] A transformation Matrix representing the heuristically
   * determined rotational change of the hand between the current
   * frame and that specified in the sinceFrame parameter.
   * @see [Matrix]
   * @see [Frame]
   *
   */
  Matrix rotationMatrix( Frame sinceFrame )
  {
    if( sinceFrame.hand( id ).isValid() )
    {
      return sinceFrame.hand( id ).rotation * new Matrix( x: new Vector3( this.rotation.xBasis.x, this.rotation.yBasis.x, this.rotation.zBasis.x ), y: new Vector3( this.rotation.xBasis.y, this.rotation.yBasis.y, this.rotation.zBasis.y ), z: new Vector3( this.rotation.xBasis.z, this.rotation.yBasis.z, this.rotation.zBasis.z ) );
    }
    else
    {
      return Matrix.identity();
    }
  }

  /**
   * The scale factor derived from this hand's motion between
   * the current frame and the specified frame.
   *
   * The scale factor is always positive. A value of 1.0 indicates no
   * scaling took place. Values between 0.0 and 1.0 indicate contraction
   * and values greater than 1.0 indicate expansion.
   *
   * The Leap Motion derives scaling from the relative inward or outward motion
   * of a hand and its associated fingers and tools (independent of
   * translation and rotation).
   *
   * If a corresponding Hand object is not found in sinceFrame,
   * or if either this frame or sinceFrame are invalid Frame objects,
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
    if( sinceFrame && sinceFrame.hand( id ) && sinceFrame.hand( id ).scaleFactorNumber )
      return Math.exp( scaleFactorNumber - sinceFrame.hand( id ).scaleFactorNumber );
    else
      return 1.0;
  }

  /**
   * The change of position of this hand between the current frame and the specified frame.
   *
   * [sinceFrame] The starting frame for computing the translation.
   * [return] A Vector representing the heuristically determined change
   * in hand position between the current frame and that specified
   * in the sinceFrame parameter.
   * @see [Vector3]
   *
   */
  Vector3 translation( Frame sinceFrame )
  {
    if( sinceFrame.hand( id ) && sinceFrame.hand( id ).translationVector )
      return new Vector3( translationVector.x - sinceFrame.hand( id ).translationVector.x, translationVector.y - sinceFrame.hand( id ).translationVector.y, translationVector.z - sinceFrame.hand( id ).translationVector.z );
    else
      return new Vector3( 0.0, 0.0, 0.0 );
  }

  /**
   * Returns an invalid Hand object.
   *
   * You can use the instance returned by this function in comparisons
   * testing whether a given Hand instance is valid or invalid.
   * (You can also use the <code>Hand.isValid()</code> function.)
   *
   * [return] The invalid Hand instance.
   *
   */
  static Hand invalid() => new Hand();

  /**
   * Suppress compiler warning for operator overloads.
   *
   */
   int get hashCode => super.hashCode;
}
