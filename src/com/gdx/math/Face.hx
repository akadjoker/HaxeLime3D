package com.gdx.math;

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
class Face
{

	  public var id	:Int;
	  public  var v0:Int;
	  public  var v1:Int;
	  public  var v2:Int;
	  public function new(v0:Int, v1:Int, v2:Int,?Id:Int=0)
	  {
		  this.v0 = v0;
		  this.v1 = v1;
		  this.v2 = v2;
		  this.id = Id;
	  }
	  public function toString():String
	  {
		  return "v0:" + v0 + ",v1:" + v1 + ",v2:" + v2+ " - ID:"+id;
	  }
	  public function clone():Face
	  {
		  return new Face(v0, v1, v2,id);
	  }
 
	
}