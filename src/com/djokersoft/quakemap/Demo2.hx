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
import com.gdx.scene3d.partition.NodeOctree;
import com.gdx.scene3d.SceneNode;

import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.util.Util;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Demo2 extends Screen
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

	var octree:NodeOctree;

	override public function show():Void 
	{
		
		scene = new SceneManager( 50000);
		
		camera = scene.addTargetCamera(0, 10, -10, 0, 0, 100);
		camera.setFarValue(42000.0);


		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
	
	octree = new NodeOctree(60);
	var mesh = MeshCreator.createCube();
	for (x in 0...28)
	{
		for (y in 0...28)
		{
		  
		  var node:SceneNode = new SceneNode(mesh);
		  node.setTexture(getTexture("data/t351sml.jpg", true, true, true), 0);
		  node.setPos(x * 5, Util.randf(-5, 5), y * 5);
		 var large = Util.randf(1, 1.5);
		  node.setScale(large, Util.randf(0.5, 1.5), large);
 		 octree.addNode(node);
		}
	}
	
	octree.build();
	scene.addNode(octree);
	

/*	
var mesh = MeshCreator.createCube();
	for (x in 0...28)
	{
		for (y in 0...28)
		{
		  
		 var node:SceneNode = scene.addSceneNode(mesh);
		   node.setTexture(getTexture("data/t351sml.jpg", true, true, true), 0);
		  node.setPos(x * 5, Util.randf(-5, 5), y * 5);
		  var large = Util.randf(1, 1.5);
		  node.setScale(large, Util.randf(0.5, 1.5), large);
 
		 
		}
	}


*/
//scene.addSceneNode(map);
		 
		
	
	}
	

	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
	
	}
	
	
	override public function render():Void 
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
		 scene.renderUI();
		
		 
		 font.caption = Gdx.Instance().status ;
		 

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
