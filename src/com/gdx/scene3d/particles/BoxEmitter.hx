package com.gdx.scene3d.particles;

import com.gdx.gl.Texture;
import com.gdx.math.Vector3;
import com.gdx.scene3d.particles.ParticleSystem;
import com.gdx.util.Util;

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
class BoxEmitter extends ParticleSystem
{
	
	public  var BoxMin:Vector3;
	public  var BoxMax:Vector3;
	
	
	
	
	public function new (MaxParticles:Int=100,boxMin:Vector3,boxMax:Vector3,Parent:Node = null , id:Int = 0) 
    {
        super(MaxParticles, Parent, id,"BoxEmitter");
		this.BoxMax = boxMax;
		this.BoxMin = boxMin;
		
		 
    }


	override public function getStartPosition ():Vector3
    {
	
		var emitPosition:Vector3 = Vector3.Zero();
    	emitPosition.x = Util.randf(BoxMin.x, BoxMax.x);
		emitPosition.y = Util.randf(BoxMin.y, BoxMax.y);
		emitPosition.z = Util.randf(BoxMin.z, BoxMax.z);
		return emitPosition;
	
	}
	
}