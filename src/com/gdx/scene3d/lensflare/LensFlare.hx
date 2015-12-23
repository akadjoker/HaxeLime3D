package com.gdx.scene3d.lensflare ;


import com.gdx.color.Color3;
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


class LensFlare 
{
	
    public var alpha :Float ;
	public var color:Color3;
	public var size :Float ;
	public var index:Float;
	public var frame:Int;
	private var _system:LensFlareSystem;
	

	public function new(size:Float, index:Float,frame:Int, ?color:Color3, system:LensFlareSystem) 
	{
		
		this.color = color != null ? color : new Color3(1, 1, 1);
        this.index = index;
        this.size = size;
		this.frame = frame;
		this.alpha = 1;
        this._system = system;

        _system.lensFlares.push(this);
	}
	
	public function dispose() 
	{
		this._system.lensFlares.remove(this);
	}
	
}
