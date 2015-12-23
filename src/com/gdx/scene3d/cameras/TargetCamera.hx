package com.gdx.scene3d.cameras;

import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
import com.gdx.util.Util;
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
class TargetCamera extends Camera {

	
	
	public var cross:Vector3;
	public var up : Vector3;
	private var angleX:Float;
	private var angleY:Float;
	private var m_vStrafe:Vector3;

	public function new(x:Float,y:Float,z:Float,lx:Float,ly:Float,lz:Float) 
	{
		
		
		super();
		
		angleX = 0;
		angleY = 0;
		cross = new Vector3();
		m_vStrafe = new Vector3();
		up = new Vector3(0, 1, 0);
		LookAt = new Vector3(lx,ly,lz);

		local_pos.set(x, y, z);
	}
	override private function calCameraMatrix():Void
	{
	    cross = Vector3.Cross(LookAt.subtract(local_pos), up);
		m_vStrafe = Vector3.Normalize(cross);
		Matrix.LookAtLHToRef(local_pos, LookAt, up, viewMatrix);
	}
	public override function getLocalTform():Matrix
	{
		
		toTarget.x = LookAt.x - local_pos.x;
		toTarget.y = LookAt.y - local_pos.y;
		toTarget.z = LookAt.z - local_pos.z;
		rotation.copyFrom(horizontalAngle);
		toTarget.getHorizontalAngle(horizontalAngle);
		local_tform.setIdentity();
		local_tform.setRotationDegrees(horizontalAngle);
    	local_tform.m12 = Position.x;
		local_tform.m13 = Position.y;
		local_tform.m14 = Position.z;
     	return local_tform;
	}
	
	public function Strafe(speed:Float)
	{
	local_pos.x += m_vStrafe.x * speed;
	local_pos.z += m_vStrafe.z * speed;
 	LookAt.x += m_vStrafe.x * speed;
 	LookAt.z += m_vStrafe.z * speed;
	posChanged = true;
	}
	
	public function Advance( speed:Float, ignoreY:Bool = false )
	{
    var  vVector = LookAt.subtract(local_pos);
	vVector = Vector3.Normalize(vVector);
	
	local_pos.x += vVector.x * speed;
	local_pos.z += vVector.z * speed;
	if(!ignoreY) local_pos.y += vVector.y * speed;
	LookAt.x += vVector.x * speed;
 	LookAt.z += vVector.z * speed;
	if (!ignoreY) LookAt.y += vVector.y * speed;
	posChanged = true;
	}

	public function MouseLook(x:Float,y:Float,yawSpeed:Float=50,pitchSpeed:Float=100,smoth:Float=1)
	{
		var vAxis:Vector3 = Vector3.Zero();
	
        angleX   =  x / yawSpeed * smoth;
        angleY   =  -y / pitchSpeed * smoth;
	
	  angleX = Util.clamp(angleX, -1, 1);
	  angleY = Util.clamp(angleY, -1, 1);
	
	    vAxis= Vector3.Normalize(cross);
	    RotateView(angleY, vAxis.x, vAxis.y, vAxis.z);
		RotateView(angleX, 0, 1, 0);
		
	
		
	}
	 public function YawPitchRotate(yaw:Float,pitch:Float)
	{
		var vAxis:Vector3 = Vector3.Zero();
	    angleX = Util.clamp(yaw, -1, 1);
	    angleY = Util.clamp(pitch, -1, 1);
	    vAxis= Vector3.Normalize(cross);
	    RotateView(angleY, vAxis.x, vAxis.y, vAxis.z);
		RotateView(angleX, 0, 1, 0);
		
	
		
	}
	public function RotateView(angle:Float, x:Float, y:Float,  z:Float)
	{

	var vNewView:Vector3=Vector3.Zero();
	var vView:Vector3=Vector3.Zero();
    var cosTheta,sinTheta:Float=0;

    vView.x = LookAt.x - local_pos.x;
	vView.y = LookAt.y - local_pos.y;
	vView.z = LookAt.z - local_pos.z;
	
	
	 cosTheta = Math.cos(angle);
 	 sinTheta = Math.sin(angle);
	
	vNewView.x = (cosTheta + (1 - cosTheta) * x * x)		* vView.x;
	vNewView.x = vNewView.x + ((1 - cosTheta) * x * y - z * sinTheta)	* vView.y;
	vNewView.x = vNewView.x + ((1 - cosTheta) * x * z + y * sinTheta)	* vView.z;
	
	vNewView.y = ((1 - cosTheta) * x * y + z * sinTheta)	* vView.x;
	vNewView.y =vNewView.y + (cosTheta + (1 - cosTheta) * y * y)		* vView.y;
	vNewView.y =vNewView.y + ((1 - cosTheta) * y * z - x * sinTheta)	* vView.z;
	
	vNewView.z = ((1 - cosTheta) * x * z - y * sinTheta)	* vView.x;
	vNewView.z =vNewView.z+ ((1 - cosTheta) * y * z + x * sinTheta)	* vView.y;
	vNewView.z =vNewView.z+ (cosTheta + (1 - cosTheta) * z * z)		* vView.z;
	
	LookAt.x = local_pos.x + vNewView.x;
	LookAt.y = local_pos.y + vNewView.y;
	LookAt.z = local_pos.z + vNewView.z;

	posChanged = true;
	}
	
}