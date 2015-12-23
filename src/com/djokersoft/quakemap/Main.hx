package com.djokersoft.quakemap;


import com.gdx.Importer;


import com.gdx.App;



/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Main extends App
{
	

	
	
	public function new () 
	{
		
		super ();
		
	}
	override function OnStart():Void 
	{

		
//	 gdx.setScreen(new Demo1());
	 gdx.setScreen(new Demo3());
	 //gdx.setScreen(new Demo2());//nodes octree
	
	}
	
	
	
	
}