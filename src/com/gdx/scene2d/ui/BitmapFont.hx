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
class BitmapFont extends Graphic
{
private var _align:Int;
public var align(get, set):Int;
	private function get_align():Int { return _align; }
	private function set_align(value:Int):Int
	{
		_align = value;
		return _align;
	}
	
public var customSpacingX:Int;
public var customSpacingY:Int;
public var image:Texture;
private var offsetX:Int;
private var offsetY:Int;
private var characterWidth:Int;
private var characterHeight:Int;
private var characterSpacingX:Int;
private var characterSpacingY:Int;
private var characterPerRow:Int;
private var glyphs:Array<Clip>;


private var _caption:String;
public var caption(get, set):String;
private function get_caption():String { return _caption; }
private function set_caption(value:String):String
	{
		_caption = value;
		return _caption;
	}





public function new(filename:String, 
width:Int, height:Int, 
charsPerRow:Int, 
xSpacing:Int = 0, ySpacing:Int = 0, 
xOffset:Int = 0, yOffset:Int = 0,
//?chars:String = " 0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^-'abcdefghijklmnopqrstuvwxyz{|]~"):Void
?chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.,\"-+!?()':;0123456789"):Void
{

super();

align = 0;
customSpacingX = 0;
customSpacingY = 0;



 image = Gdx.Instance().getTexture(filename, false, false, false);

characterWidth = width;
characterHeight = height;
characterSpacingX = xSpacing;
characterSpacingY = ySpacing;
characterPerRow = charsPerRow;
offsetX = xOffset;
offsetY = yOffset;

glyphs = new Array<Clip>();


var currentX:Int = offsetX;
var currentY:Int = offsetY;
var r:Int = 0;
var index:Int = 0;

for(c in 0...chars.length)

{
glyphs[chars.charCodeAt(c)] = new Clip(currentX, currentY, characterWidth, characterHeight);
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
				w += glyph.width;
			}
		w = Math.round(w * scaleX);
		if (textLength > 1)
		{
			w += (textLength - 1) * characterSpacingX;
		}
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
		//if(glyph!=null)    	 batch.RenderFont(image,X-cx, Y,scale, glyph, false, true,_red,_green,_blue,_alpha,blendMode);
		if (glyph != null) batch.RenderFontScale(image, (X - cx), Y, scaleX, scaleY, glyph, false, true, _red, _green, _blue, alpha,blendMode);
		
     }
  }
}

override  public function dispose() 
{
	super.dispose();
	for (i in 0...glyphs.length)
	{
		glyphs[i] = null;
	}
	glyphs = null;

}
}
