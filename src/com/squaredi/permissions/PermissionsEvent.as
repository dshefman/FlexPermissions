package com.squaredi.permissions
{
    import flash.events.Event;

    public class PermissionsEvent extends Event
    {
        public static const PERMISSIONS_UPDATED:String = "permissionsUpdated"

        public function PermissionsEvent()
        {
            super(PERMISSIONS_UPDATED);
        }
    }
}
