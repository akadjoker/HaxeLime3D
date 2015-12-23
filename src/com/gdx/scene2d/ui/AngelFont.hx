package com.gdx.scene2d.ui;




import com.gdx.gl.Texture;
import com.gdx.math.Rectangle;
import com.gdx.scene2d.render.SpriteBatch;
import com.gdx.util.Clip;
import com.gdx.util.TextParser;
import haxe.xml.Fast;
import lime.Assets;



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



typedef GlyphData = {
	var rect:Clip;
	var xOffset:Int;
	var yOffset:Int;
	var xAdvance:Int;
	var id:Int;
	var ch:Int;
};


class AngelFont extends Graphic
{
		
	private var maxWidth:Int;
	private var maxHeight:Int;
	public var lineHeight:Int = 0;
	public var fontSize:Int = 0;
	public var glyphData:Map<Int,GlyphData>;
    public var image:Texture;


private var _caption:String;
public var caption(get, set):String;
private function get_caption():String { return _caption; }
private function set_caption(value:String):String
	{
		_caption = value;
		return _caption;
	}
private var _align:Int;
public var align(get, set):Int;
	private function get_align():Int { return _align; }
	private function set_align(value:Int):Int
	{
		_align = value;
		return _align;
	}
		


public function new(filename:String, isAtlas:Bool)
{

super();

maxWidth  = -999;
maxHeight = -999;
	
	
 image=Gdx.Instance().getTexture(StringTools.replace(filename, ".fnt", ".png"));
	
glyphData = new Map();
if(isAtlas)
{
loadXMLFont(filename);
} else
{
loadfont(filename);
}


trace(maxWidth + "," + maxHeight);

align = 0;





		
}

	override public function render(batch:SpriteBatch):Void 
	{
		print(batch, _caption, x, y);
	}
	
  private function loadfont (name:String)
    {
	
		var rect:Rectangle = new Rectangle();
		

        var parser = new TextParser(Assets.getText(name ));
     
        // The basename of the font's path, where we'll find the textures
    //    var idx = name.lastIndexOf("/");
    //    var basePath = (idx >= 0) ? name.substr(0, idx+1) : "";

        // BMFont spec: http://www.angelcode.com/products/bmfont/doc/file_format.html
        for (keyword in parser.keywords())
		{
            switch (keyword) 
			{
            case "info":
                for (pair in parser.pairs()) 
				{
                    switch (pair.key) 
					{
                    case "size":
                        fontSize = pair.getInt();
						trace(fontSize);
                    }
                }

            case "common":
                for (pair in parser.pairs()) 
				{
                    switch (pair.key) 
					{
                    case "lineHeight":
                        lineHeight = pair.getInt();
                    }
                }

            case "page":
                var pageId :Int = 0;
                var file :String = null;
                for (pair in parser.pairs()) 
				{
                    switch (pair.key) {
                    case "id":
                        pageId = pair.getInt();
                    case "file":
                        file = pair.getString();
                    }
                }
         
            case "char":
					var glyphID:Int = 0;
					var x:Int = 0;
					var y:Int = 0; 
					var width:Int = 0; 
					var height:Int = 0;
					var xoffset:Int = 0;
					var yoffset:Int = 0;
					var xadvance:Int = 0;
					
                for (pair in parser.pairs()) 
				{
            		switch (pair.key) 
					{
                    case "id":
                        glyphID=pair.getInt();
                    case "x":
                        x=pair.getInt();
                    case "y":
                        y= pair.getInt();
                    case "width":
                        width = pair.getInt();
						maxWidth = Std.int(Math.max(maxWidth, width));
                    case "height":
                        height = pair.getInt();
						maxHeight =Std.int( Math.max(maxHeight, height));
                    case "page":
                        //glyph.page = pages.get(pair.getInt());
						//trace("page" + pair.getInt());
                    case "xoffset":
                        xoffset= pair.getInt();
                    case "yoffset":
                        yoffset= pair.getInt();
                    case "xadvance":
                        xadvance= pair.getInt();
                    }
					
			
					
                }
				//	trace(glyphID+","+x + "," + y);
					
			var md:GlyphData = {
				ch:glyphID,
				id:0,
				rect: new Clip(x,y,width,height),
				xOffset: xoffset,
				yOffset: yoffset,
				xAdvance: xadvance
			};
    		glyphData.set(glyphID, md);
            }
        }
    }


public  function loadXMLFont(file:String)
	{
		
		
		var xml = Xml.parse(Assets.getText(file));
		var fast = new Fast(xml.firstElement());

		lineHeight = Std.parseInt(fast.node.common.att.lineHeight);
		fontSize = Std.parseInt(fast.node.info.att.size);
		var chars = fast.node.chars;

		
		for (char in chars.nodes.char)
		{
			var glyphID:Int = Std.parseInt(char.att.id);
	


			var md:GlyphData = {
				ch:glyphID,
				id:0,
				rect: new Clip(Std.parseInt(char.att.x),Std.parseInt(char.att.y),Std.parseInt(char.att.width),Std.parseInt(char.att.height)),
				xOffset: char.has.xoffset ? Std.parseInt(char.att.xoffset) : 0,
				yOffset: char.has.yoffset ? Std.parseInt(char.att.yoffset) : 0,
				xAdvance: char.has.xadvance ? Std.parseInt(char.att.xadvance) : 0
			};

			// set the defined region

			glyphData.set(glyphID,md);
		
		}
	}


 public function print(batch:SpriteBatch, caption:String, x:Float, y:Float)
{
		

			
    var cx:Int = 0;
    var cy:Int = 0;
	var X:Float = x;
	var Y:Float = y;


	

  for (c in 0...caption.length)   
   {
 
	 
		 
    if(caption.charAt(c) == "\n")
    {
	   Y += maxHeight  * scaleY;	
       X = x * scaleX;
	}
    


	
	   if (glyphData.exists(caption.charCodeAt(c)))
	  {
	   var Glyph:GlyphData = glyphData.get(caption.charCodeAt(c));
	   
	 

	    switch (align) 
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
		
    if(caption.charAt(c) == " ")
    {
         X += Glyph.rect.width + (Glyph.xAdvance*scaleX);
    }else
    {
         X += Glyph.rect.width + (Glyph.xAdvance * scaleX);
		 batch.RenderFontScale(image, ((X - cx) - Glyph.rect.width)+ Glyph.xOffset, Y+ Glyph.yOffset, scaleX,scaleY,  Glyph.rect, false, false, _red, _green, _blue, alpha, blendMode);
	}
    }		
   }
  

}



public function getTextWidth( caption:String):Int 
	{
		var w:Int = 0;
		var textLength:Int = caption.length;
		for (i in 0...(textLength)) 
		{
		if (glyphData.exists(caption.charCodeAt(i)))
    	   {
	         var g:GlyphData = glyphData.get(caption.charCodeAt(i));
      	     w +=Std.int( g.rect.width+ g.xOffset+ g.xAdvance);
		     w = Math.round(w * scaleX );
		    }
		}
		
		return w;
	}


	override public function dispose() 
	{
		super.dispose();
	}

}
