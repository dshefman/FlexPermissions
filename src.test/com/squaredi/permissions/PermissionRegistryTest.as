package com.squaredi.permissions
{
	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertFalse;

	import org.flexunit.asserts.assertTrue;

	public class PermissionRegistryTest
	{
		private var registry:PermissionsRegistry;

		[Before]
		public function setup() :void
		{
			registry = new PermissionsRegistry();
		}

		[Test]
		public function hasPermissionLevels() :void
		{
			var permission:String = "staffing.edit.allocate";
			var permissions:ArrayCollection = new ArrayCollection([permission]);
			registry.permissionsList = permissions;

			assertTrue("level1", registry.hasPermission("staffing"));
			assertTrue("level2", registry.hasPermission("staffing.edit"));
			assertTrue("level3", registry.hasPermission("staffing.edit.allocate"));
		}

		[Test]
		public function hasPermissionLevelsWithPermissionRecord() :void
		{
			var permissionRecord:PermissionRecord = new PermissionRecord();
			var permissionExtractor:PermissionExtractor = new PermissionExtractor();
			registry.permissionExtractor = permissionExtractor;

			var permissions:ArrayCollection = new ArrayCollection([permissionRecord]);
			registry.permissionsList = permissions;

			assertTrue("level1", registry.hasPermission("staffing"));
			assertTrue("level2", registry.hasPermission("staffing.edit"));
			assertTrue("level3", registry.hasPermission("staffing.edit.allocate"));
		}

		[Test]
		public function developerPermissionOverride() :void
		{
			registry.addPermission("project");
			var permission:String = "staffing.edit.allocate";
			var permissions:ArrayCollection = new ArrayCollection([permission]);
			registry.permissionsList = permissions;

			assertFalse("DeveloperOverridecan't add", registry.hasPermission("staffing"));
			assertTrue("DeveloperOverride", registry.hasPermission("project"));
		}
	}
}

import com.squaredi.permissions.IPermissionExtrator;

class PermissionRecord
{
	public var readStaffing:Boolean = true;
	public var editStaffing:Boolean = true;
	public var allocateStaffing:Boolean = true;
}

class PermissionExtractor implements IPermissionExtrator
{
	public function getPermissionString(perm:Object):String
	{
		var record:PermissionRecord = PermissionRecord(perm);
		var rtn:String = "";
		if (record.readStaffing)
		{
			rtn = "staffing"
			if (record.editStaffing) {
				rtn+= ".edit"
				if (record.allocateStaffing)
				{
					rtn+=".allocate"
				}
			}

		}

		return rtn;
	}
}