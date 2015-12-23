package com.gdx.util ;
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
 * @author djoker
 */
class Clip
{

	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var offsetX:Int;
	public var offsetY:Int;
	public var name:String;
	public var rotated:Bool;
	
	
	public function new(?x:Int = 0, ?y:Int = 0, ?width:Int = 0, ?height:Int = 0, ?offsetX:Int = 0, ?offsetY:Int = 0, ?name:String="clip",?rotated:Bool=false) 
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.name = name;
		this.rotated = rotated;
	}
	public function set(x:Int,y:Int,width:Int,height:Int) 
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	public function toString():String
	{
		return "Name("+name+ ",x:" + x + ",y: " + y + ", w:" + width + ",h: " + height + ",offx: " + offsetX + ", offy:" + offsetY + ")"; 
	}
	
}