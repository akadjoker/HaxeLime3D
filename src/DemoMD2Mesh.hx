package ;

import com.gdx.Gdx;
import com.gdx.gl.shaders.ColorShader;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.MeshMD2;
import com.gdx.scene3d.MeshMD3;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;


import com.gdx.input.Keys;

import com.gdx.scene3d.cameras.TargetCamera;

import com.gdx.scene3d.MeshH3D;
import com.gdx.scene3d.MeshB3D;


import com.gdx.Screen;
import com.gdx.math.*;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoMD2Mesh extends Screen
{

	
	
		var font:ImageFont;

	var camera:TargetCamera;
	
	var scene:SceneManager;

	



	


	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2= Vector2.Zero();
	
	var ha3d:MeshH3D;
	var blitz:MeshB3D;


	override public function show():Void 
	{
		Gdx.Instance().clearColor(0, 0, 0.4);
		
			scene = new SceneManager();
		
		camera = scene.addTargetCamera(0, 4, -10, 0, 0, 100);
	
		font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

		
		

		var animation = new MeshMD2();
		animation.load("data/models/faerie.md2");
		
		{
		var node = scene.addAnimatedSceneNode(animation);
		node.setTexture(Gdx.Instance().getTexture("data/models/faerie2.jpg", true));
		node.Move( -4, 2, 0);
		node.setAnimationByName("point");
		}
		
		{
		var node = scene.addAnimatedSceneNode(animation);
		node.setTexture(Gdx.Instance().getTexture("data/models/faerie2.jpg", true));
		node.Move( 4, 2, 0);
		node.setAnimationByName("salut");
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
		 
		 
		 font.caption = Gdx.Instance().status+"\n Quake2 models(MD2) \n sharing mesh for multiple animations" ;
	 
	 
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
