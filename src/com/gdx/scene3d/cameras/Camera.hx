package com.gdx.scene3d.cameras;

import com.gdx.math.BoundingBox;
import com.gdx.math.BoundingInfo;
import com.gdx.math.Frustum;
import com.gdx.math.Matrix;
import com.gdx.math.Plane;
import com.gdx.math.Ray;
import com.gdx.math.Rectangle;
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
class Camera extends Node {

	
	public static inline var FOVMODE_VERTICAL_FIXED:Int = 0;
	public static inline var FOVMODE_HORIZONTAL_FIXED:Int = 1;
	
	
	public var screenRatio : Float;
	
		public var LookAt:Vector3;

	public var rotation:Vector3;
	
		public var toTarget:Vector3;
	public var horizontalAngle:Vector3;
	
	public var fovY : Float;
	public var zNear : Float;
	public var zFar : Float;

	public var frustumPlanes:Array<Plane>;
	
	public var minv:Matrix;
	public var needInv:Bool;
	
	public var projMatrix : Matrix;
	public var viewMatrix : Matrix;
	private var ViewProj:Matrix;

	public var projChanged:Bool;
	
	public var viewPort:Rectangle;
	

	public function new( fovY =45,  zNear = 0.1, zFar = 4000) 
	{
		super(null, "Camera");
	   
		this.fovY = fovY;
		
	rotation = Vector3.Zero();

		toTarget = Vector3.Zero();
		horizontalAngle = Vector3.Zero();
		
	LookAt=Vector3.Zero();

		viewPort = new Rectangle(0, 0, Gdx.Instance().width, Gdx.Instance().height);
		this.screenRatio = Gdx.Instance().width / Gdx.Instance().height;
		this.zNear = zNear;
		this.zFar = zFar;

		projChanged = true;
		needInv = true;
	
		
		
		
		viewMatrix = Matrix.Identity();
		projMatrix = Matrix.Identity();
		minv = Matrix.Identity();
		ViewProj = Matrix.Identity();
	
		
	
		
		Matrix.PerspectiveFovLHToRef(fovY,  screenRatio, zNear, zFar, projMatrix);
	
		

		
		getInverseViewProj();
		
		getProjViewMatrix();
		
		extractPlanes();
		
	}
	
	
	
	public function setFov(v:Float):Void
	{
		fovY = v;
			
		projChanged = true;
		
	}

	
		public function setFarValue(v:Float):Void
	{
		zFar = v;
		projChanged = true;
	}
    public function setNearValue(v:Float):Void
	{
		zNear = v;
		projChanged = true;
	}

	public function getInverseViewProj() 
	{
			getProjViewMatrix().invertToRef(minv);
	}

	public function getProjViewMatrix():Matrix
	{
		     viewMatrix.multiplyToRef(projMatrix, ViewProj);
			 return ViewProj;
		
	}

	 private function calCameraMatrix():Void
	 {
		Matrix.LookAtLHToRef(Position, new Vector3(0,0,100), new Vector3(0,1,0), viewMatrix); 
	 }
		
	override public function update() 
	{
	
		if (onUpdate!=null)
		{
			onUpdate();
		}
		
	
		syncRec();
		
	
		Matrix.PerspectiveFovLHToRef(fovY,  screenRatio, zNear, zFar, projMatrix);
		
		
		
		calCameraMatrix();
		 
		
		
				
		
			
		if (parent != null)
		{
			var parentInvert:Matrix = Matrix.Zero();
			parent.getWorldTform().invertToRef(parentInvert);
			viewMatrix.append(parentInvert);
		}
		
		extractPlanes();
		
		for( c in childs )
			c.update();
		
	}


	public  function CubeInFrustum(x:Float,y:Float,z:Float,size:Float):Bool 
	{
	   for (p in 0...6) 
		{
			if (frustumPlanes[p].normal.x * (x-size) + frustumPlanes[p].normal.y * (y-size) + frustumPlanes[p].normal.z * (z-size) + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * (x+size)+ frustumPlanes[p].normal.y * (y-size) + frustumPlanes[p].normal.z *  (z-size) + frustumPlanes[p].d > 0) continue;	
		
			if (frustumPlanes[p].normal.x * (x-size) + frustumPlanes[p].normal.y * (y+size) + frustumPlanes[p].normal.z * (z-size) + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * (x+size) + frustumPlanes[p].normal.y * (y+size) + frustumPlanes[p].normal.z * (z-size) + frustumPlanes[p].d > 0) continue;	
			
			if (frustumPlanes[p].normal.x * (x-size) + frustumPlanes[p].normal.y * (y-size) + frustumPlanes[p].normal.z * (z+size) + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * (x+size) + frustumPlanes[p].normal.y * (y-size) + frustumPlanes[p].normal.z * (z+size) + frustumPlanes[p].d > 0) continue;	
			
			if (frustumPlanes[p].normal.x * (x-size) + frustumPlanes[p].normal.y * (y+size) + frustumPlanes[p].normal.z * (z+size) + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * (x+size) + frustumPlanes[p].normal.y * (y+size) + frustumPlanes[p].normal.z * (z+size) + frustumPlanes[p].d > 0) continue;	
			return false;
        }
        return true;
    }
	public  function MinMaxInFrustum(min:Vector3, max:Vector3):Bool 
	{
	   for (p in 0...6) 
		{
			if (frustumPlanes[p].normal.x * min.x + frustumPlanes[p].normal.y * min.y + frustumPlanes[p].normal.z * min.z + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * max.x + frustumPlanes[p].normal.y * min.y + frustumPlanes[p].normal.z * min.z + frustumPlanes[p].d > 0) continue;	
		
			if (frustumPlanes[p].normal.x * min.x + frustumPlanes[p].normal.y * max.y + frustumPlanes[p].normal.z * min.z + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * max.x + frustumPlanes[p].normal.y * max.y + frustumPlanes[p].normal.z * min.z + frustumPlanes[p].d > 0) continue;	
			
			if (frustumPlanes[p].normal.x * min.x + frustumPlanes[p].normal.y * min.y + frustumPlanes[p].normal.z * max.z + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * max.x + frustumPlanes[p].normal.y * min.y + frustumPlanes[p].normal.z * max.z + frustumPlanes[p].d > 0) continue;	
			
			if (frustumPlanes[p].normal.x * min.x + frustumPlanes[p].normal.y * max.y + frustumPlanes[p].normal.z * max.z + frustumPlanes[p].d > 0) continue;
			if (frustumPlanes[p].normal.x * max.x + frustumPlanes[p].normal.y * max.y + frustumPlanes[p].normal.z * max.z + frustumPlanes[p].d > 0) continue;	
			return false;
        }
        return true;
    }
	public  function BoundingInFrustum(bb:BoundingInfo):Bool 
	{
		
		return bb.isInFrustum(frustumPlanes);
	}
	public  function BoundingBoxInFrustum(bb:BoundingBox):Bool 
	{
		
		return bb.isInFrustum(frustumPlanes);
	}
		public  function SphereInFrustum(center:Vector3, r:Float):Bool 
	{
	   for (p in 0...6) 
		{
			if (frustumPlanes[p].normal.x * center.x + frustumPlanes[p].normal.y * center.y + frustumPlanes[p].normal.z * center.z + frustumPlanes[p].d <= -r) return false;
			
        }
        return true;
    }
		public  function PointInFrustum(center:Vector3):Bool 
	{
	   for (p in 0...6) 
		{
			if (frustumPlanes[p].normal.x * center.x + frustumPlanes[p].normal.y * center.y + frustumPlanes[p].normal.z * center.z + frustumPlanes[p].d <= 0) return false;
			
        }
        return true;
    }
	
	private function extractPlanes():Void
	{
		if (frustumPlanes == null) 
		{
            frustumPlanes = Frustum.GetPlanes(getProjViewMatrix());
        } else 
		{
           Frustum.GetPlanesToRef(getProjViewMatrix(),frustumPlanes);
        }
   	}

	
	public function getRay():Ray
	{
		return Ray.CreateNew(Gdx.Instance().width / 2, Gdx.Instance().height / 2, viewPort.width, viewPort.height,local_tform, viewMatrix, projMatrix);
	}
	public function getPointRay(x:Float,y:Float):Ray
	{
		return Ray.CreateNew(x,y, viewPort.width, viewPort.height,  local_tform, viewMatrix, projMatrix);
	}
}
