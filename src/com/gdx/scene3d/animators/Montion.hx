package com.gdx.scene3d.animators;
import com.gdx.util.Anim;

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
class Montion
{
    private var animations:Array<Anim>;
	private var animation:Anim;
	private var lastanimation:Int;
	private var currentAnimation:Int;
	private var rollto_anim:Int;
	private var RollOver:Bool;
	private var currentFrame:Int;
	private var lastTime:Float;
	

	
	public function new() 
	{
	animations = new  Array<Anim>();
	lastanimation = -1;
	currentAnimation = 0;
	currentFrame=0;
	rollto_anim = 0;
	RollOver = false;
	lastTime = Gdx.Instance().getTimer();
	}
	
	public function addAnimation(name:String, startFrame:Int, endFrame:Int, fps:Int):Int
	{
		animations.push(new Anim(name, startFrame, endFrame, fps));
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
			
			if (animations[i].name == name)
			{
				setAnimation(i);
				break;
			}
			
		}
		
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

	
	public function update():Void 
	{
		
		var time:Float = Gdx.Instance().getTimer();
        var elapsedTime:Float = time - lastTime;
	    var t:Float = elapsedTime / (1000.0 / animation.fps);
		
		
		if (currentFrame > animation.frameEnd)
		{
			currentFrame = animation.frameStart;
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
    	 currentFrame++;
	     lastTime = time;	
	    }
		
		
	}
}