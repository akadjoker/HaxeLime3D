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
class GravityAffect extends ParticleAffect
{

	private var gravity:Vector3;
	private var timeForceLost:Int;
	public function new(gravity:Vector3,timeForceLost:Int) 
	{
		super();
		
		this.gravity = gravity;
		this.timeForceLost = timeForceLost;
		
	}
	override public function affect(now:Int,p:Particle):Void
	{
		
	
			
		var d:Float =  (now -  p.startTime) / timeForceLost;
		
		
	
		/*
		if (d > 1.0)
			d = 1.0;
		if (d < 0.0)
			d = 0.0;
		d = 1.0 - d;
		*/
		
		
		
		p.velocity.x += gravity.x * d;
		p.velocity.y += gravity.y * d;
	    p.velocity.z += gravity.z * d;
	
		// particles[i].velocity = Vector3.Lerp( particles[i].velocity, gravity, d);
		
		
		
		
	}
}