/**
 * Created by Drew on 12/30/13.
 */
package
{
	import com.squaredi.permissions.PermissionTaskConstants;
	import com.squaredi.permissions.PermissionsRegistry;

	import mx.collections.ArrayCollection;

	public class PermissionsPM
	{
		[Inject]  public var permissionsRegistry: PermissionsRegistry;

		public function PermissionsPM()
		{
			permissionsRegistry = new PermissionsRegistry();
			var permissions:Array = [PermissionTaskConstants.PROJECT_EDIT, PermissionTaskConstants.STAFFING]
			permissionsRegistry.permissionsList = new ArrayCollection(permissions);
		}

		public function canSeeProjects():Boolean
		{
			return permissionsRegistry.hasPermission(PermissionTaskConstants.PROJECT);
		}

		public function canEditProjects():Boolean
		{
			return permissionsRegistry.hasPermission(PermissionTaskConstants.PROJECT_EDIT);
		}

		public function canSeeStaffing():Boolean
		{
			return permissionsRegistry.hasPermission(PermissionTaskConstants.STAFFING);
		}

		public function canEditStaffing():Boolean
		{
			return permissionsRegistry.hasPermission(PermissionTaskConstants.STAFFING_EDIT);
		}
	}
}
