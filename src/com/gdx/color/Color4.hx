package com.gdx.color ;
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



class Color4 {

	public var r:Float;		
	public var g:Float;
	public var b:Float;
	public var a:Float;

	public function new(initialR:Float=1, initialG:Float=1, initialB:Float=1, initialA:Float = 1.0) {
		this.r = initialR;
        this.g = initialG;
        this.b = initialB;
        this.a = initialA;
	}
	public function set(initialR:Float, initialG:Float, initialB:Float, initialA:Float = 1.0) {
		this.r = initialR;
        this.g = initialG;
        this.b = initialB;
        this.a = initialA;
	}
	public function setInt(Color:Int)
	{
	
		a = ((Color >> 24) & 0xFF) / 255;
		r = ((Color >> 16) & 0xFF)/255;
		g = ((Color >> 8) & 0xFF)/255;
		b = (Color & 0xFF)/255;
	
	}
	inline public function addInPlace(right:Color4) {
		this.r += right.r;
        this.g += right.g;
        this.b += right.b;
        this.a += right.a;
	}
	
	public inline function asArray():Array<Float> {
        var result = [];
        this.toArray(result, 0);
        return result;
    }

    public inline function toArray(array:Array<Float>, index:Int = 0) {
        array[index] = this.r;
        array[index + 1] = this.g;
        array[index + 2] = this.b;
        array[index + 3] = this.a;
    }
	
	inline public function add(right:Color4):Color4 {
		return new Color4(this.r + right.r, this.g + right.g, this.b + right.b, this.a + right.a);
	}
	
	inline public function subtract(right:Color4):Color4 {
		return new Color4(this.r - right.r, this.g - right.g, this.b - right.b, this.a - right.a);
	}
	
	inline public function subtractToRef(right:Color4, result:Color4):Color4 {
		result.r = this.r - right.r;
        result.g = this.g - right.g;
        result.b = this.b - right.b;
        result.a = this.a - right.a;
		
		return result;
	}
	
	inline public function scale(scale:Float):Color4 {
		return new Color4(this.r * scale, this.g * scale, this.b * scale, this.a * scale);
	}
	
	inline public function scaleToRef(scale:Float, result:Color4):Color4 {
		result.r = this.r * scale;
        result.g = this.g * scale;
        result.b = this.b * scale;
        result.a = this.a * scale;
		
		return result;
	}

	public function toString() {
		return "{R: " + this.r + " G:" + this.g + " B:" + this.b + " A:" + this.a + "}";
	}
	
	public function clone():Color4 {
		return new Color4(this.r, this.g, this.b, this.a);
	}
	
        
        public function toRgb():Int
        {
          if (r < 0.0) r = 0.0; else if (r > 1.0) r = 1.0;
          if (g < 0.0) g = 0.0; else if (g > 1.0) g = 1.0;
          if (b < 0.0) b = 0.0; else if (b > 1.0) b = 1.0;
            
            return Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255);
        }
        
        public function toArgb():Int
        {
          if (a < 0.0) a = 0.0; else if (a > 1.0) a = 1.0;			
		  if (r < 0.0) r = 0.0; else if (r > 1.0) r = 1.0;
          if (g < 0.0) g = 0.0; else if (g > 1.0) g = 1.0;
          if (b < 0.0) b = 0.0; else if (b > 1.0) b = 1.0;
		   return Std.int( a*255)<<24 | Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255);
            
            
        }
		
	inline public static function Lerp(left:Color4, right:Color4, amount:Float):Color4 {
		var result = new Color4(0, 0, 0, 0);
        return Color4.LerpToRef(left, right, amount, result);
	}
	
	inline public static function LerpToRef(left:Color4, right:Color4, amount:Float, result:Color4):Color4 {
		result.r = left.r + (right.r - left.r) * amount;
        result.g = left.g + (right.g - left.g) * amount;
        result.b = left.b + (right.b - left.b) * amount;
        result.a = left.a + (right.a - left.a) * amount;
		
		return result;
	}
	
	inline public static function FromArray(array:Array<Float>, offset:Int = 0):Color4 {
		return new Color4(array[offset], array[offset + 1], array[offset + 2], array[offset + 3]);
	}	
	
}
