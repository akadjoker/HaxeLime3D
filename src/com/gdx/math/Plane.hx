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
 class Plane {
	
	public var normal:Vector3;
	public var d:Float;
	

	public function new(a:Float, b:Float, c:Float, d:Float) {
		this.normal = new Vector3(a, b, c);
		this.d = d;
	}

	inline public function asArray():Array<Float> {
		return [this.normal.x, this.normal.y, this.normal.z, this.d];
	}

	// Methods
	public function clone():Plane {
		return new Plane(this.normal.x, this.normal.y, this.normal.z, this.d);
	}

	inline public function normalize():Void {
		var norm = (Math.sqrt((this.normal.x * this.normal.x) + (this.normal.y * this.normal.y) + (this.normal.z * this.normal.z)));
		var magnitude = 0.0;
		
		if (norm != 0) {
			magnitude = 1.0 / norm;
		}
		
		this.normal.x *= magnitude;
		this.normal.y *= magnitude;
		this.normal.z *= magnitude;
		
		this.d *= magnitude;
	}

	static var transposedMatrix = new Matrix();
	inline public function transform(transformation:Matrix):Plane {
		transposedMatrix = Matrix.Transpose(transformation);
		var x = this.normal.x;
		var y = this.normal.y;
		var z = this.normal.z;
		var d = this.d;
		
		var normalX = (((x * transposedMatrix.m11) + (y * transposedMatrix.m12)) + (z * transposedMatrix.m13)) + (d * transposedMatrix.m14);
		var normalY = (((x * transposedMatrix.m21) + (y * transposedMatrix.m22)) + (z * transposedMatrix.m23)) + (d * transposedMatrix.m24);
		var normalZ = (((x * transposedMatrix.m31) + (y * transposedMatrix.m32)) + (z * transposedMatrix.m33)) + (d * transposedMatrix.m34);
		var finalD = (((x * transposedMatrix.m41) + (y * transposedMatrix.m42)) + (z * transposedMatrix.m43)) + (d * transposedMatrix.m44);
		
		return new Plane(normalX, normalY, normalZ, finalD);
	}


	inline public function dotCoordinate(point:Vector3):Float {
		return ((((this.normal.x * point.x) + (this.normal.y * point.y)) + (this.normal.z * point.z)) + this.d);
	}

	inline public function copyFromPoints(point1:Vector3, point2:Vector3, point3:Vector3):Void {
		var x1 = point2.x - point1.x;
		var y1 = point2.y - point1.y;
		var z1 = point2.z - point1.z;
		var x2 = point3.x - point1.x;
		var y2 = point3.y - point1.y;
		var z2 = point3.z - point1.z;
		var yz = (y1 * z2) - (z1 * y2);
		var xz = (z1 * x2) - (x1 * z2);
		var xy = (x1 * y2) - (y1 * x2);
		var pyth = (Math.sqrt((yz * yz) + (xz * xz) + (xy * xy)));
		var invPyth;
		
		if (pyth != 0) {
			invPyth = 1.0 / pyth;
		}
		else {
			invPyth = 0;
		}
		
		this.normal.x = yz * invPyth;
		this.normal.y = xz * invPyth;
		this.normal.z = xy * invPyth;
		this.d = -((this.normal.x * point1.x) + (this.normal.y * point1.y) + (this.normal.z * point1.z));
	}

	inline public function isFrontFacingTo(direction:Vector3, epsilon:Float):Bool {
		var dot = Vector3.Dot(this.normal, direction);
		
		return (dot <= epsilon);
	}
	inline public function DistanceTo(point:Vector3):Float {
		return normal.x*point.x + normal.y*point.y + normal.z*point.z + this.d;
	}

	inline public function signedDistanceTo(point:Vector3):Float {
		return Vector3.Dot(point, this.normal) + this.d;
	}

	// Statics
	inline public static function FromArray(array:Array<Float>):Plane {
		return new Plane(array[0], array[1], array[2], array[3]);
	}

	inline inline public static function FromPoints(point1:Vector3, point2:Vector3, point3:Vector3):Plane {
		var result = new Plane(0, 0, 0, 0);
		result.copyFromPoints(point1, point2, point3);
		return result;
	}

	inline public static function FromPositionAndNormal(origin:Vector3, normal:Vector3):Plane {
		var result = new Plane(0, 0, 0, 0);
		normal.normalize();
		
		result.normal = normal;
		result.d = -(normal.x * origin.x + normal.y * origin.y + normal.z * origin.z);
		
		return result;
	}
    inline public static function setPlane(point1:Vector3, point2:Vector3, point3:Vector3):Plane 
	{
		var result = new Plane(0, 0, 0, 0);
	  var vVector1:Vector3 = Vector3.Sub(point2 , point1);
	  var vVector2:Vector3 = Vector3.Sub(point3 , point1);
      result.normal = Vector3.Cross(vVector1, vVector2);
	  result.normalize();
	  
	  result.d = -Vector3.Dot(point1, result.normal);
	
		
        return result;
	}
	
	inline public static function SignedDistanceToPlaneFromPositionAndNormal(origin:Vector3, normal:Vector3, point:Vector3):Float {
		var d = -(normal.x * origin.x + normal.y * origin.y + normal.z * origin.z);
		
		return Vector3.Dot(point, normal) + d;
	}
	
}
