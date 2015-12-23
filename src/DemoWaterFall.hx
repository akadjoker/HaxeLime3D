package ;

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
class DemoWaterFall extends Screen
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
		
		scene = new SceneManager( );
		
		camera = scene.addTargetCamera(0, 2, -10, 0, 0, 1000);
	

		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
		

	var m = MeshCreator.createPlane(0, 100, 100);
	
	var n = scene.addSceneNode(m);
	n.setTexture(getTexture("data/terra/Sand.jpg"));

	
	particles = new ParticleSystem(100);
	particles.setTexture(getTexture("data/Fire.png"));
	particles.createWaterFall();
	particles.addGravityAffector(new Vector3(0, -0.40, 0), 1800);
	particles.addBounceAffector(0.5, 1000);
//	particles.addRotateAffector(new Vector3(0, -100, 0), new Vector3(0, 0, 0));
	

	particles.addColorMorphAffector([new Color3(0.2, 0,0),
                                     new Color3(0.5, 1, 0),
									 new Color3(0, .5,1),
									 new Color3(0.5, 0.2, 0),
									 new Color3(1, 0.9, 1)],
									 [ 500, 800, 1250, 1500, 2000], true);
									 

	scene.addNode(particles);

	{
		
		var p = new BoxEmitter(new Vector3( -2, 0, -2), new Vector3(2, 2, 2));
	p.setTexture(getTexture("data/Fire.png"));
	p.createFire();
	p.setPos(3, 0, 0);
	scene.addNode(p);
	

	}
	
	{
		
		var p = new SphereEmitter(new Vector3( 0, 0, 0), 1);
	p.setTexture(getTexture("data/Fire.png"));
	p.createFire();
	p.setPos(-4, 0, 0);
	scene.addNode(p);
	

	}
	
	{
		
		var p = new CylinderEmitter(new Vector3(0, 1, 0), 1, new Vector3(0, 0, 0), 0.5,false);
	p.setTexture(getTexture("data/Fire.png"));
	p.createFire();
	p.setPos(8, 0, 0);
	scene.addNode(p);
	

	}
	
		{
		
		var p = new RingEmitter(new Vector3(0, 0, 0), 2,0,0);
	p.setTexture(getTexture("data/Fire.png"));
	p.createFire();
	p.setPos(-8, 0, 0);
	scene.addNode(p);
	

	}

	}
	

	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
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
		 


		 
	
	
		 
	font.caption = Gdx.Instance().status+"\n\n Particles" ;
		 
		 
		 scene.update();
	}
	
	
	override public function render():Void 
	{
		
	
	scene.render();
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
		
		particles.restart();
		
		
	}
	
	
	
	
}
