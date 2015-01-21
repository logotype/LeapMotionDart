part of LeapMotionDart;

/**
 * The CircleGesture classes represents a circular finger movement.
 *
 * A circle movement is recognized when the tip of a finger draws
 * a circle within the Leap Motion field of view.
 *
 * <strong>Important: To use circle gestures in your application, you must
 * enable recognition of the circle gesture.</strong><br/>
 * You can enable recognition with:
 *
 * <code>leap.controller.enableGesture(Gesture.TYPE_CIRCLE);</code>
 *
 * Circle gestures are continuous. The CircleGesture objects for
 * the gesture have three possible states:
 *
 * <code>Gesture.STATE_START</code> – The circle gesture has just started.
 * The movement has progressed far enough for the recognizer to classify it as a circle.
 *
 * <code>Gesture.STATE_UPDATE</code> – The circle gesture is continuing.
 *
 * <code>Gesture.STATE_STOP</code> – The circle gesture is finished.
 *
 * You can set the minimum radius and minimum arc length required for a
 * movement to be recognized as a circle using the config attribute of a
 * connected Controller object. Use the following keys to configure circle recognition:
 *
 * <table class="innertable">
 *   <tr>
 *    <th>Key string</th>
 *    <th>Value type</th>
 *    <th>Default value</th>
 *    <th>Units</th>
 *  </tr>
 *   <tr>
 *    <td>Gesture.Circle.MinRadius</td>
 *    <td>float</td>
 *    <td>5.0</td>
 *    <td>mm</td>
 *  </tr>
 *   <tr>
 *    <td>Gesture.Circle.MinArc</td>
 *    <td>float</td>
 *    <td>1.5&#42;pi</td>
 *    <td>radians</td>
 *  </tr>
 * </table>
 *
 * The following example demonstrates how to set the circle configuration parameters:
 *
 * <listing>if(controller.config().setFloat(&quot;Gesture.Circle.MinRadius&quot;, 10.0) &amp;&amp;
 *       controller.config().setFloat(&quot;Gesture.Circle.MinArc&quot;, .5))
 *        controller.config().save();</listing>
 *
 * @author logotype
 * @see [Gesture]
 *
 */
class CircleGesture extends Gesture {
  /**
   * The circle gesture type.<br/>
   * The type value designating a circle gesture.
   */
  static int classType = Gesture.TYPE_CIRCLE;

  /**
   * The center point of the circle within the Leap Motion frame of reference.<br/>
   * The center of the circle in mm from the Leap Motion origin.
   */
  Vector3 center;

  /**
   * Returns the normal vector for the circle being traced.
   *
   * If you draw the circle clockwise, the normal vector points in the
   * same general direction as the pointable object drawing the circle.
   * If you draw the circle counterclockwise, the normal points back
   * toward the pointable. If the angle between the normal and the
   * pointable object drawing the circle is less than 90 degrees,
   * then the circle is clockwise.
   */
  Vector3 normal;

  /**
   * The Finger or Tool performing the circle gesture.
   */
  Pointable pointable;

  /**
   * The number of times the finger tip has traversed the circle.
   *
   * Progress is reported as a positive number of the number. For example,
   * a progress value of .5 indicates that the finger has gone halfway around,
   * while a value of 3 indicates that the finger has gone around the the
   * circle three times.
   *
   * Progress starts where the circle gesture began. Since it the circle must
   * be partially formed before the Leap Motion can recognize it, progress will be
   * greater than zero when a circle gesture first appears in the frame.
   */
  num progress;

  /**
   * The circle radius in mm.
   */
  num radius;

  /**
   * Constructs a new CircleGesture object.
   *
   * An uninitialized CircleGesture object is considered invalid.
   * Get valid instances of the CircleGesture class from a Frame object.
   *
   */
  CircleGesture() {
    pointable = Pointable.invalid();
  }
}
