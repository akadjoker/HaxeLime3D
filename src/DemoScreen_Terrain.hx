package ;

import com.gdx.collision.Coldet;
import com.gdx.collision.Collider;
import com.gdx.collision.CollisionData;
import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.gl.Imidiatemode;
import com.gdx.input.Keys;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.MeshGroundHeighMap;
import com.gdx.scene3d.MeshLargeLandScape;
import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.math.*;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;
import com.gdx.gl.MeshBuffer;




import com.gdx.scene2d.ui.BitmapFont;
import com.gdx.scene2d.ui.Font;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoScreen_Terrain extends Screen
{

	var font:ImageFont;


	var camera:FreeCamera;


	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();
	var lines:Imidiatemode;

	
	var velocity:Vector3 = Vector3.Zero();

var lensflare:LensFlareSystem;

var scene:SceneManager;



var collider:Collider;


		  
	override public function show():Void 
	{
		
		scene = new SceneManager( );
		
		camera = scene.addFreeCamera(10, 120, 100);
		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	collider = new Collider();
	
	
	
		
	var land = new MeshGroundHeighMap("data/terra/island-height.jpg", 1000, 1000,20,0,140);
	land.getMeshBuffer(0).scaleTexCoords(20, 20, 1);
	collider.Triangles=land.getMeshBuffer(0).getTriangles();

    var l = scene.addSceneNode(land);
	l.setTexture( Gdx.Instance().getTexture("data/terra/island.jpg",true,true, true),0);
	l.setTexture(  Gdx.Instance().getTexture("data/terra/Sand.jpg", true,true,true),1);
	
	
		 
		
	
	}
	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
		
		 var dt:Float =  Gdx.Instance().deltaTime *3 ;
		 var speed:Float= 2;
		 
		    var dx = Math.sin(camera.yaw) * speed;
           var dz = Math.cos(camera.yaw) * speed;
		   velocity.set(0, 0, 0);
	
		    if (keyPress(Keys.P))
		 {
			 velocity.y += 1;
             
			 
		 } else
		 if (keyPress(Keys.L))
		 {
			 velocity.y -= 1;
			 
		 } 
		 
		 	 
	   if (keyPress(Keys.D))
		 {
			 velocity.x += dz;
             velocity.z += dx;	
			 
		 } else
		 if (keyPress(Keys.A))
		 {
			 velocity.x -= dz;
             velocity.z -= dx;	
			 
		 } 
		 
		 if (keyPress(Keys.W))
		 {
			
			 velocity.x += dx;
             velocity.z += dz;	
	
		 } else
		 if (keyPress(Keys.S))
		 {
			
	         velocity.x -= dx;
             velocity.z -= dz;
			
		 }

		var velocityAndGravity:Vector3 = velocity.add(new Vector3(0, -0.9, 0));
		collider.moveAndSlide(camera.local_pos,velocityAndGravity,new Vector3(8,12,8),new Vector3(0,-4,0));

		
		 
		font.caption = Gdx.Instance().status+"\n\n HeightMap Terrain with simple collision response" ;
		 
		 
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
		 camera.yaw += MouseSpeed.x * Gdx.Instance().deltaTime;
		 camera.pitch += MouseSpeed.y * Gdx.Instance().deltaTime;
		 
		 if (camera.pitch >= 1.2)
		 {
			 camera.pitch = 1.2;
		 }
		 if (camera.pitch <= -0.5)
		 {
			 camera.pitch = -0.5;
		 }
	
		 
		 
		 
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
