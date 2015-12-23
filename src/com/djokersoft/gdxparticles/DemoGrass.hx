package com.djokersoft.gdxparticles;

import com.gdx.Gdx;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.GeoTerrain;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.bolt.BilboardNode;
import com.gdx.scene3d.particles.GrassNode;
import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.util.Util;






/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoGrass extends Screen
{


	var font:ImageFont;

var scene:SceneManager;

	var camera:TargetCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();




	override public function show():Void 
	{
		
		scene = new SceneManager( 90000);
		
		camera = scene.addTargetCamera(0, 200, -200, 0, 0, 1000);
	

		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
		
{
	var m = MeshCreator.createPlane(0, 1000, 1000);
	
	var n = scene.addSceneNode(m);
	n.setTexture(getTexture("data/Sand.jpg"));
}
	

	var grass:GrassNode = new GrassNode();
	grass.setTexture(getTexture("data/grass1.png"));
	scene.addNode(grass);

	
	for (x in 0...32)
	{
		for (y in 0...30)
		{
			var variant:Float = Util.randf(18, 30);
			var px =-480 +  x * variant;
			var pz = -480 +  y * variant;
			var size:Float=Util.randf(6, 17);
			var hl:Float = 0+(size-1);
			grass.addGrass(new Vector3(px,hl,pz), size, 0);
			
			
		}
	}
//	grass.setPos( -450, 0, -450);	
	
		 
		
	
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
		 var speed:Float= 80;
		 
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
		 


	
	
		 
		 font.caption = Gdx.Instance().status+"Cam:"+camera.local_pos ;
		 
		 
		 scene.update();
		 scene.renderUI();
		

		
		 
	
		
	 
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
