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
class RingEmitter extends ParticleSystem
{

	public  var Center:Vector3;
	public  var Radius:Float;
	public  var RingThickness:Float;
	public var MaxAngleDegrees:Float;
	
	
	public function new (MaxParticles:Int=100,center:Vector3,radius:Float,ringThickness:Float,MaxAngleDegrees:Float,Parent:Node = null , id:Int = 0) 
    {
        super(MaxParticles, Parent, id,"RingEmitter");
		this.Center = center;
		this.Radius = radius;
		this.RingThickness = ringThickness;
		this.MaxAngleDegrees = MaxAngleDegrees;
		 
    }


	override public function getStartPosition ():Vector3
    {
	 EmitPosition = Vector3.Zero();
	var distance:Float = Math.random() * RingThickness * 0.5;

	
	var plusMinus :Int = Std.random(2);
	if (plusMinus == 1)
	{
    distance -= Radius;
	}
    else
	{
    distance += Radius;
	}
	


EmitPosition.set(Center.x + distance,Center.y ,Center.z + distance);
EmitPosition.rotateXZBy(Math.random()*360.0, Center );

if(MaxAngleDegrees != 0.0)
{
	var dirMin = DirectionMin;
	var dirMax = DirectionMax;
	

	
dirMin.rotateXYBy(Math.random() * MaxAngleDegrees, Center );	
dirMin.rotateYZBy(Math.random() * MaxAngleDegrees, Center );	
dirMin.rotateXZBy(Math.random() * MaxAngleDegrees, Center );	

dirMax.rotateXYBy(Math.random() * MaxAngleDegrees, Center );	
dirMax.rotateYZBy(Math.random() * MaxAngleDegrees, Center );	
dirMax.rotateXZBy(Math.random() * MaxAngleDegrees, Center );	

DirectionMin = dirMin;
DirectionMax = dirMax;
}


return EmitPosition;

    }
	
}