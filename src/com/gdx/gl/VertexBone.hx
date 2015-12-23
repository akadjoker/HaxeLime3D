package com.gdx.gl;
import com.gdx.color.Color4;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import com.gdx.util.VertexWight;

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
class VertexBone
{
    public var  Pos:Vector3;
	public var  Normal:Vector3;
	public var  TCoords0:Vector2;
	public var  TCoords1:Vector2;
	public var  Color:Color4;
	public var  bones:Array<VertexWight>;
	public var numBones:Int;
	public var surfaceId:Int;

	
	public function new() 
	{
		Color = new Color4(1, 1, 1, 1);
		Pos = Vector3.Zero();
		Normal = Vector3.Zero();
		TCoords0 = Vector2.Zero();
		TCoords1 = Vector2.Zero();
	    bones = [];
		bones.push(new VertexWight( -1, 0));
		bones.push(new VertexWight( -1, 0));
		bones.push(new VertexWight( -1, 0));
		bones.push(new VertexWight( -1, 0));
		numBones = 0;
		surfaceId = 0;
	}
	public function sort():Void
	{
	
		bones.sort(function WightIndex(a:VertexWight, b:VertexWight):Int
    {

    if (a.Wight < b.Wight) return -1;
    if (a.Wight > b.Wight) return 1;
    return 0;
    } 
	);
	}
	
}