package com.djokersoft.gdxparticles;


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
 	// gdx.setScreen(new DemoScreen_Terrain());
	 //gdx.setScreen(new DemoScreen_TerrainGrass());
	 //gdx.setScreen(new DemoGrass());
	 gdx.setScreen(new DemoGeoTerrain());
	//gdx.setScreen(new DemoScreen_Decals());
	//gdx.setScreen(new DemoParticles());
	//gdx.setScreen(new DemoWaterFall());
	//gdx.setScreen(new DemoBoxEmmiter());
	}
	
	
	
	
}