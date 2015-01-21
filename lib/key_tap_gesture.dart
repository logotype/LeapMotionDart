part of LeapMotionDart;

/**
 * The KeyTapGesture class represents a tapping gesture by a finger or tool.
 *
 * A key tap gesture is recognized when the tip of a finger rotates down
 * toward the palm and then springs back to approximately the original
 * postion, as if tapping. The tapping finger must pause briefly before
 * beginning the tap.
 *
 * <strong>Important: To use key tap gestures in your application, you must enable
 * recognition of the key tap gesture.</strong><br/>You can enable recognition with:
 *
 * <code>leap.controller.enableGesture(Gesture.TYPE_KEY_TAP);</code>
 *
 * Key tap gestures are discrete. The KeyTapGesture object representing a
 * tap always has the state, <code>STATE_STOP</code>. Only one KeyTapGesture object
 * is created for each key tap gesture recognized.
 *
 * You can set the minimum finger movement and velocity required for a movement
 * to be recognized as a key tap as well as adjust the detection window for evaluating
 * the movement using the config attribute of a connected Controller object.
 * Use the following configuration keys to configure key tap recognition:
 *
 * <table class="innertable">
 *   <tr>
 *    <th>Key string</th>
 *    <th>Value type</th>
 *    <th>Default value</th>
 *    <th>Units</th>
 *  </tr>
 *   <tr>
 *    <td>Gesture.KeyTap.MinDownVelocity</td>
 *    <td>float</td>
 *    <td>50</td>
 *    <td>mm/s</td>
 *  </tr>
 *   <tr>
 *    <td>Gesture.KeyTap.HistorySeconds</td>
 *    <td>float</td>
 *    <td>0.1</td>
 *    <td>s</td>
 *  </tr>
 *   <tr>
 *    <td>Gesture.KeyTap.MinDistance</td>
 *    <td>float</td>
 *    <td>5.0</td>
 *    <td>mm</td>
 *  </tr>
 * </table>
 *
 * The following example demonstrates how to set the screen tap configuration parameters:
 *
 * <code>if(controller.config().setFloat(&quot;Gesture.KeyTap.MinDownVelocity&quot;, 40.0) &amp;&amp;
 *       controller.config().setFloat(&quot;Gesture.KeyTap.HistorySeconds&quot;, .2) &amp;&amp;
 *       controller.config().setFloat(&quot;Gesture.KeyTap.MinDistance&quot;, 8.0))
 *        controller.config().save();</code>
 *
 * @author logotype
 *
 */
class KeyTapGesture extends Gesture {
  /**
   * The type value designating a key tap gesture.
   */
  static int classType = Gesture.TYPE_KEY_TAP;

  /**
   * The current direction of finger tip motion.
   *
   * At the start of the key tap gesture, the direction points in the
   * direction of the tap. At the end of the key tap gesture, the direction
   * will either point toward the original finger tip position or it will
   * be a zero-vector, which indicates that finger movement stopped before
   * returning to the starting point.
   */
  Vector3 direction;

  /**
   * The finger performing the key tap gesture.
   */
  Pointable pointable;

  /**
   * The position where the key tap is registered.
   */
  Vector3 position;

  /**
   * The progess value is always 1.0 for a key tap gesture.
   */
  num progress = 1.0;

  /**
   * Constructs a new KeyTapGesture object.
   *
   * An uninitialized KeyTapGesture object is considered invalid.
   * Get valid instances of the KeyTapGesture class from a Frame object.
   *
   */
  KeyTapGesture() {
  }
}
