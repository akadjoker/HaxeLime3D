package com.gdx.scene2d.ui;


import com.gdx.gl.Texture;
import com.gdx.scene2d.render.SpriteBatch;
import com.gdx.util.Clip;





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
class ImageFont extends Graphic
{




public var image:Texture;
private var offsetX:Int;
private var offsetY:Int;

public var characterWidth:Int;
public var characterHeight:Int;
private var characterSpacingX:Int;
private var characterSpacingY:Int;
private var characterPerRow:Int;
private var glyphs:Array<Clip>;





public var customSpacingX:Int;
public var customSpacingY:Int;



private var _align:Int;
public var align(get, set):Int;
	private function get_align():Int { return _align; }
	private function set_align(value:Int):Int
	{
		_align = value;
		return _align;
	}

	
private var _caption:String;
public var caption(get, set):String;
private function get_caption():String { return _caption; }
private function set_caption(value:String):String
	{
		_caption = value;
		return _caption;
	}


public function new( tex:Texture,SpacingX:Int=-8, ?trim:Int = 0):Void
{
super();
_caption = "";

_align = 0;
customSpacingX = SpacingX;
customSpacingY = 0;




image = tex;


characterWidth  =   Std.int( image.width / 16);
characterHeight =   Std.int( image.height / 16);
characterSpacingX = 0;
characterSpacingY = 0;
characterPerRow =  Std.int(image.width / characterWidth);
offsetX = 0;
offsetY = 0;

glyphs = new Array<Clip>();


var currentX:Int = offsetX;
var currentY:Int = offsetY;
var r:Int = 0;
var index:Int = 0;

for(c in 30...200)
//for(c in 30...150)
{
glyphs[index++] = new Clip(currentX, currentY, characterWidth, characterHeight);
r++;
if (r == characterPerRow)
{
r = 0;
currentX = offsetX;
currentY += characterHeight + characterSpacingY;
}
else
{
currentX += characterWidth + characterSpacingX;
}
}

}


public function getTextWidth(caption:String):Int 
	{
		var w:Int = 0;
		var textLength:Int = caption.length;
		for (i in 0...(textLength)) 
		{
        var glyph = glyphs[caption.charCodeAt(i)];
		if (glyph != null) 
			{
				w += (characterWidth+customSpacingX);
			}
		w = Math.round(w * scaleX);
	//	if (textLength > 1)
	//	{
		//	w += (textLength - 1) * (characterSpacingX);
	///	}
		}
		return w;
	}

	override public function render(batch:SpriteBatch):Void 
	{
		print(batch, _caption, x, y);
	}
	
public function print(batch:SpriteBatch,caption:String, x:Float, y:Float)
{

	var cx:Int = 0;
    var cy:Int = 0;
	var X:Float = x;
	var Y:Float = y;
	var newLine:Float = characterHeight + characterSpacingY;

	   switch (_align) 
       { 
       case 0:
       cx = 0;
       case 1:
       cx = getTextWidth(caption);
       case 2:
       cx = Std.int(getTextWidth(caption) / 2);
	   default:
	   cx = 0;
   
       }
	   


  for (c in 0...caption.length)   
   {
    if(caption.charAt(c) == " ")
    {
       X += characterWidth + customSpacingX;
    }
    else
	  if(caption.charAt(c) == "\n")
    {
	   Y += newLine;	
       X = x-characterWidth + customSpacingX;
    } else
      {
        var glyph = glyphs[caption.charCodeAt(c)];
        X += characterWidth + customSpacingX;
	    if(glyph!=null) batch.RenderFontScale(image,(X-cx)-characterWidth, Y,scaleX,scaleY, glyph, false, false, _red, _green, _blue, alpha, blendMode);
     }
  }
}

override public function dispose() 
{
	super.dispose();
	for (i in 0...glyphs.length)
	{
		glyphs[i] = null;
	}
	glyphs = null;

}
	
}