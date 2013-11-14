part of LeapMotionDart;

/**
 * The FingerList class represents a list of Finger objects.
 *
 * Get a FingerList object by calling Frame.fingers().
 *
 * @author logotype
 *
 */
class FingerList extends ListBase<Finger>
{
  List<Finger> list;
  
  /**
   * Constructs an empty list of fingers.
   *
   */
  FingerList()
  {
    list = new List();
  }
  
  /**
   * The member of the list that is farthest to the front
   * within the standard Leap Motion frame of reference
   * (i.e has the smallest Z coordinate).
   *
   * [return] The frontmost finger, or invalid if list is empty.
   *
   */
  Finger frontmost()
  {
    // TODO: Implement
    return null; //Finger.invalid();
  }
  
  /**
   * The member of the list that is farthest to the left
   * within the standard Leap Motion frame of reference
   * (i.e has the smallest X coordinate).
   *
   * [return] The leftmost finger, or invalid if list is empty.
   *
   */
  Finger leftmost()
  {
    // TODO: Implement
    return null; //Finger.invalid();
  }
  
  /**
   * The member of the list that is farthest to the right
   * within the standard Leap Motion frame of reference
   * (i.e has the largest X coordinate).
   *
   * [return] The rightmost finger, or invalid if list is empty.
   *
   */
  Finger rightmost()
  {
    // TODO: Implement
    return null; //Finger.invalid();
  }

  get length => list.length;
  set length(val) { list.length = val; }

  operator [](index) => list[index];
  operator []=(index, val) => list[index] = val;
}