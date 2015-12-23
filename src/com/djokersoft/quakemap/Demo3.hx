package com.djokersoft.quakemap;

import com.gdx.collision.OctSelector;
import com.gdx.collision.QuadSelector;
import com.gdx.Gdx;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.GeoTerrain;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshBSP;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.bolt.BilboardNode;
import com.gdx.scene3d.particles.GrassNode;
import com.gdx.scene3d.partition.NodeMeshOctree;

import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.util.Util;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Demo3 extends Screen
{


	var font:ImageFont;

var scene:SceneManager;

	var camera:TargetCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();

	var map:MeshBSP;

	var octree:NodeMeshOctree;

	override public function show():Void 
	{
		
		scene = new SceneManager( 50000);
		
		camera = scene.addTargetCamera(0,  10,100, 0, 0, 100);
		camera.setFarValue(5000.0);


		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	

	map = MeshCreator.loadBSPMap("data/small.bsp", "data/maxpayne/", 2, true);
	
//map = MeshCreator.loadBSPMap("data/egyptians.bsp", "data/egyptians/", 2, false);
//map = MeshCreator.loadBSPMap("data/gothic.bsp", "data/gothic/", 2, false);
//map = MeshCreator.loadBSPMap("data/gad1.bsp", "data/level/", 5, false,false);
//map = MeshCreator.loadBSPMap("data/sfi.bsp", "data/sfi/", 8, false);
//map = MeshCreator.loadBSPMap("data/castel.bsp", "data/castel/", 1, false,true);
camera.setLocalPosition(map.getPlayerPosition());


var n = scene.addSceneNode(map);
		 

 var m = MeshCreator.createCube();

	 
	 
		var t =  scene.addSceneNode(m);
		
	
	}
	

	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
	
		
		 var dt:Float =  Gdx.Instance().deltaTime *3 ;
		 var speed:Float= 120;
		 
		     if (keyPress(Keys.D))
		 {
			camera.Strafe( -speed*dt);
		 } else
		 if (keyPress(Keys.A))
		 {
			 camera.Strafe( speed*dt);
		 } 
		 
		 if (keyPress(Keys.W))
		 {
			 camera.Advance( speed*dt);
		 } else
		 if (keyPress(Keys.S))
		 {
			 camera.Advance( -speed*dt);
		 }
		 


	
	
		 
		 scene.update();
	}
	
	
	override public function render():Void 
	{
		
	
	
		
		 scene.render();
		 scene.renderUI();
		
		 
		 font.caption = Gdx.Instance().status;
		 

		//selector.debug();
		 
	
		
	 
	}

	override public function TouchMove(mx:Float, my:Float, num:Int):Void 
	{
		mousex = mx;
		mousey = my;
		
		if (mouseDow)
		{
		 MouseSpeed.x = mx - previousMouse.x ;
		 MouseSpeed.y = my - previousMouse.y  ;
		 MouseSpeed.normalize();
				 camera.MouseLook(MouseSpeed.x, MouseSpeed.y, 8, 10, 8.0 * Gdx.Instance().deltaTime );
		 
		 
		// camera.MouseLook(MouseSpeed.x, MouseSpeed.y, 8, 10, 8.0 * Gdx.Instance().deltaTime );
		 previousMouse.set( mx,my);
		}
	}
	override public function TouchUp(x:Float, y:Float, num:Int):Void 
	{
		mouseDow = false; 
	}
	override public function TouchDown(mx:Float, my:Float, num:Int):Void 
	{
		mouseDow = true;
		
		
	}
	
	
	
	
}
