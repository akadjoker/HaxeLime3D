package com.gdx.math;
/*
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
         Version 0.002, 14, January, 1978

Copyright (C) 2014 Luis Santos AKA DJOKER <djokertheripper@gmail.com>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.
*/
 class Frustum {
	
	inline public static function GetPlanes(transform:Matrix):Array<Plane> 
	{
		var frustumPlanes:Array<Plane> = [];
		
		for (index in 0...6) {
			frustumPlanes.push(new Plane(0, 0, 0, 0));
		}
		
		Frustum.GetPlanesToRef(transform, frustumPlanes);
		
		return frustumPlanes;
	}

	inline public static function GetPlanesToRef(transform:Matrix, frustumPlanes:Array<Plane>):Void
	{
		// Near
		frustumPlanes[0].normal.x = transform.m14 + transform.m13;
		frustumPlanes[0].normal.y = transform.m24 + transform.m23;
		frustumPlanes[0].normal.z = transform.m33 + transform.m33;
		frustumPlanes[0].d = transform.m44 + transform.m43;
		frustumPlanes[0].normalize();
		
		// Far
		frustumPlanes[1].normal.x = transform.m14 - transform.m13;
		frustumPlanes[1].normal.y = transform.m24 - transform.m23;
		frustumPlanes[1].normal.z = transform.m34 - transform.m33;
		frustumPlanes[1].d = transform.m44 - transform.m43;
		frustumPlanes[1].normalize();
		
		// Left
		frustumPlanes[2].normal.x = transform.m14 + transform.m11;
		frustumPlanes[2].normal.y = transform.m24 + transform.m21;
		frustumPlanes[2].normal.z = transform.m34 + transform.m31;
		frustumPlanes[2].d = transform.m44 + transform.m41;
		frustumPlanes[2].normalize();
		
		// Right
		frustumPlanes[3].normal.x = transform.m14 - transform.m11;
		frustumPlanes[3].normal.y = transform.m24 - transform.m21;
		frustumPlanes[3].normal.z = transform.m34 - transform.m31;
		frustumPlanes[3].d = transform.m44 - transform.m41;
		frustumPlanes[3].normalize();
		
		// Top
		frustumPlanes[4].normal.x = transform.m14 - transform.m12;
		frustumPlanes[4].normal.y = transform.m24 - transform.m22;
		frustumPlanes[4].normal.z = transform.m34 - transform.m32;
		frustumPlanes[4].d = transform.m44 - transform.m42;
		frustumPlanes[4].normalize();
		
		// Bottom
		frustumPlanes[5].normal.x = transform.m14 + transform.m12;
		frustumPlanes[5].normal.y = transform.m24 + transform.m22;
		frustumPlanes[5].normal.z = transform.m34 + transform.m32;
		frustumPlanes[5].d = transform.m44 + transform.m42;
		frustumPlanes[5].normalize();
	}
	
}
