package ;

import com.gdx.Gdx;
import com.gdx.gl.Imidiatemode;
import com.gdx.input.Keys;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.SceneNode;

import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.math.*;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;
import com.gdx.gl.MeshBuffer;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoTransform extends Screen
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
	     font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
		
	

	
		
		var player:SceneNode = scene.addSceneNode(MeshCreator.createCone(8));
		 player.setPos( 0, 0, 0);
		 player.onUpdate = function ()
		{
			var vy:Float =  ikeyPress(Keys.P) -ikeyPress(Keys.L);
			var vx:Float =  ikeyPress(Keys.RIGHT) -ikeyPress(Keys.LEFT);
			var vz:Float = ikeyPress(Keys.DOWN)-ikeyPress(Keys.UP) ;
			player.Move(vx, vy, vz);
		};
		player.setTexture(Gdx.Instance().getTexture("data/marble.jpg", true));
		
		
		var poinent:SceneNode =scene.addSceneNode(MeshCreator.createCube());
		poinent.setPos( 2, 0, 0);
		 poinent.onUpdate = function ()
		{
		//	poinent.Point(player);
			poinent.PointLerp(player,0.02);
	
			};
		poinent.setTexture(Gdx.Instance().getTexture("data/point.jpg", true));
			
		
		
		var cylx:SceneNode =scene.addSceneNode(MeshCreator.createCube());
	    cylx.setPos(0, 0, 0);
		cylx.setTexture(Gdx.Instance().getTexture("data/align.jpg", true));
		cylx.onUpdate = function ()
		{
			var meuX:Float = cylx.nodeX();
			var meuZ:Float = cylx.nodeZ();
			
			var alvoX:Float = player.nodeX();
			var alvoZ:Float = player.nodeZ();
			
	
			cylx.AlignToVector(alvoX - meuX, 0, alvoZ - meuZ, 3, 0.1);
			
		};
		

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
		 
	 
font.caption = Gdx.Instance().status+"\n\n Transformation keys(Up/Down left/right p/l)" ;
		 
		 
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
