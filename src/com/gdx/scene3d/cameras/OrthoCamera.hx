package com.gdx.scene3d.cameras;

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

class OrthoCamera extends Camera {

	
	
	
	//2dcamera
	public var rotate2D(default, set) : Float;
	public var scale2D(default,set) : Float;


	
	

	public function new( ) 
	{
		super(45,-100,100);

	

		
	rotate2D = 0;
	scale2D = 1;
	
			
		
		update();
		
	}
	
	private  function set2D (x:Float, y:Float, scale:Float = 1, rotation:Float = 0) 
	{
		
		var theta = rotation * Math.PI / 180.0;
		var c = Math.cos (theta);
		var s = Math.sin (theta);
		
		viewMatrix.set(
		
			c*scale,  -s*scale, 0,  0,
			s*scale,  c*scale, 0,  0,
			0,        0,        1,  0,
			x,        y,        0,  1
		);
		
	}
	private function setOrtho (x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float) 
	{
	
		projChanged = true;
		
		var sx = 1.0 / (x1 - x0);
		var sy = 1.0 / (y1 - y0);
		var sz = 1.0 / (zFar - zNear);
		
		projMatrix.set(
			2.0 * sx,     0,          0,                 0,
			0,            2.0 * sy,   0,                 0,
			0,            0,          -2.0 * sz,         0,
			- (x0 + x1) * sx, - (y0 + y1) * sy, - (zNear + zFar) * sz,  1
		);
		
	}
	
	

	
	override public function update() 
	{
	
		if (onUpdate!=null)
		{
			onUpdate();
		}
		
	
		syncRec();
		

		setOrtho(0, Gdx.Instance().width, Gdx.Instance().height,0, zNear, zFar);
	
		set2D( Position.x, Position.y, scale2D, rotate2D);	
		
		
				
		
		
		for( c in childs )
			c.update();
		
	}

	
	
	inline function set_rotate2D(v) {
		rotate2D = v;
			 posChanged = false;
		return v;
	}

	inline function set_scale2D(v) {
		scale2D = v;
			 posChanged = false;
		return v;
	}

	
	
}
