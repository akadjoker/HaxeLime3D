package ;

import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.lights.PointLight;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;








/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoH3DMeshStatic extends Screen
{

	
	
		var font:ImageFont;

	var camera:TargetCamera;
	
	var scene:SceneManager;

	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2= Vector2.Zero();
	

	
	var currFrame:Int = 0;
	var nextFrame:Int = 0;



	override public function show():Void 
	{
		Gdx.Instance().clearColor(0, 0, 0.4);
		
			scene = new SceneManager();
		
		camera = scene.addTargetCamera(20, 4, -30, 10, 0, 100);
	
		font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);




//var mesh = MeshCreator.loadStaticB3DMesh("data/models/castel.b3d", "data/models/textures/");
//var mesh = MeshCreator.createCone();
var mesh = MeshCreator.loadStaticH3DMesh("data/models/Canyon.h3d", "data/models/textures/");
//var mesh = MeshCreator.loadMs3dStatic("data/models/normals.ms3d", "data/models/textures/");
//var mesh = MeshCreator.loadStaticB3DMesh("data/models/soldier.b3d", "data/models/textures/");
//var mesh = MeshCreator.loadStaticB3DMesh("data/models/ninja.b3d", "data/models/");

//mesh.Scale(0.1, 0.1, 0.1);
//mesh.CleanMesh();
//var opetMesh:Mesh = new Mesh();
//mesh.CopyMeshTo(opetMesh);
//opetMesh.AddMesh(mesh);

var node = scene.addSceneNode(mesh);
//node.setTexture(getTexture("data/models/textures/nskinwh.jpg",false,false,true));




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
		 
			 scene.update();
		
	}
	
	
	override public function render():Void 
	{
		
	
		 
		 	 font.caption = Gdx.Instance().status+"\n\n\n H3D Mesh (gdx format from assimp)" ;
	 
	 
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