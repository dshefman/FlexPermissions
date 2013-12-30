FlexPermissions
===============

Using string based, dot notation for permissions in Flex.

Full blog can be found at http://squaredi.blogspot.com/2013/12/permissions-modelling-in-flex.html

 Just to clarify my requirements, here are the user stories that I'm working with.
 Should be testable.
 As the developer, I want to be able to declare which permissions are present during testing and development independent of my actual permissions on the system. (In other words - decoupled)
 Should be scalable
 As a client, I want to be able to add/remove permissions at any time without major work/rework in the application
 Easy to understand
 As a new or jr. developer, I want to be able to understand and implement permissions in a best practices way

In this way, if you were assigned a permission of "staffing.edit.allocate", you would inherit all of the rights of "staffing" and "staffing.edit". This satisfy's the scalable requirement. It is trivial to add or remove permissions, as it would only mean adding / removing strings from the permission path.

A couple of other special features about the code. As a developer I can manually add and remove permissions from the list. When I do this, it sets a "developerUpdated" flag, which will ignore setting the whole array. Here is the use case for that. I login to the system but the service call to get permissions is delayed (for some reason). Then I want to verify how the system looks for other users, and add specific permissions, then the service call comes back and could potentially overwrite the values that I've modified. So there is code in place to prevent that.

The other feature that is in the code, is an interface for extracting the data. This could be used in the case of a value object (VO) that returns from the database that has a list of permissions for a given user. This VO is an object, and doesn't have the necessary string representation for permissions. The permission registry accepts an PermissionExtractor helper, that can convert the VO into permissions strings.