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
class DemoScreen extends Screen
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
		
			scene = new SceneManager(14000);
		
		camera = scene.addTargetCamera(0, 4, -10, 0, 0, 100);
	
		font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

		
		

		var animation = new MeshMD2();
		animation.load("data/models/faerie.md2");
		
		{
		var node = scene.addAnimatedSceneNode(animation);
		node.setTexture(Gdx.Instance().getTexture("data/faerie2.jpg", true));
		node.Move( -8, 2, 0);
		node.setAnimationByName("point");
		}
		
		{
		var node = scene.addAnimatedSceneNode(animation);
		node.setTexture(Gdx.Instance().getTexture("data/faerie2.jpg", true));
		node.Move( 8, 2, 0);
		node.setAnimationByName("salut");
		}
		

var meshLegs = new MeshMD3( 10);
meshLegs.load("data/models/sarge/lower.md3");

var nodeLegs = scene.addAnimatedSceneNode(meshLegs);
nodeLegs.setTexture(Gdx.Instance().getTexture("data/models/sarge/band.jpg", true));
nodeLegs.loadAnimation("data/models/sarge/legs.xml");
nodeLegs.setAnimationByName("RUN");




var mehsTorso = new MeshMD3( 10);
mehsTorso.load("data/models/sarge/upper.md3");
//legs.getTag(0)
var torso = scene.addAnimatedSceneNode(mehsTorso, nodeLegs.getChildAt(0));// meshLegs.getTag(0));
torso.loadAnimation("data/models/sarge/torso.xml");
torso.setTexture(Gdx.Instance().getTexture("data/models/sarge/band.jpg", true));
torso.setAnimationByName("STAND");
torso.onUpdate = function()
{

};



var m = new MeshMD3(10);
m.load("data/models/sarge/head.md3");
var torso = scene.addAnimatedSceneNode(m, torso.getChildAt(0));// mehsTorso.getTag(0));
torso.setTextureIndex(1,Gdx.Instance().getTexture("data/models/sarge/band.jpg", true));
torso.setTextureIndex(0,Gdx.Instance().getTexture("data/models/sarge/cigar.jpg", true));

ha3d = new MeshH3D();
ha3d.load("data/models/bob.h3d", "data/models/");
	
{
var node = scene.addAnimatedSceneNode(ha3d);
#if debug
for (b in ha3d.Joints)
{
	
	var debug:SceneNode = scene.addSceneNode( MeshCreator.createCube(), b);
    debug.setShader(Gdx.SHADERCOLOR);
	debug.scale(0.2);
//	node.addChild(debug);

}
#end

node.scale(0.1);
node.Translate(2, 0, 0);
node.onUpdate = function()
{
	node.Turn(0, 1, 0);
}
}


{
var node = scene.addAnimatedSceneNode(ha3d);
#if debug
for (b in ha3d.Joints)
{
	
	var debug:SceneNode = scene.addSceneNode( MeshCreator.createCube(), b);
    debug.setShader(Gdx.SHADERCOLOR);
	debug.scale(0.2);
//	node.addChild(debug);

}
#end

node.scale(0.1);
node.Translate(-2, 0, 0);
node.onUpdate = function()
{
	node.Turn(0, 1, 0);
}
}



blitz = new MeshB3D();
blitz.load("data/models/ninja.b3d", "data/models/");
var node = scene.addAnimatedSceneNode(blitz);
node.Translate(8, 0, 0);
#if debug
for (b in blitz.Bones)
{
	
	var debug:SceneNode = scene.addSceneNode( MeshCreator.createCube(), b);
    debug.setShader(Gdx.SHADERCOLOR);
	debug.scale(0.1);

}
#end

	}
	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
	
		
		
		
	}
	
	
	override public function render():Void 
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
		 
		 
		 	 font.caption = Gdx.Instance().status ;
	 
	 
		 scene.update();
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
