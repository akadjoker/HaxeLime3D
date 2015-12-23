package com.gdx.scene3d.lights;
import com.gdx.color.Color3;
import com.gdx.scene3d.Node;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Light extends Node
{
	public var color:Color3;
	public var intensity:Float;
	public var ambient:Color3;
	
	
	public function new(Color:Color3,Intensity:Float, ?parent : Node=null, ?Name:String = "Light", ?id:Int = -1 ) 
	{
	 super(parent,Name,id);
	this.color = Color;
	this.intensity = Intensity;
	ambient = new Color3(0.0, 0.0, 0.0);
	active = true;
	visible = true;
		
	}
	
}