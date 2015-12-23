package ;

import com.gdx.Gdx;
import com.gdx.gl.Imidiatemode;
import com.gdx.input.Keys;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.MeshCreator;

import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.math.*;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;
import com.gdx.scene3d.SceneNode;
import com.gdx.gl.MeshBuffer;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoPrimitives extends Screen
{

	var font:ImageFont;
	var Cube:SceneNode;
	var Cube2:SceneNode;

	var camera:TargetCamera;




	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2= Vector2.Zero();
	
	var scene:SceneManager;

	override public function show():Void 
	{
	
		Gdx.Instance().clearColor(0, 0, 0.4);
		
		scene = new SceneManager( );
		camera = scene.addTargetCamera(0,2,-20,0,0,100);
	     font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 150);


		
	
		Cube =  scene.addSceneNode(MeshCreator.createCube());
		Cube.setTexture(Gdx.Instance().getTexture("data/marble.jpg", true));
		Cube.setPos( -4, 0, 0);
		var turn:Float = 0;
		Cube.Turn(90, 0, 0, false);
	    Cube.onUpdate = function ()
		{
			Cube.Rotate(turn, 0.0, 0.0);
			turn += 1;
		//Cube.Turn(0,0.5, 0);
		
		
		};
		
		
		Cube2 = scene.addSceneNode(MeshCreator.createCube(),Cube);
		Cube2.setTexture(Gdx.Instance().getTexture("data/marble.jpg", true));
		Cube2.setPos(1, 2, 0);
		
		var global:Bool = true;
		
		var yaw:Float = 0;
		Cube2.onUpdate = function ()
		{
			 	 
	   if (keyPress(Keys.P))
		 {
			global = true;
		 } else
		 if (keyPress(Keys.L))
		 {
			global = false;
		 } 
		 
		
		 
		 
			//
			Cube2.Rotate(0,yaw,  0.0, global);
			//yaw += 1;
			//Cube2.Turn(0, 0, 1, true);
		};
	
		
		var cone:SceneNode = scene.addSceneNode(MeshCreator.createCone(8));
		cone.setPos( 0, 0, -5);
		 cone.onUpdate = function ()
		{
			
			var vx:Float =  ikeyPress(Keys.RIGHT) -ikeyPress(Keys.LEFT);
			var vy:Float = ikeyPress(Keys.DOWN)-ikeyPress(Keys.UP) ;
			
			cone.Move(vx, 0, vy);
			
		
		 if (keyPress(Keys.LEFT))
		 {
			cone.Turn(0,1, 0);
		 } else
		 if (keyPress(Keys.RIGHT))
		 {
			cone.Turn(0,-1, 0);
		 } 
		
		if (keyPress(Keys.UP))
		 {
			cone.Move(0, 0, 1);
		 } else
		 if (keyPress(Keys.DOWN))
		 {
			cone.Move(0, 0, -1);
		 } 
		 
			//cone.Point(Cube);
		//	cone.rotate(0.1, 0.1, 0.1);
		//	cone.setPos(Math.sin(Gdx.Instance().getTimer() / 1000) * 50, 0, Math.cos(Gdx.Instance().getTimer() / 1000) * 50);
		};
		cone.setTexture(Gdx.Instance().getTexture("data/marble.jpg", true));
		
		
		var poinent:SceneNode = scene.addSceneNode(MeshCreator.createCube());
		poinent.setPos( -6, 0, -5);
		 poinent.onUpdate = function ()
		{
			poinent.Point(cone);
	
			};
		poinent.setTexture(Gdx.Instance().getTexture("data/marble.jpg", true));
			
		
		var cyl:SceneNode =scene.addSceneNode(MeshCreator.createCylinder());
	    cyl.setTexture(Gdx.Instance().getTexture("data/marble.jpg", true));
		
		
		var cylx:SceneNode = scene.addSceneNode(MeshCreator.createCube());
	    cylx.setPos(0, 0, -5);
		cylx.setTexture(Gdx.Instance().getTexture("data/marble.jpg", true));
		cylx.onUpdate = function ()
		{
			var meuX:Float = cylx.nodeX();
			var meuZ:Float = cylx.nodeZ();
			
			var alvoX:Float = cone.nodeX();
			var alvoZ:Float = cone.nodeZ();
			
			//cylx.Turn(0.0, 0.0, 0.1);
			cylx.AlignToVector(alvoX - meuX, 0, alvoZ - meuZ, 3, 0.2);
			
		};
		

	}
override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
	
		 var dt:Float =  Gdx.Instance().deltaTime *3 ;
		 var speed:Float= 10;
		 
	
		 	 
	   if (keyPress(Keys.D))
		 {
			camera.Strafe( speed*dt);
		 } else
		 if (keyPress(Keys.A))
		 {
			 camera.Strafe( -speed*dt);
		 } 
		 
		 if (keyPress(Keys.W))
		 {
			 camera.Advance( speed*dt);
		 } else
		 if (keyPress(Keys.S))
		 {
			 camera.Advance( -speed*dt);
		 }
		 
		 
		 	 font.caption = Gdx.Instance().status+"\n\n\n Primitives and Transformation \n use left/right keys" ;
		
		 scene.update();
	}
	
	
	override public function render():Void 
	{
		
	 
	 
	 scene.render();
	
	 
	 
	 scene.renderUI();
		 
	
	 

	 
	}
	
	

	override public function TouchMove(mx:Float, my:Float, num:Int):Void 
	{
		if (mouseDow)
		{
			 MouseSpeed.x = mx - previousMouse.x ;
		 MouseSpeed.y = my - previousMouse.y  ;
		 MouseSpeed.normalize();
		 camera.MouseLook(MouseSpeed.x, MouseSpeed.y, 8, 10, 8.0 * Gdx.Instance().deltaTime );
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
