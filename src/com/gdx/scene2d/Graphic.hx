package com.gdx.scene2d;
import com.gdx.Buffer;
import com.gdx.gl.BlendMode;
import com.gdx.scene2d.render.SpriteBatch;
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
class Graphic extends Buffer
{

	 public var x:Float;	
	 public var y:Float;	
	 public var scaleX:Float;
     public var scaleY:Float;
	 public var blendMode:Int;
	 public var active:Bool;
	
    public function new()
	{
		super();
		active = true;
		x = 0;
		y = 0;
		blendMode = BlendMode.NORMAL;
	    _color = 0x00FFFFFF;
	    _red = _green = _blue = 1;
	    alpha = 1;
	    scaleX = scaleY = 1;
	}
	public var alpha(get, set):Float;
	private function get_alpha():Float { return _alpha; }
	private function set_alpha(value:Float):Float
	{
		value = value < 0 ? 0 : (value > 1 ? 1 : value);
		if (_alpha == value) return value;
		_alpha = value;
		return _alpha;
	}
	public var color(get, set):Int;
	private function get_color():Int { return _color; }
	private function set_color(value:Int):Int
	{
		value &= 0xFFFFFF;
		if (_color == value) return value;
		_color = value;
		_red = Util.getRed(_color) / 255;
		_green = Util.getGreen(_color) / 255;
		_blue = Util.getBlue(_color) / 255;
		return _color;
	}

	public function render(batch:SpriteBatch):Void
	{
		
	}

	public var _alpha:Float;
	private var _color:Int;
	public var _red:Float;
	public var _green:Float;
	public var _blue:Float;
	
}