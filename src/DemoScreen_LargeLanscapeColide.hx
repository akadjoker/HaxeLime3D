package ;

import com.gdx.collision.OctSelector;
import com.gdx.collision.QuadSelector;
import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.gl.Imidiatemode;
import com.gdx.input.Keys;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.lensflare.LensFlareSystem;

import com.gdx.scene3d.MeshLargeLandScape;

import com.gdx.scene3d.MeshSkyBox;


import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.math.*;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Node;
import com.gdx.gl.MeshBuffer;

import com.gdx.util.Util;

import com.gdx.util.SpriteSheet;

import com.gdx.scene2d.render.BatchPrimitives;
import com.gdx.scene2d.render.SpriteAtlas;
import com.gdx.scene2d.render.SpriteBatch;
import com.gdx.scene2d.render.SpriteCloud;

import com.gdx.scene2d.ui.BitmapFont;
import com.gdx.scene2d.ui.Font;



/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoScreen_LargeLanscapeColide extends Screen
{

	var font:ImageFont;


	var camera:FreeCamera;

	var land:MeshLargeLandScape;
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();
	var lines:Imidiatemode;
	var canvas:BatchPrimitives;
	
	var landColider:QuadSelector;


var lensflare:LensFlareSystem;

var scene:SceneManager;
var mousex:Float=0;
var mousey:Float = 0;

var sngWalk:Float = 0;
var sngStrafe:Float = 0;
var sngAngleX:Float = 0;
var sngAngleY:Float = 0;
var pointPos:Vector3 = Vector3.Zero();
var velocity:Vector3 = Vector3.zero;
var LastPosition:Vector3 = Vector3.zero;
var ellipse:Vector3 = new Vector3(8, 12, 8);

var PlayerAngleY:Float = 0;
var PlayerAngleX:Float = 0;

var PlayerAngleYSpeed:Float = 0;
var PlayerAngleYAim:Float = 0;
var PlayerAngleXSpeed:Float = 0;
var PlayerAngleXAi:Float = 0;
var PlayerAngleXAim:Float = 0;

	override public function show():Void 
	{
		
		scene = new SceneManager();
		
		camera = scene.addFreeCamera(20,20,20);

		
		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	
	
	
	scene.addSkyBox(500, "data/skybox01");
	
		
	 land = new MeshLargeLandScape("data/terra/Raid.png");
	 land.GenerateHugeTerrain(8,1,1,80,0,0);
//	land.ExpandTexture(0, 0, 4, 4);
	land.scaleTexCoords(40, 40, 1);
	var l = scene.addSceneNode(land);
	
	l.setTexture( Gdx.Instance().getTexture("data/terra/raidtexture.jpg", true, true, true));
	l.setTexture( Gdx.Instance().getTexture("data/terra/detail_texture.jpg",true,true, true),1);
		
//l.visible = false;
	
	landColider = new QuadSelector(250, 4);
	landColider.addLargeLandscape(land);
	landColider.build();
	
var spr:SpriteSheet = new SpriteSheet();
spr.loadSparrow("flares.xml", "data/");
		

lensflare =scene.addLensFlare( spr,-4500,6850,-4450);
//lensflare =scene.addLensFlare( spr,-500,680,-600);
         lensflare.addFlare(5, 0.9, 0 ,Color3.YELLOW);
		 lensflare.addFlare(3, 0.5, 0.2);
		 lensflare.addFlare(1, 0.6, 0.4);
		 lensflare.addFlare(4, 0.7, 0.6);
		 lensflare.addFlare(0, 0.5, 0.7);
		 lensflare.addFlare(3, 0.8, 0.8);
		 lensflare.addFlare(2, 0.5, 0.9);
		 lensflare.addFlare(1, 0.4, 1.0);
		 
		
	
	}
	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
	
	
		
		 var dt:Float =  Gdx.Instance().deltaTime *3 ;
		 var speed:Float = 0.9;
		 
		 var walk:Bool = false;
		 
		
	
		
		    var dx = Math.sin(camera.yaw) * speed;
           var dz = Math.cos(camera.yaw) * speed;
		   velocity.set(0, 0, 0);
	
		 	 
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
		 
		 
			 
	//	var velocityAndGravity:Vector3 = velocity.add(new Vector3(0, -0.9, 0));
	//	camera.position.addInPlace(velocity);

		 
	//	var bounds:BoundingBox = new BoundingBox(
	//	new Vector3(camera.local_pos.x - 20, camera.local_pos.y - 20, camera.local_pos.z - 20), 
	//	new Vector3(camera.local_pos.x + 20, camera.local_pos.y + 20, camera.local_pos.z + 20));
	
		
	
		
		
		 scene.update();
		
		 
			
		 var bounds:BoundingBox = new BoundingBox(Vector3.zero,Vector3.zero);
			bounds.reset(camera.local_pos);
			bounds.addInternalVector(Vector3.Add(camera.local_pos, velocity));
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
		
		//landColider.BoxTraceSimples(bounds, camera.local_pos, ellipse, velocityAndGravity, closeDistance);
		landColider.BoxTrace(bounds, camera.local_pos, ellipse, velocity,new Vector3(0,-0.4,0), closeDistance);
	
	//	landColider.SphereTraceSimples(30, camera.local_pos, ellipse, velocityAndGravity, closeDistance);
		
	//SceneManager.lines.drawABBox(bounds, 0, 1, 1);
		 
	}
	
	
	override public function render():Void 
	{
	
		
	
	   //  landColider.debug();
		
		
		 scene.render();
		 scene.renderUI();
		 
		 	  
		
		
		
		  
	
	//	pos.y = hi;
		
		 
font.caption = Gdx.Instance().status+"\n\n Large Lanscape with QuadTree collision response" ;
	 
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
		// camera.MouseLook(MouseSpeed.x, MouseSpeed.y, 8, 10, 8.0 * Gdx.Instance().deltaTime );
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
