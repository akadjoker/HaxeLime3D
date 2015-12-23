package com.gdx;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Buffer
{ 
	

	public function new() 
	{

	 Gdx.Instance().numBuffers += 1;	
	}
	public function dispose()
	{
	Gdx.Instance().numBuffers -= 1;
	}
	public function getType():String 
	{
		return Type.getClassName(Type.getClass(this));
	}
	
}