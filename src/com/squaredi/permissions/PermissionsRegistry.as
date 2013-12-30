package com.squaredi.permissions
{

    import mx.collections.ArrayCollection;



    public class PermissionsRegistry
    {
        [MessageDispatcher]
        public var dispatcher:Function;

        private var _permissionsList:ArrayCollection;
        public const exact:String = "EXACT_CONST";



        public var permissionExtractor:IPermissionExtrator
        private var developerUpdated:Boolean = false;

        //To hold dot syntax as an object for perms
        public var permObj:Object

        [Bindable]
        public function get permissionsList():ArrayCollection {
            return _permissionsList ||= createDefaultPermissions()
        }


        public function set permissionsList(value:ArrayCollection):void{
            if (developerUpdated) { return} //Don't allow it to be overwritten if the developer has already set individual permissions for testing
            _permissionsList = value
            permObj = createPermObj(_permissionsList)
            notifyUpdate();
        }

		public function hasPermission(permCode:String, userPermObj:Object = null,friendlyName:String=null):Boolean
		{
			/*
			 Has permission will compare the code to the permission object pressed in
			 The concept here is if the user doesn't have it we return false, but check to
			 see if it is in the main perms list
			 */

			if (! userPermObj) {userPermObj = (this.permObj) ?  this.permObj : createPermObj(permissionsList)}
			var resultObj:Object = crawlToFindPerm(permCode, userPermObj)

			// 	 If we have a match we are authorized
			if (resultObj){
				if (exact in resultObj && resultObj[exact] == true){
					return true
				}else{
					//If not exact we should verify the exact perm exists in the perm list and created it
					createIfNotInMainPerms(permCode,friendlyName)
					return true
				}
			}
			else{ //We have no match, not authorized
				createIfNotInMainPerms(permCode,friendlyName)
				return false
			}
		}

        public function get permissionsSource():Array{
            return permissionsList.source
        }
        public function set permissionSource(v:Array):void
        {
          if (developerUpdated) { return} //Don't allow it to be overwritten if the developer has already set individual permissions for testing
          permissionsList.source = v;
          permObj = createPermObj(_permissionsList)
          notifyUpdate();
        }

        public function addPermission(permission:String):void
        {
            var idx:int = permissionsList.getItemIndex(permission);
            if (idx <0)
            {
                permissionsList.addItem(permission);
                permObj = createPermObj(permissionsList)
                developerUpdated = true;
                notifyUpdate();
            }
        }

        public function removePermission(permission:String):void
        {
            var idx:int = permissionsList.getItemIndex(permission);
            if (idx >=0)
            {
                developerUpdated = true;
                permissionsList.removeItemAt(idx);
                permObj = createPermObj(permissionsList);
                notifyUpdate();
            }

        }


        public function refreshData():void {
            _permissionsList.refresh();
            notifyUpdate();
        }

        [Bindable(event="permissionsUpdated")]
        public function getAllPermissionsString():String
        {
            return permissionsSource.join(" ; ")
        }



        private function createPermObj(list:ArrayCollection):Object
		{
			/*
			Convert the 'dot' permission strings into a single object which can be verified against
			The main goal is so that if a user has permissin something.else.full they can also verify as something.else
			without creating the permission in the db
			 */

            var tempPermObj:Object = new Object()
            for each (var perm:Object in list){
                //split a.b.c to [a,b,c]
                var permArray:Array
                if (permissionExtractor != null){
                    permArray = permissionExtractor.getPermissionString(perm).split(".")
                }else if (perm is String){
                    permArray = perm.split(".")
                }

                //keep the sub obect at the root ot tempPermObj
                var subObj:Object = tempPermObj
                for (var i:int = 0; i < permArray.length; i++){
                    var subPerm:String =permArray[i]
                    //If the subperm exists, step into it
                    if (subObj.hasOwnProperty(subPerm)){
                        subObj = subObj[subPerm]
                    }else{
                        //Otherwise create and step into it
                        subObj[subPerm] = new Object()
                        subObj = subObj[subPerm]
                    }
                    //Check if this is the final permblock and tagg the permObj as exact
                    //so later we can create it if it is a subperm
                    if (i == permArray.length-1){
                        subObj[exact] = true
                    }
                }
            }
            return tempPermObj
        }


        //Look through a perm object to see if there is a perm code match and return the matched object
        private function crawlToFindPerm(permCode:String, testPermObj:Object):Object{
            if (testPermObj == null) return null
            var tempPermObj:Object = testPermObj;
            for each (var subPerm:String in permCode.split(".")){
                if (!tempPermObj.hasOwnProperty(subPerm)){
                    return null
                }else{
                    tempPermObj = tempPermObj[subPerm]
                }
            }
            return tempPermObj
        }

        private function createIfNotInMainPerms(permCode:String,friendlyName:String=null):void
		{
			//Check if a permCode is an exact match in the perm object and if not, create it.
			var resultObj:Object = crawlToFindPerm(permCode,permObj)
            if (resultObj && exact in resultObj && resultObj[exact] == true){

            }
            else
            {
                if (_permissionsList == null) //meaning we have no original permissions result
                {
                    return
                }
            }
        }

        private function createDefaultPermissions():ArrayCollection
        {
            var rtn:ArrayCollection = new ArrayCollection([])
            createPermObj(rtn);
            return rtn;
        }

        private function notifyUpdate():void
        {
            dispatchEvent(new PermissionsEvent());
            if (dispatcher != null) {dispatcher(new PermissionsEvent())}
        }

        public function init():void
        {
            developerUpdated = false;
        }
    }
}