package com.gdx.scene3d.particles;

import com.gdx.gl.Texture;
import com.gdx.math.Vector3;

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
class SphereEmitter extends ParticleSystem
{

	public  var Center:Vector3;
	public  var Radius:Float;
	
	
	public function new (MaxParticles:Int=100,center:Vector3,radius:Float,Parent:Node = null , id:Int = 0) 
    {
        super(MaxParticles, Parent, id,"SphereEmitter");
		this.Center = center;
		this.Radius = radius;
		 
    }


	override public function getStartPosition ():Vector3
    {
	 EmitPosition = new Vector3(0, 0, 0);
     var  distance = Math.random() * Radius;
     EmitPosition.set(Center.x + distance,Center.y + distance,Center.z + distance);
     EmitPosition.rotateXYBy(Math.random() * 360.0, Center );
     EmitPosition.rotateYZBy(Math.random() * 360.0, Center );
     EmitPosition.rotateXZBy(Math.random() * 360.0, Center );
     return EmitPosition;
    }
	
}