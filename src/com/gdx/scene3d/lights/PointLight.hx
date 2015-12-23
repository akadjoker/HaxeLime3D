package com.gdx.scene3d.lights;
import com.gdx.color.Color3;
import com.gdx.math.Vector3;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class PointLight extends Light
{


	public var specularIntensity:Float;
	public var specularPower:Float;
	
	public var constant:Float;
	public var linear:Float;
	public var exponent:Float;

	
	public function new(Color:Color3, Intensity:Float,pos:Vector3,?SpecularIntensity:Float = 2,?SpecularPower:Float=8, ?parent : Node = null, ?Name:String = "PointLight", ?id:Int = -1 ) 
	{
	 super(Color,Intensity,parent,Name,id);
	 this.local_pos = pos;
     specularIntensity = SpecularIntensity;
     specularPower = SpecularPower;
	 constant = 0;
	 linear = 0;
	 exponent = 1;
	}
	
	
}