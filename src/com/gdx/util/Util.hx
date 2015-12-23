package com.gdx.util;

import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import lime.Assets;
import lime.graphics.Image;
import lime.math.Matrix4;
import lime.math.Matrix3;

import com.gdx.util.ByteArray;

#if (neko)
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
#end

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

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Util
{
	public static inline var Epsilon:Float = 0.001;
	public static var CollisionsEpsilon:Float = 0.001;
	public static inline var E = 2.718281828459045;
    public static inline var LN2 = 0.6931471805599453;
    public static inline var LN10 = 2.302585092994046;
    public static inline var LOG2E = 1.4426950408889634;
    public static inline var LOG10E = 0.43429448190325176;
    public static inline var PI = 3.141592653589793;
    public static inline var SQRT1_2 = 0.7071067811865476;
    public static inline var SQRT2 = 1.4142135623730951;
	public static inline var dtor = 0.0174532925199432957692369076848861;
	public static inline var rtod=1/dtor;
	
	
	public static  var DEG:Float = -180 / Math.PI;
    public static  var  RAD:Float = Math.PI / -180;
    public static  var Rad2Deg 			= 180.0 / PI;
 	public static  var Deg2Rad 			= PI / 180.0;

	public function new() 
	{
		
	}
	
private static inline	function degTorad(degrees:Float):Float
{
	 var M_PI:Float =3.14159265358979323846;
     var DEG_CIRCLE:Float =360;
     var DEG_TO_RAD:Float= (M_PI / (DEG_CIRCLE / 2));
    return degrees * DEG_TO_RAD;
 
}
private static inline	function radTodeg(degrees:Float):Float
{
	 var M_PI:Float =3.14159265358979323846;
     var DEG_CIRCLE:Float =360;
     var RAD_TO_DEG:Float = ((DEG_CIRCLE / 2) / M_PI);
	 return degrees * RAD_TO_DEG;
 
}	
	public static inline function randf(max:Float, min:Float ):Float
{	
     return Math.random() * (max - min) + min;
}
public static inline function randi(max:Int, min:Int ):Int
{
	return Std.int(Math.random() * (max - min) + min);
     
}
public static inline function deg2rad(deg:Float):Float
    {
        return deg / 180.0 * Math.PI;   
    }
public static inline function rad2deg(rad:Float):Float
    {
        return rad / Math.PI * 180.0;            
    }
	
	public static inline function atan2deg(val:Float,val2:Float):Float
    {
        return radTodeg(Math.atan2(val, val2));        
    }
	
public static inline function ToRadians(deg:Float):Float
    {
        return (deg * 0.017453292519943295769236907684886);
    }
public static inline function ToDegrees(rad:Float):Float
    {
        return (rad * 57.295779513082320876798154814105);  
    }
	
public static inline	function cosdeg(degrees:Float):Float
{
	return  Math.cos(degTorad(degrees));  
}

public static inline function sindeg( degrees:Float):Float
{
	return return  Math.sin(degTorad(degrees));
}
inline static public function CurveValue(newvalue:Float, oldvalue:Float, increments:Float):Float
{
if (increments>1.0)  oldvalue=oldvalue-(oldvalue-newvalue)/increments;
if (increments <= 1.0) oldvalue = newvalue;

return oldvalue;
}
public static inline function scale(value:Float, min:Float, max:Float, min2:Float, max2:Float):Float
	{
		return min2 + ((value - min) / (max - min)) * (max2 - min2);
	}
public static inline function fMod(n:Float, d:Float):Float	
{
	var i:Int = Math.round(n / d);
	return n - d * i;
}
	

		public static function iclamp(value:Int, min:Int, max:Int):Int
	{
		if (max > min)
		{
			if (value < min) return min;
			else if (value > max) return max;
			else return value;
		}
		else
		{
			// Min/max swapped
			if (value < max) return max;
			else if (value > min) return min;
			else return value;
		}
	}
	public static function percentage(  value:Float,  min:Float,  max:Float ):Float
    {
     value = Util.clamp( value, min, max );
    return ( value - min ) / ( max - min );
    }
	public static function clamp(value:Float, min:Float, max:Float):Float
	{
		if (max > min)
		{
			if (value < min) return min;
			else if (value > max) return max;
			else return value;
		}
		else
		{
			// Min/max swapped
			if (value < max) return max;
			else if (value > min) return min;
			else return value;
		}
	}
	
		

	inline public static function Lerp(start:Float, end:Float, amount:Float):Float {
		return  start + ((end - start) * amount);
		
		
	}
	inline public static function Hermite( value1:Float,  tangent1:Float, value2:Float,  tangent2:Float, amount:Float):Float
        {
            // All transformed to double not to lose precission
            // Otherwise, for high numbers of param:amount the result is NaN instead of Infinity
            var v1 = value1, v2 = value2, t1 = tangent1, t2 = tangent2, s = amount, result:Float;
            var sCubed = s * s * s;
            var sSquared = s * s;

            if (amount == 0)
                result = value1;
            else if (amount == 1)
                result = value2;
            else
                result = (2 * v1 - 2 * v2 + t2 + t1) * sCubed +
                    (3 * v2 - 3 * v1 - 2 * t1 - t2) * sSquared +
                    t1 * s +
                    v1;
            return result;
        }


	// Misc. 
	inline public static function Clamp(value:Float, min:Float = 0, max:Float = 1):Float {
		return Math.min(max, Math.max(min, value));
	}  
	
	inline public static function Clamp2(x:Float, a:Float, b:Float):Float {
		return (x < a) ? a : ((x > b) ? b : x);
	}
	inline public static function wrapAngle(angle:Float):Float
	{
		angle %= 360;
		if (angle <= -180) {
			return angle + 360;
		} else if (angle > 180) {
			return angle - 360;
		} else {
			return angle;
		}
	}

	
	// Returns -1 when value is a negative number and
	// +1 when value is a positive number. 
	inline public static function Sign(value:Dynamic):Int {
		if (value == 0) {
			return 0;
		}
			
		return value > 0 ? 1 : -1;
	}

	public static function Format(value:Float, decimals:Int = 2):String {
		value = Math.round(value * Math.pow(10, decimals));
		var str = '' + value;
		var len = str.length;
		if(len <= decimals){
			while(len < decimals){
				str = '0' + str;
				len++;
			}
			return (decimals == 0 ? '' : '0.') + str;
		}
		else{
			return str.substr(0, str.length - decimals) + (decimals == 0 ? '' : '.') + str.substr(str.length - decimals);
		}
	}
	
	public static function getAngleWeight(v1:Vector3, v2:Vector3,v3:Vector3):Vector3 {

	// Calculate this triangle's weight for each of its three vertices
	// start by calculating the lengths of its sides
	var a = v2.getDistanceFromSQ(v3);
	var asqrt = Math.sqrt(a);
	var b = v1.getDistanceFromSQ(v3);
	var bsqrt = Math.sqrt(b);
	var c = v1.getDistanceFromSQ(v2);
	var csqrt = Math.sqrt(c);

	// use them to find the angle at each vertex
	return new Vector3(
		Math.acos((b + c - a) / (2.0 * bsqrt * csqrt)),
		Math.acos((-b + c + a) / (2.0 * asqrt * csqrt)),
		Math.acos((b - c + a) / (2.0 * bsqrt * asqrt)));
}


public static function calculateTangents(normal:Vector3, tangent:Vector3, binormal:Vector3,
vt1:Vector3, vt2:Vector3, vt3:Vector3,
tc1:Vector2, tc2:Vector2, tc3:Vector2):Void 
{
		
    var v1:Vector3 = Vector3.Sub(vt1 , vt2);
	var v2:Vector3 = Vector3.Sub(vt3 , vt1);
	normal = v2.cross(v1);
	normal.normalize();

	// binormal

	var deltaX1 = tc1.x - tc2.x;
	var deltaX2 = tc3.x - tc1.x;
	binormal.x = (v1.x * deltaX2) - (v2.x * deltaX1);
	binormal.y = (v1.y * deltaX2) - (v2.y * deltaX1);
	binormal.z = (v1.z * deltaX2) - (v2.z * deltaX1);
	binormal.normalize();

	// tangent

	var deltaY1 = tc1.y - tc2.y;
	var deltaY2 = tc3.y - tc1.y;
	tangent.x = (v1.x * deltaY2) - (v2.x * deltaY1);
	tangent.y = (v1.y * deltaY2) - (v2.y * deltaY1);
	tangent.z = (v1.z * deltaY2) - (v2.z * deltaY1);
	tangent.normalize();

	// adjust

	var txb = tangent.cross(binormal);
	if (txb.dot(normal) < 0.0)
	{
		
		tangent.x *= -1.0;
		tangent.y *= -1.0;
		tangent.z *= -1.0;
		
		binormal.x *= -1.0;
		binormal.y *= -1.0;
		binormal.z *= -1.0;
		
	}
	
}


inline public static function CheckExtends(v:Vector3, min:Vector3, max:Vector3) {
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

	inline public static function WithinEpsilon(a:Float, b:Float, epsilon:Float = 1.401298E-45):Bool {
		var num = a - b;
		return -epsilon <= num && num <= epsilon;
	}

	public static inline function getRed(color:Int):Int
	{
		return color >> 16 & 0xFF;
	}


	public static inline function getGreen(color:Int):Int
	{
		return color >> 8 & 0xFF;
	}

	public static inline function getBlue(color:Int):Int
	{
		return color & 0xFF;
	}
	
public static inline function ComputeNormal(positions:Array<Float>, normals:Array<Float>, indices:Array<Int>) 
  {
		var positionVectors:Array<Vector3> = [];
        var facesOfVertices:Array<Array<Int>> = [];
		
        var index:Int = 0;

		while (index < positions.length) 
		{
            var vector3 = new Vector3(positions[index], positions[index + 1], positions[index + 2]);
            positionVectors.push(vector3);
            facesOfVertices.push([]);
			index += 3;
        }
		
        // Compute normals
        var facesNormals:Array<Vector3> = [];
        for (index in 0...Std.int(indices.length / 3)) {
            var i1 = indices[index * 3];
            var i2 = indices[index * 3 + 1];
            var i3 = indices[index * 3 + 2];

            var p1 = positionVectors[i1];
            var p2 = positionVectors[i2];
            var p3 = positionVectors[i3];

            var p1p2 = p1.subtract(p2);
            var p3p2 = p3.subtract(p2);

            facesNormals[index] = Vector3.Normalize(Vector3.Cross(p1p2, p3p2));
            facesOfVertices[i1].push(index);
            facesOfVertices[i2].push(index);
            facesOfVertices[i3].push(index);
        }

        for (index in 0...positionVectors.length) 
		{
            var faces:Array<Int> = facesOfVertices[index];

            var normal:Vector3 = Vector3.Zero();
            for (faceIndex in 0...faces.length) 
			{
                normal.addInPlace(facesNormals[faces[faceIndex]]);
            }

            normal = Vector3.Normalize(normal.scale(1.0 / faces.length));

            normals[index * 3] = normal.x;
            normals[index * 3 + 1] = normal.y;
            normals[index * 3 + 2] = normal.z;
        }
	}
	
	        
public static inline function normalizeAngle(angle:Float):Float
        {
            // move into range [-180 deg, +180 deg]
            while (angle < -Math.PI) angle += Math.PI * 2.0;
            while (angle >  Math.PI) angle -= Math.PI * 2.0;
            return angle;
        }
	public static function AngleBetweenVectors( V1:Vector3,  V2:Vector3):Float
    {							
	var dotProduct:Float = Vector3.Dot(V1, V2);
	var vectorsMagnitude:Float = V1.length() *  V2.length() ;

	// Get the angle in radians between the 2 vectors
	var angle:Float = Math.acos( dotProduct / vectorsMagnitude );

	// Here we make sure that the angle is not a -1.#IND0000000 number, which means indefinate
	if (Math.isNaN(angle)) return 0;

	
	// Return the angle in radians
	return angle ;
}

public static function removeIntDuplicate(arr:Array<Int>) : Void
{
    var i:Int;
    var j: Int;
    for (i in 0... arr.length - 1)
	{
        for (j in i + 1 ... arr.length)
		{
            if (arr[i] == arr[j])
			{
                arr.splice(j, 1);
            }
        }
    }
}

public static function VNormalize( V:Vector3):Vector3
{
	var v:Float = V.length();
	if (v == 0) return Vector3.Zero();
	return new Vector3(V.x / v, V.y / v, V.z / v);
}

public static function VAdd( V1:Vector3,  V2:Vector3):Vector3
{
	return new Vector3(V1.x + V2.x, V1.y + V2.y, V1.z + V2.z);
}
public static function VSubtract( V1:Vector3,  V2:Vector3):Vector3
{
	return new Vector3(V1.x - V2.x, V1.y - V2.y, V1.z - V2.z);
}
public static function VScale( V1:Vector3,  s:Float):Vector3
{
	return new Vector3(V1.x *s, V1.y *s, V1.z *s);
}
	public static inline function getColorRGB(R:Int = 0, G:Int = 0, B:Int = 0):Int
	{
		return R << 16 | G << 8 | B;
	}
		public static inline function getColorRGBA(R:Int = 0, G:Int = 0, B:Int = 0,A:Int=0):Int
	{
		return A << 24 | R << 16 | G << 8 | B;
		/*
		if (format == ARGB32) {
			
			r = (color >> 16) & 0xFF;
			g = (color >> 8) & 0xFF;
			b = color & 0xFF;
			a = (image.transparent) ? (color >> 24) & 0xFF : 0xFF;
			
		} else {
			
			r = (color >> 24) & 0xFF;
			g = (color >> 16) & 0xFF;
			b = (color >> 8) & 0xFF;
			a = (image.transparent) ? color & 0xFF : 0xFF;
			
		}
		*/
	}
	public static inline function getColorARGB(A:Int=0,R:Int = 0, G:Int = 0, B:Int = 0):Int
	{
		return  R << 24 | G << 16 | B <<8 | A;
		/*
		if (format == ARGB32) {
			
			r = (color >> 16) & 0xFF;
			g = (color >> 8) & 0xFF;
			b = color & 0xFF;
			a = (image.transparent) ? (color >> 24) & 0xFF : 0xFF;
			
		} else {
			
			r = (color >> 24) & 0xFF;
			g = (color >> 16) & 0xFF;
			b = (color >> 8) & 0xFF;
			a = (image.transparent) ? color & 0xFF : 0xFF;
			
		}
		*/
	}
public static function saveBytesToFile(fname:String, bytes:ByteArray):Void
{
	#if neko
	
//	var file = File.write(fname, true);
	//file.writeString(bytes.toString());
//	file.close();
	
	#end
}

public static inline function saveImageToFile(data:Image,filename:String)
{
	
#if neko

 // var b:ByteArray = data.encode("png");
//  var f:FileOutput = File.write(filename);
//  f.writeString(b.toString());
//  f.close();
#end
}
public static inline function readString(byteData:ByteArray, count:Int):String 
	{
        var name:String = "";
        var k:Int = 0;
        for (j in 0...count) 
		{
            var ch:Int = byteData.readByte();

			
            if (ch > 32 && ch <= 126 ) 
			{
            name += String.fromCharCode(ch);
            }	
				
            
        }
		
        return name;
    }

	public static inline function nextToken(byteData:ByteArray, count:Int, token:Int ):String 
	{
        var name:String = "";
        var k:Int = 0;
		
		var skeep:Bool = false;
        for (j in 0...count) 
		{
            var ch:Int = byteData.readByte();

			if (ch == token)
			{
				skeep = true;
			}
            if (ch > 32 && ch <= 126 ) 
			{
               if(!skeep) name += String.fromCharCode(ch);
            }	
				
            
        }
		
        return name;
    }
public static function getBytes (id:String):ByteArray
{
	     var b=Assets.getBytes(id);
		return ByteArray.fromBytes(b);
		
	}
	
}