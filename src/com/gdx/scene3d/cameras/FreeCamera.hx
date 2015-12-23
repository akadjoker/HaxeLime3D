package com.gdx.scene3d.cameras;

import com.gdx.math.Quaternion;
import com.gdx.scene3d.cameras.Camera;
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
class FreeCamera extends Camera
{

	public var yaw:Float;
	public var pitch:Float;
	public var roll:Float;

	public function new(x:Float,y:Float,z:Float) 
	{
		super();
	setPos(x, y, z);
	yaw = 0;
	pitch = 0;
	roll = 0;
	
	}
	override private function calCameraMatrix():Void
	{
		viewMatrix.setIdentity();
		
		
		var rot:Quaternion = Quaternion.RotationYawPitchRoll(yaw, pitch, roll);
	
		rot.toRotationMatrix(viewMatrix);
	    
		viewMatrix.m41 = Position.x;
		viewMatrix.m42 = Position.y;
		viewMatrix.m43 = Position.z;
		

		viewMatrix = viewMatrix.invert();
	

	}
	

}