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
class Vector2 {
	
	public var x:Float;
	public var y:Float;
	
	
	public function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	inline public function set(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	
	}
	public function toString():String {
		return "{X:" + this.x + " Y:" + this.y + "}";
	}

	// Operators
	public function toArray(array:Array<Float>, index:Int = 0):Vector2 {
		array[index] = this.x;
		array[index + 1] = this.y;
		
		return this;
	}

	public function asArray():Array<Float> {
		var result:Array<Float> = [];
		
		this.toArray(result, 0);
		
		return result;
	}

	inline public function copyFrom(source:Vector2):Vector2 {
		this.x = source.x;
		this.y = source.y;
		
		return this;
	}

	inline public function copyFromFloats(x:Float, y:Float):Vector2 {
		this.x = x;
		this.y = y;
		
		return this;
	}

	inline public function add(otherVector:Vector2):Vector2 {
		return new Vector2(this.x + otherVector.x, this.y + otherVector.y);
	}

	inline public function addVector3(otherVector:Vector3):Vector2 {
		return new Vector2(this.x + otherVector.x, this.y + otherVector.y);
	}

	inline public function subtract(otherVector:Vector2):Vector2 {
		return new Vector2(this.x - otherVector.x, this.y - otherVector.y);
	}

	inline public function subtractInPlace(otherVector:Vector2):Vector2 {
		this.x -= otherVector.x;
		this.y -= otherVector.y;
		
		return this;
	}

	inline public function multiplyInPlace(otherVector:Vector2):Vector2 {
		this.x *= otherVector.x;
		this.y *= otherVector.y;
		
		return this;
	}

	inline public function multiply(otherVector:Vector2):Vector2 {
		return new Vector2(this.x * otherVector.x, this.y * otherVector.y);
	}

	inline public function multiplyToRef(otherVector:Vector2, result:Vector2):Vector2 {
		result.x = this.x * otherVector.x;
		result.y = this.y * otherVector.y;
		
		return this;
	}

	inline public function multiplyByFloats(x:Float, y:Float):Vector2 {
		return new Vector2(this.x * x, this.y * y);
	}

	inline public function divide(otherVector:Vector2):Vector2 {
		return new Vector2(this.x / otherVector.x, this.y / otherVector.y);
	}

	inline public function divideToRef(otherVector:Vector2, result:Vector2):Vector2 {
		result.x = this.x / otherVector.x;
		result.y = this.y / otherVector.y;
		
		return this;
	}

	inline public function negate():Vector2 {
		return new Vector2(-this.x, -this.y);
	}

	inline public function scaleInPlace(scale:Float):Vector2 {
		this.x *= scale;
		this.y *= scale;
		
		return this;
	}

	inline public function scale(scale:Float):Vector2 {
		return new Vector2(this.x * scale, this.y * scale);
	}

	inline public function equals(otherVector:Vector2):Bool {
		return otherVector != null && this.x == otherVector.x && this.y == otherVector.y;
	}
	
	inline public function equalsWithEpsilon(otherVector:Vector2, epsilon:Float = Util.Epsilon):Bool {
		return otherVector != null && Util.WithinEpsilon(this.x, otherVector.x, epsilon) && Util.WithinEpsilon(this.y, otherVector.y, epsilon);
	}

	// Properties
	inline public function length():Float {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}

	inline public function lengthSquared():Float {
		return (this.x * this.x + this.y * this.y);
	}

	// Methods
	public function normalize():Vector2 {
		var len = this.length();
		
		if (len == 0) {
			return this;
		}
		
		var num = 1.0 / len;
		
		this.x *= num;
		this.y *= num;
		
		return this;
	}

	inline public function clone():Vector2 {
		return new Vector2(this.x, this.y);
	}

	// Statics
	inline public static function Zero():Vector2 {
		return new Vector2(0, 0);
	}

	inline public static function FromArray(array:Array<Float>, offset:Int = 0):Vector2 {
		return new Vector2(array[offset], array[offset + 1]);
	}

	inline public static function FromArrayToRef(array:Array<Float>, offset:Int, result:Vector2):Vector2 {
		result.x = array[offset];
		result.y = array[offset + 1];
		
		return result;
	}

	inline public static function CatmullRom(value1:Vector2, value2:Vector2, value3:Vector2, value4:Vector2, amount:Float):Vector2 {
		var squared = amount * amount;
		var cubed = amount * squared;
		
		var x = 0.5 * ((((2.0 * value2.x) + ((-value1.x + value3.x) * amount)) +
			(((((2.0 * value1.x) - (5.0 * value2.x)) + (4.0 * value3.x)) - value4.x) * squared)) +
			(((( -value1.x + (3.0 * value2.x)) - (3.0 * value3.x)) + value4.x) * cubed));
			
		var y = 0.5 * ((((2.0 * value2.y) + ((-value1.y + value3.y) * amount)) +
			(((((2.0 * value1.y) - (5.0 * value2.y)) + (4.0 * value3.y)) - value4.y) * squared)) +
			(((( -value1.y + (3.0 * value2.y)) - (3.0 * value3.y)) + value4.y) * cubed));
			
		return new Vector2(x, y);
	}

	inline public static function Clamp(value:Vector2, min:Vector2, max:Vector2):Vector2 {
		var x = value.x;
		x = (x > max.x) ? max.x : x;
		x = (x < min.x) ? min.x : x;
		
		var y = value.y;
		y = (y > max.y) ? max.y : y;
		y = (y < min.y) ? min.y : y;
		
		return new Vector2(x, y);
	}

	inline public static function Hermite(value1:Vector2, tangent1:Vector2, value2:Vector2, tangent2:Vector2, amount:Float):Vector2 {
		var squared = amount * amount;
		var cubed = amount * squared;
		var part1 = ((2.0 * cubed) - (3.0 * squared)) + 1.0;
		var part2 = (-2.0 * cubed) + (3.0 * squared);
		var part3 = (cubed - (2.0 * squared)) + amount;
		var part4 = cubed - squared;

		var x = (((value1.x * part1) + (value2.x * part2)) + (tangent1.x * part3)) + (tangent2.x * part4);
		var y = (((value1.y * part1) + (value2.y * part2)) + (tangent1.y * part3)) + (tangent2.y * part4);
		
		return new Vector2(x, y);
	}

	inline public static function Lerp(start:Vector2, end:Vector2, amount:Float):Vector2 {
		var x = start.x + ((end.x - start.x) * amount);
		var y = start.y + ((end.y - start.y) * amount);
		
		return new Vector2(x, y);
	}

	inline public static function Dot(left:Vector2, right:Vector2):Float {
		return left.x * right.x + left.y * right.y;
	}

	inline public static function Normalize(vector:Vector2):Vector2 {
		var newVector = vector.clone();
		newVector.normalize();
		return newVector;
	}

	inline public static function Minimize(left:Vector2, right:Vector2):Vector2 {
		var x = (left.x < right.x) ? left.x :right.x;
		var y = (left.y < right.y) ? left.y :right.y;
		
		return new Vector2(x, y);
	}

	inline public static function Maximize(left:Vector2, right:Vector2):Vector2 {
		var x = (left.x > right.x) ? left.x :right.x;
		var y = (left.y > right.y) ? left.y :right.y;
		
		return new Vector2(x, y);
	}

	inline public static function Transform(vector:Vector2, transformation:Matrix):Vector2 {
		var x = (vector.x * transformation.m11) + (vector.y * transformation.m21);
		var y = (vector.x * transformation.m12) + (vector.y * transformation.m22);
		
		return new Vector2(x, y);
	}

	inline public static function Distance(value1:Vector2, value2:Vector2):Float {
		return Math.sqrt(Vector2.DistanceSquared(value1, value2));
	}

	inline public static function DistanceSquared(value1:Vector2, value2:Vector2):Float {
		var x = value1.x - value2.x;
		var y = value1.y - value2.y;
		
		return (x * x) + (y * y);
	}
	
}
	