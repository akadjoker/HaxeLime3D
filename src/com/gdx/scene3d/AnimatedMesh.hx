package com.gdx.scene3d;

import com.gdx.scene3d.Node;

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
class AnimatedMesh extends Mesh

{
		public var duration:Float;
        public var framesPerSecond:Float;
		public var NumFrames:Int;
		public var isAnimated:Bool;
	

	public function new() 
	{
		super();
		duration = 0;
	    framesPerSecond = 0;
		NumFrames = 0;
		isAnimated = false;
	}
	 public function animate(currentFrame:Int,nextFrame:Int,poll:Float):Void 
	{
	}
	
public function numJoints():Int
{
	return 0;
}	
public function getJoint(name:String):Node
{
	
	return null;
}
public function getJointIndex(name:String):Int
{
	
	return -1;
}
}