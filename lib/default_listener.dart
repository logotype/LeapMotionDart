part of LeapMotionDart;

class DefaultListener extends EventDispatcher implements Listener
{
    void onConnect( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( type: LeapEvent.LEAPMOTION_CONNECTED, targetListener: this ) );
    }

    void onDisconnect( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( type: LeapEvent.LEAPMOTION_DISCONNECTED, targetListener: this ) );
    }

    void onExit( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( type: LeapEvent.LEAPMOTION_EXIT, targetListener: this ) );
    }

    void onFrame( Controller controller, Frame frame )
    {
        controller.dispatchEvent( new LeapEvent( type: LeapEvent.LEAPMOTION_FRAME, targetListener: this, frameObject: frame ) );
    }

    void onInit( Controller controller )
    {
        controller.dispatchEvent( new LeapEvent( type: LeapEvent.LEAPMOTION_INIT, targetListener: this ) );
    }
}
