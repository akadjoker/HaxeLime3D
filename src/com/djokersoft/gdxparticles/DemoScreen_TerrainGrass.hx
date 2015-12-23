package com.djokersoft.gdxparticles;

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
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.Screen;
import com.gdx.util.Util;




import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;






/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoScreen_TerrainGrass extends Screen
{


	var font:ImageFont;


	var camera:TargetCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();


var lensflare:LensFlareSystem;

var scene:SceneManager;

var landmesh:Mesh;

var point:SceneNode;

var grass:GrassNode;

	override public function show():Void 
	{
		
		scene = new SceneManager( 50000);
		
		camera = scene.addTargetCamera(0, 200, -200, 0, 0, 1000);
	
//http://blogs.msdn.com/b/eternalcoding/archive/2013/08/06/babylon-js-creating-a-convincing-world-for-your-game-with-custom-shaders-height-maps-and-skyboxes.aspx
		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	scene.addSkyBox(500,"data/skybox01");
	
	 landmesh=MeshCreator.createMeshGroundHeighMap(	"data/island-height.jpg", 5000, 5000,50,0,240);
	var land = scene.addSceneNode(landmesh);
	land.setTexture( Gdx.Instance().getTexture("data/island.jpg",true,true, false));
	land.setTexture( Gdx.Instance().getTexture("data/Sand.jpg", true,true,false),1);
	landmesh.getMeshBuffer(0).scaleTexCoords(5, 5, 1);
	//land.setScale(2, 1.5, 2);
	
	
	point = scene.addSceneNode(MeshCreator.createCube());
	point.setTexture(Gdx.Instance().getTexture("data/noise.jpg",true,true, false));


	 grass = new GrassNode();
	grass.setTexture(getTexture("data/grass1.png"));
	scene.addNode(grass);

	grass.loadFromFile("data/grass.dat");
	
	
/*
	for (x in 0...12)
	{
		for (y in 0...10)
		{
			var variant:Float = Util.randf(18, 100);
			var px =-480 +  x * variant;
			var pz = -480 +  y * variant;
			var size:Float=Util.randf(2, 4);
			var hl:Float = landmesh.getMeshBuffer(0).getHeight(px, pz) + (size);
			grass.addGrass(new Vector3(px,hl,pz), size, 0);
			
			
		}
	}
	*/
	
//	grass.saveToFile("grass.dat");
	


	#if neko

	// var xml = Xml.createElement("SceneManager");
	// grass.save(xml); 
	  
	//var file = File.write("grass.dat", true);
	//file.writeString(

	
	
	//file.close();
	//File.saveContent("nodes.xml", grass.save());
	
	#end
	
	
		
	
	}
	
	override public function dipose():Void 
	{
		
	//	grass.saveToFile("grass.dat");
		super.dipose();
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
		 

		
		
		  if (keyPress(Keys.SPACE))
		 {
		
			  var inpact:Vector3 = Vector3.Zero();
		 var ray = camera.getPointRay(mousex, mousey);
		 landmesh.getMeshBuffer(0).intersectsEx(ray, inpact, true);
		 point.setLocalPosition(inpact);
		
		
			 
			for (x in 0...8)
	{
		for (y in 0...8)
		{
			var variant:Float = Util.randf(5, 10);
			var px =inpact.x +  x * variant;
			var pz =inpact.z +  y * variant;
			var size:Float=Util.randf(2, 4);
			var hl:Float = landmesh.getMeshBuffer(0).getHeight(px, pz) + (size);
			grass.addGrass(new Vector3(px,hl,pz), size, 0);
		}
	}
	
	 
		 }

	
	
		 
		 font.caption = Gdx.Instance().status+"Cam:"+camera.local_pos ;
		 
		 
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
		if (num == 2)
		{
		var inpact:Vector3 = Vector3.Zero();
		var ray = camera.getPointRay(x, y);
		landmesh.getMeshBuffer(0).intersectsEx(ray, inpact, true);
		point.setLocalPosition(inpact);
		var size:Float = Util.randf(2, 4);
		inpact.y += size;
		grass.addGrass(inpact, size, 0);
		}
		
		
		mouseDow = false; 
	}
	override public function TouchDown(mx:Float, my:Float, num:Int):Void 
	{
		mouseDow = true;
		
		
	}
	
	
	
	
}
