package com.gdx.scene3d.animators;

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
class DeleteAnimator extends Animator
{
    private var DeleteTime:Int;
	private var startTime:Int;
	public function new(time:Int) 
	{
		super();
		DeleteTime = time;
		startTime = Gdx.Instance().getTimer();
	}
	override public function animate(node:SceneNode):Void
	{
		if (Gdx.Instance().getTimer() >= startTime+DeleteTime)
		{
			node.active = false;
		//	node.scene.addToDeletion(node);
		}
	}

	
}