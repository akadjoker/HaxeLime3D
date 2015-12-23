package com.gdx.scene3d.particles ;


import com.gdx.Gdx;
import com.gdx.gl.BlendMode;
import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.Texture;
import com.gdx.gl.VertexBuffer;
import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.util.Clip;
import com.gdx.util.Util;
import lime.graphics.opengl.GL;
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
class BilboardStaticBatch  extends Node
{

	
	private var vertexStrideSize:Int;

	
	private	var vert_tex_coords:Float32Array;
	private var vert_col :Float32Array;
	private	var vert_coords:Float32Array;
	private var currentBatchSize:Int;
	private var vertexbuffer:VertexBuffer;
	private var clip:Array<Clip>;
	public var material:Material;
	private var horizontal:Vector3 = Vector3.Zero();
	private var vertical:Vector3 = Vector3.Zero();
	private var invTexWidth:Float = 0;
     private var invTexHeight:Float = 0;
	 private var dirt:Bool = false ;
	 private var numParticles:Int;
	

  
    public function new (?parent:Node=null,?id:Int=0,?Name:String="BillBoard") 
    {
        super(parent, name,id);
		
		 clip = [];
	 	material = new Material();
		material.CullingFace = false;
		material.DepthMask = true;
		material.DepthTest = true;
		material.BlendType = BlendMode.NORMAL;
		material.BlendFace = true;
		numParticles = 0;
		decales=[];
		dirt = true;
		
		
    }
    override public function debug(lines:Imidiatemode):Void
	{
		lines.drawABBox(Bounding, 1, 0, 0);
		
	
	}
	
	
	override public function getMaterial(index:Int):Material
	{
		return material;
		
	}
	public function addBillboard( pos:Vector3, size:Float,frame:Int=0,type:Int=1):Void
	{
		Bounding.addInternalPoint(pos.x + size, pos.y + size, pos.z + size);
		Bounding.addInternalVector(pos);
		Bounding.addInternalPoint(pos.x - size, pos.y - size, pos.z - size);
	
		var b = new BillSprite(pos, size, 1, type);
		b.reset(pos, size, 1, frame, type);
		decales.push(b);
		
		numParticles++;
		dirt = true;
		boundChanged = true;
	}
	public function addGrass( pos:Vector3, size:Float,frame:Int=0):Void
	{
		addBillboard(pos, size,  frame, 1);
		addBillboard(pos, size,  frame, 3);


	}
	public function  count():Int
	{
		return this.decales.length;
	}
	public function setTexture(tex:Texture,frameWidth:Int=0, frameHeight:Int=0)
	{
		  material.setTexture(tex);

		if (frameWidth != 0 && frameHeight != 0)
		{
		var row:Int = Math.floor(tex.width / frameWidth);
		var column:Int = Math.floor(tex.height / frameHeight);
		var index:Int = 0;
		for (i in 0 ... row)
		{
			for (j in 0 ... column)
			{
				    var frame:Clip = new Clip (i * frameWidth, j * frameHeight, frameWidth, frameHeight, 0, 0);
				    clip.push(frame);
					index++;
			}
		}
		} else
		{
			 var frame:Clip = new Clip (0,0,tex.width,tex.height, 0, 0);
			clip.push(frame);
		}
		invTexWidth  = 1.0 / tex.width;
        invTexHeight = 1.0 / tex.height;
	}

	private  function Build():Void
	{
		
		
	
    InitWithTotal(numParticles);		

    for (ii in 0...decales.length)
    {
	              var particle = decales[ii];
				 var   xOffset =   ( clip[particle.frame].width  / 2   * particle.size)/100;
                 var   yOffset =   ( clip[particle.frame].height / 2   * particle.size)/100;
			          
						 
			 switch (particle.type)
			 {
				
					 case 1:
						 {

					  
						   horizontal.set(1 * xOffset, 0 * xOffset, 0 * xOffset); 
			                           vertical.set  (0 * yOffset, 1 * yOffset, 0 * yOffset);	 
					
						    	    	      drawBillboard(ii, horizontal, vertical, particle);
					  
						 }
						 case 2:
						 {
							 
						     horizontal.set(1 * xOffset, 0 * xOffset, 0 * xOffset); 
			                 vertical.set  (0 * yOffset, 0 * yOffset, 1 * yOffset);
						     drawBillboard(ii, horizontal, vertical, particle);
					
						 }
						 case 3:
						 {
							   horizontal.set(0 * xOffset, 0 * xOffset, 1 * xOffset); 
			                 vertical.set  (0 * yOffset, 1 * yOffset, 0 * yOffset);
							 drawBillboard(ii, horizontal, vertical, particle);
							 
							 
						
						 }
                                              
			 }
			 
	}
	 
		
					
		
		 
		
      

vertexbuffer.setVertex(vert_coords);
vertexbuffer.setUVCoord0(vert_tex_coords);
vertexbuffer.setColors(vert_col);


}
  
	private function InitWithTotal(numberOf:Int)
	{
    	  var indices:Array<Int> = [];
        var index = 0;
		var oldvertices:Int = 0;
        for (count in 0...Std.int(numberOf * 6)) {
            indices.push(index + 0);
            indices.push(index + 2);
            indices.push(index + 1);
            indices.push(index + 0);
            indices.push(index + 3);
            indices.push(index + 2);
            index += 4;
        }
		
		vertexbuffer = new VertexBuffer(Gdx.Instance().materials[Gdx.SHADERGRASS]);
		vertexbuffer.uploadIndices(indices);
		

	    vert_coords    = new Float32Array(numberOf*3*4) ; 
		vert_tex_coords= new Float32Array(numberOf*2*4) ; 
     	vert_col =     new Float32Array(numberOf * 4 * 4) ; 
		
			   
		
		
		
	}
	
  


	 public function drawBillboard(ii:Int,horizontal:Vector3,vertical:Vector3,particle:BillSprite):Void
	{
		    		 
			
	      
		    vert_coords[(ii * 12) + 0] = particle.position.x + horizontal.x + vertical.x;//baixo direita
			vert_coords[(ii * 12) + 1] = particle.position.y + horizontal.y + vertical.y;
			vert_coords[(ii * 12) + 2] = particle.position.z + horizontal.z + vertical.z;
			
			vert_coords[(ii * 12) + 3] = particle.position.x + horizontal.x - vertical.x;//cima direita
			vert_coords[(ii * 12) + 4] = particle.position.y + horizontal.y - vertical.y;
			vert_coords[(ii * 12) + 5] = particle.position.z + horizontal.z - vertical.z;
			
			vert_coords[(ii * 12) + 6] = particle.position.x - horizontal.x - vertical.x;//cima esquerda
			vert_coords[(ii * 12) + 7] = particle.position.y - horizontal.y - vertical.y;
			vert_coords[(ii * 12) + 8] = particle.position.z - horizontal.z - vertical.z;
			
			vert_coords[(ii * 12) + 9]  = particle.position.x - horizontal.x + vertical.x;
			vert_coords[(ii * 12) + 10] = particle.position.y - horizontal.y + vertical.y;
			vert_coords[(ii * 12) + 11] = particle.position.z - horizontal.z + vertical.z;
			
			
			
		
			
 var u:Float = clip[particle.frame].x * invTexWidth;
 var v:Float = (clip[particle.frame].y + clip[particle.frame].height) * invTexHeight;
 var u2:Float = (clip[particle.frame].x + clip[particle.frame].width) * invTexWidth;
 var v2:Float = clip[particle.frame].y * invTexHeight;
			
	  vert_tex_coords [(ii * 8) + 0] = u2; vert_tex_coords [(ii * 8) +1] = v2;
	  vert_tex_coords [(ii * 8) + 2] = u2; vert_tex_coords [(ii * 8) +3] = v;
	  vert_tex_coords [(ii * 8) + 4] = u; vert_tex_coords [(ii * 8) +5] = v;
	  vert_tex_coords [(ii * 8) + 6] = u; vert_tex_coords [(ii * 8) +7] = v2;
	  
	  
	  
	  var alpha:Float =  particle.alpha;
	  

	  
	        vert_col[(ii * 16) + 0] =  1;
			vert_col[(ii * 16) + 1] =  1;
			vert_col[(ii * 16) + 2] =  1;
			vert_col[(ii * 16) + 3] =  alpha;
			
		    vert_col[(ii * 16) + 4] =  1;
			vert_col[(ii * 16) + 5] =  1;
			vert_col[(ii * 16) + 6] =  1;
			vert_col[(ii * 16) + 7] =  alpha;
			
			vert_col[(ii * 16) + 8] =  1;
			vert_col[(ii * 16) + 9] =  1;
			vert_col[(ii * 16) + 10] =  1;
			vert_col[(ii * 16) + 11] =  alpha;
			
		    vert_col[(ii * 16) + 12] =  1;
			vert_col[(ii * 16) + 13] =  1;
			vert_col[(ii * 16) + 14] =  1;
			vert_col[(ii * 16) + 15] =  alpha;

		
		
		 
   	
	}


	
	
override public function render(cam:Camera):Void
	{
		if (dirt)
		{
			this.Build();
			dirt = false;
			return;
		}
	    var mat:Matrix = getWorldTform();

	  
	    if (boundChanged)
		{
			Bounding.calculate();
			Bounding.update(mat);

		}
		
	  if (Bounding.isInFrustum(cam.frustumPlanes))
	  {
				
  
	      vertexbuffer.pipeline.Bind(cam.viewMatrix, cam.projMatrix, mat);
		  vertexbuffer.pipeline.ApplayMaterial(material);
		  
		  
	
	


vertexbuffer.render(GL.TRIANGLES, numParticles * 6);


		Gdx.Instance().numVertex     += numParticles *4 ;
		Gdx.Instance().numTris += numParticles * 2 ;
		
		
			    
	        if(vertexbuffer.pipeline.vertexAttribute!=-1)  GL.disableVertexAttribArray (vertexbuffer.pipeline.vertexAttribute);
 	        if(vertexbuffer.pipeline.texCoord0Attribute!=-1) GL.disableVertexAttribArray (vertexbuffer.pipeline.texCoord0Attribute);
		    if (vertexbuffer.pipeline.colorAttribute!=-1) GL.disableVertexAttribArray (vertexbuffer.pipeline.colorAttribute);	
	  }
	   
	    if (boundChanged)
		{
				boundChanged = false;
		
		}
		
  	}

	


    

    private var decales :Array<BillSprite>;
   
	
}

private class BillSprite
{
    public var position :Vector3;
	public var alpha :Float ;
    public var life :Float ;
	public var size :Float ;
	public var type:Int;
	public var active:Bool;
	public var frame:Int;
	public var startlife:Float;
	public var startsize:Float;
	
    public function new (p:Vector3,s:Float,life:Float,type:Int) 
	{
	    this.active = false;
		this.type = type;
		this.position = new Vector3(p.x, p.y, p.z);
	    this.alpha = 1;
		this.life = life;
		this.size = s;
	}
	public function reset (p:Vector3,s:Float,life:Float,frame:Int,type:Int) 
	{
		this.startlife = life;
		this.frame = frame;
	    this.active = true;
		this.type = type;
		this.position.set(p.x, p.y, p.z);
	    this.alpha = 1;
		this.life = life;
		this.size = s;
		this.startsize = s;
	}
}
