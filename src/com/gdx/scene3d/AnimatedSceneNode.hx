package com.gdx.scene3d;

import com.gdx.math.Matrix;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;
import com.gdx.util.Anim;
import haxe.xml.Fast;
import lime.Assets;
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
class AnimatedSceneNode extends SceneNode

{
	
	private var animations:Array<Anim>;
	private var animation:Anim;
    private var lastTime:Float;
    public var lerp:Float;
	public var currentFrame:Int;
	public var nextFrame:Int;
	private var lastanimation:Int;
	private var currentAnimation:Int;
	private var rollto_anim:Int;
	private var RollOver:Bool;


	public function new(mesh:AnimatedMesh,?parent:Node=null,?id:Int=0,?Name:String="Node") 
	{
	super(mesh, parent, id, Name);
	currentFrame = 0;
	nextFrame = 0;
	lastTime = 0;
	animations = new  Array<Anim>();
	lastanimation = -1;
	currentAnimation = 0;
	rollto_anim = 0;
	RollOver = false;
	lerp = 0;
	///have to parent the bones that don't have parent :P
		if (Std.is(mesh, MeshH3D))
		{
			addAnimation("all", 0, mesh.NumFrames,  Std.int(mesh.framesPerSecond));
			
		} else
		if (Std.is(mesh, MeshB3D))
		{
			addAnimation("all", 0,mesh.NumFrames, Std.int(mesh.framesPerSecond));
			
		
	   } else
		if (Std.is(mesh, MeshMD2))
		{
			
	 animations.push(new Anim("stand", 0, 39, 9));
	 animations.push(new Anim("run", 40, 45, 10));
	 animations.push(new Anim("attack", 46, 53, 10));
	 animations.push(new Anim("pain_a", 54, 57, 7));
	 animations.push(new Anim("pain_b", 58, 61, 7));
	 animations.push(new Anim("pain_c", 62, 65, 7));
	 animations.push(new Anim("jump", 66, 71, 7));
	 animations.push(new Anim("flip", 72, 83, 7));
	 animations.push(new Anim("salute", 84, 94, 7));
	 animations.push(new Anim("fallback", 95, 111, 10));
	 animations.push(new Anim("wave", 112, 122, 7));
	 animations.push(new Anim("point", 123, 134, 6));
	 animations.push(new Anim("crouch_stand", 135, 153, 10));
	 animations.push(new Anim("crouch_walk", 154, 159, 7));
	 animations.push(new Anim("crouch_attack", 160, 168, 10));
	 animations.push(new Anim("crouch_pain", 169, 172, 7));
	 animations.push(new Anim("crouch_death", 173, 177, 5));
	 animations.push(new Anim("death_fallback", 178, 183, 7));
	 animations.push(new Anim("death_fallbackforward", 184, 189, 7));
	 animations.push(new Anim("death_fallbackslow", 190, 197, 7));
	 animations.push(new Anim("boom", 198, 198, 5));
	 animations.push(new Anim("all", 0, 198, 15));
		} else
		if (Std.is(mesh, MeshMD3))
		{
			addAnimation("all", 0, mesh.NumFrames-1, Std.int(mesh.framesPerSecond));
			var m:MeshMD3 = cast(mesh, MeshMD3);
			for (b in m.bones)
            {
				trace(name+";"+b.name);
		    	   addChild(b);
	         	   b.parent = this;
	        }
			
		}
	

	
	setAnimation(0);
	
	}
	
		public function addAnimation(name:String, startFrame:Int, endFrame:Int, fps:Int):Int
	{
		animations.push(new Anim(name.toUpperCase(), startFrame, endFrame, fps));
		return (animations.length - 1);
		
	}
	
	public function numAnimations():Int
	{
		return animations.length;
	}
	
	public function BackAnimation():Void
	{
		currentAnimation = (currentAnimation - 1) %  (numAnimations());
		if (currentAnimation < 0) currentAnimation = numAnimations();
	    setAnimation(currentAnimation);
	}
	public function NextAnimation():Void
	{
		currentAnimation = (currentAnimation +1) %  (numAnimations());
		if (currentAnimation >numAnimations()) currentAnimation = 0;
	    setAnimation(currentAnimation);
	}
	public function setAnimation(num:Int):Void
	{
	 if (num == lastanimation) return;
	 if (num > animations.length) return;
		
	 currentAnimation = num;	
	 animation = animations[currentAnimation];
	 currentFrame = animations[currentAnimation].frameStart;
	 lastanimation = currentAnimation;
	}
	public function setAnimationByName(name:String):Void
	{
	 
		for (i in 0 ... animations.length)
		{
			
			if (animations[i].name.toUpperCase() == name.toUpperCase())
			{
				setAnimation(i);
				break;
			}
			
		}
		
	}
	public function getAnimationByName(name:String):Int
	{
	 
		for (i in 0 ... animations.length)
		{
			
			if (animations[i].name.toUpperCase() == name.toUpperCase())
			{
				return i;
			}
			
		}
		return 0;
	}
	public function SetAnimationRollOver(num:Int,next:Int):Void
	{
		if (num == lastanimation) return;
		if (num > animations.length) return;
		
	 currentAnimation = num;	
	 animation = animations[currentAnimation];
	 currentFrame = animations[currentAnimation].frameStart;
	 lastanimation = currentAnimation;
	 RollOver = true;
	 rollto_anim = next;
	}

public function SetAnimationRollOverbyName(num:String,next:String):Void
	{
	SetAnimationRollOver(getAnimationByName(num), getAnimationByName(next));
	}

	override public function update():Void
	{
		var time:Float = Gdx.Instance().getTimer();
        var elapsedTime:Float = time - lastTime;
	    lerp = elapsedTime / (1000.0 / animation.fps);
		
		nextFrame = (currentFrame+1);
		if (nextFrame > animation.frameEnd)
		{
			nextFrame = animation.frameStart;
		}
	
		if (RollOver)
		{
			if (currentFrame >= animation.frameEnd)
			{
				setAnimation(rollto_anim);
				RollOver = false;
			}
		}
		
		if (elapsedTime >= (1000.0 / animation.fps) )
	    {
    	
			currentFrame = nextFrame;
		    lastTime = time;	
	
	    }	
		
		super.update();
	}
	override public function onAnimate():Void 
	{
	
		
		var meshAnimated:AnimatedMesh = cast(mesh, AnimatedMesh);
    		meshAnimated.animate(currentFrame, nextFrame, lerp);
		

		
	}
	
	
	public function loadAnimation(filename:String):Void
	{
		

		var xml:Xml = Xml.parse (Assets.getText(filename));
		var node = xml.firstElement();
		for (frameNode in node.elements()) 
		{
			
			var frameNodeFast = new Fast(frameNode);
		
			        var name = frameNodeFast.att.name;
					var start = Std.parseInt ( frameNodeFast.att.start );
					var end = Std.parseInt ( frameNodeFast.att.end );
					var fps = Std.parseInt ( frameNodeFast.att.fps );
				
					
					addAnimation(name, start, end, fps);
					
				//	trace(name+" , start:" + start + " , end:" +end+" , fps: " + fps);
			
		}
		
	
		
	
	}
	
	override public function render(cam:Camera):Void
	{
 	  var mat:Matrix = getWorldTform();
 	   if (boundChanged)
		{
			Bounding.update(mat);
			boundChanged = false;
		}
	  
	  if (Bounding.isInFrustum(cam.frustumPlanes))
	  {
		
	  
		mesh.render(mat,cam,false);
		onAnimate();
		
		
		for ( c in childs )
		{
			c.render(cam);
			
		}
		
		/*
		
		    GL.disableVertexAttribArray (mesh.pipline.vertexAttribute);
 	        if(mesh.pipline.normalAttribute>=0) GL.disableVertexAttribArray (mesh.pipline.normalAttribute);	
			if(mesh.pipline.texCoord0Attribute>=0) GL.disableVertexAttribArray (mesh.pipline.texCoord0Attribute);
			if(mesh.pipline.texCoord1Attribute>=0) GL.disableVertexAttribArray (mesh.pipline.texCoord1Attribute);
		    if (mesh.pipline.colorAttribute >= 0) GL.disableVertexAttribArray (mesh.pipline.colorAttribute);	
			if (mesh.pipline.bonesAttribute >= 0) GL.disableVertexAttribArray (mesh.pipline.bonesAttribute);	
			if (mesh.pipline.wighsAttribute >= 0) GL.disableVertexAttribArray (mesh.pipline.wighsAttribute);*/	
			  
	  }

	}
	
}