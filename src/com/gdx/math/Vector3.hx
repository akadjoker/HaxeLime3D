package com.gdx.math;
import com.gdx.util.Util;

import com.gdx.math.Rectangle;
import lime.utils.Float32Array;
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
class Vector3 {
	
	static public var zero(get_zero, null):Vector3;	static private function get_zero():Vector3 { return new Vector3(0, 0, 0); }
	static public var axisX(get_axisX, null):Vector3;	static private function get_axisX():Vector3 { return new Vector3(1, 0, 0); }
	static public var axisY(get_axisY, null):Vector3;	static private function get_axisY():Vector3 { return new Vector3(0, 1, 0); }
	static public var axisZ(get_axisZ, null):Vector3;	static private function get_axisZ():Vector3 { return new Vector3(0, 0, 1); }

	
	public var x:Float;
	public var y:Float;
	public var z:Float;


	public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	

	inline public function toString():String {
		return "{X:" + this.x + " Y:" + this.y + " Z:" + this.z + "}";
	}

	// Operators
	inline public function asArray():Array<Float> {
		var result:Array<Float> = [];
		
		this.toArray(result, 0);
		
		return result;
	}
	
	inline public function set(x:Float = 0, y:Float = 0, z:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	inline public function toArray(array:Array<Float>, index:Int = 0) {
		array[index] = this.x;
		array[index + 1] = this.y;
		array[index + 2] = this.z;
	}
	
	inline public function toQuaternion():Quaternion {
		var result = new Quaternion(0, 0, 0, 1);
		
		var cosxPlusz = Math.cos((this.x + this.z) * 0.5);
		var sinxPlusz = Math.sin((this.x + this.z) * 0.5);
		var coszMinusx = Math.cos((this.z - this.x) * 0.5);
		var sinzMinusx = Math.sin((this.z - this.x) * 0.5);
		var cosy = Math.cos(this.y * 0.5);
		var siny = Math.sin(this.y * 0.5);
		
		result.x = coszMinusx * siny;
		result.y = -sinzMinusx * siny;
		result.z = sinxPlusz * cosy;
		result.w = cosxPlusz * cosy;
		
		return result;
	}
	
	inline public function yaw():Float
	{
		return -Math.atan2(x, z);
	}
    inline public function pitch():Float
	{
		return -Math.atan2(y, Math.sqrt(x*x+z*z));
	}
	
	inline public function addInPlace(otherVector:Vector3):Vector3 {
		this.x += otherVector.x;
		this.y += otherVector.y;
		this.z += otherVector.z;
		return this;
	}

	inline public function add(otherVector:Vector3):Vector3 {
		return new Vector3(this.x + otherVector.x, this.y + otherVector.y, this.z + otherVector.z);
	}

	inline public function addToRef(otherVector:Vector3, result:Vector3) {
		result.x = this.x + otherVector.x;
		result.y = this.y + otherVector.y;
		result.z = this.z + otherVector.z;
	}

	inline public function subtractInPlace(otherVector:Vector3):Vector3 {
		this.x -= otherVector.x;
		this.y -= otherVector.y;
		this.z -= otherVector.z;
		return this;
	}

	inline public function subtract(otherVector:Vector3):Vector3 {
		return new Vector3(this.x - otherVector.x, this.y - otherVector.y, this.z - otherVector.z);
	}

	inline public function subtractToRef(otherVector:Vector3, result:Vector3) {
		result.x = this.x - otherVector.x;
		result.y = this.y - otherVector.y;
		result.z = this.z - otherVector.z;
	}

	inline public function subtractFromFloats(x:Float, y:Float, z:Float):Vector3 {
		return new Vector3(this.x - x, this.y - y, this.z - z);
	}

	inline public function subtractFromFloatsToRef(x:Float, y:Float, z:Float, result:Vector3) {
		result.x = this.x - x;
		result.y = this.y - y;
		result.z = this.z - z;
	}

	inline public function negate():Vector3 {
		return new Vector3(-this.x, -this.y, -this.z);
	}

	inline public function scaleInPlace(scale:Float):Vector3 {
		this.x *= scale;
		this.y *= scale;
		this.z *= scale;
		return this;
	}

	inline public function scale(scale:Float):Vector3 {
		return new Vector3(this.x * scale, this.y * scale, this.z * scale);
	}

	inline public function scaleToRef(scale:Float, result:Vector3) {
		result.x = this.x * scale;
		result.y = this.y * scale;
		result.z = this.z * scale;
	}
	 inline public static function Mult(v:Vector3, d:Float):Vector3 
	{
		return new Vector3(  v.x * d, 
		                     v.y * d, 
							 v.z * d);
	}
	


	inline public static function Sub(a:Vector3, b:Vector3):Vector3 
	{
		return new Vector3(a.x - b.x, 
		                   a.y - b.y, 
						   a.z - b.z);
	}
	inline public static function Add(a:Vector3, b:Vector3):Vector3 
	{
		return new Vector3(a.x + b.x,
		                   a.y + b.y, 
						   a.z + b.z);
	}
	inline public function setLength(l:Float):Void 
	{
		var len:Float = Math.sqrt(x * x + y * y + z * z);
	    x *= l / len;
	    y *= l / len;
	    z *= l / len;
	}
		public static function divEquals(v:Vector3,s:Float):Vector3 {
			if (s == 0) s = 0.0001;
			return new Vector3(	v.x / s ,
								v.y  / s ,
								v.z / s );
		}
		public static function divEqualsTo(v:Vector3,s:Vector3):Vector3 {
			return new Vector3(	v.x / s.x ,
								v.y  / s.y ,
								v.z / s.z );
		}	


	inline public static function checkExtends(v:Vector3, min:Vector3, max:Vector3):Void
	{
            if (v.x < min.x)
                min.x = v.x;
            if (v.y < min.y)
                min.y = v.y;
            if (v.z < min.z)
                min.z = v.z;

            if (v.x > max.x)
                max.x = v.x;
            if (v.y > max.y)
                max.y = v.y;
            if (v.z > max.z)
                max.z = v.z;
        }
		
	inline public function equals(otherVector:Vector3):Bool {
		return otherVector != null && this.x == otherVector.x && this.y == otherVector.y && this.z == otherVector.z;
	}

	inline public function equalsWithEpsilon(otherVector:Vector3, epsilon:Float = Util.Epsilon):Bool {
		return otherVector != null && Util.WithinEpsilon(this.x, otherVector.x, epsilon) && Util.WithinEpsilon(this.y, otherVector.y, epsilon) && Util.WithinEpsilon(this.z, otherVector.z, epsilon);
	}

	inline public function equalsToFloats(x:Float, y:Float, z:Float):Bool {
		return this.x == x && this.y == y && this.z == z;
	}

	inline public function multiplyInPlace(otherVector:Vector3) {
		this.x *= otherVector.x;
		this.y *= otherVector.y;
		this.z *= otherVector.z;
	}

	inline public function multiply(otherVector:Vector3):Vector3 {
		return new Vector3(this.x * otherVector.x, this.y * otherVector.y, this.z * otherVector.z);
	}

	inline public function multiplyToRef(otherVector:Vector3, result:Vector3) {
		result.x = this.x * otherVector.x;
		result.y = this.y * otherVector.y;
		result.z = this.z * otherVector.z;
	}

	public function multiplyByFloats(x:Float, y:Float, z:Float):Vector3 {
		return new Vector3(this.x * x, this.y * y, this.z * z);
	}

	inline public function divide(otherVector:Vector3):Vector3 {
		return new Vector3(this.x / otherVector.x, this.y / otherVector.y, this.z / otherVector.z);
	}

	inline public function divideToRef(otherVector:Vector3, result:Vector3) {
		result.x = this.x / otherVector.x;
		result.y = this.y / otherVector.y;
		result.z = this.z / otherVector.z;
	}

	inline public function MinimizeInPlace(other:Vector3) {
		if (other.x < this.x) this.x = other.x;
		if (other.y < this.y) this.y = other.y;
		if (other.z < this.z) this.z = other.z;
	}

	inline public function MaximizeInPlace(other:Vector3) {
		if (other.x > this.x) this.x = other.x;
		if (other.y > this.y) this.y = other.y;
		if (other.z > this.z) this.z = other.z;
	}

	// Properties
	inline public function length():Float {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}

	inline public function lengthSquared():Float {
		return (this.x * this.x + this.y * this.y + this.z * this.z);
	}

	// Methods
	public function normalize():Vector3 {
		var len = this.length();
		
		if (len == 0) {
			return this;
		}
		
		var num = 1.0 / len;
		
		this.x *= num;
		this.y *= num;
		this.z *= num;
		
		return this;
	}

	inline public function clone():Vector3 {
		return new Vector3(this.x, this.y, this.z);
	}

	inline public function copyFrom(source:Vector3) {
		this.x = source.x;
		this.y = source.y;
		this.z = source.z;
	}

	inline public function copyFromFloats(x:Float, y:Float, z:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	// Statics
	inline public static function GetClipFactor(vector0:Vector3, vector1:Vector3, axis:Vector3, size:Float):Float {
        var d0 = Vector3.Dot(vector0, axis) - size;
        var d1 = Vector3.Dot(vector1, axis) - size;
		
        var s = d0 / (d0 - d1);
		
        return s;
    }
	
	inline public static function FromArray(array:Array<Float>, offset:Int = 0):Vector3 {
		return new Vector3(array[offset], array[offset + 1], array[offset + 2]);
	}

	inline public static function FromArrayToRef(array:Array<Float>, offset:Int, result:Vector3) {
		result.x = array[offset];
		result.y = array[offset + 1];
		result.z = array[offset + 2];
	}

	inline public static function FromFloatArrayToRef(array:Array<Float> , offset:Int, result:Vector3) {
		result.x = array[offset];
		result.y = array[offset + 1];
		result.z = array[offset + 2];
	}

	inline public static function FromFloatsToRef(x:Float, y:Float, z:Float, result:Vector3) {
		result.x = x;
		result.y = y;
		result.z = z;
	}

	inline public static function Zero():Vector3 {
		return new Vector3(0, 0, 0);
	}

	inline public static function Up():Vector3 {
		return new Vector3(0, 1.0, 0);
	}

	inline public static function TransformCoordinates(vector:Vector3, transformation:Matrix):Vector3 {
		var result = Vector3.Zero();
		
		Vector3.TransformCoordinatesToRef(vector, transformation, result);
		
		return result;
	}

	inline public static function TransformCoordinatesToRef(vector:Vector3, transformation:Matrix, result:Vector3) 
	{
		var x = (vector.x * transformation.m11) + (vector.y * transformation.m21) + (vector.z * transformation.m31) + transformation.m41;
		var y = (vector.x * transformation.m12) + (vector.y * transformation.m22) + (vector.z * transformation.m32) + transformation.m42;
		var z = (vector.x * transformation.m13) + (vector.y * transformation.m23) + (vector.z * transformation.m33) + transformation.m43;
		var w = (vector.x * transformation.m14) + (vector.y * transformation.m24) + (vector.z * transformation.m34) + transformation.m44;
		
		result.x = x / w;
		result.y = y / w;
		result.z = z / w;
	}

	inline public static function TransformCoordinatesFromFloatsToRef(x:Float, y:Float, z:Float, transformation:Matrix, result:Vector3) {
		var rx = (x * transformation.m11) + (y * transformation.m21) + (z * transformation.m31) + transformation.m41;
		var ry = (x * transformation.m12) + (y * transformation.m22) + (z * transformation.m32) + transformation.m42;
		var rz = (x * transformation.m13) + (y * transformation.m23) + (z * transformation.m33) + transformation.m43;
		var rw = (x * transformation.m14) + (y * transformation.m24) + (z * transformation.m34) + transformation.m44;
		
		result.x = rx / rw;
		result.y = ry / rw;
		result.z = rz / rw;
	}

	inline public static function TransformNormal(vector:Vector3, transformation:Matrix):Vector3 {
		var result = Vector3.Zero();
		
		Vector3.TransformNormalToRef(vector, transformation, result);
		
		return result;
	}

	 inline public static function TransformByQuaternion(value:Vector3, rotation: Quaternion):Vector3
	   {
            var x:Float = 2 * (rotation.y * value.z - rotation.z * value.y);
            var y:Float = 2 * (rotation.z * value.x - rotation.x * value.z);
            var z:Float = 2 * (rotation.x * value.y - rotation.y * value.x);

			var result:Vector3 = new Vector3();
            result.x = value.x + x * rotation.w + (rotation.y * z - rotation.z * y);
            result.y = value.y + y * rotation.w + (rotation.z * x - rotation.x * z);
            result.z = value.z + z * rotation.w + (rotation.x * y - rotation.y * x);
			return result;
        }
	inline public static function TransformNormalToRef(vector:Vector3, transformation:Matrix, result:Vector3) {
		result.x = (vector.x * transformation.m11) + (vector.y * transformation.m21) + (vector.z * transformation.m31);
		result.y = (vector.x * transformation.m12) + (vector.y * transformation.m22) + (vector.z * transformation.m32);
		result.z = (vector.x * transformation.m13) + (vector.y * transformation.m23) + (vector.z * transformation.m33);
	}

	inline public static function TransformNormalFromFloatsToRef(x:Float, y:Float, z:Float, transformation:Matrix, result:Vector3) {
		result.x = (x * transformation.m11) + (y * transformation.m21) + (z * transformation.m31);
		result.y = (x * transformation.m12) + (y * transformation.m22) + (z * transformation.m32);
		result.z = (x * transformation.m13) + (y * transformation.m23) + (z * transformation.m33);
	}

	inline public static function CatmullRom(value1:Vector3, value2:Vector3, value3:Vector3, value4:Vector3, amount:Float):Vector3 {
		var squared = amount * amount;
		var cubed = amount * squared;
		
		var x = 0.5 * ((((2.0 * value2.x) + ((-value1.x + value3.x) * amount)) +
			(((((2.0 * value1.x) - (5.0 * value2.x)) + (4.0 * value3.x)) - value4.x) * squared)) +
			(((( -value1.x + (3.0 * value2.x)) - (3.0 * value3.x)) + value4.x) * cubed));
			
		var y = 0.5 * ((((2.0 * value2.y) + ((-value1.y + value3.y) * amount)) +
			(((((2.0 * value1.y) - (5.0 * value2.y)) + (4.0 * value3.y)) - value4.y) * squared)) +
			(((( -value1.y + (3.0 * value2.y)) - (3.0 * value3.y)) + value4.y) * cubed));
			
		var z = 0.5 * ((((2.0 * value2.z) + ((-value1.z + value3.z) * amount)) +
			(((((2.0 * value1.z) - (5.0 * value2.z)) + (4.0 * value3.z)) - value4.z) * squared)) +
			(((( -value1.z + (3.0 * value2.z)) - (3.0 * value3.z)) + value4.z) * cubed));
			
		return new Vector3(x, y, z);
	}

	inline public static function Clamp(value:Vector3, min:Vector3, max:Vector3):Vector3 {
		var x = value.x;
		x = (x > max.x) ? max.x : x;
		x = (x < min.x) ? min.x : x;
		
		var y = value.y;
		y = (y > max.y) ? max.y : y;
		y = (y < min.y) ? min.y : y;
		
		var z = value.z;
		z = (z > max.z) ? max.z : z;
		z = (z < min.z) ? min.z : z;
		
		return new Vector3(x, y, z);
	}

	inline public static function Hermite(value1:Vector3, tangent1:Vector3, value2:Vector3, tangent2:Vector3, amount:Float):Vector3 {
		var squared = amount * amount;
		var cubed = amount * squared;
		var part1 = ((2.0 * cubed) - (3.0 * squared)) + 1.0;
		var part2 = (-2.0 * cubed) + (3.0 * squared);
		var part3 = (cubed - (2.0 * squared)) + amount;
		var part4 = cubed - squared;
		
		var x = (((value1.x * part1) + (value2.x * part2)) + (tangent1.x * part3)) + (tangent2.x * part4);
		var y = (((value1.y * part1) + (value2.y * part2)) + (tangent1.y * part3)) + (tangent2.y * part4);
		var z = (((value1.z * part1) + (value2.z * part2)) + (tangent1.z * part3)) + (tangent2.z * part4);
		
		return new Vector3(x, y, z);
	}
	
	 public  function lerp(start:Vector3, end:Vector3, amount:Float):Void 
	 {
		 x = start.x + ((end.x - start.x) * amount);
		 y = start.y + ((end.y - start.y) * amount);
		 z = start.z + ((end.z - start.z) * amount);
		
		
	}
	inline public  function getHorizontalAngle(angle:Vector3):Vector3
	{
			if (angle == null)
			{
				angle = Vector3.Zero();
			}
			

			angle.y = ((Math.atan2(x, z) * Util.Rad2Deg));

			if (angle.y < 0.0)
				angle.y += 360.0;
			if (angle.y >= 360.0)
				angle.y -= 360.0;

			var z1:Float = Math.sqrt(x*x + z*z);

			angle.x = (Math.atan2(z1, y) *Util.Rad2Deg - 90.0);

			if (angle.x < 0.0)
				angle.x += 360.0;
			if (angle.x >= 360.0)
				angle.x -= 360.0;

			return angle;
		}
	inline public  function rotateXYBy(degrees:Float, center:Vector3):Void
	{
		degrees *= Util.Deg2Rad;
		var cs:Float = Math.cos(degrees);
		var sn:Float = Math.sin(degrees);
		x -= center.x;
		y -= center.y;
		set((x * cs - y * sn), (x * sn +y * cs), z);
		x += center.x;
		y += center.y;	
		
	}
	inline public  function rotateXZBy(degrees:Float, center:Vector3):Void
	{
		degrees *= Util.Deg2Rad;
		var cs:Float = Math.cos(degrees);
		var sn:Float = Math.sin(degrees);
		x -= center.x;
		z -= center.z;
		set((x * cs - z * sn),y, (x * sn + z * cs));
		x += center.x;
		z += center.z;	
		
	}
	inline public  function rotateYZBy(degrees:Float, center:Vector3):Void
	{
		degrees *= Util.Deg2Rad;
		var cs:Float = Math.cos(degrees);
		var sn:Float = Math.sin(degrees);
		z -= center.z;
		y -= center.y;
		set(x,(y * cs - z * sn), (y * sn + z * cs));
		z += center.z;
		y += center.y;	
		
	}

	inline public  function Mul(r:Vector3):Vector3
	{
		return new Vector3(x * r.x, y * r.y, z * r.z);
	}
	inline public  function Mulf(r:Float):Vector3
	{
		return new Vector3(x * r, y * r, z * r);
	}
	inline public  function Rotate(axis:Vector3,angle:Float):Vector3
	{
		
		var sinAngle:Float = Math.cos(-angle);
		var cosAngle:Float = Math.sin(-angle);
		
		return 
		this.cross(axis.Mulf(sinAngle).add(  //x
		this.Mulf(cosAngle).add(             //z
		axis.Mulf(this.dot(axis.Mulf(1 - cosAngle)))))); //z
		
	}
	inline public  function RotateQuat(rotation:Quaternion):Vector3
	{
		
	var conjugate:Quaternion = rotation.Conjugate();
	var w:Quaternion = rotation.MulV3(this).multiply(conjugate);
	return new Vector3(w.x, w.y, w.z);
	
		
	}
	inline public static function Lerp(start:Vector3, end:Vector3, amount:Float):Vector3 {
		var x = start.x + ((end.x - start.x) * amount);
		var y = start.y + ((end.y - start.y) * amount);
		var z = start.z + ((end.z - start.z) * amount);
		
		return new Vector3(x, y, z);
	}

	inline public  function dot( right:Vector3):Float
	{
		return (x * right.x + y * right.y + z * right.z);
	}

	inline public static function Dot(left:Vector3, right:Vector3):Float
	{
		return (left.x * right.x + left.y * right.y + left.z * right.z);
	}

	inline public  function cross( right:Vector3):Vector3 
	{
		var result:Vector3 = Vector3.Zero();
		result.x = y * right.z - z * right.y;
		result.y = z * right.x - x * right.z;
		result.z = x * right.y - y * right.x;
		return result;
	}
	
	inline public static function Cross(left:Vector3, right:Vector3):Vector3 {
		var result = Vector3.Zero();
		Vector3.CrossToRef(left, right, result);
		return result;
	}

	inline public static function CrossToRef(left:Vector3, right:Vector3, result:Vector3) {
		result.x = left.y * right.z - left.z * right.y;
		result.y = left.z * right.x - left.x * right.z;
		result.z = left.x * right.y - left.y * right.x;
	}

	inline public static function Normalize(vector:Vector3):Vector3 {
		var result = Vector3.Zero();
		Vector3.NormalizeToRef(vector, result);
		return result;
	}
	inline public static function Subtract(a:Vector3, b:Vector3):Vector3 
	{
     return new Vector3(a.x - b.x, a.y - b.y, a.z - b.z);
	}
    inline public static function Scale(a:Vector3, b:Vector3):Vector3 
	{
     return new Vector3(a.x * b.x, a.y * b.y, a.z * b.z);
	}

	inline public static function NormalizeToRef(vector:Vector3, result:Vector3) {
		result.copyFrom(vector);
		result.normalize();
	}

	inline public static function Project(vector:Vector3, world:Matrix, transform:Matrix, viewport:Rectangle):Vector3 {
		var cw = viewport.width;
		var ch = viewport.height;
		var cx = viewport.x;
		var cy = viewport.y;
		
		var viewportMatrix = Matrix.FromValues(
			cw / 2.0, 0, 0, 0,
			0, -ch / 2.0, 0, 0,
			0, 0, 1, 0,
			cx + cw / 2.0, ch / 2.0 + cy, 0, 1);
			
		var finalMatrix = world.multiply(transform).multiply(viewportMatrix);
		
		return Vector3.TransformCoordinates(vector, finalMatrix);
	}

	inline public static function Unproject(source:Vector3, viewportWidth:Float, viewportHeight:Float, world:Matrix, view:Matrix, projection:Matrix):Vector3 {
		var matrix = world.multiply(view).multiply(projection);
		matrix.invert();
		source.x = source.x / viewportWidth * 2 - 1;
		source.y = -(source.y / viewportHeight * 2 - 1);
		var vector = Vector3.TransformCoordinates(source, matrix);
		var num = source.x * matrix.m14 + source.y * matrix.m24 + source.z * matrix.m34 + matrix.m44;
		
		if (Util.WithinEpsilon(num, 1.0)) {
			vector = vector.scale(1.0 / num);
		}
		
		return vector;
	}

	inline public static function Minimize(left:Vector3, right:Vector3):Vector3 {
		var min = left.clone();
		min.MinimizeInPlace(right);
		return min;
	}

	inline public static function Maximize(left:Vector3, right:Vector3):Vector3 {
		var max = left.clone();
		max.MaximizeInPlace(right);
		return max;
	}

	inline public static function Distance(value1:Vector3, value2:Vector3):Float {
		return Math.sqrt(Vector3.DistanceSquared(value1, value2));
	}

	inline public static function DistanceSquared(value1:Vector3, value2:Vector3):Float {
		var x = value1.x - value2.x;
		var y = value1.y - value2.y;
		var z = value1.z - value2.z;
		
		return (x * x) + (y * y) + (z * z);
	}

	inline public  function getDistanceFromSQ( value2:Vector3):Float {
		var ax = x - value2.x;
		var ay = y - value2.y;
		var az = z - value2.z;
		
		return (ax *ax) + (ay * ay) + (az * az);
	}
	inline public static function Center(value1:Vector3, value2:Vector3):Vector3 {
		var center = value1.add(value2);
		center.scaleInPlace(0.5);
		return center;
	}
	
public static function TriangleNormal(vPolygon1:Vector3,vPolygon2:Vector3,vPolygon3:Vector3):Vector3					
{
	var a:Vector3 = Vector3.Sub(vPolygon3 , vPolygon1);
	var b:Vector3 = Vector3.Sub(vPolygon2 , vPolygon1);
	var vNormal:Vector3 = Vector3.Cross(a, b);		
    vNormal = Vector3.Normalize(vNormal);	
	return vNormal;						
	
}
}
