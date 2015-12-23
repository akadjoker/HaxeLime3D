package ;

import com.gdx.collision.Collider;
import com.gdx.collision.Octree;
import com.gdx.collision.OctSelector;
import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.gl.Imidiatemode;
import com.gdx.input.Keys;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.ArcBallCamera;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.MeshB3D;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.MeshGroundHeighMap;
import com.gdx.scene3d.MeshH3D;
import com.gdx.scene3d.MeshLargeLandScape;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.Screen;
import com.gdx.math.*;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;
import com.gdx.gl.MeshBuffer;
import com.gdx.util.Util;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoScreen_MeshOctree extends Screen
{

	var octree:OctSelector;

		  

	var font:ImageFont;

	var velocity:Vector3 = Vector3.zero;
	var LastPosition:Vector3 = Vector3.zero;

	var camera:ArcBallCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();
	var lines:Imidiatemode;

	var ellipse:Vector3 = new Vector3(4, 4, 4);

var scene:SceneManager;

var triangles:Array<Triangle>;
var camYaw:Float = 90;


var player:SceneNode;


var yaw:Float=0;


	override public function show():Void 
	{
		
		scene = new SceneManager( );
		
		//camera = scene.addTargetCamera(100, 100, -20, 0, 0, 1000);
		camera = scene.addArcBallCamera( new Vector3(64, 16, 64),
		Util.ToRadians( -30), 0, 32, 192, 128);
		//(new Vector3(-50, 30, 0));
		
		player= scene.addSceneNode(MeshCreator.createSphere());
		player.setTexture( Gdx.Instance().getTexture("data/marble.jpg"));
		
		player.setScale(3, 6, 3);
		player.setPos(100,150,100);

		
		
var cube=scene.addSceneNode(MeshCreator.createCube(),player);
		cube.setTexture( Gdx.Instance().getTexture("data/marble.jpg"));
		cube.setScale(1,0.5,0.5);
		cube.setPos(0.7,0.8,0);


var mesh = MeshCreator.loadStaticB3DMesh("data/models/castel.b3d","data/models/textures/");

mesh.Scale(0.4,0.4,0.4);
mesh.Translate(-780,0.4,0);
mesh.Rotate(90, 0, 0);

scene.addSceneNode(mesh);

		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
				
	var land = new MeshGroundHeighMap("data/terra/island-height.jpg", 1000, 1000,20,0,140);
	land.getMeshBuffer(0).scaleTexCoords(20, 20, 1);
	
	
	var l = scene.addSceneNode(land);
//	l.visible = false;
	l.setTexture( Gdx.Instance().getTexture("data/terra/island.jpg",true,true, true),0);
	l.setTexture(  Gdx.Instance().getTexture("data/terra/Sand.jpg", true,true,true),1);

	octree = new OctSelector(250, 4);
	octree.addMeshBuffer(land.getMeshBuffer(0));
	octree.addMesh(mesh);
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


	camera.Target = player.local_pos;
	
	camera.Rotation = Util.Lerp(camera.Rotation, yaw - Util.ToRadians(camYaw), 1.9*Gdx.Instance().deltaTime);
		 
		font.caption = Gdx.Instance().status+"\n HeightMap and Mesh with Octree collision response \n left/right and up/down control player" ;
			
		 
		 scene.update();
		 
		
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
		
		octree.BoxTrace(bounds,player.local_pos,ellipse,velocity,new Vector3(0,-0.9,0),closeDistance);
	//	SceneManager.lines.drawABBox(bounds,0,0,1);
		
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
		
		 
		 
		 var yawSpeed:Float = 50;
		 var pitchSpeed:Float = 100;
	
		   
	//	if (mouseDow)
		{
		
		 MouseSpeed.x = mx - previousMouse.x ;
		 MouseSpeed.y = my - previousMouse.y  ;
		 MouseSpeed.normalize();
		
		 camera.Elevation += MouseSpeed.y * Gdx.Instance().deltaTime;
		 camYaw+= MouseSpeed.x * (5 * Gdx.Instance().deltaTime);
		   
	
		 previousMouse.set( mx,my);
		}
	}
	override public function TouchUp(x:Float, y:Float, num:Int):Void 
	{
		//camera.yaw = 0;
		//camera.pitch = 0;
		mouseDow = false; 
	}
	override public function TouchDown(mx:Float, my:Float, num:Int):Void 
	{
		mouseDow = true;
		
		
	}
	
	
	
	
}
