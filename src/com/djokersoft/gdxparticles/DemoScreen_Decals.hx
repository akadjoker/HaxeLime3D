package com.djokersoft.gdxparticles;

import com.gdx.Gdx;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.bolt.BilboardNode;
import com.gdx.scene3d.bolt.DecaleNode;
import com.gdx.scene3d.particles.GrassNode;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.Screen;
import com.gdx.util.Util;











/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoScreen_Decals extends Screen
{


	var font:ImageFont;


	var camera:TargetCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();


var scene:SceneManager;

var mesh:Mesh;

var point:SceneNode;
var decals:DecaleNode;


	override public function show():Void 
	{
		
		scene = new SceneManager( 90000);
		
		camera = scene.addTargetCamera(8, 140, -550, 0, 0, 1000);
	
		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
	mesh = MeshCreator.loadStaticB3DMesh("data/castel.b3d", "data/textures/");
	mesh.Scale(0.2, 0.2, 0.2);

	scene.addSceneNode(mesh);
	
	point = scene.addSceneNode(MeshCreator.createCube());
	point.setTexture(Gdx.Instance().getTexture("data/noise.jpg",true,true, false));


	decals = new DecaleNode(500);
	decals.setTexture(getTexture("data/grass1.png"));
	scene.addNode(decals);
	
		
	
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
		 

			  var inpact:Vector3 = Vector3.Zero();
		      var ray = camera.getPointRay(mousex, mousey);
		 
		if (mesh.rayTrace(ray))
		{
		point.setLocalPosition(mesh.getContactPoint());	
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
		if (num == 2)
		{
			  var inpact:Vector3 = Vector3.Zero();
		      var ray = camera.getPointRay(x, y);
		 
		if (mesh.rayTrace(ray))
		{
		point.setLocalPosition(mesh.getContactPoint());	
		decals.addDecal(mesh.getContactPoint(), mesh.getContactNormal(), 5, 20);
		}
		
		}
		
		
		mouseDow = false; 
	}
	override public function TouchDown(mx:Float, my:Float, num:Int):Void 
	{
		mouseDow = true;
		
		
	}
	
	
	
	
}
