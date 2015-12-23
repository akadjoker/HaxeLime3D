package com.gdx.scene2d;

import com.gdx.gl.BlendMode;
import com.gdx.gl.Texture;
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
class Image extends Graphic
{

public var width:Float;
public var height:Float;



public var angle:Float;

public var originX:Float;
public var originY:Float;
public var texture:Texture;

public var clip:Clip;
public var flipX:Bool;
public var flipY:Bool;

	public function new(Tex:Texture) 
	{
		super();
		clip = new Clip(0, 0, Tex.width, Tex.height);
		angle = 0;

		originX = 0;
		originY = 0;

	
		width = Tex.width;
        height = Tex.height;
		flipX = false;
		flipY = false;
		blendMode = BlendMode.NORMAL;
		texture = Tex;
	}
	
}