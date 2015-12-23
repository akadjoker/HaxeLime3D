package ;

import com.gdx.collision.Collider;
import com.gdx.collision.Octree;
import com.gdx.collision.OctSelector;
import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.gl.Imidiatemode;
import com.gdx.input.Keys;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.MeshGroundHeighMap;
import com.gdx.scene3d.MeshLargeLandScape;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.Screen;
import com.gdx.math.*;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;
import com.gdx.gl.MeshBuffer;



/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoScreen_TerrainOctree extends Screen
{

	var octree:OctSelector;
	  
var ellipse:Vector3 = new Vector3(4, 4, 4);

	var font:ImageFont;

	var velocity:Vector3 = Vector3.zero;
	var LastPosition:Vector3 = Vector3.zero;

	var camera:TargetCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();
	var lines:Imidiatemode;



var scene:SceneManager;

var triangles:Array<Triangle>;




var player:SceneNode;

var yaw:Float=0;


	override public function show():Void 
	{
		
		scene = new SceneManager( );
		
		camera = scene.addTargetCamera(100, 200, -300, 0, 0, 1000);
		
		
		player = scene.addSceneNode(MeshCreator.createSphere());
	//player=scene.addCubeMesh();
		player.setTexture( Gdx.Instance().getTexture("data/marble.jpg"));
		player.scale(4);
		player.setPos(100,100,100);

    var cube=scene.addSceneNode(MeshCreator.createCube(),player);
		cube.setTexture( Gdx.Instance().getTexture("data/marble.jpg"));
		cube.setScale(1,0.5,0.5);
		cube.setPos(1,0.5,0.5);


		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);


	

		
	var land = new MeshGroundHeighMap("data/terra/island-height.jpg", 1000, 1000,20,0,140);
	land.getMeshBuffer(0).scaleTexCoords(20, 20, 1);
	
	var l = scene.addSceneNode(land);
	l.setTexture( Gdx.Instance().getTexture("data/terra/island.jpg",true,true, true),0);
	l.setTexture(  Gdx.Instance().getTexture("data/terra/Sand.jpg", true,true,true),1);

	octree = new OctSelector(100, 8);
	octree.addMeshBuffer(land.getMeshBuffer(0));
	octree.build();
	
	
		 
		
	
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
		 


           var force:Float= 80;

		   var dx = Math.sin(-yaw) * force;
           var dz = Math.cos(-yaw) * force;
		   velocity.set(0, 0, 0);
	
		  
		 
		 	 
	   if (keyPress(Keys.UP))
		 {
			 velocity.x += dz*dt;
             velocity.z += dx*dt;	
			 
		 } else
		 if (keyPress(Keys.DOWN))
		 {
			 velocity.x -= dz*dt;
             velocity.z -= dx*dt;	
			 
		 } 
		 
		 if (keyPress(Keys.LEFT))
		 {
		 	yaw-=2*dt;
	
		 } else
		 if (keyPress(Keys.RIGHT))
		 {
		 	yaw+=2*dt;
			
		 }
		
		player.setRotate(0,yaw,0);


	
		 
		font.caption = Gdx.Instance().status+"\n\n HeightMap Terrain with Octree collision response \n left/right and up/down control player" ;
		 
		 
		 scene.update();
		 
		 // octree.debug();
		 
	
		 var bounds:BoundingBox = new BoundingBox(Vector3.zero, Vector3.zero);
		    bounds.reset(player.local_pos);
			bounds.addInternalVector(Vector3.Add(player.local_pos, velocity));
			bounds.minimum.x -= ellipse.x;
			bounds.minimum.y -= ellipse.y;
			bounds.minimum.z -= ellipse.z;
			bounds.maximum.x += ellipse.x;
			bounds.maximum.y += ellipse.y;
			bounds.maximum.z += ellipse.z;
			bounds.calculate();

			
		
		//land.colide(camera.position, new Vector3(10, 18, 10), velocityAndGravity, 0.0005);
		var CollisionsEpsilon:Float = 0.001;
		var closeDistance = CollisionsEpsilon * 10.0;
		
	//	octree.BoxTrace(bounds,player.local_pos,ellipse,velocity,new Vector3(0,-0.9,0),closeDistance);
		SceneManager.lines.drawABBox(bounds,0,0,1);
		
	}
	
	
	override public function render():Void 
	{
		
		
		scene.render();
		 scene.renderUI();
		

		 
		 //octree.RayTrace(ray);
		 
		

	 
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
