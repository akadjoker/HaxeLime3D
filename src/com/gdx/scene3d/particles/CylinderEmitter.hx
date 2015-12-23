package com.gdx.scene3d.particles;

import com.gdx.gl.Texture;
import com.gdx.math.Vector3;
import com.gdx.scene3d.particles.ParticleSystem;

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
class CylinderEmitter extends ParticleSystem
{

	public  var Normal:Vector3;
	public  var Length:Float;
	
	public  var Radius:Float;
	public  var Center:Vector3;

	public  var OutlineOnly:Bool;
	
	
	public function new (MaxParticles:Int=100,normal:Vector3,lenght:Float,center:Vector3,radius:Float,outlineOnly:Bool,Parent:Node = null , id:Int = 0) 
    {
        super(MaxParticles,Parent, id,"CylinderEmitter");
		this.Center = center;
		this.Normal = normal;
		this.Length = lenght;
		this.Radius = radius;
		this.OutlineOnly = outlineOnly;
		 
    }


	override public function getStartPosition ():Vector3
    {
	 EmitPosition = Vector3.Zero();


var distance = (!OutlineOnly) ? (Math.random() *Radius) : Radius;
EmitPosition.set(Center.x + distance,Center.y ,Center.z + distance);
EmitPosition.rotateXZBy(Math.random() * 360.0, Center );
var  length:Float = Math.random() * Length;
EmitPosition.x += Normal.x * length;
EmitPosition.y += Normal.y * length;
EmitPosition.z += Normal.z * length;

return EmitPosition;

    }
	
}