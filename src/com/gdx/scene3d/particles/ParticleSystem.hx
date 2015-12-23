package com.gdx.scene3d.particles ;

import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.gl.BlendMode;
import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.Texture;
import com.gdx.gl.VertexBuffer;
import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.particles.affectors.BounceAffect;
import com.gdx.scene3d.particles.affectors.ColorMorphAffect;
import com.gdx.scene3d.particles.affectors.GravityAffect;
import com.gdx.scene3d.particles.affectors.ParticleAffect;
import com.gdx.scene3d.particles.affectors.RotateAffect;
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
class ParticleSystem  extends Node
{

	
	var boudUpdate:Bool;
	
		var vert_tex_coords:Float32Array;
	    var vert_col :Float32Array;
		var vert_coords:Float32Array;
	
		private var currentBatchSize:Int;


    /** The current number of particles being shown. */
    public var numParticles (default, null) :Int = 0;

    public var maxParticles (get, set) :Int;

  
	public var alphaBlend:Bool;
    /** How long the emitter should remain enabled, or <= 0 to never expire. */
    public var duration :Float;


    public var enabled :Bool = true;

    public var alphaStart (default, null) :Float;
 
    public var alphaEnd (default, null) :Float;
  


     public var EmitPosition:Vector3;

    public var lifespanVariance (default, null) :Float;
    public var lifespan (default, null) :Float;


    public var sizeStart (default, null) :Float;
    public var sizeStartVariance (default, null) :Float;
    public var sizeEnd (default, null) :Float;
 
	public var DirectionMin:Vector3;
	public var DirectionMax:Vector3;

	public var AccelerationMin :Vector3;
	public var AccelerationMax:Vector3;

	
	private var affectors:List<ParticleAffect>;
	
	public var startColor:Color3 = new Color3();
	public var endColor:Color3 = new Color3();

	
	private var vertexbuffer:VertexBuffer;
	private var clip:Clip;
	public var material:Material;	


    public function new (MaxParticles:Int=100,?parent:Node=null,?id:Int=0,?Name:String="ParticlesSystem") 
    {
        super(parent, name,id);
		alphaBlend = true;
		 clip = new Clip();
		 _particles = new Array<Particle>();
	 	material = new Material();
		material.CullingFace = false;
		material.DepthMask = false;
		material.DepthTest = false;
		material.BlendType = BlendMode.ADD;
		material.BlendFace = true;
		EmitPosition=Vector3.zero;
		this.InitWithTotalParticles(MaxParticles);
		createDefault();
		 boudUpdate = true;
		 affectors = new List<ParticleAffect>();
		 
    }

	public function setTexture(tex:Texture,?tex_clip:Clip=null)
	{
		  material.setTexture(tex);
		
		if (tex_clip != null)
		{
			clip = tex_clip;
		} else
		{
		 clip.set(0, 0, tex.width, tex.height);
		}
	}
	public function createDefault()
	{
	
	

			setupEmitter(-1, 
			new Vector3( -0.2, 0.5, -0.2), new Vector3(0.2, 2, 0.2), 
			new Vector3(0, 0, 0), new Vector3(0,0,0),
		 1, 0.8, 0.2, 
		Color3.DARKORANGE, Color3.YELLOW, 
		1, 0.0, 
		1.5, 0.5);
	
	
  }
	public function createFire()
	{
	

			setupEmitter(-1, 
			new Vector3( -0.2, 1, -0.2), new Vector3(0.2, 2, 0.2), 
			new Vector3(-0.01, -0.2, -0.01), new Vector3(0.01, -0.5, 0.01),
		1, 0.8, 0.2, 
		new Color3(0,0,0), new Color3(1,0.5,0.5), 
		1, 0.1, 
		1, 0.8);
	
	
  }
  public function createWaterFall()
	{
	

			setupEmitter(-1, 
			new Vector3( -2.5, 4, -2.5), new Vector3(2.5, 6, 2.5), 
			new Vector3(-0.01, 0.2, -0.01), new Vector3(0.01, 0.5, 0.01),
		2, 0.5, 0.5, 
		new Color3(0.1,0.1,0.5), new Color3(0.0,0.0,0.9), 
		0.5, 0.9, 
		2, 0.8);
		
		//duration:Float,
//	minDirection:Vector3, maxDirection:Vector3,
//	minAcceleration:Vector3, maxAcceleration:Vector3,
//	startSize:Float, startVariance:Float, endSize:Float,
//	ColorBegin:Color3, ColorEnd:Color3, 
//	startAlpha:Float, endAlpha:Float,
//	life:Float,lifeVariance:Float
	
	
  }
  
	private function InitWithTotalParticles(numberOfParticles:Int)
	{
    	  var indices:Array<Int> = [];
        var index = 0;
		var oldvertices:Int = 0;
        for (count in 0...Std.int(numberOfParticles * 6)) {
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
		

	    vert_coords    = new Float32Array(numberOfParticles*3*4) ; 
		vert_tex_coords= new Float32Array(numberOfParticles*2*4) ; 
     	vert_col =     new Float32Array(numberOfParticles * 4 * 4) ; 
		
			   
		
	
	
        var ii = 0, ll = numberOfParticles;
		while (ii < ll) 
		{
	        _particles[ii] = new Particle();
            ++ii;
        }
		
		
		
	}
	
    public function restart ()
    {

        enabled = true;
        _totalElapsed = 0;
    }

	
	
	public function addAffector(affect:ParticleAffect):Void
	{
		this.affectors.add(affect);
	}
    public function removeAffector(affect:ParticleAffect):Void
	{
		this.affectors.remove(affect);
	}

	public function addGravityAffector(g:Vector3,timeForceLost:Int=1000):Void
	{
		var affect:GravityAffect = new GravityAffect(g, timeForceLost);
		addAffector(affect);
	}
	
   public function addBounceAffector(bounce:Float,timeForceLost:Int=1000):Void
	{
		var affect:BounceAffect = new BounceAffect(bounce, timeForceLost);
		addAffector(affect);
	}
	 public function addRotateAffector(speed:Vector3,pivot:Vector3):Void
	{
		var affect:RotateAffect = new RotateAffect(speed, pivot);
		addAffector(affect);
	}
	 public function addColorMorphAffector(ColorList:Array<Color3>,TimeList:Array<Int>,?smooth:Bool=true):Void
	{
		var affect:ColorMorphAffect = new ColorMorphAffect(ColorList,TimeList,smooth);
		addAffector(affect);
	}
	 public function drawBillboard(ii:Int,horizontal:Vector3,vertical:Vector3,particle:Particle):Void
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
			
			
			
		
			
	  vert_tex_coords [(ii * 8) + 0] = 0.0; vert_tex_coords [(ii * 8) +1] = 0.0;
	  vert_tex_coords [(ii * 8) + 2] = 0.0; vert_tex_coords [(ii * 8) +3] = 1.0;
	  vert_tex_coords [(ii * 8) + 4] = 1.0; vert_tex_coords [(ii * 8) +5] = 1.0;
	  vert_tex_coords [(ii * 8) + 6] = 1.0; vert_tex_coords [(ii * 8) +7] = 0.0;

	  
	  var color:Color3 =  particle.color;
	  var alpha:Float  =  particle.alpha;
	  

	  
	        vert_col[(ii * 16) + 0] =  color.r;
			vert_col[(ii * 16) + 1] =  color.g;
			vert_col[(ii * 16) + 2] =  color.b;
			vert_col[(ii * 16) + 3] =  alpha;
			
		    vert_col[(ii * 16) + 4] =  color.r;
			vert_col[(ii * 16) + 5] =  color.g;
			vert_col[(ii * 16) + 6] =  color.b;
			vert_col[(ii * 16) + 7] =  alpha;
			
			vert_col[(ii * 16) + 8] =  color.r;
			vert_col[(ii * 16) + 9] =  color.g;
			vert_col[(ii * 16) + 10] =  color.b;
			vert_col[(ii * 16) + 11] =  alpha;
			
		    vert_col[(ii * 16) + 12] =  color.r;
			vert_col[(ii * 16) + 13] =  color.g;
			vert_col[(ii * 16) + 14] =  color.b;
			vert_col[(ii * 16) + 15] =  alpha;

		
		
		 
   	
	}
	
	
	
override public function render(cam:Camera):Void
	{
	    var mat:Matrix = getWorldTform();
	    var m:Matrix = cam.viewMatrix;	
	  
	    if (boundChanged)
		{
			Bounding.calculate();
			Bounding.update(mat);

		}
	
		
		Bounding.initFloats(999999, -99999);
	 

		
				
        

	var horizontal:Vector3 = Vector3.Zero();
	var vertical:Vector3 = Vector3.Zero();
	
	  

	
      

		
			
		

 var ii = 0;
 for (ii in 0...numParticles)
 {
	         var particle = _particles[ii];
			var   xOffset =   ( clip.width  / 2   * particle.scale)/100;
            var   yOffset =   ( clip.height / 2   * particle.scale)/100;
			   horizontal.set(m.m11 * xOffset, m.m21 * xOffset, m.m31 * xOffset);
			    vertical.set  (m.m12 * yOffset, m.m22 * yOffset, m.m32 * yOffset);
		     	drawBillboard(ii, horizontal, vertical, particle);
         		Bounding.addInternalVector(particle.position);	 
				 boundChanged=true;
	
		        
	 }
	if (ii >= numParticles)
	{
		 boundChanged=false;
	
	}
	

	  	
        if (numParticles <= 0) return;	 
      
		
		
		
	      vertexbuffer.pipeline.Bind(cam.viewMatrix, cam.projMatrix, mat);
		  vertexbuffer.pipeline.ApplayMaterial(material);
		  
		 
	
	

		    

vertexbuffer.setVertex(vert_coords);
vertexbuffer.setUVCoord0(vert_tex_coords);
vertexbuffer.setColors(vert_col);
vertexbuffer.render(GL.TRIANGLES, numParticles * 6);


	
			


		Gdx.Instance().numVertex     += numParticles *4 ;
		Gdx.Instance().numTris += numParticles *2 ;
  	}

	override public function debug(lines:Imidiatemode):Void
	{
		lines.drawOBBox(Bounding, 1, 0, 0);
		
		super.debug(lines);
	}
	
	 override public function update()
	{
		
       var dt:Float = Gdx.Instance().deltaTime;		
	   
	   
        var ii = 0;
        while (ii < numParticles) 
		{
            var particle = _particles[ii];
                if (particle.life > 0) 
			    {
              
             var lerp:Float = (particle.startlife - particle.life) / particle.startlife * dt;
				
			 
		
		particle.scale =   Util.Lerp(particle.scale,  sizeEnd , lerp);
		particle.alpha =  Util.Lerp(particle.alpha , alphaEnd, lerp);
	    particle.color = Color3.Lerp(particle.color, endColor, lerp);
			
		
		
		
		
				particle.position.x += particle.velocity.x * dt;
				particle.position.y += particle.velocity.y * dt;
				particle.position.z += particle.velocity.z * dt;
				
		    	
				
				particle.velocity.x +=particle.acceleration.x * dt;
				particle.velocity.y +=particle.acceleration.y * dt;
				particle.velocity.z +=particle.acceleration.z * dt;
				
			
				
 for (affect in affectors)
				{
					affect.affect(Gdx.Instance().getTimer(), particle);
				}
		       
				
				

                particle.life -= dt;
				
				if (particle.scale <= 0)
				{
					particle.life = 0;
					
				}
				if (particle.alpha <= 0)
				{
					particle.life = 0;
				}
				
                ++ii;

            } else {
                   --numParticles;
                if (ii != numParticles) 
				{
                    _particles[ii] = _particles[numParticles];
                    _particles[numParticles] = particle;
	                }
            }
        }

        // Check whether we should continue to the emit step
        if (!enabled) 
		{
			if (numParticles <= 0)
			{
				//active = false;
			}
	        return;
        }
        if (duration > 0)
		{
            _totalElapsed += dt;
            if (_totalElapsed >= duration) 
			{
                enabled = false;
                return;
            }
        }

	
		
        // Emit new particles
        var emitDelay =  lifespan / _particles.length;
        _emitElapsed += dt;
        while (_emitElapsed >= emitDelay)
		{
            if (numParticles < _particles.length) 
			{
                var particle = _particles[numParticles];
                if (initParticle(particle)) 
				{
					
                    ++numParticles;
                }
            }
            _emitElapsed -= emitDelay;
        }
		
		
		
		
		
			 super.update();
    }
 public function setupEmitter(
	duration:Float,
	minDirection:Vector3, maxDirection:Vector3,
	minAcceleration:Vector3, maxAcceleration:Vector3,
	startSize:Float, startVariance:Float, endSize:Float,
	ColorBegin:Color3, ColorEnd:Color3, 
	startAlpha:Float, endAlpha:Float,
	life:Float,lifeVariance:Float
	):Void
	{
	 DirectionMin = minDirection;
	 DirectionMax = maxDirection;
	 AccelerationMin = minAcceleration;
	 AccelerationMax = maxAcceleration;
	 this.duration = duration;
	 this.sizeStart = startSize;
	 this.sizeStartVariance = startVariance;
	 this.sizeEnd = endSize;
	 this.startColor = ColorBegin;
	 this.endColor = ColorEnd;
	 this.alphaStart = startAlpha;
	 this.alphaEnd = endAlpha;
	 this.lifespan = life;
	 this.lifespanVariance = lifeVariance;
	
	
	}
	
	public function setDirection(min:Vector3, max:Vector3):Void
	{
			 DirectionMin = min;
	         DirectionMax = max;
	}
 	public function getStartPosition():Vector3
	{
		
		return new Vector3(0,0,0);
	}

    private function initParticle (particle :Particle) :Bool
    {
		particle.startTime = Gdx.Instance().getTimer();
        
		particle.startlife = lifespan + lifespanVariance * (Math.random() * 2.0 - 1.0);
		particle.life = particle.startlife;
		

		
        particle.color = startColor;
		
		
		particle.scale = Util.randf(sizeStart, sizeEnd);
		particle.alpha = Util.randf(alphaStart, alphaEnd);
	    
	

		particle.position = getStartPosition();
		
		
		//trace(_particles.length);


		
	    particle.acceleration.x = Util.randf(AccelerationMin.x, AccelerationMax.x);
		particle.acceleration.y = Util.randf(AccelerationMin.y, AccelerationMax.y);
		particle.acceleration.z = Util.randf(AccelerationMin.z, AccelerationMax.z);
		particle.velocity.x = Util.randf(DirectionMin.x, DirectionMax.x);
		particle.velocity.y = Util.randf(DirectionMin.y, DirectionMax.y);
		particle.velocity.z = Util.randf(DirectionMin.z, DirectionMax.z);
		
		particle.start_velocity.copyFrom(particle.velocity);
		
		
		
		
        return true;
    }

    inline private function get_maxParticles () :Int
    {
        return _particles.length;
    }

    private function set_maxParticles (maxParticles :Int) :Int
    {
      
        var oldLength = _particles.length;
        while (oldLength < maxParticles) 
		{
            _particles[oldLength] = new Particle();
            ++oldLength;
        }

        if (numParticles > maxParticles) {
            numParticles = maxParticles;
        }

        return maxParticles;
    }

    private static function random (base :Float, variance :Float)
    {
        if (variance != 0) {
            base += variance * (2*Math.random()-1);
        }
        return base;
    }


    private var _particles :Array<Particle>;
    private var _emitElapsed :Float = 0;
    private var _totalElapsed :Float = 0;
}


