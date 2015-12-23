package com.djokersoft.gdxparticles;

import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.bolt.BilboardNode;
import com.gdx.scene3d.particles.GrassNode;
import com.gdx.scene3d.particles.ParticleSystem;
import com.gdx.scene3d.particles.BoxEmitter;
import com.gdx.scene3d.particles.CylinderEmitter;
import com.gdx.scene3d.particles.MeshEmitter;
import com.gdx.scene3d.particles.RingEmitter;
import com.gdx.scene3d.particles.SphereEmitter;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.Screen;
import com.gdx.util.Util;






/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoBoxEmmiter extends Screen
{


	var font:ImageFont;

var scene:SceneManager;

	var camera:TargetCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();

	var particles:ParticleSystem;
	



	override public function show():Void 
	{
		
		scene = new SceneManager( 50000);
		
		camera = scene.addTargetCamera(0, 2, -10, 0, 0, 1000);
	

		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
		
{
	var m = MeshCreator.createPlane(0, 100, 100);
	
	var n = scene.addSceneNode(m);
	n.setTexture(getTexture("data/Sand.jpg"));
}
	
{
	var m = MeshCreator.createCube();
	
	var n = scene.addSceneNode(m);
	n.setTexture(getTexture("data/hire.png"));
	n.getMaterial(0).setMaterialType(Gdx.MaterialTransparentAlphaChannel);
	n.setPos(0, 1, 0);

		
		var p = new BoxEmitter(20,new Vector3( -1, -1.5, -1), new Vector3(1, 0, 1),n);
		
	p.setTexture(getTexture("data/Fire.png"));
	p.createFire();
	
	
									 
									 
	scene.addNode(p);
	

	}


	{
		
		var m = MeshCreator.createSphere(8);
	
	var n = scene.addSceneNode(m);
	n.setTexture(getTexture("data/Fire.png"));
	n.getMaterial(0).setMaterialType(Gdx.MaterialTransparentAlphaChannel);
	n.setPos(-4, 2, 0);

	
		var p = new SphereEmitter(30,new Vector3( 0, -0.5, 0), 0.5,n);
	p.setTexture(getTexture("data/Fire.png"));
	p.addRotateAffector(new Vector3(0, -120, 0), Vector3.Zero());
	p.createFire();

		p.addColorMorphAffector([Color3.DARKORANGE,
	                         Color3.DARKVIOLET,
							 Color3.WHITE,
							 Color3.YELLOW,
							 Color3.BLUE],
									 [ 500, 800, 1250, 1500, 2000], true);
									 
	scene.addNode(p);
	

	}
	

	{
		
			var m = MeshCreator.createCylinder();
	
	var n = scene.addSceneNode(m);
	n.setTexture(getTexture("data/hire.png"));
	n.getMaterial(0).setMaterialType(Gdx.MaterialTransparentAlphaChannel);
	n.setPos(5, 2, 0);
		
		var p = new CylinderEmitter(20,new Vector3(0, 1, 0), 1, new Vector3(0, -1, 0), 0.5,false,n);
	p.setTexture(getTexture("data/light.jpg"));
	p.addRotateAffector(new Vector3(0, 90, 0), Vector3.Zero());
	p.setupEmitter(-1, 
			new Vector3( 0.2, 0.4, 0.1), new Vector3(0.40, 1.8, 0.2), 
			new Vector3(0.01, 0.1, 0.00), new Vector3(0.01, 0.5, 0.0),
		0.8, 4.5, 4.2, 
		new Color3(0.5,0.5,0.5), new Color3(0.1,0.1,0.1), 
		1.0, 0.4, 
		4, 2.8);
	

	
	scene.addNode(p);
	

	}
	
	/*
		{
		
		var p = new RingEmitter(new Vector3(0, 0, 0), 2,0,0);
	p.setTexture(getTexture("data/Fire.png"));
	p.createFire();
	p.setPos(-8, 0, 0);
	scene.addNode(p);
	

	}
	*/
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
		
		//particles.restart();
		
		
	}
	
	
	
	
}
