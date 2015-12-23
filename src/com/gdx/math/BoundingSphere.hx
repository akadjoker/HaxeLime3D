package com.gdx.math;
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
class BoundingSphere {
	
	public var minimum:Vector3;
	public var maximum:Vector3;
	public var center:Vector3;
	public var radius:Float;
	public var centerWorld:Vector3;
	public var radiusWorld:Float;

	private var _tempRadiusVector:Vector3 = Vector3.Zero();
	

	public function new(minimum:Vector3, maximum:Vector3) 
	{
		this.minimum = minimum;
        this.maximum = maximum;
		var distance = Vector3.Distance(minimum, maximum);
		
		this.center = Vector3.Lerp(minimum, maximum, 0.5);
		this.radius = distance * 0.5;
		
		this.centerWorld = Vector3.Zero();
		this.update(Matrix.Identity());
	}
    public function init(minimum:Vector3, maximum:Vector3) :Void
	{
		this.minimum = minimum;
        this.maximum = maximum;
	    var distance = Vector3.Distance(minimum, maximum);
		
		this.center = Vector3.Lerp(minimum, maximum, 0.5);
		this.radius = distance * 0.5;
		
		this.centerWorld = Vector3.Zero();
		this.update(Matrix.Identity());	
	}
	public function getCenter():Vector3
	{
	   return Vector3.Lerp(minimum, maximum, 0.5);
	}
	public function initFloats(min:Float,max:Float):Void
		{
		  this.minimum.set(min, min, min);
          this.maximum.set(max,max,max);
		 var distance = Vector3.Distance(minimum, maximum);
		this.center = Vector3.Lerp(minimum, maximum, 0.5);
		this.radius = distance * 0.5;
		}
	
	public function reset(v:Vector3) :Void
		{
		this.maximum.copyFrom(v);
		this.minimum.copyFrom(v);
		}
	public function calculate():Void
	{
       var distance:Float = Vector3.Distance(minimum, maximum);
        this.center = Vector3.Lerp(minimum, maximum, 0.5);
        this.radius = distance * 0.5;
	}


		public function addInternalPoint(x:Float, y:Float,z:Float):Void
	{
		   if (x>maximum.x) maximum.x = x;
			if (y>maximum.y) maximum.y = y;
			if (z>maximum.z) maximum.z = z;

			if (x<minimum.x) minimum.x = x;
			if (y<minimum.y) minimum.y = y;
			if (z<minimum.z) minimum.z = z;
		    
	}

	// Methods
	inline public function update(world:Matrix):Void {
		Vector3.TransformCoordinatesToRef(this.center, world, this.centerWorld);
		Vector3.TransformNormalFromFloatsToRef(1.0, 1.0, 1.0, world, this._tempRadiusVector);
		this.radiusWorld = Math.max(Math.max(Math.abs(this._tempRadiusVector.x), Math.abs(this._tempRadiusVector.y)), Math.abs(this._tempRadiusVector.z)) * this.radius;
	}

	public function isInFrustum(frustumPlanes:Array<Plane>):Bool {
		for (i in 0...6) {
			if (frustumPlanes[i].dotCoordinate(this.centerWorld) <= -this.radiusWorld)
				return false;
		}
		
		return true;
	}

	public function intersectsPoint(point:Vector3):Bool {
		var x = this.centerWorld.x - point.x;
		var y = this.centerWorld.y - point.y;
		var z = this.centerWorld.z - point.z;
		
		var distance = Math.sqrt((x * x) + (y * y) + (z * z));
		
		if (Math.abs(this.radiusWorld - distance) < Util.Epsilon)
			return false;
			
		return true;
	}

	// Statics
	public static function Intersects(sphere0:BoundingSphere, sphere1:BoundingSphere):Bool {
		var x = sphere0.centerWorld.x - sphere1.centerWorld.x;
		var y = sphere0.centerWorld.y - sphere1.centerWorld.y;
		var z = sphere0.centerWorld.z - sphere1.centerWorld.z;
		
		var distance = Math.sqrt((x * x) + (y * y) + (z * z));
		
		if (sphere0.radiusWorld + sphere1.radiusWorld < distance)
			return false;
			
		return true;
	}


}
