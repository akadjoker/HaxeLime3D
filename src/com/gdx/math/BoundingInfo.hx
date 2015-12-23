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
class BoundingInfo {
	
	public var boundingBox:BoundingBox;
	public var boundingSphere:BoundingSphere;
	
	public var minimum:Vector3;
	public var maximum:Vector3;

	
	public function new(minimum:Vector3, maximum:Vector3) 
	{
		this.minimum = minimum;
		this.maximum = maximum;
		this.boundingBox = new BoundingBox(minimum, maximum);
		this.boundingSphere = new BoundingSphere(minimum, maximum);
	}


	public function init(minimum:Vector3, maximum:Vector3) :Void
	{
		this.minimum = minimum;
		this.maximum = maximum;
		this.boundingBox.init(minimum, maximum);
		this.boundingSphere.init(minimum, maximum);
	}
	public function initFloats(min:Float,max:Float)
	{
		  this.minimum.set(min, min, min);
          this.maximum.set(max, max, max);
		  boundingBox.initFloats(min,max);
	 	  boundingSphere.initFloats(min, max);
	}
		
	public function reset(v:Vector3) 
		{
		 boundingBox.reset(v);
	 	 boundingSphere.reset(v);
		}
        
	public function addInternalPoint(x:Float, y:Float,z:Float):Void
	{
		  
		   boundingBox.addInternalPoint(x, y, z);
		   boundingSphere.addInternalPoint(x, y, z);
	}
	public function addInternalVector(v:Vector3):Void
	{
		
		addInternalPoint(v.x, v.y, v.z);
		   
	}
	public function calculate()
	{
	   boundingBox.calculate();
	   boundingSphere.calculate();
	}

	// Methods
	inline public function update(world:Matrix) 
	{
		this.boundingBox.update(world);
		this.boundingSphere.update(world);

	}

	public function isInFrustum(frustumPlanes:Array<Plane>):Bool
	{
		if (!this.boundingSphere.isInFrustum(frustumPlanes))
			return false;
			
		return this.boundingBox.isInFrustum(frustumPlanes);
	}

	inline public function isCompletelyInFrustum(frustumPlanes:Array<Plane>):Bool
	{
		return this.boundingBox.isCompletelyInFrustum(frustumPlanes);
	}
   

	public function intersectsPoint(point:Vector3):Bool
	{
		if (this.boundingSphere.centerWorld == null) {
			return false;
		}
		
		if (!this.boundingSphere.intersectsPoint(point)) {
			return false;
		}
		
		if (!this.boundingBox.intersectsPoint(point)) {
			return false;
		}
		
		return true;
	}

	public function intersects(boundingInfo:BoundingInfo, precise:Bool = false):Bool
	 {
		if (this.boundingSphere.centerWorld == null || boundingInfo.boundingSphere.centerWorld == null) {
			return false;
		}
		
		if (!BoundingSphere.Intersects(this.boundingSphere, boundingInfo.boundingSphere)) {
			return false;
		}
		
		if (!BoundingBox.Intersects(this.boundingBox, boundingInfo.boundingBox)) {
			return false;
		}
		
		if (precise) {
			return true;
		}
		
		var box0 = this.boundingBox;
		var box1 = boundingInfo.boundingBox;
		
		if (!axisOverlap(box0.directions[0], box0, box1)) return false;
		if (!axisOverlap(box0.directions[1], box0, box1)) return false;
		if (!axisOverlap(box0.directions[2], box0, box1)) return false;
		if (!axisOverlap(box1.directions[0], box0, box1)) return false;
		if (!axisOverlap(box1.directions[1], box0, box1)) return false;
		if (!axisOverlap(box1.directions[2], box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[0], box1.directions[0]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[0], box1.directions[1]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[0], box1.directions[2]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[1], box1.directions[0]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[1], box1.directions[1]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[1], box1.directions[2]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[2], box1.directions[0]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[2], box1.directions[1]), box0, box1)) return false;
		if (!axisOverlap(Vector3.Cross(box0.directions[2], box1.directions[2]), box0, box1)) return false;
		
		return true;
	}
	
	// Statics
	inline private static function computeBoxExtents(axis:Vector3, box:BoundingBox):Dynamic 
	{
        var p = Vector3.Dot(box.center, axis);
		
        var r0 = Math.abs(Vector3.Dot(box.directions[0], axis)) * box.extendSize.x;
        var r1 = Math.abs(Vector3.Dot(box.directions[1], axis)) * box.extendSize.y;
        var r2 = Math.abs(Vector3.Dot(box.directions[2], axis)) * box.extendSize.z;
		
        var r = r0 + r1 + r2;
        return {
            min: p - r,
            max: p + r
        };
    }

    inline private static function extentsOverlap(min0:Float, max0:Float, min1:Float, max1:Float):Bool
	{
		return !(min0 > max1 || min1 > max0);
	}

    inline private static function axisOverlap(axis:Vector3, box0:BoundingBox, box1:BoundingBox):Bool 
	{
        var result0 = computeBoxExtents(axis, box0);
        var result1 = computeBoxExtents(axis, box1);
		
        return extentsOverlap(result0.min, result0.max, result1.min, result1.max);
    }
	
}
