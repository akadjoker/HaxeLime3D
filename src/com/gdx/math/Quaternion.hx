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
class Quaternion {
	
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;
	
	
	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	inline public static function Zero():Quaternion {
		return new Quaternion(0, 0, 0,0);
	}
	
	public inline function dot( q : Quaternion ) {
		return x * q.x + y * q.y + z * q.z + w * q.w;
	}
	public inline function negate() {
		x = -x;
		y = -y;
		z = -z;
		w = -w;
	}
	public inline function inverse() :Quaternion
	{
        var d:Float = x*x + y*y + z*z + w*w;
        return new Quaternion(x/d, -y/d, -z/d, -w/d);
    }

	public inline function axisX() :Vector3
	{
        var xz = x * z;
		var wy = w * y;
		var xy = x * y;
		var wz = w * z;
		var yy = y * y;
		var zz = z * z;
		
		
        return new Vector3(1-2*(yy+zz),2*(xy-wz),2*(xz+wy));
    }
	
	
	public inline function axisY() :Vector3
	{
       var yz = y * z;
	   var wx = w * x;
	   var xy = x * y;
	   var wz = w * z;
	   var xx = x * x;
	   var zz = z * z;
		return new Vector3( 2*(xy+wz),1-2*(xx+zz),2*(yz-wx) ); 
    }
	public inline function axisZ() :Vector3
	{
       var xz = x * z;
	   var wy = w * y;
	   var yz = y * z;
	   var wx = w * x;
	   var xx = x * x;
	   var yy = y * y;
		return new Vector3( 2 * (xz - wy), 2 * (yz + wx), 1 - 2 * (xx + yy) );
	}
    	
	public inline static function NormalInverse(q:Quaternion) :Quaternion
	{
           var norm:Float = q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z;
			if( norm > 0.0 )
			{
				var inverseNorm:Float = 1.0 / norm;
				return new Quaternion( q.w * inverseNorm, -q.x * inverseNorm, -q.y * inverseNorm, -q.z * inverseNorm );
			}
			else
			{
			
				return Quaternion.Zero();
			}
    }

	
	 inline public static function Inverse(q:Quaternion):Quaternion
	{
		return new Quaternion(-q.x, -q.y, -q.z, q.w);
	}
	 
	
	
	public function toString():String {
		return "{X:" + this.x + " Y:" + this.y + " Z:" + this.z + " W:" + this.w + "}";
	}

	inline public function asArray():Array<Float> {
		return [this.x, this.y, this.z, this.w];
	}
	public inline function lengthSq() {
		return x * x + y * y + z * z + w * w;
	}

	public inline function length() {
		return Math.sqrt(lengthSq());
	}

	
	inline public function set(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 1) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	inline public function equals(otherQuaternion:Quaternion):Bool {
		return otherQuaternion != null && this.x == otherQuaternion.x && this.y == otherQuaternion.y && this.z == otherQuaternion.z && this.w == otherQuaternion.w;
	}

	inline public function clone():Quaternion {
		return new Quaternion(this.x, this.y, this.z, this.w);
	}

	inline public function copyFrom(other:Quaternion):Quaternion {
		this.x = other.x;
		this.y = other.y;
		this.z = other.z;
		this.w = other.w;
		
		return this;
	}

	inline public function copyFromFloats(x:Float, y:Float, z:Float, w:Float):Quaternion {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
		
		return this;
	}

	inline public function add(other:Quaternion):Quaternion {
		return new Quaternion(this.x + other.x, this.y + other.y, this.z + other.z, this.w + other.w);
	}

	inline public function subtract(other:Quaternion):Quaternion {
		return new Quaternion(this.x - other.x, this.y - other.y, this.z - other.z, this.w - other.w);
	}

	inline public function scale(value:Float):Quaternion {
		return new Quaternion(this.x * value, this.y * value, this.z * value, this.w * value);
	}
	
    inline public function Conjugate():Quaternion
	{
		return new Quaternion(-x, -y, -z, w);
	}


	
	inline public function multLeft(q:Quaternion):Void
	{
	    var newX = q.w * x + q.x * w + q.y * z - q.z * y;
		var newY = q.w * y + q.y * w + q.z * x - q.x * z;
		var newZ = q.w * z + q.z * w + q.x * y - q.y * x;
		var newW = q.w * w - q.x * x - q.y * y - q.z * z;
		x = newX;
		y = newY;
		z = newZ;
		w = newW;
	}
	
	
	inline public function multiply(q1:Quaternion):Quaternion 
	{
		var result = new Quaternion(0, 0, 0, 1.0);
		this.multiplyToRef(q1, result);
		return result;
	}
   inline public function Mulf(r:Float):Quaternion 
	{
		return new Quaternion(x*r, y*r, z*r, w*r);
	}
	inline public function MulV3(r:Vector3):Quaternion 
	{
		
		var w_:Float = -x * r.x - y * r.y- z * r.z;
		var x_:Float =  w * r.x + y * r.z - z * r.y;
		var y_:Float =  w * r.y + z * r.x - x * r.z;
		var z_:Float =  w * r.z + x * r.y - y * r.x;
		
		return new Quaternion(x_, y_, z_, w_);
	}
	inline public function Mul(r:Quaternion):Quaternion 
	{
		var w_:Float = w * r.w - x * r.x - y * r.y - z * r.z;
		var x_:Float = x * r.w + w * r.x + y * r.z - z * r.y;
		var y_:Float = y * r.w + w * r.y + z * r.x - x * r.z;
		var z_:Float = z * r.w + w * r.z + x * r.y - y * r.x;
		
		return new Quaternion(x_, y_, z_, w_);
	}
	inline public function multiplyToRef(q1:Quaternion, result:Quaternion)
	{
		result.x = this.x * q1.w + this.y * q1.z - this.z * q1.y + this.w * q1.x;
		result.y = -this.x * q1.z + this.y * q1.w + this.z * q1.x + this.w * q1.y;
		result.z = this.x * q1.y - this.y * q1.x + this.z * q1.w + this.w * q1.z;
		result.w = -this.x * q1.x - this.y * q1.y - this.z * q1.z + this.w * q1.w;
	}


	

	inline public function normalize():Quaternion {
		var length = 1.0 / this.length();
		this.x *= length;
		this.y *= length;
		this.z *= length;
		this.w *= length;
		
		return this;
	}
	
	inline public  function   rotateAngleAxis(axis:Vector3, angle:Float) :Void
	{
		
            var halfAngle:Float = 0.5 * angle;
            var sin:Float = Math.sin(halfAngle);
            w = Math.cos(halfAngle);
            x = sin * axis.x;
            y = sin * axis.y;
            z = sin * axis.z;
        
  
    }
	
	inline public function toEulerAngles():Vector3 {
		var result = Vector3.Zero();
		this.toEulerAnglesToRef(result);
		return result;
	}
	
	inline public function toEulerAnglesToRef(result:Vector3) {
		//result is an EulerAngles in the in the z-x-z convention
		var qx = this.x;
		var qy = this.y;
		var qz = this.z;
		var qw = this.w;
		var qxy = qx * qy;
		var qxz = qx * qz;
		var qwy = qw * qy;
		var qwz = qw * qz;
		var qwx = qw * qx;
		var qyz = qy * qz;
		var sqx = qx * qx;
		var sqy = qy * qy;
		
		var determinant = sqx + sqy;
		
		if (determinant != 0.000 && determinant != 1.000) {
			result.x = Math.atan2(qxz + qwy, qwx - qyz);
			result.y = Math.acos(1 - 2 * determinant);
			result.z = Math.atan2(qxz - qwy, qwx + qyz);
		} else {
			if (determinant == 0.000) {
				result.x = 0.0;
				result.y = 0.0;
				result.z = Math.atan2(qxy - qwz, 0.5 - sqy - qz * qz); //actually, degeneracy gives us choice with x+z=Math.atan2(qxy-qwz,0.5-sqy-qz*qz)
			} else //determinant == 1.000
			{
				result.x = Math.atan2(qxy - qwz, 0.5 - sqy - qz * qz); //actually, degeneracy gives us choice with x-z=Math.atan2(qxy-qwz,0.5-sqy-qz*qz)
				result.y = Math.PI;
				result.z = 0.0;
			}
		}
	}

	inline public function toRotationMatrix(result:Matrix) {
		var xx = this.x * this.x;
		var yy = this.y * this.y;
		var zz = this.z * this.z;
		var xy = this.x * this.y;
		var zw = this.z * this.w;
		var zx = this.z * this.x;
		var yw = this.y * this.w;
		var yz = this.y * this.z;
		var xw = this.x * this.w;
		
		result.m11 = 1.0 - (2.0 * (yy + zz));
		result.m12 = 2.0 * (xy + zw);
		result.m13 = 2.0 * (zx - yw);
		result.m14 = 0;
		result.m21 = 2.0 * (xy - zw);
		result.m22 = 1.0 - (2.0 * (zz + xx));
		result.m23 = 2.0 * (yz + xw);
		result.m24 = 0;
		result.m31 = 2.0 * (zx + yw);
		result.m32 = 2.0 * (yz - xw);
		result.m33 = 1.0 - (2.0 * (yy + xx));
		result.m34 = 0;
		result.m41 = 0;
		result.m42 = 0;
		result.m43 = 0;
		result.m44 = 1.0;
	}

	public function initRotate( ax : Float, ay : Float, az : Float ) 
	{
		var sinX = Math.sin( ax * 0.5 );
		var cosX = Math.cos( ax * 0.5 );
		var sinY = Math.sin( ay * 0.5 );
		var cosY = Math.cos( ay * 0.5 );
		var sinZ = Math.sin( az * 0.5 );
		var cosZ = Math.cos( az * 0.5 );
		var cosYZ = cosY * cosZ;
		var sinYZ = sinY * sinZ;
		x = sinX * cosYZ - cosX * sinYZ;
		y = cosX * sinY * cosZ + sinX * cosY * sinZ;
		z = cosX * cosY * sinZ - sinX * sinY * cosZ;
		w = cosX * cosYZ + sinX * sinYZ;
	}
	public function initRotateAxis( x : Float, y : Float, z : Float, a : Float ) 
	{
		var sin =Math.sin( a / 2);
		var cos =Math.cos(a / 2);
		this.x = x * sin;
		this.y = y * sin;
		this.z = z * sin;
		this.w = cos * Math.sqrt( x * x + y * y + z * z);
		normalize();
	}
	
	inline public  function RotationYawPitchRollTo(yaw:Float, pitch:Float, roll:Float):Void 
		{
		var halfRoll = roll * 0.5;
        var halfPitch = pitch * 0.5;
        var halfYaw = yaw * 0.5;

        var sinRoll = Math.sin(halfRoll);
        var cosRoll = Math.cos(halfRoll);
        var sinPitch = Math.sin(halfPitch);
        var cosPitch = Math.cos(halfPitch);
        var sinYaw = Math.sin(halfYaw);
        var cosYaw = Math.cos(halfYaw);

        x = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
        y = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
        z = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
        w = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
		
		
	}
	inline public function fromRotationMatrix(matrix:Matrix) 
	{
		Quaternion.FromRotationMatrixToRef(matrix, this);
		return this;
	}

	// Statics
	inline public static function FromRotationMatrix(matrix:Matrix):Quaternion {
		var result = new Quaternion();
		Quaternion.FromRotationMatrixToRef(matrix, result);
		return result;
	}
	
	inline public static  function Multiply(q1:Quaternion, q2:Quaternion):Quaternion 
	{
		var result:Quaternion = Quaternion.Zero();
		result.x =  q1.x * q2.w + q1.y * q2.z - q1.z * q2.y + q1.w * q2.x;
		result.y = -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y;
		result.z =  q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z;
		result.w = -q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w;
		return result;
	}

	
	inline public static function FromRotationMatrixToRef(matrix:Matrix, result:Quaternion) {
		
		var m11 = matrix.m11;
		var m12 = matrix.m21;
		var m13 = matrix.m31;
		
		var m21 = matrix.m12;
		var m22 = matrix.m22;
		var m23 = matrix.m32;
		
		var m31 = matrix.m13;
		var m32 = matrix.m23;
		var m33 = matrix.m33;
		
		var _trace = m11 + m22 + m33;
		var s:Float = 0;
		
		if (_trace > 0) {
			
			s = 0.5 / Math.sqrt(_trace + 1.0);
			
			result.w = 0.25 / s;
			result.x = (m32 - m23) * s;
			result.y = (m13 - m31) * s;
			result.z = (m21 - m12) * s;
			
		} else if (m11 > m22 && m11 > m33) {
			
			s = 2.0 * Math.sqrt(1.0 + m11 - m22 - m33);
			
			result.w = (m32 - m23) / s;
			result.x = 0.25 * s;
			result.y = (m12 + m21) / s;
			result.z = (m13 + m31) / s;
			
		} else if (m22 > m33) {
			
			s = 2.0 * Math.sqrt(1.0 + m22 - m11 - m33);
			
			result.w = (m13 - m31) / s;
			result.x = (m12 + m21) / s;
			result.y = 0.25 * s;
			result.z = (m23 + m32) / s;
			
		} else {
			
			s = 2.0 * Math.sqrt(1.0 + m33 - m11 - m22);
			
			result.w = (m21 - m12) / s;
			result.x = (m13 + m31) / s;
			result.y = (m23 + m32) / s;
			result.z = 0.25 * s;
		}
	}
	
	
	
	inline public static function Identity():Quaternion {
		return new Quaternion(0, 0, 0, 1);
	}

	
	inline public static function RotationAxis(axis:Vector3, angle:Float):Quaternion {
		var result = new Quaternion();
		var sin = Math.sin(angle / 2);
		
		result.w = Math.cos(angle / 2);
		result.x = axis.x * sin;
		result.y = axis.y * sin;
		result.z = axis.z * sin;
		
		return result;
	}
	inline public static function   CreateFromAngleAxis(axis:Vector3, angle:Float) :Quaternion
	{
		var q:Quaternion= new Quaternion(0, 0, 0, 1);
		
            var halfAngle:Float = 0.5 * angle;
            var sin:Float = Math.sin(halfAngle);
            q.w = Math.cos(halfAngle);
            q.x = sin * axis.x;
            q.y = sin * axis.y;
            q.z = sin * axis.z;
        
        return q;
    }

	inline public static function FromArray(array:Array<Float>, offset:Int = 0):Quaternion {
		return new Quaternion(array[offset], array[offset + 1], array[offset + 2], array[offset + 3]);
	}

	inline public static function RotationYawPitchRoll(yaw:Float, pitch:Float, roll:Float):Quaternion {
		var result = new Quaternion();
		Quaternion.RotationYawPitchRollToRef(yaw, pitch, roll, result);
		return result;
	}

	inline public static function RotationYawPitchRollToRef(yaw:Float, pitch:Float, roll:Float, result:Quaternion) {
		var halfRoll = roll * 0.5;
		var halfPitch = pitch * 0.5;
		var halfYaw = yaw * 0.5;
		
		var sinRoll = Math.sin(halfRoll);
		var cosRoll = Math.cos(halfRoll);
		var sinPitch = Math.sin(halfPitch);
		var cosPitch = Math.cos(halfPitch);
		var sinYaw = Math.sin(halfYaw);
		var cosYaw = Math.cos(halfYaw);
		
		result.x = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
		result.y = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
		result.z = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
		result.w = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
	}
	
	public inline function lerp( q1 : Quaternion, q2 : Quaternion, v : Float, nearest = false ) {
		var v2;
		if( nearest && q1.dot(q2) < 0 )
			v2 = v - 1;
		else
			v2 = 1 - v;
		var x = q1.x * v + q2.x * v2;
		var y = q1.y * v + q2.y * v2;
		var z = q1.z * v + q2.z * v2;
		var w = q1.w * v + q2.w * v2;
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}


	
	inline public static function Slerp(left:Quaternion, right:Quaternion, amount:Float):Quaternion 
	{
		
		var num2 = 0.0;
		var num3 = 0.0;
		var num = amount;
		var num4 = (((left.x * right.x) + (left.y * right.y)) + (left.z * right.z)) + (left.w * right.w);
		var flag = false;
		
		if (num4 < 0) {
			flag = true;
			num4 = -num4;
		}
		
		if (num4 > 0.999999) {
			num3 = 1 - num;
			num2 = flag ? -num : num;
		}
		else {
			var num5 = Math.acos(num4);
			var num6 = (1.0 / Math.sin(num5));
			num3 = (Math.sin((1.0 - num) * num5)) * num6;
			num2 = flag ? ((-Math.sin(num * num5)) * num6) : ((Math.sin(num * num5)) * num6);
		}
		
		return new Quaternion((num3 * left.x) + (num2 * right.x), (num3 * left.y) + (num2 * right.y), (num3 * left.z) + (num2 * right.z), (num3 * left.w) + (num2 * right.w));
	}
	
	public function GetForward():Vector3
	{
		return new Vector3(0, 0, 1).RotateQuat(this);
	}
	public function GetBack():Vector3
	{
		return new Vector3(0, 0, -1).RotateQuat(this);
	}
	public function GetUp():Vector3
	{
		return new Vector3(0, 1, 0).RotateQuat(this);
	}
	public function GetDown():Vector3
	{
		return new Vector3(0, -1, 0).RotateQuat(this);
	}
	public function GetRight():Vector3
	{
		return new Vector3(1, 0, 0).RotateQuat(this);
	}
	public function GetLeft():Vector3
	{
		return new Vector3(-1, 0, 0).RotateQuat(this);
	}
	
	//From Ken Shoemake's "Quaternion Calculus and Fast Animation" article
	inline public static function FromMatrix( rot:Matrix):Quaternion
	{
		var Trace:Float = rot.m11 + rot.m22 + rot.m33;
		
		var x:Float = 0;
		var y:Float = 0;
		var z:Float = 0;
		var w:Float = 0;

		if(Trace > 0)
		{
			var s:Float = 0.5 / Math.sqrt(Trace+ 1.0);
			w = 0.25 / s;
			x = (rot.m23 - rot.m32) * s;
			y = (rot.m31 - rot.m13) * s;
			z = (rot.m12 - rot.m21) * s;
		}
		else
		{
			if(rot.m11 > rot.m22 && rot.m11 > rot.m33)
			{
				var s:Float = 2.0 * Math.sqrt(1.0 + rot.m11 - rot.m22 - rot.m33);
				w = (rot.m23 - rot.m32) / s;
				x = 0.25 * s;
				y = (rot.m21 + rot.m12) / s;
				z = (rot.m31 + rot.m13) / s;
			}
			else if(rot.m22 > rot.m33)
			{
				var s:Float = 2.0 * Math.sqrt(1.0 + rot.m22 - rot.m11 - rot.m33);
				w = (rot.m31 - rot.m13) / s;
				x = (rot.m21 + rot.m12) / s;
				y = 0.25 * s;
				z = (rot.m32 + rot.m23) / s;
			}
			else
			{
				var s:Float = 2.0 * Math.sqrt(1.0 + rot.m33- rot.m11 - rot.m22);
				w = (rot.m12 - rot.m21 ) / s;
				x = (rot.m31 + rot.m13 ) / s;
				y = (rot.m23 + rot.m32 ) / s;
				z = 0.25 * s;
			}
		}

		var length:Float = Math.sqrt(x * x + y * y + z * z + w * w);
		x /= length;
		y /= length;
		z /= length;
		w /= length;
		return new Quaternion(x, y, z, w);
	}
}
