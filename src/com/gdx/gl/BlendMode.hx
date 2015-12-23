package com.gdx.gl;


import lime.graphics.opengl.GL;


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
class BlendMode
{

public static var NORMAL:Int      = 0;
public static var ADD:Int         = 1;
public static var MULTIPLY:Int    = 2;
public static var SCREEN:Int      = 3;
public static var TRANSPARENT:Int  = 4;





static 	public function setBlend(mode:Int ) 
	{
	 switch( mode ) {
    case BlendMode.NORMAL:
		
       Gdx.Instance().setBlendFunc(GL.SRC_ALPHA,GL.ONE_MINUS_SRC_ALPHA );
    case BlendMode.ADD:
        //Gdx.Instance().setBlendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );
		Gdx.Instance().setBlendFunc(GL.ONE, GL.ONE );
    case BlendMode.MULTIPLY:
        Gdx.Instance().setBlendFunc(GL.DST_COLOR,GL.ONE_MINUS_SRC_ALPHA );
    case BlendMode.SCREEN:
       Gdx.Instance().setBlendFunc(GL.SRC_ALPHA, GL.ONE );	
	case BlendMode.TRANSPARENT:   
		Gdx.Instance().setBlendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA );	
    default:
      Gdx.Instance().setBlendFunc(GL.ONE,GL.ONE_MINUS_SRC_ALPHA );
    }
}
	
	
	
	
		
	
}