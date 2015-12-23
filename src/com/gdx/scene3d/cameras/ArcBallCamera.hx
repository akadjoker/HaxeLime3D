package com.gdx.scene3d.cameras;

import com.gdx.math.Matrix;
import com.gdx.math.Quaternion;
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


class ArcBallCamera extends Camera {

	
private var target:Vector3;
private var up:Vector3;
private var felevation:Float;
private var frotation:Float;
 private var maxDistance:Float;
 private var minDistance:Float;
 private var viewDistance:Float;
 private var baseCameraReference:Vector3 = new Vector3(0, 0, 1);
		


	
	public function new(
		  targetPosition:Vector3,
             initialElevation:Float,
             initialRotation:Float,
             minDistance:Float,
             maxDistance:Float,
             initialDistance:Float) 
	{
		super();
		
		up = Vector3.Up();
		this.felevation = initialElevation;
		this.frotation = initialRotation;
		this.target = targetPosition;
		this.minDistance =minDistance;
		this.maxDistance = maxDistance;
		this.viewDistance = initialDistance;
		
        
		
	
	
	}
	
	public var Target(get, set):Vector3;
	private function get_Target():Vector3 { return target; }
	private function set_Target(value:Vector3):Vector3 
	{ 
		target = value;
		return value;
	}
	
	public var Elevation(get, set):Float;
	private function get_Elevation():Float { return felevation; }
	private function set_Elevation(value:Float):Float 
	{ 
		//felevation = value;
		
		felevation=Util.Clamp(value, Util.ToRadians( -70), Util.ToRadians( -10));
		return value;
	}
	
	
	public var ViewDistance(get, set):Float;
	private function get_ViewDistance():Float { return minDistance; }
	private function set_ViewDistance(value:Float):Float 
	{ 
		//viewDistance = value;
		
		viewDistance=Util.Clamp(value,minDistance,maxDistance);
		return value;
	}
	
	public var Rotation(get, set):Float;
	private function get_Rotation():Float { return frotation; }
	private function set_Rotation(value:Float):Float 
	{ 
		frotation = value;
	
		
		return value;
	}
	
	
	override private function calCameraMatrix():Void
	{
		
	
		var rotationQuad:Quaternion = Quaternion.RotationYawPitchRoll(frotation, felevation, 0);
		var mat:Matrix = Matrix.Identity();
		rotationQuad.toRotationMatrix(mat);
		
	Position =	Vector3.TransformCoordinates(baseCameraReference, mat);
	Position.scaleInPlace(viewDistance);
	Position.addInPlace(target);
		
		LookAt.copyFrom(target);
		
		toTarget.x = LookAt.x - local_pos.x;
		toTarget.y = LookAt.y - local_pos.y;
		toTarget.z = LookAt.z - local_pos.z;
		toTarget.getHorizontalAngle(horizontalAngle);
		rotation.copyFrom(horizontalAngle);
		
		
			
			//Matrix.LookAtLHToRef(Position, target, up, viewMatrix);
			
			
			viewMatrix.setLookAtLH(Position, LookAt, up);
			
			
	}

	



	
	
}