package com.gdx.util;
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
class ArrayIterator<T> {
	var i : Int;
	var l : Int;
	var a : Array<T>;
	public inline function new(a) {
		this.i = 0;
		this.a = a;
		this.l = this.a.length;
	}
	public inline function hasNext() {
		return i < l;
	}
	public inline function next() {
		return a[i++];
	}
}