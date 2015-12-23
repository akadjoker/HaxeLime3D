package com.gdx.scene2d.render;

import com.gdx.Gdx;
import com.gdx.gl.BlendMode;
import com.gdx.gl.shaders.ShaderTexture;
import com.gdx.gl.Texture;
import com.gdx.math.Matrix;
import com.gdx.math.Matrix2D;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.util.Clip;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.utils.Int16Array;





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
class SpriteBatch 
{
	public static var FIX_ARTIFACTS_BY_STRECHING_TEXEL:Bool = true;
	private var left:Float;
private var right:Float;
private var top:Float;
private var bottom:Float;


	private var capacity:Int;
	private var numVerts:Int;
	private var numIndices:Int; 
	private var vertices:Float32Array;
	private var lastIndexCount:Int;
	private var drawing:Bool;
	private var currentBatchSize:Int;
	private var currentBlendMode:Int;
	private var currentBaseTexture:Texture;

		private var index:Int;

private var vertexBuffer:GLBuffer;
private var indexBuffer:GLBuffer;
private var invTexWidth:Float = 0;
private var invTexHeight:Float = 0;
private var vertexStrideSize:Int;


    public var shader:ShaderTexture;
	public var camera:Camera;
	public var transform:Matrix;   


	public function new(c:Camera,capacity:Int ) 
	{
		shader =  cast( Gdx.Instance().materials[Gdx.SHADERTEXTURE], ShaderTexture);
		camera = c;
		transform = Matrix.Identity();
		
	   this.capacity = capacity;
	   vertexStrideSize =  (3+2+4) * 4; // 9 floats (x, y, z,u,v, r, g, b, a)
       numVerts = capacity * vertexStrideSize ;
       numIndices = capacity * 6;
       vertices = new Float32Array(numVerts);

	   index = 0;
    
left = right = top = bottom = 0;
	
	
        var indices:Array<Int> = [];
        var index = 0;
        for (count in 0...numIndices) {
            indices.push(index);
            indices.push(index + 1);
            indices.push(index + 2);
            indices.push(index);
            indices.push(index + 2);
            indices.push(index + 3);
            index += 4;
        }
		

    drawing = false;
    currentBatchSize = 0;
	currentBlendMode = BlendMode.NORMAL;
	
	currentBaseTexture = null;

	

    vertexBuffer = GL.createBuffer();
    indexBuffer = GL.createBuffer();


    //upload the index data
    GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    GL.bufferData(GL.ELEMENT_ARRAY_BUFFER,  new Int16Array(indices), GL.STATIC_DRAW);
	indices = null;
    GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
    GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
	
  	
	}
	
	
    public    function Render(texture:Texture, x:Float, y:Float,  srcX:Int,  srcY:Int,  srcWidth:Int,  srcHeight:Int,blendMode:Int)
	{
		
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
 var u:Float = srcX * invTexWidth;
 var v:Float = (srcY + srcHeight) * invTexHeight;
 var u2:Float = (srcX + srcWidth) * invTexWidth;
 var v2:Float = srcY * invTexHeight;
 var fx2:Float = x + srcWidth;
 var fy2:Float = y + srcHeight;

 
var r, g, b, a:Float;
r = 1;
g = 1;
b = 1;
a = 1;




var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


 
 
this.currentBatchSize++;
	
	

	}
	public  inline  function RenderTile(texture:Texture,x:Float,y:Float,width:Float,height:Float,clip:Clip,flipx:Bool,flipy:Bool,blendMode:Int)
{
	
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
       this.setBlendMode(blendMode);
    }	
	





		var fx2:Float = x+width;
		var fy2:Float = y+height;
		

		
		
		
		


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {

   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
				

 if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		
		
		var index:Int = currentBatchSize *  vertexStrideSize;


vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = right; vertices[index++] = top;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


 
 
this.currentBatchSize++;
	
	
		
}
public  inline function RenderTileScale(texture:Texture,x:Float,y:Float,width:Float,height:Float,scaleX:Float,scaleY:Float,clip:Clip,flipx:Bool,flipy:Bool,blendMode:Int)
{

	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
       this.setBlendMode(blendMode);
    }	
	





	    var fx:Float = x;
		var fy:Float = y;
		var fx2:Float = x+(width*scaleX) ;
		var fy2:Float = y+(height*scaleY) ;
		
		


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {

   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
				

 if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		
		
		var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = fx;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = fx;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = right; vertices[index++] = top;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


 
 
this.currentBatchSize++;
	
	
		
}

public function startBatch(texture:Texture, blendMode:Int)
{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
       this.setBlendMode(blendMode);
    }	
	
	
	 index = currentBatchSize *  vertexStrideSize;
}

public   function RenderTileBatch(x:Float,y:Float,width:Float,height:Float,scaleX:Float,scaleY:Float,clip:Clip,flipx:Bool,flipy:Bool,r:Float,g:Float,b:Float,a:Float)
{




	    var fx:Float = x;
		var fy:Float = y;
		var fx2:Float = x+(width*scaleX) ;
		var fy2:Float = y+(height*scaleY) ;
		
		
		
		

  var widthTex:Int  = currentBaseTexture.width;
  var heightTex:Int = currentBaseTexture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {

   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
				

 if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		
		
		

vertices[index++] = fx;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = fx;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = right; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


 


	
	
		
}
public function endBatch()
{
	this.currentBatchSize+=Std.int(index / 4);
}

public   function RenderTileScaleColor(texture:Texture,x:Float,y:Float,width:Float,height:Float,scaleX:Float,scaleY:Float,clip:Clip,flipx:Bool,flipy:Bool,r:Float,g:Float,b:Float,a:Float,blendMode:Int)
{
	

	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
       this.setBlendMode(blendMode);
    }	





	    var fx:Float = x;
		var fy:Float = y;
		var fx2:Float = x+(width*scaleX) ;
		var fy2:Float = y+(height*scaleY) ;
		
		
		


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {

   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
				

 if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		
		
		
	 var index:Int  = currentBatchSize *  vertexStrideSize;	

vertices[index++] = fx;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = fx;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = right; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


 
 this.currentBatchSize++;

	
	
		
}
public  inline  function RenderFont(texture:Texture,x:Float,y:Float,scale:Float,c:Clip,flipx:Bool,flipy:Bool,r:Float,g:Float,b:Float,a:Float,blendMode:Int)
{
	
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
       this.setBlendMode(blendMode);
    }	
	





	    var fx:Float = x;
		var fy:Float = y;
		var fx2:Float = x+c.width ;
		var fy2:Float = y+c.height ;
		
		if (scale != 1 )
		{
			fx *= scale;
			fy *= scale;
			fx2 *= scale;
			fy2 *= scale;
		}
		
		
				

  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*c.x+1) / (2*widthTex);
   right =  left +(c.width*2-2) / (2*widthTex);
   top = (2*c.y+1) / (2*heightTex);
   bottom = top +(c.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = c.x / widthTex;
   right =  (c.x + c.width) / widthTex;
   top = c.y / heightTex;
   bottom = (c.y + c.height) / heightTex;
  }			
  
		
		
		var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = fx;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


 
 
this.currentBatchSize++;
	
	
		
}

public  inline  function RenderFontScale(texture:Texture,x:Float,y:Float,scaleX:Float,scaleY:Float,c:Clip,flipx:Bool,flipy:Bool,r:Float,g:Float,b:Float,a:Float,blendMode:Int)
{
	
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
       this.setBlendMode(blendMode);
    }	
	





	    var fx:Float = x;
		var fy:Float = y;
		var fx2:Float = x+c.width ;
		var fy2:Float = y+c.height ;
		
	
		if (scaleX != 1 || scaleY != 1)
		{
			fx *= scaleX;
			fy *= scaleY;
			fx2 *= scaleX;
			fy2 *= scaleY;
		}
		
		
				
  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*c.x+1) / (2*widthTex);
   right =  left +(c.width*2-2) / (2*widthTex);
   top = (2*c.y+1) / (2*heightTex);
   bottom = top +(c.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = c.x / widthTex;
   right =  (c.x + c.width) / widthTex;
   top = c.y / heightTex;
   bottom = (c.y + c.height) / heightTex;
  }		
		
		
		var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = fx;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


 
 
this.currentBatchSize++;
	
	
		
}


	public  inline  function drawEntityPixi(texture:Texture,
    
		 m:Matrix2D,
		 clip:Clip,
		 m_obOffsetPositionX:Float,m_obOffsetPositionY:Float,
		 flipx:Bool,flipy:Bool,
	     red:Float,green:Float,blue:Float,alpha:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	
var index:Int = currentBatchSize *  vertexStrideSize;





  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		

 
  if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}

		
		 var aX = m_obOffsetPositionX;
         var aY = m_obOffsetPositionY;
	

		 var w0, w1, h0, h1:Float;
		 
		  w0 = (clip.width ) * (1-aX);
          w1 = (clip.width ) * -aX;

        h0 = clip.height * (1-aY);
        h1 = clip.height * -aY;
		

            var a:Float = m.a;
            var b:Float = m.c;
            var c:Float = m.b;
            var d:Float = m.d;
			var tx:Float = m.tx;
			var ty:Float = m.ty;
			

		
vertices[index++] =a * w1 + c * h1 + tx;
vertices[index++] =d * h1 + b * w1 + ty;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = red;vertices[index++] = green;vertices[index++] = blue;vertices[index++] = alpha;
	
vertices[index++] = a * w0 + c * h1 + tx;
vertices[index++] = d * h1 + b * w0 + ty;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = red;vertices[index++] = green;vertices[index++] = blue;vertices[index++] = alpha;

vertices[index++] =a * w0 + c * h0 + tx;
vertices[index++] =d * h0 + b * w0 + ty;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = red;vertices[index++] = green;vertices[index++] = blue;vertices[index++] = alpha;

vertices[index++] = a * w1 + c * h0 + tx;
vertices[index++] = d * h0 + b * w1 + ty;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = bottom;
vertices[index++] = red;vertices[index++] = green;vertices[index++] = blue;vertices[index++] = alpha;	
		
    currentBatchSize++;
	
	}
	public  inline  function drawEntity(texture:Texture,
    
		 m:Matrix2D,
		 clip:Clip,
		 m_obOffsetPositionX:Float,m_obOffsetPositionY:Float,
		 flipx:Bool,flipy:Bool,
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	
var index:Int = currentBatchSize *  vertexStrideSize;

		
		



  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		

 
  if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}

		
		    var x1:Float = m_obOffsetPositionX;
            var y1:Float = m_obOffsetPositionY;

            var x2:Float = x1 + clip.width;
            var y2:Float = y1 + clip.height;
            var x:Float = m.tx;
            var y:Float = m.ty;


            var cr:Float = m.a;
            var sr:Float = m.b;
            var cr2:Float = m.d;
            var sr2:Float = -m.c;
			
            var ax:Float = x1 * cr - y1 * sr2 + x;
            var ay:Float = x1 * sr + y1 * cr2 + y;

            var bx:Float = x2 * cr - y1 * sr2 + x;
            var by:Float = x2 * sr + y1 * cr2 + y;

            var cx:Float = x2 * cr - y2 * sr2 + x;
            var cy:Float = x2 * sr + y2 * cr2 + y;

            var dx:Float = x1 * cr - y2 * sr2 + x;
            var dy:Float = x1 * sr + y2 * cr2 + y;

		
vertices[index++] =ax;
vertices[index++] =ay;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = bx;
vertices[index++] = by;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] =cx;
vertices[index++] =cy;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = dx;
vertices[index++] = dy;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;		
		
    currentBatchSize++;
	
	}
		
	public  inline  function drawMatrix(
	     texture:Texture,
  		 matrix:Matrix2D, 
 	     clip:Clip, 
	     r:Float, g:Float, b:Float, a:Float, flipx:Bool, flipy:Bool, blendMode:Int)
		 
	{	

	if(texture!= this.currentBaseTexture )
    {
       		switchTexture(texture);
    }
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }




		
 
  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		

 
  if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}


var index:Int = currentBatchSize *  vertexStrideSize;

var TempX1:Float = 0;
var TempY1:Float = 0;
var TempX2:Float = clip.width;
var TempY2:Float = clip.height;





//z
vertices[index+0*9+2] = 0;
vertices[index+1*9+2] = 0;
vertices[index+2*9+2] = 0;
vertices[index+3*9+2] = 0;




vertices[index + 0 * 9 + 0] = TempX1;vertices[index + 0 * 9 + 1] = TempY1;
vertices[index + 1 * 9 + 0] = TempX1;vertices[index + 1 * 9 + 1] = TempY2;
vertices[index + 2 * 9 + 0] = TempX2;vertices[index + 2 * 9 + 1] = TempY2;
vertices[index + 3 * 9 + 0] = TempX2;vertices[index + 3 * 9 + 1] = TempY1;


vertices[index+0*9+3] = left;vertices[index+0*9+4] =top;
vertices[index+1*9+3] = left;vertices[index+1*9+4] =bottom;
vertices[index+2*9+3] =right;vertices[index+2*9+4] =bottom;
vertices[index+3*9+3] =right;vertices[index+3*9+4] =top;

	


vertices[index+0*9+5] = r;vertices[index+0*9+6] = g;vertices[index+0*9+7] = b;vertices[index+0*9+8] = a;
vertices[index+1*9+5] = r;vertices[index+1*9+6] = g;vertices[index+1*9+7] = b;vertices[index+1*9+8] = a;
vertices[index+2*9+5] = r;vertices[index+2*9+6] = g;vertices[index+2*9+7] = b;vertices[index+2*9+8] = a;
vertices[index+3*9+5] = r;vertices[index+3*9+6] = g;vertices[index+3*9+7] = b;vertices[index+3*9+8] = a;



	for (i in 0...4)
		{
			var x:Float = vertices[index + i * 9 + 0];
			var y:Float = vertices[index + i * 9 + 1];
			vertices[index + i * 9 + 0] = matrix.a * x + matrix.c * y + matrix.tx;
		    vertices[index + i * 9 + 1] = matrix.d * y + matrix.b * x + matrix.ty;
		}		
 
this.currentBatchSize++;


}

   public function Blt(texture:Texture, src:Clip,dst:Clip,flipX:Bool,flipY:Bool,blendMode:Int)
	{
		if (texture == null) return;
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }




		var fx2:Float = src.x+src.width;
		var fy2:Float = src.y+src.height;
		

		
		
		
				
 var u:Float  = dst.x * invTexWidth;
 var u2:Float = (dst.x + dst.width) * invTexWidth;
 
 var v:Float  = (dst.y + dst.height) * invTexHeight;
 var v2:Float = dst.y * invTexHeight;

 if (flipX) 
 {
			var tmp:Float = u;
			u = u2;
			u2 = tmp;
		}

		if (flipY)
		{
			var tmp:Float = v;
			v = v2;
			v2 = tmp;
		}
 


var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = src.x;
vertices[index++] = src.y;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = src.x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = src.y;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


 

 
this.currentBatchSize++;
	
	

	}
	
	public  function RenderClip(texture:Texture, x:Float, y:Float,c:Clip,flipX:Bool,flipY:Bool,blendMode:Int)
	{

		
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*c.x+1) / (2*widthTex);
   right =  left +(c.width*2-2) / (2*widthTex);
   top = (2*c.y+1) / (2*heightTex);
   bottom = top +(c.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = c.x / widthTex;
   right =  (c.x + c.width) / widthTex;
   top = c.y / heightTex;
   bottom = (c.y + c.height) / heightTex;
  }			
  
		

 
  if (flipX) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipY)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
 

		var worldOriginX:Float = x + c.offsetX;
		var worldOriginY:Float = y + c.offsetY;
		var fx:Float = -c.offsetX;
		var fy:Float = -c.offsetY;
		var fx2:Float = c.width - c.offsetX;
		var fy2:Float = c.height - c.offsetY;


	    var p1x:Float = fx;
		var p1y:Float = fy;
		var p2x:Float = fx;
		var p2y:Float = fy2;
		var p3x:Float = fx2;
		var p3y:Float = fy2;
		var p4x:Float = fx2;
		var p4y:Float = fy;

		var x1:Float;
		var y1:Float;
		var x2:Float;
		var y2:Float;
		var x3:Float;
		var y3:Float;
		var x4:Float;
		var y4:Float;
		
		

			x1 = p1x;
			y1 = p1y;

			x2 = p2x;
			y2 = p2y;

			x3 = p3x;
			y3 = p3y;

			x4 = p4x;
			y4 = p4y;
		

		x1 += worldOriginX;
		y1 += worldOriginY;
		x2 += worldOriginX;
		y2 += worldOriginY;
		x3 += worldOriginX;
		y3 += worldOriginY;
		x4 += worldOriginX;
		y4 += worldOriginY;


var r, g, b, a:Float;
r = 1;
g = 1;
b = 1;
a = 1;
		
var index:Int = currentBatchSize *  vertexStrideSize;



vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;



 
this.currentBatchSize++;
	
	

	}
	
	public  inline  function drawVertexMatrix2D(texture:Texture,
    
		 x1:Float,
		 y1:Float,
		 x2:Float,
		 y2:Float,
		 x3:Float,
		 y3:Float,
		 x4:Float,
		 y4:Float,
 	     clip:Clip, 
		 m:Matrix2D,
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{

	
if (texture != null)
{
		
		
		if(texture!= this.currentBaseTexture )
        {
       		switchTexture(texture);
        }


    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }

	

 var u:Float  = clip.x * invTexWidth;
 var u2:Float = ( clip.x +  clip.width) * invTexWidth;
 var v:Float  = ( clip.y +  clip.height) * invTexHeight;
 var v2:Float =  clip.y * invTexHeight;


var index:Int = currentBatchSize *  vertexStrideSize;



//z
vertices[index+0*9+2] = 0;
vertices[index+1*9+2] = 0;
vertices[index+2*9+2] = 0;
vertices[index+3*9+2] = 0;



vertices[index + 0 * 9 + 0] = x1; vertices[index + 0 * 9 + 1] = y1;
vertices[index + 1 * 9 + 0] = x2; vertices[index + 1 * 9 + 1] = y2;
vertices[index + 2 * 9 + 0] = x3; vertices[index + 2 * 9 + 1] = y3;
vertices[index + 3 * 9 + 0] = x4; vertices[index + 3 * 9 + 1] = y4;



vertices[index+0*9+3] = u;vertices[index+0*9+4] =v2;
vertices[index+1*9+3] = u;vertices[index+1*9+4] =v;
vertices[index+2*9+3] =u2;vertices[index+2*9+4] =v;
vertices[index+3*9+3] =u2;vertices[index+3*9+4] =v2;

	


vertices[index+0*9+5] = r;vertices[index+0*9+6] = g;vertices[index+0*9+7] = b;vertices[index+0*9+8] = a;
vertices[index+1*9+5] = r;vertices[index+1*9+6] = g;vertices[index+1*9+7] = b;vertices[index+1*9+8] = a;
vertices[index+2*9+5] = r;vertices[index+2*9+6] = g;vertices[index+2*9+7] = b;vertices[index+2*9+8] = a;
vertices[index+3*9+5] = r;vertices[index+3*9+6] = g;vertices[index+3*9+7] = b;vertices[index+3*9+8] = a;



	for (i in 0...4)
		{
			var x:Float = vertices[index + i * 9 + 0];
			var y:Float = vertices[index + i * 9 + 1];
			vertices[index + i * 9 + 0] = m.a * x + m.c * y + m.tx;
		    vertices[index + i * 9 + 1] = m.d * y + m.b * x + m.ty;
		}		
 
this.currentBatchSize++;
}
}
	
public  inline  function renderVertexRotateScale(texture:Texture,clip:Clip, X:Float, Y:Float, spin:Float,size:Float,blendMode:Int=0)
{
	
  var  xOffset:Float = (clip.width   /2);
  var  yOffset:Float = (clip.height / 2);
		
	
 var  TX1 = -xOffset * size;
 var  TY1 = -yOffset * size;
 var  TX2 = (clip.width - xOffset) * size;
 var  TY2 = (clip.height - yOffset) * size;

 var CosT:Float  = Math.cos(spin);
 var SinT:Float  = Math.sin(spin);
                 	
      drawVertex(texture,
 TX1 * CosT - TY1 * SinT + X,TX1 * SinT + TY1 * CosT + Y,
 TX2 * CosT - TY1 * SinT + X,TX2 * SinT + TY1 * CosT + Y,
 TX2 * CosT - TY2 * SinT + X,TX2 * SinT + TY2 * CosT + Y,
 TX1 * CosT - TY2 * SinT + X,TX1 * SinT + TY2 * CosT + Y,
 
 clip, 1, 1, 1, 1, blendMode);

	
			
	      
}


	public  inline  function drawVertex(texture:Texture,
    
		 x1:Float,
		 y1:Float,
		 x2:Float,
		 y2:Float,
		 x3:Float,
		 y3:Float,
		 x4:Float,
		 y4:Float,
 	     clip:Clip, 
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	





var index:Int = currentBatchSize *  vertexStrideSize;

					



		
		
		
		
				
 var u:Float  = clip.x * invTexWidth;
 var u2:Float = (clip.x + clip.width) * invTexWidth;
 
 var v:Float  = (clip.y + clip.height) * invTexHeight;
 var v2:Float = clip.y * invTexHeight;
 
 

 
vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}

	
		
	public  inline function drawVertexFlip(texture:Texture,
    
		 x1:Float,
		 y1:Float,
		 x2:Float,
		 y2:Float,
		 x3:Float,
		 y3:Float,
		 x4:Float,
		 y4:Float,
 	     clip:Clip, 
	     r:Float,g:Float,b:Float,a:Float,flipX:Bool,flipY:Bool,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
var index:Int = currentBatchSize *  vertexStrideSize;



var widthTex:Int  = texture.width;
var heightTex:Int = texture.height;


 
 if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {

   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
   

 
  }			
 
 
 /*

  var u:Float  = clip.x * invTexWidth;
 var u2:Float = (clip.x + clip.width) * invTexWidth;
 var v:Float  = (clip.y + clip.height) * invTexHeight;
 var v2:Float = clip.y * invTexHeight;
 
 var u:Float  = clip.x /tw;
 var u2:Float = (clip.x + clip.width)  /tw;
 var v:Float  = (clip.y + clip.height) / th;
 var v2:Float = clip.y / th;
*/
 
 if (flipX) {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipY) {
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		} 
 
vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = right; vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
	
	public    function RenderScaleRotateColorAlpha(texture:Texture,x:Float, y:Float,ScaleX:Float,ScaleY:Float,Rotation:Float,r:Float,g:Float,b:Float,Alpha:Float,blendMode:Int)
	{
	
  var  xOffset:Float = (texture.width   /2);
  var  yOffset:Float = (texture.height / 2);
		
	
 var  TX1 = -xOffset * ScaleX;
 var  TY1 = -yOffset * ScaleY;
 var  TX2 = (texture.width - xOffset) * ScaleX;
 var  TY2 = (texture.height - yOffset) * ScaleY;

 var CosT:Float  = Math.cos(Rotation);
 var SinT:Float  = Math.sin(Rotation);
                 	
      drawVertexTexture(texture,
 TX1 * CosT - TY1 * SinT + x,TX1 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY1 * SinT + x,TX2 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY2 * SinT + x,TX2 * SinT + TY2 * CosT + y,
 TX1 * CosT - TY2 * SinT + x,TX1 * SinT + TY2 * CosT + y,
 
 r,g,b, Alpha, blendMode);

	}
	
	public    function RenderScaleRotateAlpha(texture:Texture,x:Float, y:Float,Scale:Float,Rotation:Float,Alpha:Float,blendMode:Int)
	{
	
  var  xOffset:Float = (texture.width   /2);
  var  yOffset:Float = (texture.height / 2);
		
	
 var  TX1 = -xOffset * Scale;
 var  TY1 = -yOffset * Scale;
 var  TX2 = (texture.width - xOffset) * Scale;
 var  TY2 = (texture.height - yOffset) * Scale;

 var CosT:Float  = Math.cos(Rotation);
 var SinT:Float  = Math.sin(Rotation);
                 	
      drawVertexTexture(texture,
 TX1 * CosT - TY1 * SinT + x,TX1 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY1 * SinT + x,TX2 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY2 * SinT + x,TX2 * SinT + TY2 * CosT + y,
 TX1 * CosT - TY2 * SinT + x,TX1 * SinT + TY2 * CosT + y,
 
  1, 1, 1, Alpha, blendMode);

	}
	
	
	public  inline  function drawVertexTexture(texture:Texture,
    
		 x1:Float,
		 y1:Float,
		 x2:Float,
		 y2:Float,
		 x3:Float,
		 y3:Float,
		 x4:Float,
		 y4:Float,
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	





var index:Int = currentBatchSize *  vertexStrideSize;

					



		
		
		
		
				
 var u:Float  = 0;
 var u2:Float = 1;
 
 var v:Float  = 1;
 var v2:Float = 0;
 
 

 
vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
	
		public    function RenderScaleRotateClipColorAlpha(texture:Texture,x:Float, y:Float,ScaleX:Float,ScaleY:Float,Rotation:Float,clip:Clip,r:Float,g:Float,b:Float,Alpha:Float,blendMode:Int)
	{
	
  var  xOffset:Float = (clip.width   / 2);
  var  yOffset:Float = (clip.height / 2);
		
	
 var  TX1 = -xOffset * ScaleX;
 var  TY1 = -yOffset * ScaleY;
 var  TX2 = (clip.width - xOffset) * ScaleX;
 var  TY2 = (clip.height - yOffset) * ScaleY;

 var CosT:Float  = Math.cos(Rotation);
 var SinT:Float  = Math.sin(Rotation);
                 	
      drawVertexTextureClip(texture,
 TX1 * CosT - TY1 * SinT + x,TX1 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY1 * SinT + x,TX2 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY2 * SinT + x,TX2 * SinT + TY2 * CosT + y,
 TX1 * CosT - TY2 * SinT + x,TX1 * SinT + TY2 * CosT + y,
 clip,
 r,g,b, Alpha, blendMode);

	}
	
	public  inline  function drawVertexTextureClip(texture:Texture,
    
		 x1:Float,
		 y1:Float,
		 x2:Float,
		 y2:Float,
		 x3:Float,
		 y3:Float,
		 x4:Float,
		 y4:Float,
		 clip:Clip,
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	





var index:Int = currentBatchSize *  vertexStrideSize;

					



		
		
		
		


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		

 
 

 
vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = right; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
	
	//******************
	public    function RenderScaleRotateClipFlipColorAlpha(texture:Texture,x:Float, y:Float,ScaleX:Float,ScaleY:Float,Rotation:Float,clip:Clip,flipx:Bool,flipy:Bool,r:Float,g:Float,b:Float,Alpha:Float,blendMode:Int)
	{
	
  var  xOffset:Float = (clip.width   /2);
  var  yOffset:Float = (clip.height / 2);
		
	
 var  TX1 = -xOffset * ScaleX;
 var  TY1 = -yOffset * ScaleY;
 var  TX2 = (clip.width - xOffset) * ScaleX;
 var  TY2 = (clip.height - yOffset) * ScaleY;

 var CosT:Float  = Math.cos(Rotation);
 var SinT:Float  = Math.sin(Rotation);
                 	
      drawVertexTextureClipFlip(texture,
 TX1 * CosT - TY1 * SinT + x,TX1 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY1 * SinT + x,TX2 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY2 * SinT + x,TX2 * SinT + TY2 * CosT + y,
 TX1 * CosT - TY2 * SinT + x,TX1 * SinT + TY2 * CosT + y,
 clip,flipx,flipy,
 r,g,b, Alpha, blendMode);

	}
	public    function RenderScaleRotateClipFlipColorAlphaOffset(texture:Texture,x:Float, y:Float,xOffset:Float,yOffset:Float,ScaleX:Float,ScaleY:Float,Rotation:Float,clip:Clip,flipx:Bool,flipy:Bool,r:Float,g:Float,b:Float,Alpha:Float,blendMode:Int)
	{
	

		
	
 var  TX1 = -xOffset * ScaleX;
 var  TY1 = -yOffset * ScaleY;
 var  TX2 = (clip.width - xOffset) * ScaleX;
 var  TY2 = (clip.height - yOffset) * ScaleY;

 var CosT:Float  = Math.cos(Rotation);
 var SinT:Float  = Math.sin(Rotation);
                 	
      drawVertexTextureClipFlip(texture,
 TX1 * CosT - TY1 * SinT + x,TX1 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY1 * SinT + x,TX2 * SinT + TY1 * CosT + y,
 TX2 * CosT - TY2 * SinT + x,TX2 * SinT + TY2 * CosT + y,
 TX1 * CosT - TY2 * SinT + x,TX1 * SinT + TY2 * CosT + y,
 clip,flipx,flipy,
 r,g,b, Alpha, blendMode);

	}
	public  inline  function drawVertexTextureClipFlip(texture:Texture,
    
		 x1:Float,
		 y1:Float,
		 x2:Float,
		 y2:Float,
		 x3:Float,
		 y3:Float,
		 x4:Float,
		 y4:Float,
		 clip:Clip,
		 flipx:Bool,flipy:Bool,
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	





var index:Int = currentBatchSize *  vertexStrideSize;

					



		
		
		
		


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		

 
  if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		

 
vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = right; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] =left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
	
	//******************
	public    function RenderNormal(texture:Texture, x:Float, y:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
 var u:Float = 0;
 var v:Float = 0;
 var u2:Float = 1;
 var v2:Float = 1;
 var fx2:Float = x + texture.width;
 var fy2:Float = y + texture.height;





var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


    currentBatchSize++;

	}
	
	public    function RenderNormalSize(texture:Texture, x:Float, y:Float, w:Float, h:Float,
	r:Float, g:Float, b:Float, a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
 var u:Float = 0;
 var v:Float = 1;
 var u2:Float = 1;
 var v2:Float = 0;
 var fx2:Float = x + w;
 var fy2:Float = y + h;





var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;

	}
	public    function RenderNormalSizeScroll(texture:Texture, x:Float, y:Float,w:Float,h:Float,xAmount:Float, yAmount:Float,blendMode:Int,?depht:Float=0)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
 var u:Float = 0;
 var v:Float = 0;
 var u2:Float = 1;
 var v2:Float = 1;
 
 if (xAmount != 0) {
			var width:Float = (u2 - u) * texture.width;
			u = (u + xAmount) % 1;
			u2 = u + width / texture.width;
		}
		if (yAmount != 0) 
		{
			var height:Float = (v2 - v) * texture.height;
			v = (v + yAmount) % 1;
			v2 = v + height / texture.height;
		}
		
 var fx2:Float = x + w;
 var fy2:Float = y + h;





var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = depht;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;vertices[index++] = 1;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = depht;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = depht;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = depht;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1; vertices[index++] = 1;


    currentBatchSize++;

	}
	public    function RenderNormalSizeScrollColor(texture:Texture, x:Float, y:Float, w:Float, h:Float, xAmount:Float, yAmount:Float,
	r:Float, g:Float, b:Float, a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
 var u:Float = 0;
 var v:Float = 0;
 var u2:Float = 1;
 var v2:Float = 1;
 
 if (xAmount != 0) {
			var width:Float = (u2 - u) * texture.width;
			u = (u + xAmount) % 1;
			u2 = u + width / texture.width;
		}
		if (yAmount != 0) 
		{
			var height:Float = (v2 - v) * texture.height;
			v = (v + yAmount) % 1;
			v2 = v + height / texture.height;
		}
		
 var fx2:Float = x + w;
 var fy2:Float = y + h;





var index:Int = currentBatchSize *  vertexStrideSize;

vertices[index++] = x;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = fy2;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = fx2;
vertices[index++] = y;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;

	}
	
	

		
		public    function drawImage(tex:Texture, 
	x:Float, y:Float, 
	width:Float, height:Float,
	scaleX:Float, scaleY:Float,
	angle:Float,
	originX:Float, originY:Float,
	clip:Clip,
	flipX:Bool,flipY:Bool,
	r:Float, g:Float, b:Float, a:Float,blendMode:Int)
	{
		if(tex!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(tex);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	







var index:Int = currentBatchSize *  vertexStrideSize;

					
		var worldOriginX:Float = x + originX;
		var worldOriginY:Float = y + originY;
		var fx:Float = -originX;
		var fy:Float = -originY;
		var fx2:Float = width - originX;
		var fy2:Float = height - originY;
		
		if (scaleX != 1 || scaleY != 1)
		{
			fx *= scaleX;
			fy *= scaleY;
			fx2 *= scaleX;
			fy2 *= scaleY;
		}
		
		var p1x:Float = fx;
		var p1y:Float = fy;
		var p2x:Float = fx;
		var p2y:Float = fy2;
		var p3x:Float = fx2;
		var p3y:Float = fy2;
		var p4x:Float = fx2;
		var p4y:Float = fy;

		var x1:Float;
		var y1:Float;
		var x2:Float;
		var y2:Float;
		var x3:Float;
		var y3:Float;
		var x4:Float;
		var y4:Float;
		
		
		
			if (angle != 0) 
			{
		
	                var angle:Float = angle * Math.PI / 180;
					//var cos:Float = Util.Cos(angle);// Math.cos(angle);
					//var sin:Float = Util.Sin(angle);// Math.sin(angle);
					var cos:Float = Math.cos(angle);
					var sin:Float =  Math.sin(angle);
					
			x1 = cos * p1x - sin * p1y;
			y1 = sin * p1x + cos * p1y;

			x2 = cos * p2x - sin * p2y;
			y2 = sin * p2x + cos * p2y;

			x3 = cos * p3x - sin * p3y;
			y3 = sin * p3x + cos * p3y;

			x4 = x1 + (x3 - x2);
			y4 = y3 - (y2 - y1);
		} else {
			x1 = p1x;
			y1 = p1y;

			x2 = p2x;
			y2 = p2y;

			x3 = p3x;
			y3 = p3y;

			x4 = p4x;
			y4 = p4y;
		}

		x1 += worldOriginX;
		y1 += worldOriginY;
		x2 += worldOriginX;
		y2 += worldOriginY;
		x3 += worldOriginX;
		y3 += worldOriginY;
		x4 += worldOriginX;
		y4 += worldOriginY;
		
				
	

  var widthTex:Int  = tex.width;
  var heightTex:Int = tex.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		

 
  if (flipX) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipY)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
 
vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = left;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
		
	
	public    function drawImageEx(tex:Texture, 
	x:Float, y:Float, 
	width:Float, height:Float,
	scaleX:Float, scaleY:Float,
	angle:Float,
	originX:Float, originY:Float,
	clip:Clip,
	flipX:Bool,flipY:Bool,
	r:Float, g:Float, b:Float, a:Float,blendMode:Int)
	{
		if(tex!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(tex);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	







var index:Int = currentBatchSize *  vertexStrideSize;

					
		var worldOriginX:Float = x + originX;
		var worldOriginY:Float = y + originY;
		var fx:Float = -originX;
		var fy:Float = -originY;
		var fx2:Float = width - originX;
		var fy2:Float = height - originY;
		
		if (scaleX != 1 || scaleY != 1)
		{
			fx *= scaleX;
			fy *= scaleY;
			fx2 *= scaleX;
			fy2 *= scaleY;
		}
		
		var p1x:Float = fx;
		var p1y:Float = fy;
		var p2x:Float = fx;
		var p2y:Float = fy2;
		var p3x:Float = fx2;
		var p3y:Float = fy2;
		var p4x:Float = fx2;
		var p4y:Float = fy;

		var x1:Float;
		var y1:Float;
		var x2:Float;
		var y2:Float;
		var x3:Float;
		var y3:Float;
		var x4:Float;
		var y4:Float;
		
		
		
			if (angle != 0) 
			{
		
	                var angle:Float = angle * Math.PI / 180;
					var cos:Float = Math.cos(angle);
					var sin:Float = Math.sin(angle);
					
			x1 = cos * p1x - sin * p1y;
			y1 = sin * p1x + cos * p1y;

			x2 = cos * p2x - sin * p2y;
			y2 = sin * p2x + cos * p2y;

			x3 = cos * p3x - sin * p3y;
			y3 = sin * p3x + cos * p3y;

			x4 = x1 + (x3 - x2);
			y4 = y3 - (y2 - y1);
		} else {
			x1 = p1x;
			y1 = p1y;

			x2 = p2x;
			y2 = p2y;

			x3 = p3x;
			y3 = p3y;

			x4 = p4x;
			y4 = p4y;
		}

		x1 += worldOriginX;
		y1 += worldOriginY;
		x2 += worldOriginX;
		y2 += worldOriginY;
		x3 += worldOriginX;
		y3 += worldOriginY;
		x4 += worldOriginX;
		y4 += worldOriginY;
		
				
 var u:Float  = clip.x * invTexWidth;
 var u2:Float = (clip.x + clip.width) * invTexWidth;
 
 var v:Float  = (clip.y + clip.height) * invTexHeight;
 var v2:Float = clip.y * invTexHeight;
 
 

 
 if (flipX) {
			var tmp:Float = u;
			u = u2;
			u2 = tmp;
		}

		if (flipY) {
			var tmp:Float = v;
			v = v2;
			v2 = tmp;
		}
 
vertices[index++] = x1;
vertices[index++] = y1;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = x2;
vertices[index++] = y2;
vertices[index++] = 0;
vertices[index++] = u;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x3;
vertices[index++] = y3;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = x4;
vertices[index++] = y4;
vertices[index++] = 0;
vertices[index++] = u2;vertices[index++] = v2;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
	/*
	public  inline  function drawMatrix2DTextureClipFlip(texture:Texture,
    
		 m:Matrix2D,
		 clip:Clip,
		 flipx:Bool,flipy:Bool,
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	
var index:Int = currentBatchSize *  vertexStrideSize;

		
		


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		

 
  if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		
  var pos = transformQuad(m,0, 0, clip.width, clip.height);
 
vertices[index++] = pos[0];
vertices[index++] = pos[1];
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = pos[2];
vertices[index++] = pos[3];
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = pos[4];
vertices[index++] = pos[5];
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = pos[6];
vertices[index++] = pos[7];
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
	public  inline  function drawMatrix2DTextureClipFlipSrc(texture:Texture,
    
	     x:Float, y:Float, w:Float, h:Float,
		 tv:Float,tu:Float,
		 m:Matrix2D,
		 clip:Clip,
		 flipx:Bool,flipy:Bool,
	     r:Float,g:Float,b:Float,a:Float,blendMode:Int)
	{
	if(texture!= this.currentBaseTexture || this.currentBatchSize >= this.capacity)
    {
       		switchTexture(texture);
    }


    // check blend mode
    if(blendMode != this.currentBlendMode)
    {
        this.setBlendMode(blendMode);
    }
	
	
var index:Int = currentBatchSize *  vertexStrideSize;

		
		


  var widthTex:Int  = texture.width;
  var heightTex:Int = texture.height;


  
  if (FIX_ARTIFACTS_BY_STRECHING_TEXEL)
  {
   left = (2*clip.x+1) / (2*widthTex);
   right =  left +(clip.width*2-2) / (2*widthTex);
   top = (2*clip.y+1) / (2*heightTex);
   bottom = top +(clip.height * 2 - 2) / (2 * heightTex);



}else
  {
   left = clip.x / widthTex;
   right =  (clip.x + clip.width) / widthTex;
   top = clip.y / heightTex;
   bottom = (clip.y + clip.height) / heightTex;
  }			
  
		
  left *= tv;
  right *= tv;
  top *= tu;
  bottom *= tu;

 
  if (flipx) 
 {
			var tmp:Float = left;
			left = right;
			right = tmp;
		}

		if (flipy)
		{
			var tmp:Float = top;
			top = bottom;
			bottom = tmp;
		}
		
  var pos = transformQuad(m,x,y,w,h);
 
vertices[index++] = pos[0];
vertices[index++] = pos[1];
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;
	
vertices[index++] = pos[2];
vertices[index++] = pos[3];
vertices[index++] = 0;
vertices[index++] = right;vertices[index++] = top;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = pos[4];
vertices[index++] = pos[5];
vertices[index++] = 0;
vertices[index++] =right;vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;

vertices[index++] = pos[6];
vertices[index++] = pos[7];
vertices[index++] = 0;
vertices[index++] = left; vertices[index++] = bottom;
vertices[index++] = r;vertices[index++] = g;vertices[index++] = b;vertices[index++] = a;


    currentBatchSize++;
	
	}
	*/


	
	public  function Begin()
	{

		Gdx.Instance().setCullFace(false);
		Gdx.Instance().setBlend(true);
		Gdx.Instance().setDepthTest(true);
		Gdx.Instance().setDepthMask(false);
		
		 currentBatchSize = 0;
		 currentBaseTexture = null;
		 currentBlendMode = -1;
		 
	shader.Bind(camera.viewMatrix, camera.projMatrix, transform);
	
	GL.enableVertexAttribArray (shader.vertexAttribute);
	GL.enableVertexAttribArray (shader.texCoord0Attribute);
	GL.enableVertexAttribArray (shader.colorAttribute);
	
	
	
	
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
     GL.vertexAttribPointer(shader.vertexAttribute, 3, GL.FLOAT, false, vertexStrideSize, 0);
     GL.vertexAttribPointer(shader.texCoord0Attribute  , 2, GL.FLOAT, false, vertexStrideSize, 3 * 4);
     GL.vertexAttribPointer(shader.colorAttribute, 4, GL.FLOAT, false, vertexStrideSize, (3+2) * 4);
     if(currentBlendMode != BlendMode.NORMAL)
     {
        setBlendMode(currentBlendMode);
     }
	}
	public   function End()
	{
	  flush();
	}
	

	
private   function flush()
{
    if (currentBatchSize == 0) return;

	shader.setTexture0(currentBaseTexture);
    
		
	
//    GL.bufferSubData(GL.ARRAY_BUFFER, 0, vertices);
    GL.bufferData(GL.ARRAY_BUFFER, vertices, GL.STATIC_DRAW);
	GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
    GL.drawElements(GL.TRIANGLES, currentBatchSize * 6, GL.UNSIGNED_SHORT, 0);
    currentBatchSize = 0;
}
private   function switchTexture (texture:Texture) 
{
this.flush();
this.currentBaseTexture = texture;
invTexWidth  = 1.0 / texture.width;
invTexHeight = 1.0 / texture.height;
}

public   function setBlendMode(blendMode:Int)
{
    flush();
    currentBlendMode = blendMode;
    BlendMode.setBlend(currentBlendMode);

}
   public function dispose():Void 
{
	this.vertices = null;
	GL.deleteBuffer(indexBuffer);
	GL.deleteBuffer(vertexBuffer);

	
}


}