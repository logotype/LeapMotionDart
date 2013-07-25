part of LeapMotionDart;

class LeapEvent
{
    static String LEAPMOTION_INIT = "leapMotionInit";
    static String LEAPMOTION_CONNECTED = "leapMotionConnected";
    static String LEAPMOTION_DISCONNECTED = "leapMotionDisconnected";
    static String LEAPMOTION_EXIT = "leapMotionExit";
    static String LEAPMOTION_FRAME = "leapMotionFrame";

    String _type;
    Listener _target;

    Frame frame;

    LeapEvent( { String type, Listener targetListener, Frame frameObject: null } )
    {
        _type = type;
        _target = targetListener;
        frame = frameObject;
    }

    Object getTarget()
    {
        return _target;
    }

    String getType()
    {
        return _type;
    }
}