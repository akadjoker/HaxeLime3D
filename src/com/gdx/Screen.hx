package com.gdx;
import com.gdx.gl.Texture;

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
class Screen 
{

	public  var width:Int ;
    public  var height:Int;
	
	public function new() 
	{
		width  = Gdx.Instance().getWidth();
		height = Gdx.Instance().getHeight();
		
	}
	public function getTimer():Int
	{
		return Gdx.Instance().getTimer();
	}
	public function getTexture(url:String, Linear:Bool = true, Repeat:Bool = true, mipmap:Bool = false):Texture
	{
		return Gdx.Instance().getTexture(url, Linear,Repeat,mipmap);
	}
	
	public function update(delta:Float):Void 
	{
		
	}
	public function render():Void 
	{
		
	}
	public function keyPress(keyCode:Int):Bool
    {
     return Gdx.Instance().keyPress(keyCode);
	}
	public function ikeyPress(keyCode:Int):Int
    {
      if (Gdx.Instance().keyPress(keyCode)) return 1; else return 0;
	}
	public function resize(width:Int, height:Int):Void 
	{
		this.width = width;
		this.height = height;
	}
	
	public function show():Void 
	{
		
	}
	
	public function hide():Void 
	{
		
	}
	
	public function pause():Void 
	{
		
	}
	
	public function resume():Void 
	{
		
	}
	
	public function dipose():Void 
	{
		
	}
	public function KeyUp(key:Int):Void 
	{
		
	}
	public function KeyDown(key:Int):Void 
	{
		
	}
	public function TouchDown(x:Float,y:Float,num:Int):Void 
	{
		
	}
	public function TouchMove(x:Float,y:Float,num:Int):Void 
	{
		
	}
	public function TouchUp(x:Float,y:Float,num:Int):Void 
	{
		
	}
	public function tickcount():Int
	{
		return Gdx.Instance().getTimer();
	}
}