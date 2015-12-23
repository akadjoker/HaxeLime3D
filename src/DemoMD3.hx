package ;

import com.gdx.collision.OctSelector;
import com.gdx.collision.QuadSelector;
import com.gdx.Gdx;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.AnimatedSceneNode;
import com.gdx.scene3d.bolt.Bullet;
import com.gdx.scene3d.bolt.Decale;
import com.gdx.scene3d.bolt.Muzzle;
import com.gdx.scene3d.bolt.Sprite3DBatch;
import com.gdx.scene3d.cameras.ArcBallCamera;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.GeoTerrain;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshBSP;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.bolt.BilboardNode;
import com.gdx.scene3d.MeshMD3;
import com.gdx.scene3d.particles.GrassNode;
import com.gdx.scene3d.partition.NodeMeshOctree;

import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.util.Util;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoMD3 extends Screen
{


	var font:ImageFont;

var scene:SceneManager;

	var camera:TargetCamera;
	
	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();

	var map:MeshBSP;

	var octree:NodeMeshOctree;
	var player:AnimatedSceneNode;
	var body:AnimatedSceneNode;
	var gun:AnimatedSceneNode;
	
	
var yaw:Float = 0;
var camYaw:Float = 90;
	var velocity:Vector3 = Vector3.zero;
	var LastPosition:Vector3 = Vector3.zero;
	
	var playerYaw:Float = 0;
	var playerPitch:Float = 0;
	
	var gunPosition:Vector3=Vector3.Zero();
	var gunTarget:Vector3=Vector3.Zero();

	
	var sprites:Sprite3DBatch;

	override public function show():Void 
	{
		
		scene = new SceneManager( );
		
		camera = scene.addTargetCamera(0,  2, -50, 0, 0, 100);
	
	
	
		
		camera.setFarValue(5000.0);


		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	

var meshLegs = new MeshMD3( 10);meshLegs.load("data/model/lower.md3");
player = scene.addAnimatedSceneNode(meshLegs,null,0,"Legs");
player.setTexture(Gdx.Instance().getTexture("data/model/body.jpg", true));
player.loadAnimation("data/model/legs.xml");
player.setAnimationByName("run");
//player.setPos(-100, 6, -50);
player.setPos(0,1,0);




var mehsTorso = new MeshMD3(10);mehsTorso.load("data/model/upper.md3");
body = scene.addAnimatedSceneNode(mehsTorso, meshLegs.getTag(0),0,"Torso");
body.loadAnimation("data/model/torso.xml");
body.setTexture(Gdx.Instance().getTexture("data/model/body.jpg", true));
body.setAnimationByName("stand");


trace("LOAD GUN");
var mgun = new MeshMD3(10);mgun.load("data/model/gun.md3");
gun = scene.addAnimatedSceneNode(mgun, body.getChildAt(1),0,"weapon");
gun.setTexture(Gdx.Instance().getTexture("data/model/gun.jpg", true));




var m = new MeshMD3(10);m.load("data/model/head.md3");
var head = scene.addAnimatedSceneNode(m, body.getChildAt(0),0,"Head");
head.setTexture(Gdx.Instance().getTexture("data/model/head.jpg", true));


sprites = new Sprite3DBatch(500);
scene.addNode(sprites);
sprites.setTexture(getTexture("data/sprites.png", false));
sprites.LoadFrames("data/sprites.xml");


		 
		  for (i in 0...10)
		 {
			 sprites.addSprite(new Bullet(100));
		 }
		 
		 for (i in 0...10)
		 {
			 sprites.addSprite(new Muzzle(200));
		 }
		 for (i in 0...10)
		 {
			 sprites.addSprite(new Decale(300));
		 }



	}

	

	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
	
		
		 var dt:Float =  Gdx.Instance().deltaTime *3 ;
		 var speed:Float = 4.0;

		 
		    if (keyPress(Keys.RIGHT))
		 {
		//	camera.Strafe( -speed*dt);
		 } else
		 if (keyPress(Keys.LEFT))
		 {
			// camera.Strafe( speed*dt);
		 } 
		 
		 if (keyPress(Keys.UP))
		 {
			 camera.Advance( speed*dt);
		 } else
		 if (keyPress(Keys.DOWN))
		 {
			 camera.Advance( -speed*dt);
		 }


		   var dx = Math.sin(-yaw) * speed;
           var dz = Math.cos(-yaw) * speed;
		   velocity.set(0, 0, 0);
	
		  
		   var isMove:Bool = false;
		   var isTurn:Bool = false;
		   
		   
	//	   playerPitch *= 0.98;
		 
		 	 
	   if (keyPress(Keys.W))
		 {
			 velocity.x += dz*dt;
             velocity.z += dx * dt;	
			isMove = true;
			
			 
		 } else
		 if (keyPress(Keys.S))
		 {
		     isMove = true;
			 velocity.x -= dz*dt;
             velocity.z -= dx*dt;	
			 
		 } 
		 
		  if (playerYaw >= 1.4)
		  {
			   playerYaw = 1.4;
			   yaw += 0.4 * dt;
			   isTurn = true;	
		  }else 
		  if(playerYaw<=-0.4)
		  {
			  playerYaw = -0.4;
			   yaw -= 0.4 * dt;
			   isTurn = true;	
		  }
		  
		    if (playerPitch >= 0.5)
		  {
			  playerPitch = 0.5;
		  }else 
		  if(playerPitch<=-0.4)
		  {
			  playerPitch = -0.4;
		  }
		  
		 body.setRotate(0,  playerYaw, playerPitch);
			
		 
		 if (keyPress(Keys.A))
		 {
		     yaw -= 0.4 * dt;
		    isTurn = true;	
	
		 } else
		 if (keyPress(Keys.D))
		 {
			isTurn = true;	
		 	yaw += 0.4 * dt;
		
			
		 } 
		
		 
		 if (isMove)
		 {
			player.setAnimationByName("run");
		 } else
		 {
			  if (isTurn)
			 {
				 player.setAnimationByName("turn");
			 } else
			 {
			 player.setAnimationByName("idle");
			 }
		 }
		 
		 
		player.local_pos.addInPlace(velocity); 
		player.setRotate(0, yaw, 0);
		

		

		 
		var barrel =  gun.getChildAt(0);
		var weap =  gun.getChildAt(2);
		
	
	
		
		
		
	
	
		 
		 scene.update();
	}
	
	
	override public function render():Void 
	{
		
	
		
		
		 scene.render();
		 scene.renderUI();
		
		 
	font.caption = Gdx.Instance().status+"\n\n Quake3 models(MD3) \n 3d sprites" ;
		 

		//selector.debug();
		 
	
		
	 
	}

	override public function TouchMove(mx:Float, my:Float, num:Int):Void 
	{
		mousex = mx;
		mousey = my;
		
	
		 MouseSpeed.x = mx - previousMouse.x ;
		 MouseSpeed.y = my - previousMouse.y  ;
		 MouseSpeed.normalize();
			
		if (mouseDow)
		{
		// camera.MouseLook(MouseSpeed.x, MouseSpeed.y, 8, 10, 8.0 * Gdx.Instance().deltaTime );
		}
		 
		 
		  playerYaw += MouseSpeed.x * (2 * Gdx.Instance().deltaTime);
		  playerPitch += MouseSpeed.y * (1 * Gdx.Instance().deltaTime);
		  
		
		  previousMouse.set( mx,my);
		
	}
	override public function TouchUp(x:Float, y:Float, num:Int):Void 
	{
		mouseDow = false; 
	}
	override public function TouchDown(mx:Float, my:Float, num:Int):Void 
	{
		mouseDow = true;
		
	//	body.SetAnimationRollOverbyName("ATTACK", "STAND");

		var flash =  gun.getChildAt(1);
		gunPosition = flash.getWorldPosition();
		var Forward:Vector3=flash.getWorldTform().rotateVect(new Vector3(1, 0, 0));
		gunTarget.x = gunPosition.x + Forward.x * 100;
		gunTarget.y = gunPosition.y + Forward.y * 100;
		gunTarget.z = gunPosition.z + Forward.z * 100;
		
			
		var m:Muzzle = cast (sprites.getSpritePool(200));
		if (m !=null)
		{
			m.shot(gunPosition);
		}	
		
		var b:Bullet = cast (sprites.getSpritePool(100));
		if (b != null )
		{
			
	
		
			b.shot(gunPosition, gunTarget, 80);
		}
	}
	
	
	
	
}
