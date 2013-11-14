part of LeapMotionDart;

/**
 * The Listener interface defines a set of callback functions that you can
 * implement to respond to events dispatched by the Leap.
 *
 * To handle Leap events, implement the Listener interface and assign
 * it to the Controller instance. The Controller calls the relevant Listener
 * callback when an event occurs, passing in a reference to itself.
 * You have to implement callbacks for every method specified in the interface.
 *
 * Note: you have to create an instance of the LeapMotion class and set the Listener to your class:
 *
 * <listing>
 * leap = new LeapMotion();
 * leap.controller.setListener( this );</listing>
 *
 * @author logotype
 *
 */
abstract class Listener
{
    /**
     * Called when the Controller object connects to the Leap software,
     * or when this Listener object is added to a Controller that is already connected.
     *
     * [controller] The Controller object invoking this callback function.
     *
     */
    void onConnect( Controller controller );

    /**
     * Called when the Controller object disconnects from the Leap software.
     *
     * The controller can disconnect when the Leap device is unplugged,
     * the user shuts the Leap software down, or the Leap software encounters
     * an unrecoverable error.
     *
     * <listing>
     * public onDisconnect( controller:Controller ):void {
     *     trace( "Disconnected" );
     * }</listing>
     *
     * Note: When you launch a Leap-enabled application in a debugger,
     * the Leap library does not disconnect from the application.
     * This is to allow you to step through code without losing the connection
     * because of time outs.
     *
     * [controller] The Controller object invoking this callback function.
     *
     */
    void onDisconnect( Controller controller );

    /**
     * Called when this Listener object is removed from the Controller or
     * the Controller instance is destroyed.
     *
     * <listing>
     * public onExit( controller:Controller ):void {
     *     trace( "Exited" );
     * }</listing>
     *
     * [controller] The Controller object invoking this callback function.
     *
     */
    void onExit( Controller controller );

    /**
     * Called when a new frame of hand and finger tracking data is available.
     *
     * Access the new frame data using the <code>controller.frame()</code> function.
     *
     * <listing>
     * public onFrame( controller:Controller, frame:Frame ):void {
     *     trace( "New frame" );
     * }</listing>
     *
     * Note, the Controller skips any pending onFrame events while your
     * onFrame handler executes. If your implementation takes too long to
     * return, one or more frames can be skipped. The Controller still inserts
     * the skipped frames into the frame history. You can access recent frames
     * by setting the history parameter when calling the <code>controller.frame()</code>
     * function. You can determine if any pending onFrame events were skipped
     * by comparing the ID of the most recent frame with the ID of the last
     * received frame.
     *
     * [controller] The Controller object invoking this callback function.
     * [frame] The most recent frame object.
     *
     */
    void onFrame( Controller controller, Frame frame );

    /**
     * Called once, when this Listener object is newly added to a Controller.
     *
     * <listing>
     * public onInit( controller:Controller ):void {
     *     trace( "Init" );
     * }</listing>
     *
     * [controller] The Controller object invoking this callback function.
     *
     */
    void onInit( Controller controller );
}