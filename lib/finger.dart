part of LeapMotionDart;

/**
 * The Finger class represents a tracked finger.
 *
 * Fingers are Pointable objects that the Leap Motion has classified as a finger.
 * Get valid Finger objects from a Frame or a Hand object.
 * 
 * Fingers may be permanently associated to a hand. In this case the
 * angular order of the finger IDs will be invariant. As fingers move in
 * and out of view it is possible for the guessed ID of a finger to be
 * incorrect. Consequently, it may be necessary for finger IDs to be
 * exchanged. All tracked properties, such as velocity, will remain
 * continuous in the API. However, quantities that are derived from the
 * API output (such as a history of positions) will be discontinuous
 * unless they have a corresponding ID exchange.
 *
 * Note that Finger objects can be invalid, which means that they do not
 * contain valid tracking data and do not correspond to a physical finger.
 * Invalid Finger objects can be the result of asking for a Finger object
 * using an ID from an earlier frame when no Finger objects with that ID
 * exist in the current frame. A Finger object created from the Finger
 * constructor is also invalid.<br/>
 * Test for validity with the <code>Finger.sValid()</code> function.
 *
 * @author logotype
 *
 */
class Finger extends Pointable
{
  /**
   * Enumerates the joints of a finger.
   * 
   * <p>The joints along the finger are indexed from 0 to 3 (tip to knuckle). The same
   * joint identifiers are used for the thumb, even though the thumb has one less
   * phalanx bone than the other digits. This puts the base joint (JOINT_MCP) at the
   * base of thumb's metacarpal bone.</p> 
   *
   * <p>Pass a member of this enumeration to Finger::jointPosition() to get the
   * physical position of that joint.</p>
   *
   * <p>Note: The term "joint" is applied loosely here and the set of joints includes the
   * finger tip even though it is not an anatomical joint.</p>
   *
   * @since 1.f
   */

  /**
   * The metacarpopophalangeal joint, or knuckle, of the finger.
   *
   * <p>The metacarpopophalangeal joint is located at the base of a finger between
   * the metacarpal bone and the first phalanx. The common name for this joint is
   * the knuckle.</p>
   *
   * <p>On a thumb, which has one less phalanx than a finger, this joint index
   * identifies the thumb joint near the base of the hand, between the carpal
   * and metacarpal bones.</p>
   * 
   * @since 1.f
   */
  static const int JOINT_MCP = 0;

  /**
   * The proximal interphalangeal joint of the finger. This joint is the middle
   * joint of a finger.
   *
   * <p>The proximal interphalangeal joint is located between the two finger segments
   * closest to the hand (the proximal and the intermediate phalanges). On a thumb,
   * which lacks an intermediate phalanx, this joint index identifies the knuckle joint
   * between the proximal phalanx and the metacarpal bone.</p>
   *
   * @since 1.f
   */
  static const int JOINT_PIP = 1;

  /**
   * The distal interphalangeal joint of the finger.
   * 
   * <p>This joint is closest to the tip.</p>
   * 
   * <p>The distal interphalangeal joint is located between the most extreme segment
   * of the finger (the distal phalanx) and the middle segment (the intermediate
   * phalanx).</p>
   *
   * @since 1.f
   */
  static const int JOINT_DIP = 2;

  /**
   * The tip of the finger.
   * 
   * @since 1.f
   */
  static const int JOINT_TIP = 3;
  
  /**
   * Enumerates the names of the fingers.
   *
   * <p>Members of this enumeration are returned by Finger::type() to identify a 
   * Finger object.</p>
   * 
   * @since 1.f
   */
  
  /**
   * The thumb.
   */
  static const int TYPE_THUMB = 0;
  
  /**
   * The index or fore- finger.
   */
  static const int TYPE_INDEX = 1;

  /**
   * The middle finger.
   */
  static const int TYPE_MIDDLE = 2;

  /**
   * The ring finger.
   */
  static const int TYPE_RING = 3;

  /**
   * The pinky or little finger.
   */
  static const int TYPE_PINKY = 4;
  
  /**
   * The name of this finger.
   */
  int type;
  
  /**
   * The position of the distal interphalangeal joint of the finger.
   * This joint is closest to the tip.
   * 
   * <p>The distal interphalangeal joint is located between the most extreme segment
   * of the finger (the distal phalanx) and the middle segment (the intermediate
   * phalanx).</p>
   */  
  Vector3 dipPosition;
  
  /**
   * The position of the proximal interphalangeal joint of the finger. This joint is the middle
   * joint of a finger.
   *
   * <p>The proximal interphalangeal joint is located between the two finger segments
   * closest to the hand (the proximal and the intermediate phalanges). On a thumb,
   * which lacks an intermediate phalanx, this joint index identifies the knuckle joint
   * between the proximal phalanx and the metacarpal bone.</p>
   */  
  Vector3 pipPosition;
  
  /**
   * The position of the metacarpopophalangeal joint, or knuckle, of the finger.
   *
   * <p>The metacarpopophalangeal joint is located at the base of a finger between
   * the metacarpal bone and the first phalanx. The common name for this joint is
   * the knuckle.</p>
   *
   * <p>On a thumb, which has one less phalanx than a finger, this joint index
   * identifies the thumb joint near the base of the hand, between the carpal
   * and metacarpal bones.</p>
   */  
  Vector3 mcpPosition;
  
  /**
   * Constructs a Finger object.
   *
   * An uninitialized finger is considered invalid.
   * Get valid Finger objects from a Frame or a Hand object.
   *
   */
  Finger()
  {
    isFinger = true;
    isTool = false;
  }
  
  /**
   * The position of the specified joint on this finger in millimeters from the Leap Motion origin.
   *
   * @param jointIx An index value from the Finger::Joint enumeration identifying the
   * joint of interest.
   * @return The Vector containing the coordinates of the joint position.
   *
   * @since 1.f
   */
  Vector3 jointPosition( num jointIx )
  {
      switch( jointIx )
      {
          case JOINT_MCP:
              return mcpPosition;
              break;
          case JOINT_PIP:
              return pipPosition;
              break;
          case JOINT_DIP:
              return dipPosition;
              break;
          case JOINT_TIP:
              return tipPosition;
              break;
          default:
              return Vector3.invalid();
              break;
      }
  }

  /**
   * The joint positions of this finger as a vector in the order base to tip.
   *
   * @return A Vector of joint positions.
   */
  List<Vector3> positions()
  {
      List<Vector3> positionsVector = new List<Vector3>();
      positionsVector.add( mcpPosition );
      positionsVector.add( pipPosition );
      positionsVector.add( dipPosition );
      positionsVector.add( tipPosition );

      return positionsVector;
  }

  /**
   * Returns an invalid Finger object.
   *
   * You can use the instance returned by this function in
   * comparisons testing whether a given Finger instance
   * is valid or invalid.
   * (You can also use the <code>Finger.isValid()</code> function.)
   *
   * [return] The invalid Finger instance.
   *
   */
  static Finger invalid() => new Finger();
}