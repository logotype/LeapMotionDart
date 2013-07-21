part of LeapMotionDart;

class DefaultListener extends EventDispatcher implements Listener
{
    void onConnect( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_CONNECTED, this ) );
    }

    void onDisconnect( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_DISCONNECTED, this ) );
    }

    void onExit( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_EXIT, this ) );
    }

    void onFrame( Controller controller, Frame frame )
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FRAME, this, frame ) );
    }

    void onInit( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_INIT, this ) );
    }
}
