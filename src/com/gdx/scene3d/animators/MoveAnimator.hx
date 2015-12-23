package com.gdx.scene3d.animators;
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
class MoveAnimator extends Animator
{
private var direction:Vector3;

	public function new(dir:Vector3) 
	{
		super();
		direction = Vector3.zero;
		direction.copyFrom(dir);
	}
	override public function animate(node:SceneNode):Void
	{
		var pos = node.local_pos;
		pos.addInPlace(direction);
		
	}
}