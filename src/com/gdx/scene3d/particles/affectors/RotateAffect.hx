package com.gdx.scene3d.particles.affectors;
import com.gdx.math.Vector3;
import com.gdx.scene3d.particles.Particle;

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
class RotateAffect extends ParticleAffect
{

	private var speed:Vector3;
	private var pivot:Vector3;
	
	public function new(speed:Vector3,pivot:Vector3) 
	{
		super();
		
		this.speed = speed;
		this.pivot = pivot;
		
	}
	override public function affect(now:Int,p:Particle):Void
	{
		
	
	var dt:Float = Gdx.Instance().deltaTime;		
		
	
		
		if (speed.x != 0.0)
		{
			p.position.rotateYZBy(dt * speed.x, pivot);
		}
		
		
		if (speed.y != 0.0)
		{
			p.position.rotateXZBy(dt * speed.y, pivot);
		}
		
		if (speed.z != 0.0)
		{
			p.position.rotateXYBy(dt * speed.z, pivot);
		}
		
		
		
		
		
		
	}
}