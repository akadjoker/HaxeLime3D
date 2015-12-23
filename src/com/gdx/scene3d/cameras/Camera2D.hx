package com.gdx.scene3d.cameras;

import com.gdx.math.Matrix;
import com.gdx.math.Matrix2D;
import com.gdx.math.Rectangle;
import com.gdx.math.Vector2;
import com.gdx.util.Util;
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
class Camera2D
{

	private var mTransformationMatrix:Matrix2D;
	 public var projMatrix:Matrix;
	 public var viewMatrix:Matrix;
	 private var width:Float;
	 private var height:Float;
     private var mX:Float;
	 private var mY:Float;
	 private var mPivotX:Float;
	 private var mPivotY:Float;
	 private var mScaleX:Float;
	 private var mScaleY:Float;
	 private var mSkewX:Float;
	 private var mSkewY:Float;
	 private var mRotation:Float;
	 private var mOrientationChanged:Bool;
	 private var viewport:Rectangle;
	
	private var gameWidth :Float;
	private	var gameHeight:Float;
		

	public var x(get, set):Float;
	public var y(get, set):Float;
	public var pivotX(get, set):Float;
	public var pivotY(get, set):Float;
	public var scaleX(get, set):Float;
	public var scaleY(get, set):Float;
	public var skewX(get, set):Float;
	public var skewY(get, set):Float;
	public var rotation(get, set):Float;
	
	
	public var bound_width:Int;
	public var bound_height:Int;
	public var viewportWidth:Int;
	public var viewportHeight:Int;
	
	public function new(screen_width:Int, scree_height:Int, ?game_width:Int=0,?game_height:Int=0) 
	{
		mX = mY = mPivotX = mPivotY = mRotation = mSkewX = mSkewY = 0.0;
		mScaleX = mScaleY  = 1.0;       
		mTransformationMatrix = new Matrix2D();
		viewport = new Rectangle(0, 0, screen_width,scree_height);
		projMatrix = Matrix.Identity();
		setProjOrtho(0, screen_width, scree_height, 0,  -100, 100);
		this.width = screen_width;
		this.height = scree_height;
		if (game_width == 0)
		{
			this.gameWidth = screen_width;
		} else
		{
			this.gameWidth = game_width;
		}
		if (game_height == 0)
		{
			this.gameHeight = scree_height;
		}else
		{
			this.gameHeight = game_height;
		}
		viewportWidth = 0;
		viewportHeight = 0;
		bound_width = 0;
		bound_height = 0;
		viewMatrix = Matrix.Identity();
		mOrientationChanged = true;
		//centerRotation();
		update();
	}

	public function centerRotation():Void
	{
		x = width / 2;
		y = height / 2;
		pivotX = width / 2;
		pivotY = height / 2;
	}

	public function update()
	{
         GL.viewport (Std.int (viewport.x), Std.int (viewport.y), Std.int (viewport.width), Std.int (viewport.height));
		 if (mOrientationChanged)
		 {
			
			var m = GetTransformationMatrix();
			viewMatrix.setIdentity();
			viewMatrix.m11 = m.a;
			viewMatrix.m11 = m.b;
			
			viewMatrix.m21 = m.c;
			viewMatrix.m22 = m.d;
			
			viewMatrix.m41 = m.tx;
			viewMatrix.m42 = m.ty;
			
		    mOrientationChanged = false;
		 }
		 
  
		
	}
	
	
	public function GetTransformationMatrix():Matrix2D
	{
		if (mOrientationChanged)
		{
			mOrientationChanged = false;
			
			if (mSkewX == 0.0 && mSkewY == 0.0)
			{
				
				if (mRotation == 0.0)
				{
					mTransformationMatrix.setTo(mScaleX, 0.0, 0.0, mScaleY,mX - mPivotX * mScaleX, mY - mPivotY * mScaleY);
				}
				else
				{
					var cos:Float = Math.cos(mRotation);
					var sin:Float = Math.sin(mRotation);
					var a:Float   = mScaleX *  cos;
					var b:Float   = mScaleX *  sin;
					var c:Float   = mScaleY * -sin;
					var d:Float   = mScaleY *  cos;
					var tx:Float  = mX - mPivotX * a - mPivotY * c;
					var ty:Float  = mY - mPivotX * b - mPivotY * d;
					mTransformationMatrix.setTo(a, b, c, d, tx, ty);
				}
			}
			else
			{
				mTransformationMatrix.identity();
				mTransformationMatrix.scale(mScaleX, mScaleY);
				Matrix2D.Skew(mTransformationMatrix, mSkewX, mSkewY);
				mTransformationMatrix.rotate(mRotation);
				mTransformationMatrix.translate(mX, mY);
				
				if (mPivotX != 0.0 || mPivotY != 0.0)
				{
				
					mTransformationMatrix.tx = mX - mTransformationMatrix.a * mPivotX
												  - mTransformationMatrix.c * mPivotY;
					mTransformationMatrix.ty = mY - mTransformationMatrix.b * mPivotX 
												  - mTransformationMatrix.d * mPivotY;
				}
			}
		}
		
		return mTransformationMatrix; 
	}
	public function setViewPort(x:Int, y:Int, w:Int, h:Int):Void
	{
    	  viewport.setTo(x, y, w, h);
		 
	}
	public function setOrtho(width:Float, height:Float) 
	{
	this.width = width;
	this.height = height;
	setProjOrtho(0, width, height, 0,  -100, 100);
	}
	 
	public function setScreenBounds ( screenX:Int,  screenY:Int,  screenWidth:Int,  screenHeight:Int) :Void
	{
		setViewPort(screenX, screenY, screenWidth, screenHeight);
	   	setOrtho(Std.int(screenWidth),Std.int( screenHeight));
	}
	
	
	 public function resize(width:Int, height:Int,?fit:Bool=true) 
	{ 
	    var scaled:Vector2 = apply(fit,gameWidth, gameHeight,width, height);
		 viewportWidth = Math.round(scaled.x);
		 viewportHeight = Math.round(scaled.y);
		bound_width = Std.int((width - viewportWidth) / 2);
		bound_height = Std.int( (height - viewportHeight) / 2);
  	    setScreenBounds(Std.int((width - viewportWidth) / 2),Std.int( (height - viewportHeight) / 2), viewportWidth, viewportHeight);
	}
	private function apply (fit:Bool, sourceWidth:Float,  sourceHeight:Float,  targetWidth:Float,  targetHeight:Float):Vector2
	{
	//	fit
	if (fit)
	{
			var targetRatio:Float = targetHeight / targetWidth;
			var sourceRatio:Float = sourceHeight / sourceWidth;
			var scale:Float = targetRatio > sourceRatio ? targetWidth / sourceWidth : targetHeight / sourceHeight;
			return new Vector2(sourceWidth * scale, sourceHeight * scale);
	} else
	{
		
	//	fill
			var targetRatio:Float = targetHeight / targetWidth;
			var sourceRatio:Float = sourceHeight / sourceWidth;
			var scale:Float = targetRatio < sourceRatio ? targetWidth / sourceWidth : targetHeight / sourceHeight;
			return new Vector2(sourceWidth * scale, sourceHeight * scale);
	}
	}
	
	
	private function get_x():Float { return mX; }
	private function set_x(value:Float):Float 
	{ 
		if (mX != value)
		{
			mX = value;
			mOrientationChanged = true;
		}
		return value;
	}
	private function get_y():Float { return mY; }
	private function set_y(value:Float):Float 
	{
		if (mY != value)
		{
			mY = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function get_pivotX():Float { return mPivotX; }
	private function set_pivotX(value:Float):Float 
	{
		if (mPivotX != value)
		{
			mPivotX = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function get_pivotY():Float { return mPivotY; }
	private function set_pivotY(value:Float):Float 
	{ 
		if (mPivotY != value)
		{
			mPivotY = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function get_scaleX():Float { return mScaleX; }
	private function set_scaleX(value:Float):Float 
	{ 
		if (mScaleX != value)
		{
			mScaleX = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function get_scaleY():Float { return mScaleY; }
	private function set_scaleY(value:Float):Float 
	{ 
		if (mScaleY != value)
		{
			mScaleY = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function get_skewX():Float { return mSkewX; }
	private function set_skewX(value:Float):Float 
	{
		value = Util.normalizeAngle(value);
		
		if (mSkewX != value)
		{
			mSkewX = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function get_skewY():Float { return mSkewY; }
	private function set_skewY(value:Float):Float 
	{
		value = Util.normalizeAngle(value);
		
		if (mSkewY != value)
		{
			mSkewY = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function get_rotation():Float { return mRotation; }
	private function set_rotation(value:Float):Float 
	{
		value = Util.normalizeAngle(value);
		if (mRotation != value)
		{            
			mRotation = value;
			mOrientationChanged = true;
		}
		return value;
	}
	
	private function setProjOrtho (x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float) 
	{
	
			
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
}