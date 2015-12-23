package com.gdx.scene3d.particles;

import com.gdx.color.Color3;
import com.gdx.math.Vector3;

/**
 * ...
 * @author djoker
 */
 class Particle
{
 
	public var start_velocity :Vector3;
    public var velocity :Vector3;
	public var position :Vector3;
	public var acceleration:Vector3;
	

	public var life:Float;
	public var startlife:Float;

    public var scale :Float = 0;

    public var alpha :Float = 0;

	
    public var startTime:Int = 0;


	public var color:Color3;
	
    public function new () 
	{
		this.velocity = new Vector3(0, 0, 0);
		this.position = new Vector3(0, 0, 0);
		this.acceleration = new Vector3(0, 0, 0);
		this.start_velocity= new Vector3(0, 0, 0);
     
		this.startTime = 0;
        life = 1;
		startlife = 1;
		this.scale = 1;

		alpha = 1;
	
		color = new Color3();
			
		}
}
