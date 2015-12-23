package com.gdx.scene3d.bolt ;

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
class DecaleNode  extends Node
{



	
	private	var vert_tex_coords:Float32Array;
	private var vert_col :Float32Array;
	private	var vert_coords:Float32Array;
	private var buffer:VertexBuffer;		
	private var currentBatchSize:Int;
    private  var texture :Texture;
	private var vertexbuffer:VertexBuffer;
	private var clip:Clip;
	private var MaxDecales:Int;
	public var material:Material;	
    public var numParticles (default, null) :Int = 0;
  
    public function new (maxDecales:Int,?parent:Node=null,?id:Int=0,?Name:String="DecalSystem") 
    {
        super(parent, name,id);
		
		 clip = new Clip();
		material = new Material();
		material.CullingFace = false;
		material.DepthMask = true;
		material.DepthTest = true;
		material.BlendType = BlendMode.NORMAL;
		material.BlendFace = true;
		
		MaxDecales = maxDecales;
		InitWithTotal(maxDecales);
		numParticles = 0;
		decales=[];
    }

	public function addDecal(position:Vector3, normal:Vector3, size:Float,life:Float=10):Void
	{
		
		
		
		/*
		position.x += normal.x *0.5;
		position.y += normal.y *0.5;
		position.z += normal.z *0.5;
		*/
		decales.push(new Decale(normal, position, size,life));
		numParticles++;
		
		
		Bounding.addInternalPoint(position.x + size, position.y + size, position.z + size);
		Bounding.addInternalVector(position);
		Bounding.addInternalPoint(position.x - size, position.y - size, position.z - size);
		boundChanged = true;
		
	}
	public function  count():Int
	{
		return this.decales.length;
	}
	public function setTexture(tex:Texture,?tex_clip:Clip=null)
	{
			texture = tex;
		
		if (tex_clip != null)
		{
			clip = tex_clip;
		} else
		{
		 clip.set(0, 0, texture.width, texture.height);
		}
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
		
		vertexbuffer = new VertexBuffer(Gdx.Instance().materials[Gdx.SHADERTEXTURE]);
		vertexbuffer.uploadIndices(indices);
		
		

	    vert_coords    = new Float32Array(numberOf*3*4) ; 
		vert_tex_coords= new Float32Array(numberOf*2*4) ; 
     	vert_col =     new Float32Array(numberOf * 4 * 4) ; 
		
			   
		
	
		
		
	}
	
   


	 public function drawBillboard(ii:Int,particle:Decale):Void
	{
			
   vert_coords[(ii * 12) + 0] = particle.position.x + ((-particle.right.x - particle.up.x) * particle.size);
   vert_coords[(ii * 12) + 1] = particle.position.y + ((-particle.right.y - particle.up.y) * particle.size);
   vert_coords[(ii * 12) + 2] = particle.position.z + ((-particle.right.z - particle.up.z) * particle.size);
   
   vert_coords[(ii * 12) + 3] = particle.position.x + ((particle.right.x - particle.up.x) * particle.size);
   vert_coords[(ii * 12) + 4] = particle.position.y + ((particle.right.y - particle.up.y) * particle.size);
   vert_coords[(ii * 12) + 5] = particle.position.z + ((particle.right.z - particle.up.z) * particle.size);

   vert_coords[(ii * 12) + 6] = particle.position.x + ((particle.right.x + particle.up.x) * particle.size);
   vert_coords[(ii * 12) + 7] = particle.position.y + ((particle.right.y + particle.up.y) * particle.size);
   vert_coords[(ii * 12) + 8] = particle.position.z + ((particle.right.z + particle.up.z) * particle.size);
   
   vert_coords[(ii * 12) + 9]  = particle.position.x + ((-particle.right.x + particle.up.x) * particle.size);
   vert_coords[(ii * 12) + 10] = particle.position.y + ((-particle.right.y + particle.up.y) * particle.size);
   vert_coords[(ii * 12) + 11] = particle.position.z + ((-particle.right.z + particle.up.z) * particle.size);
			
		
			
	  vert_tex_coords [(ii * 8) + 0] = 0.0; vert_tex_coords [(ii * 8) +1] = 0.0;
	  vert_tex_coords [(ii * 8) + 2] = 0.0; vert_tex_coords [(ii * 8) +3] = 1.0;
	  vert_tex_coords [(ii * 8) + 4] = 1.0; vert_tex_coords [(ii * 8) +5] = 1.0;
	  vert_tex_coords [(ii * 8) + 6] = 1.0; vert_tex_coords [(ii * 8) +7] = 0.0;

	  
	  var alpha:Float  =  particle.alpha;
	  

	  
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
		if (numParticles <= 0) return;	 
	    var mat:Matrix = getWorldTform();
	 
	
	  
	    if (boundChanged)
		{
			Bounding.calculate();
			Bounding.update(mat);

		}
		
	  if (Bounding.isInFrustum(cam.frustumPlanes))
	  {
		
		

    for (ii in 0...numParticles)
    {
	         var particle = decales[ii];
	    	drawBillboard(ii,  particle);
	 }
		
		
		
  
	      vertexbuffer.pipeline.Bind(cam.viewMatrix, cam.projMatrix, mat);
		  vertexbuffer.pipeline.ApplayMaterial(material);
		  
		 
	
	

		    

vertexbuffer.setVertex(vert_coords);
vertexbuffer.setUVCoord0(vert_tex_coords);
vertexbuffer.setColors(vert_col);
vertexbuffer.render(GL.TRIANGLES, numParticles * 6);


		Gdx.Instance().numVertex     += numParticles *4 ;
		Gdx.Instance().numTris += numParticles * 2 ;
	  }
  	}

	
	 override public function update()
	{
       var dt:Float = Gdx.Instance().deltaTime;		
	   var ii = 0;
        while (ii < numParticles) 
		{
                var particle = decales[ii];
                if (particle.life > 0) 
			    {
         	    particle.life -= dt;
				particle.alpha = Util.clamp(particle.life, 0, 1);
                ++ii;
                }
			else 
			{
                  --numParticles;
                  decales.remove(particle);
				  particle = null;
	        }
        }

        

	
		
		
	 super.update();
    }


   

    

    private var decales :Array<Decale>;
   
	
}
private class Decale
{
    public var position :Vector3;
	public var right:Vector3;
	public var up:Vector3;
    public var alpha :Float ;
    public var life :Float ;
	 public var size :Float ;
	
    public function new (n:Vector3,p:Vector3,s:Float,life:Float) 
	{
		var factor:Float = 0.5;
		p.x += n.x * factor;
		p.y += n.y * factor;
		p.z += n.z * factor;
		
		this.right = new Vector3(0, 0, 0);
		
		var axis:Array<Vector3> = [];
		axis.push(new Vector3(1, 0, 0));
		axis.push(new Vector3(0, 1, 0));
		axis.push(new Vector3(0, 0, 1));
		
		 var poly_normal:Vector3=new Vector3(Math.abs(n.x), Math.abs(n.y),Math.abs(n.z));
         poly_normal.normalize();
	
   var temp:Vector3 = Vector3.zero;
    var major:Int;

    if (poly_normal.x > poly_normal.y && poly_normal.x > poly_normal.z)
        major = 0;
    else if (poly_normal.y > poly_normal.x && poly_normal.y > poly_normal.z)
        major = 1;
    else
        major = 2;

    // build right vector by hand
    if (poly_normal.x == 1.0 || poly_normal.y == 1.0 || poly_normal.z == 1.0)
    {
        if ((major == 0 && n.x > 0.0) || major == 1)
            right.set(0.0, 0.0, -1.0);
        else if (major == 0)
            right.set(0.0, 0.0, 1.0);
        else
            right.set(1.0 * n.z, 0.0, 0.0);
    }
    else
    {
		axis[major] = Vector3.Cross(axis[major], n);
		right.copyFrom(axis[major]);
       
    }

    temp.x = n.x;
    temp.y = n.y;
    temp.z = n.z;
    up=Vector3.Cross(temp,right);
    up.normalize();
    right.normalize();
	
		
		this.position = new Vector3(p.x, p.y, p.z);
	    this.alpha = 1;
		this.life = life;
		this.size = s;
	}
}
