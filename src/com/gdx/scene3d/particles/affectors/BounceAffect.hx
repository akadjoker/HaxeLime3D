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
class BounceAffect extends ParticleAffect
{

	private var timeForceLost:Int;
	private var normal:Vector3;
	private var bounce:Float;
	public function new(b:Float,timeForceLost:Int) 
	{
		super();
		this.bounce = b;
		this.normal = new Vector3(0, 1, 0);
		this.timeForceLost = timeForceLost;
		
	}
	override public function affect(now:Int,p:Particle):Void
	{
		
	
			
		var d:Float =  (now -  p.startTime) / timeForceLost;
		
		
             	if (p.position.y <= 0)
				{
					p.position.y = 0;
					
						
				
					var speed:Float = normal.dot(p.velocity);
	
					
					
					
					p.velocity.x -= d * normal.x * speed;
					p.velocity.y -= d * normal.y * speed;
					p.velocity.z -= d * normal.z * speed;
					
				
					
					p.velocity.x *= bounce;
					p.velocity.y *= bounce;
					p.velocity.z *= bounce;
					
				}
		
		
		
		
	}
}