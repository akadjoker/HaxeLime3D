package com.gdx.scene3d.cameras;

import com.gdx.math.Quaternion;
import com.gdx.math.Vector3;


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
class OrbitCamera extends Camera {

	
public var target:Node;
public var offset:Vector3;
public var yaw:Float;
public var pitch:Float;
public var up:Vector3;
private var quatYaw:Quaternion;
private var quatPitch:Quaternion;

	public function new(Offset:Vector3) 
	{
		super();
		up = new  Vector3(0, 1, 0);
		this.offset = Offset;
		yaw = 0;
		pitch = 0;
		quatYaw = Quaternion.Zero();
		quatPitch = Quaternion.Zero();
	
	
	}
	public function setTarget( obj:Node):Void
	{
		this.target = obj;
		LookAt.copyFrom(obj.Position);
		viewMatrix.setLookAtLH(obj.local_pos.add(offset), LookAt, up);
	}
	override private function calCameraMatrix():Void
	{
		
	
			quatYaw.rotateAngleAxis(new Vector3(0, 1, 0), yaw);
		    
			 offset=Vector3.TransformByQuaternion(offset,quatYaw);
	        up = Vector3.TransformByQuaternion(up, quatYaw );
			
			
			var forward:Vector3 = new Vector3( -offset.x, -offset.y, -offset.z);
			forward.normalize();
			
			var left:Vector3 = Vector3.Cross(up, forward);
			left.normalize();
			
		
			quatPitch.rotateAngleAxis(left, pitch);
			 
		    offset=Vector3.TransformByQuaternion(offset,quatPitch);
	        up = Vector3.TransformByQuaternion(up, quatPitch );
		
			
			LookAt.copyFrom( target.Position);
			
			local_pos.copyFrom(target.Position.add(offset));
			
			viewMatrix.setLookAtLH(Position,LookAt, up);
			
			
	}

	



	
	
}