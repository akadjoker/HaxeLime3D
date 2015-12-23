package com.gdx.math;
import com.gdx.Buffer;
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
class BoundingBox extends Buffer {
	
	public var minimum:Vector3;
    public var maximum:Vector3;
	public var vectors:Array<Vector3> = [];
	
	public var center:Vector3;
	public var extendSize:Vector3;
	public var directions:Array<Vector3>;
	public var vectorsWorld:Array<Vector3> = [];
	
	public var minimumWorld:Vector3;
	public var maximumWorld:Vector3;

	private var _worldMatrix:Matrix;
	
	public var __smartArrayFlags:Array<Int>;
	

	public function new(minimum:Vector3, maximum:Vector3) {
		super();
		this.minimum = minimum;
		this.maximum = maximum;
		
		// Bounding vectors            
		this.vectors.push(this.minimum.clone());
		this.vectors.push(this.maximum.clone());
		
		this.vectors.push(this.minimum.clone());
		this.vectors[2].x = this.maximum.x;
		
		this.vectors.push(this.minimum.clone());
		this.vectors[3].y = this.maximum.y;
		
		this.vectors.push(this.minimum.clone());
		this.vectors[4].z = this.maximum.z;
		
		this.vectors.push(this.maximum.clone());
		this.vectors[5].z = this.minimum.z;
		
		this.vectors.push(this.maximum.clone());
		this.vectors[6].x = this.minimum.x;
		
		this.vectors.push(this.maximum.clone());
		this.vectors[7].y = this.minimum.y;
		
		// OBB
		this.center = this.maximum.add(this.minimum).scale(0.5);
		this.extendSize = this.maximum.subtract(this.minimum).scale(0.5);
		this.directions = [Vector3.Zero(), Vector3.Zero(), Vector3.Zero()];
		
		// World
		for (index in 0...this.vectors.length) {
			this.vectorsWorld[index] = Vector3.Zero();
		}
		this.minimumWorld = Vector3.Zero();
		this.maximumWorld = Vector3.Zero();
		
		this.update(Matrix.Identity());
	}
	public function init(minimum:Vector3, maximum:Vector3) :Void
	{
		this.minimum = minimum;
		this.maximum = maximum;
		
		// Bounding vectors            
		this.vectors.push(this.minimum.clone());
		this.vectors.push(this.maximum.clone());
		
		this.vectors.push(this.minimum.clone());
		this.vectors[2].x = this.maximum.x;
		
		this.vectors.push(this.minimum.clone());
		this.vectors[3].y = this.maximum.y;
		
		this.vectors.push(this.minimum.clone());
		this.vectors[4].z = this.maximum.z;
		
		this.vectors.push(this.maximum.clone());
		this.vectors[5].z = this.minimum.z;
		
		this.vectors.push(this.maximum.clone());
		this.vectors[6].x = this.minimum.x;
		
		this.vectors.push(this.maximum.clone());
		this.vectors[7].y = this.minimum.y;
		
		// OBB
		this.center = this.maximum.add(this.minimum).scale(0.5);
		this.extendSize = this.maximum.subtract(this.minimum).scale(0.5);
		this.directions = [Vector3.Zero(), Vector3.Zero(), Vector3.Zero()];
		
		// World
		for (index in 0...this.vectors.length)
		{
			this.vectorsWorld[index] = Vector3.Zero();
		}
		this.minimumWorld = Vector3.Zero();
		this.maximumWorld = Vector3.Zero();
		
		this.update(Matrix.Identity());

	}
    public function initFloats(min:Float,max:Float):Void
	{
		  this.minimum.set(min, min, min);
          this.maximum.set(max,max,max);
		  
	}

    public function reset(v:Vector3) :Void
		{
		this.maximum.copyFrom(v);
		this.minimum.copyFrom(v);
		}
	
   public function calculate():Void
	{
		var  aMinX, aMaxX, aMinY, aMaxY, aMinZ, aMaxZ:Float;
		aMinX = minimum.x;
		aMinY = minimum.y;
		aMinZ = minimum.z;
		aMaxX = maximum.x;
		aMaxY = maximum.y;
		aMaxZ = maximum.z;
		
	this.vectors[0].set(aMinX, aMinY, aMaxZ);
  	this.vectors[1].set(aMaxX, aMinY, aMaxZ);
  	this.vectors[2].set(aMaxX, aMaxY, aMaxZ);
  	this.vectors[3].set(aMinX, aMaxY, aMaxZ);
  	this.vectors[4].set(aMinX, aMinY, aMinZ);
  	this.vectors[5].set(aMinX, aMaxY, aMinZ);
  	this.vectors[6].set(aMaxX, aMaxY, aMinZ);
  	this.vectors[7].set(aMaxX, aMinY, aMinZ);
	
		

		
        // OBB
     	this.center = this.maximum.add(this.minimum).scale(0.5);
		this.extendSize = this.maximum.subtract(this.minimum).scale(0.5);
		
    }

	public function isFullInside(other:BoundingBox) :Bool
	{
				return (minimum.x >= other.minimum.x && minimum.y >= other.minimum.y && minimum.z >= other.minimum.z &&
				maximum.x <= other.maximum.x && maximum.y <= other.maximum.y && maximum.z <= other.maximum.z);
	
	}

	public function addInternalVector(v:Vector3):Void
	{
		 addInternalPoint(v.x, v.y, v.z);
	}
    public function addInternalBox(b:BoundingBox):Void
	{
	addInternalVector(b.maximum);
	addInternalVector(b.minimum);
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
	public function getCenter():Vector3
	{
	    var v:Vector3 = new Vector3(
		
		(minimum.x + maximum.x) / 2,
		(minimum.y + maximum.y) / 2,
		(minimum.z + maximum.z) / 2);
		
		return v;
	}

	public function isEmpty():Bool
	{
		return minimum.equals(maximum);
	}
	public function getEdges(edges:Array<Vector3>):Void
	{
		    var diag:Vector3 = center.subtract(maximum);
		    edges.push(new Vector3(center.x + diag.x, center.y + diag.y, center.z + diag.z));
			edges.push(new Vector3(center.x + diag.x, center.y - diag.y, center.z + diag.z));
			edges.push(new Vector3(center.x + diag.x, center.y + diag.y, center.z - diag.z));
			edges.push(new Vector3(center.x + diag.x, center.y - diag.y, center.z - diag.z));
			edges.push(new Vector3(center.x - diag.x, center.y + diag.y, center.z + diag.z));
			edges.push(new Vector3(center.x - diag.x, center.y - diag.y, center.z + diag.z));
			edges.push(new Vector3(center.x - diag.x, center.y + diag.y, center.z - diag.z));
			edges.push(new Vector3(center.x - diag.x, center.y - diag.y, center.z - diag.z));
	}

	

	public function update(world:Matrix)
	{
		Vector3.FromFloatsToRef(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, this.minimumWorld);
		Vector3.FromFloatsToRef(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, this.maximumWorld);
		
		for (index in 0...this.vectors.length)
		{
			var v = this.vectorsWorld[index];
			Vector3.TransformCoordinatesToRef(this.vectors[index], world, v);
			
			if (v.x < this.minimumWorld.x)
				this.minimumWorld.x = v.x;
			if (v.y < this.minimumWorld.y)
				this.minimumWorld.y = v.y;
			if (v.z < this.minimumWorld.z)
				this.minimumWorld.z = v.z;
				
			if (v.x > this.maximumWorld.x)
				this.maximumWorld.x = v.x;
			if (v.y > this.maximumWorld.y)
				this.maximumWorld.y = v.y;
			if (v.z > this.maximumWorld.z)
				this.maximumWorld.z = v.z;
		}
		
		// OBB
		this.maximumWorld.addToRef(this.minimumWorld, this.center);
		this.center.scaleInPlace(0.5);
		
		Vector3.FromFloatArrayToRef(world.getFloats(), 0, this.directions[0]);
		Vector3.FromFloatArrayToRef(world.getFloats(), 4, this.directions[1]);
		Vector3.FromFloatArrayToRef(world.getFloats(), 8, this.directions[2]);
		
		this._worldMatrix = world;
	}

	inline public function isInFrustum(frustumPlanes:Array<Plane>):Bool 
	{
		return BoundingBox.IsInFrustum(this.vectorsWorld, frustumPlanes);
	}

	inline public function isCompletelyInFrustum(frustumPlanes:Array<Plane>):Bool 
	{
		return BoundingBox.IsCompletelyInFrustum(this.vectorsWorld, frustumPlanes);
	}
	 public function isPointInside(p:Vector3):Bool
	 {
		return (	p.x >= minimum.x && p.x <= maximum.x &&
							p.y >= minimum.y && p.y <= maximum.y &&
							p.z >= minimum.z && p.z <= maximum.z);
		
     }

	public function intersectsPoint(point:Vector3):Bool 
	{
		var delta = -Util.Epsilon;
		
		if (this.maximumWorld.x - point.x < delta || delta > point.x - this.minimumWorld.x)
			return false;
			
		if (this.maximumWorld.y - point.y < delta || delta > point.y - this.minimumWorld.y)
			return false;
			
		if (this.maximumWorld.z - point.z < delta || delta > point.z - this.minimumWorld.z)
			return false;
			
		return true;
	}

	inline public function intersectsSphere(sphere:BoundingSphere):Bool 
	{
		return BoundingBox.IntersectsSphere(this.minimumWorld, this.maximumWorld, sphere.centerWorld, sphere.radiusWorld);
	}

	public function intersectsMinMax(min:Vector3, max:Vector3):Bool
	{
		if (this.maximumWorld.x < min.x || this.minimumWorld.x > max.x)
			return false;
			
		if (this.maximumWorld.y < min.y || this.minimumWorld.y > max.y)
			return false;
			
		if (this.maximumWorld.z < min.z || this.minimumWorld.z > max.z)
			return false;
			
		return true;
	}

	// Statics
	public static function Intersects(box0:BoundingBox, box1:BoundingBox):Bool 
	{
		if (box0.maximumWorld.x < box1.minimumWorld.x || box0.minimumWorld.x > box1.maximumWorld.x)
			return false;
			
		if (box0.maximumWorld.y < box1.minimumWorld.y || box0.minimumWorld.y > box1.maximumWorld.y)
			return false;
			
		if (box0.maximumWorld.z < box1.minimumWorld.z || box0.minimumWorld.z > box1.maximumWorld.z)
			return false;
			
		return true;
	}
	public static function IntersectsAAB(box0:BoundingBox, box1:BoundingBox):Bool 
	{
		if (box0.maximum.x < box1.minimum.x || box0.minimum.x > box1.maximum.x)
			return false;
			
		if (box0.maximum.y < box1.minimum.y || box0.minimum.y > box1.maximum.y)
			return false;
			
		if (box0.maximum.z < box1.minimum.z || box0.minimum.z > box1.maximum.z)
			return false;
			
		return true;
	}

	static var IntersectsSphere_vector:Vector3 = new Vector3();
	inline public static function IntersectsSphere(minPoint:Vector3, maxPoint:Vector3, sphereCenter:Vector3, sphereRadius:Float):Bool {
		IntersectsSphere_vector = Vector3.Clamp(sphereCenter, minPoint, maxPoint);
		var num = Vector3.DistanceSquared(sphereCenter, IntersectsSphere_vector);
		return (num <= (sphereRadius * sphereRadius));
	}

	public static function IsCompletelyInFrustum(boundingVectors:Array<Vector3>, frustumPlanes:Array<Plane>):Bool {
		for (p in 0...6) {
			for (i in 0...8) {
				if (frustumPlanes[p].dotCoordinate(boundingVectors[i]) < 0) {
					return false;
				}
			}
		}
		return true;
	}

	public static function IsInFrustum(boundingVectors:Array<Vector3>, frustumPlanes:Array<Plane>):Bool {
		for (p in 0...6) {
			var inCount = 8;
			
			for (i in 0...8) {
				if (frustumPlanes[p].dotCoordinate(boundingVectors[i]) < 0) {
					--inCount;
				} 
				else {
					break;
				}
			}
			if (inCount == 0)
				return false;
		}
		return true;
	}

	override public function dispose() 
	{
		super.dispose();
	}
}
