part of LeapMotionDart;

/**
 * The SwipeGesture class represents a swiping motion of a finger or tool.
 *
 * <strong>Important: To use swipe gestures in your application, you must enable
 * recognition of the swipe gesture.</strong><br/>You can enable recognition with:
 *
 * <code>leap.controller.enableGesture(Gesture.TYPE_SWIPE);</code>
 *
 * Swipe gestures are continuous.
 *
 * You can set the minimum length and velocity required for a movement to be
 * recognized as a swipe using the config attribute of a connected Controller object.
 * Use the following keys to configure swipe recognition:
 *
 * <table class="innertable">
 *   <tr>
 *    <th>Key string</th>
 *    <th>Value type</th>
 *    <th>Default value</th>
 *    <th>Units</th>
 *  </tr>
 *   <tr>
 *    <td>Gesture.Swipe.MinLength</td>
 *    <td>float</td>
 *    <td>150</td>
 *    <td>mm</td>
 *  </tr>
 *   <tr>
 *    <td>Gesture.Swipe.MinVelocity</td>
 *    <td>float</td>
 *    <td>1000</td>
 *    <td>mm/s</td>
 *  </tr>
 * </table>
 *
 * The following example demonstrates how to set the swipe configuration parameters:
 *
 * <code>if(controller.config().setFloat(&quot;Gesture.Swipe.MinLength&quot;, 200.0) &amp;&amp;
 *       controller.config().setFloat(&quot;Gesture.Swipe.MinVelocity&quot;, 750))
 *        controller.config().save();</code>
 *
 * @author logotype
 *
 */
class SwipeGesture extends Gesture
{
  /**
   * The type value designating a swipe gesture.
   */
  static int classType = Gesture.TYPE_SWIPE;

  /**
   * The unit direction vector parallel to the swipe motion.
   *
   * You can compare the components of the vector to classify the swipe
   * as appropriate for your application. For example, if you are using
   * swipes for two dimensional scrolling, you can compare the x and y
   * values to determine if the swipe is primarily horizontal or vertical.
   */
  Vector3 direction;

  /**
   * The Finger or Tool performing the swipe gesture.
   */
  Pointable pointable;

  /**
   * The current swipe position within the Leap Motion frame of reference, in mm.
   */
  Vector3 position;

  /**
   * The speed of the finger performing the swipe gesture in millimeters per second.
   */
  num speed;

  /**
   * The position where the swipe began.
   */
  Vector3 startPosition;

  /**
   * Constructs a SwipeGesture object from an instance of the Gesture class.
   *
   */
  SwipeGesture()
  {
  }
}