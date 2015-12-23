package com.gdx.gl ;




import com.gdx.Buffer;
import com.gdx.gl.shaders.ColorShader;
import com.gdx.math.BoundingBox;
import com.gdx.math.Matrix;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.util.Util;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;







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
class Imidiatemode extends Buffer

{
	public var colorBuffer:GLBuffer;
	public var colorIndex:Int;
	public var colors:Float32Array;
	public var vertexBuffer:GLBuffer;
	public var vertices:Float32Array;


	public var fcolorBuffer:GLBuffer;
	public var fcolorIndex:Int;
	public var fcolors:Float32Array;
	public var fvertexBuffer:GLBuffer;
	public var fvertices:Float32Array;

	
    private var capacity:Int;

	private var shader:ColorShader;

	private var alpha:Float = 1;
	public var _red:Float=1;
	public var _green:Float=1;
	public var _blue:Float=1;
	   
	private var cp:Vector2 = new Vector2(0, 0);

	private var currentBlendMode:Int;


	private var idxCols:Int;
	private var idxPos:Int;


	
    private var fidxCols:Int;
	private var fidxPos:Int;
	
	private var primitiveCount:Int;
	private var fprimitiveCount:Int;

	
   

   



  




	
	public function new(capacity:Int) 
	{
		super();
    shader = cast( Gdx.Instance().materials[Gdx.SHADERCOLOR], ColorShader);

	this.vertexBuffer =  GL.createBuffer();
	this.colorBuffer =  GL.createBuffer();

	this.fvertexBuffer =  GL.createBuffer();
	this.fcolorBuffer =  GL.createBuffer();

	primitiveCount = 0;
	fprimitiveCount = 0;
	this.capacity = capacity;

    idxPos=0;
	idxCols = 0;

	fidxPos=0;
	fidxCols = 0;




    vertices = new Float32Array(capacity * 3 * 4 *4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
	GL.bufferData(GL.ARRAY_BUFFER,this.vertices , GL.DYNAMIC_DRAW);
	colors = new Float32Array(capacity * 4 * 4 * 4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.colorBuffer);
	GL.bufferData(GL.ARRAY_BUFFER, this.colors , GL.DYNAMIC_DRAW);
    
	fvertices = new Float32Array(capacity * 3 *4*4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.fvertexBuffer);
	GL.bufferData(GL.ARRAY_BUFFER,this.fvertices , GL.DYNAMIC_DRAW);
	fcolors = new Float32Array(capacity * 4 * 4*4);
	GL.bindBuffer(GL.ARRAY_BUFFER, this.fcolorBuffer);
	GL.bufferData(GL.ARRAY_BUFFER, this.fcolors , GL.DYNAMIC_DRAW);

	}
	
	
	
public function fvertex(x:Float, y:Float, ?z:Float = 0.0)
{
		fvertices[fidxPos++] = x;
        fvertices[fidxPos++] = y;
        fvertices[fidxPos++] = z;
	
}
public function fcolor(r:Float, g:Float,b:Float, ?a:Float =0.0)
	{
	fcolors[fidxCols++] = r;
	fcolors[fidxCols++] = g;
	fcolors[fidxCols++] = b;
	fcolors[fidxCols++] = a;	
	}
	
public function vertex(x:Float, y:Float, ?z:Float = 0.0)
{
		vertices[idxPos++] = x;
        vertices[idxPos++] = y;
        vertices[idxPos++] = z;
	
	
}
public function color(r:Float, g:Float,b:Float, ?a:Float =0.0)
	{
	colors[idxCols++] = r;
	colors[idxCols++] = g;
	colors[idxCols++] = b;
	colors[idxCols++] = a;	
	}


	public function reset()
	{
	 idxPos=0;
	 idxCols = 0;
	  fidxPos=0;
	 fidxCols = 0;
	 fprimitiveCount = 0;
	 primitiveCount = 0;
	 

	}
	
    public function render(camera:Camera,mat:Matrix)
	{
	
		Gdx.Instance().setCullFace(false);
	//	Gdx.Instance().setBlend(true);
		Gdx.Instance().setDepthMask(true);
		Gdx.Instance().setDepthTest(true);

  
 
	
		 shader.Bind(camera.viewMatrix, camera.projMatrix, mat);
		
	     GL.enableVertexAttribArray (shader.vertexAttribute);
    	 GL.enableVertexAttribArray (shader.colorAttribute);

	 

	

	if(idxPos >= 1)
{
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);	
     GL.bufferData(GL.ARRAY_BUFFER, this.vertices , GL.STATIC_DRAW);
	 GL.vertexAttribPointer(shader.vertexAttribute, 3, GL.FLOAT, false, 0, 0);
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.colorBuffer);
	 GL.bufferData(GL.ARRAY_BUFFER, this.colors , GL.STATIC_DRAW);
	 GL.vertexAttribPointer(shader.colorAttribute, 4, GL.FLOAT, false, 0, 0);
	 GL.drawArrays(GL.LINES, 0, Std.int(primitiveCount*2));			 
} 
	 
	 
	 if(fidxPos >= 1)
{
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.fvertexBuffer);	
     GL.bufferSubData(GL.ARRAY_BUFFER, 0, this.fvertices);
     GL.vertexAttribPointer(shader.vertexAttribute, 3, GL.FLOAT, false, 0, 0);
	 GL.bindBuffer(GL.ARRAY_BUFFER, this.fcolorBuffer);
	 GL.bufferSubData(GL.ARRAY_BUFFER, 0, this.fcolors);
     GL.vertexAttribPointer(shader.colorAttribute, 4, GL.FLOAT, false, 0, 0);
     GL.drawArrays(Gdx.GLTRIANGLES, 0, Std.int(fprimitiveCount*3));			 

}

  
	 
	}


	
	//**********
	
public function line(x1:Float,y1:Float,x2:Float,y2:Float,r:Float,g:Float,b:Float,?a:Float=1)
{

vertex(x1, y1);
color(r, g, b, a);
vertex(x2, y2);
color(r, g, b, a);
primitiveCount += 1;
}
public function lineVector(va:Vector3,vb:Vector3,r:Float,g:Float,b:Float,?a:Float=1)
{

vertex(va.x,va.y,va.z);
color(r, g, b, a);
vertex(vb.x,vb.y,vb.z);
color(r, g, b, a);
primitiveCount += 1;
}



public function drawFillTriangle(va:Vector3,vb:Vector3,vc:Vector3,r:Float,g:Float,b:Float,?a:Float=1)
{

fvertex(va.x,va.y,va.z);
fcolor(r, g, b, a);
fvertex(vb.x,vb.y,vb.z);
fcolor(r, g, b, a);
fvertex(vc.x,vc.y,vc.z);
fcolor(r, g, b, a);
fprimitiveCount += 1;
}
public function drawTriangle(va:Vector3,vb:Vector3,vc:Vector3,r:Float,g:Float,b:Float,?a:Float=1)
{

vertex(va.x,va.y,va.z);
color(r, g, b, a);
vertex(vb.x,vb.y,vb.z);
color(r, g, b, a);
vertex(vc.x,vc.y,vc.z);
color(r, g, b, a);
primitiveCount += 1;
}
public function line3D(x1:Float,y1:Float,z1:Float,x2:Float,y2:Float,z2:Float,r:Float=1,g:Float=1,b:Float=1,?a:Float=1)
{

vertex(x1, y1,z1);
color(r, g, b, a);
vertex(x2, y2,z2);
color(r, g, b, a);
primitiveCount += 1;
}



public function setColor(color:Int = 0, alpha:Float = 1.0):Void
{
	    this.alpha = alpha;
      	color &= 0xFFFFFF;
	    _red = Util.getRed(color) / 255;
		_green = Util.getGreen(color) / 255;
		_blue = Util.getBlue(color) / 255;
}






public function drawABBox(box:BoundingBox,r:Float,g:Float,b:Float)
	{
			
		  var center:Vector3 = box.center;
	 	 var diag:Vector3 = center.subtract(box.maximum);
		 
		 line3D(center.x - diag.x, center.y - diag.y, center.z + diag.z, center.x + diag.x, center.y - diag.y, center.z + diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y - diag.y, center.z + diag.z, center.x + diag.x, center.y - diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y - diag.y, center.z - diag.z, center.x - diag.x, center.y - diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y - diag.y, center.z - diag.z, center.x - diag.x, center.y - diag.y, center.z + diag.z, r,g,b, 1);
		 
		 line3D(center.x + diag.x, center.y + diag.y, center.z + diag.z, center.x + diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y + diag.y, center.z - diag.z, center.x - diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y + diag.y, center.z - diag.z, center.x - diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y + diag.y, center.z + diag.z, center.x + diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 
		 line3D(center.x + diag.x, center.y - diag.y, center.z + diag.z, center.x + diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y - diag.y, center.z - diag.z, center.x + diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y - diag.y, center.z - diag.z, center.x - diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y - diag.y, center.z + diag.z, center.x - diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 
		 
		 
		
		
		

		
	}

public function drawOBBox(box:BoundingBox,r:Float,g:Float,b:Float)
	{
			
		  var center:Vector3 = box.center;
	 	 var diag:Vector3 = center.subtract(box.maximumWorld);
		 
		 line3D(center.x - diag.x, center.y - diag.y, center.z + diag.z, center.x + diag.x, center.y - diag.y, center.z + diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y - diag.y, center.z + diag.z, center.x + diag.x, center.y - diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y - diag.y, center.z - diag.z, center.x - diag.x, center.y - diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y - diag.y, center.z - diag.z, center.x - diag.x, center.y - diag.y, center.z + diag.z, r,g,b, 1);
		 
		 line3D(center.x + diag.x, center.y + diag.y, center.z + diag.z, center.x + diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y + diag.y, center.z - diag.z, center.x - diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y + diag.y, center.z - diag.z, center.x - diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y + diag.y, center.z + diag.z, center.x + diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 
		 line3D(center.x + diag.x, center.y - diag.y, center.z + diag.z, center.x + diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 line3D(center.x + diag.x, center.y - diag.y, center.z - diag.z, center.x + diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y - diag.y, center.z - diag.z, center.x - diag.x, center.y + diag.y, center.z - diag.z, r,g,b, 1);
		 line3D(center.x - diag.x, center.y - diag.y, center.z + diag.z, center.x - diag.x, center.y + diag.y, center.z + diag.z, r,g,b, 1);
		 
		 
		 
		
		
		

		
	}

 override public function dispose():Void 
{
	super.dispose();
	 
		this.vertices = null;
		this.colors = null;
    	GL.deleteBuffer(vertexBuffer);
		GL.deleteBuffer(colorBuffer);
	
		
}


}