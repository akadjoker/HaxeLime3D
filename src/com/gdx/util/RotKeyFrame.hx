package com.gdx.util;

import com.gdx.math.Quaternion;
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
/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class RotKeyFrame
{
public var Rot:Quaternion;
public var time:Float;
public function new(t:Float,q:Quaternion)
{
	time = t;
	Rot = q;
}

}