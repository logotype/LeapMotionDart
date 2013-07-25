part of LeapMotionDart;

/**
 * The EventDispatcher class provides strongly typed events.
 */
class EventDispatcher
{
    List<ListenerObject> _listeners = new List<ListenerObject>();

    EventDispatcher()
    {
        _listeners = [];
    }

    bool hasEventListener( String type, Function listener )
    {
        bool exists = false;
        for( int i = 0; i < _listeners.length; i++ )
        {
            if( _listeners[ i ].type == type && _listeners[ i ].listener == listener )
            {
                exists = true;
                break;
            }
        }

        return exists;
    }

    void addEventListener ( String typeStr, Function listenerFunction )
    {
        if( hasEventListener( typeStr, listenerFunction ) )
            return;

        _listeners.add( new ListenerObject( typeStr, listenerFunction ) );
    }

    void removeEventListener ( String typeStr, Function listenerFunction )
    {
        for( int i = 0; i < _listeners.length; i++ )
        {
            if( _listeners[ i ].type == typeStr && _listeners[ i ].listener == listenerFunction )
                _listeners.removeRange( i, i );
        }
    }

    void dispatchEvent ( LeapEvent event )
    {
        for( int i = 0; i < _listeners.length; i++ )
        {
            if( _listeners[ i ].type == event.getType() )
              _listeners[ i ].listener( event );
        }
    }
}

class ListenerObject
{
  String type;
  Function listener;
  
  ListenerObject( String typeStr, Function listenerFunction )
  {
    type = typeStr;
    listener = listenerFunction;
  }
}