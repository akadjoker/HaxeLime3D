package ;

import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.gl.shaders.ShaderLight;
import com.gdx.gl.shaders.ShaderPointLight;
import com.gdx.gl.shaders.ShaderSpotLight;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.lights.PointLight;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.Screen;








/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoBS3DMeshStatic3 extends Screen
{

	
	
		var font:ImageFont;

	var camera:TargetCamera;
	
	var scene:SceneManager;

	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2= Vector2.Zero();
	

	var levelMesh:Mesh;
	var levelNode:SceneNode;
	
	var light:PointLight;
	
	var currFrame:Int = 0;
	var nextFrame:Int = 0;

	var lightPosition:Vector3 = Vector3.Zero();
	var angle:Float = 0;

	var bullets:List<Bolt>;

	override public function show():Void 
	{
		Gdx.Instance().clearColor(0, 0, 0.4);
		
			scene = new SceneManager();
		
		camera = scene.addTargetCamera(-10, 8, -60, 0, 0, 100);
	
		font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);


/*
var m:Mesh = MeshCreator.createCone();
m.Rotate(90, -90, -90);
light = scene.addSceneNode(m);
light.setLocalPosition(new Vector3(0,10,0));
light.setShader(Gdx.SHADERCOLOR);
*/

//var mesh = MeshCreator.loadStaticB3DMesh("data/models/castel.b3d", "data/models/textures/");
//levelMesh = MeshCreator.loadMs3dStatic("data/models/normals.ms3d", "data/models/textures/");
//levelMesh.ScaleEx(0.1);
//levelMesh.UpdateNormals();
var levelMesh = MeshCreator.loadStaticB3DMesh("data/models/LL3.b3d", "data/models/textures/");
levelMesh.setShader(Gdx.SHADERLIGHT);
//var mesh = MeshCreator.loadStaticH3DMesh("data/models/castel.h3d", "data/models/textures/");
//var mesh = MeshCreator.loadStaticB3DMesh("data/models/soldier.b3d", "data/models/textures/");
//var mesh = MeshCreator.loadStaticB3DMesh("data/models/ninja.b3d", "data/models/");

//mesh.Scale(0.1, 0.1, 0.1);
//mesh.CleanMesh();
//var opetMesh:Mesh = new Mesh();
//mesh.CopyMeshTo(opetMesh);
//opetMesh.AddMesh(mesh);

levelNode = scene.addSceneNode(levelMesh);
levelNode.UseLights = true;
//node.setTexture(getTexture("data/models/textures/nskinwh.jpg",false,false,true));


{
var p:Vector3 = new Vector3( -17, 8, -2);	
var col:Color3 = new Color3(1, 1, 1);
var light = cast( scene.addLight(new PointLight(col, 100, p,0.2,18.5)), PointLight);
var m = MeshCreator.createCube();
m.ScaleEx(0.2);
m.setColor(Std.int(col.r*255), Std.int(col.g*255), Std.int(col.b*255));
var n = scene.addSceneNode(m);
n.setPos(p.x, p.y, p.z);
n.setShader(Gdx.SHADERCOLOR);

}

{
var p:Vector3 = new Vector3( -65, 12, 9);	
var col:Color3 = new Color3(1, 0.2, 0.2);
var light = cast( scene.addLight(new PointLight(col, 59, p, 1, 1)), PointLight);
 light.constant = 24.4;
 light.linear = -3.6;
 light.onUpdate = function()
 {
	 light.linear = Math.sin(Gdx.Instance().getTimer()) * 2.5 + Math.cos(Gdx.Instance().getTimer()) * -1.8;
	 light.intensity=50+ Math.sin(Gdx.Instance().getTimer()) * 5.5 * Math.cos(Gdx.Instance().getTimer()) * 4.8;
 };
var m = MeshCreator.createCube();
m.ScaleEx(0.2);
m.setColor(Std.int(col.r*255), Std.int(col.g*255), Std.int(col.b*255));
var n = scene.addSceneNode(m);
n.setPos(p.x, p.y, p.z);
n.setShader(Gdx.SHADERCOLOR);

		 
}

{
var p:Vector3 = new Vector3( 30,12,-36);	
var col:Color3 = new Color3(1, 0.2, 0.2);
var light = cast( scene.addLight(new PointLight(col, 59, p, 1, 1)), PointLight);
 light.constant = 24.4;
 light.linear = -3.6;
 light.onUpdate = function()
 {
	 light.linear = Math.sin(Gdx.Instance().getTimer()) * 0.5 + Math.cos(Gdx.Instance().getTimer()) * -0.8;
 };
var m = MeshCreator.createCube();
m.ScaleEx(0.2);
m.setColor(Std.int(col.r*255), Std.int(col.g*255), Std.int(col.b*255));
var n = scene.addSceneNode(m);
n.setPos(p.x, p.y, p.z);
n.setShader(Gdx.SHADERCOLOR);

		 
}

{
var p:Vector3 = new Vector3( -70, 12, 67);	
var col:Color3 = new Color3(1, 0.8, 0.6);
 light = cast( scene.addLight(new PointLight(col, 162, p, 1, 1)), PointLight);
 light.constant = 29.5;
 light.linear = -3.6;
var m = MeshCreator.createCube();
m.ScaleEx(0.2);
m.setColor(Std.int(col.r*255), Std.int(col.g*255), Std.int(col.b*255));
var n = scene.addSceneNode(m);
n.setPos(p.x, p.y, p.z);
n.setShader(Gdx.SHADERCOLOR);

		



}

bullets = new List<Bolt>();
for (i in 0 ... 20)
{
	bullets.add(new Bolt(scene));
}

	}
	override public function resize(width:Int, height:Int):Void 
	{			
	Gdx.Instance().setViewPort(0, 0, width, height);
	}
	
	override public function update(delta:Float):Void 
	{
	
		 var dt:Float =  Gdx.Instance().deltaTime *3 ;
		 var speed:Float= 8;
		 
		 
		  angle+= 0.5 *dt;
		  lightPosition =  new Vector3( 8.0 * Math.cos(angle), 4 , 8.0 * Math.sin(angle));// , 5.0 * sine);
		
	
		 
		  if (keyPress(Keys.P))
		 {
			light.intensity += 1;
		 } else
		 if (keyPress(Keys.L))
		 {
			light.intensity -= 1;
		 } 
		 
		  if (keyPress(Keys.O))
		 {
			light.constant += 0.1;
		 } else
		 if (keyPress(Keys.K))
		 {
			light.constant -= 0.1;
		 } 
		 	
		  if (keyPress(Keys.I))
		 {
			light.linear += 0.1;
		 } else
		 if (keyPress(Keys.J))
		 {
			light.linear -= 0.1;
		 } 
	
		
		 
		 
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
		 
		 
		 	 font.caption = Gdx.Instance().status + "\n\nDeferred Render , Right mouse shootlights";
			 
			 
			 for (bullet in bullets)
			 {
				 bullet.update(dt);
			 }
			 
		
		 scene.update();
	}
	
	
	override public function render():Void 
	{
		
		
//	 showNormals(levelNode.world_tform, levelMesh, 10);
	 
	 
	 scene.render();
	
	 
	 
	 scene.renderUI();
		 
	
	 

	 
	}
	
	public function showNormals(m:Matrix,mesh:Mesh,length:Float)
	{
		
		for (i in 0... mesh.numMeshBuffer())
		{
		var surf = mesh.getMeshBuffer(i);
			
		for (i in 0... surf.no_verts)
		{
			var v:Vector3 = surf.getVertex(i);
			var n:Vector3 = Vector3.Mult( surf.getNormal(i), length);
			
			v = m.transformVector(v);
			n = m.transformVector(n);
			
			
			SceneManager.lines.line3D(
			v.x, v.y, v.z, 
			v.x + n.x, v.y + n.y, v.z + n.z,
			1, 0, 0);
			
		}

		}

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
		
		if (num == 2)
		{
		 //	var p:Vector3 =new Vector3( camera.local_pos.x,camera.local_pos.y,camera.local_pos.z);
          //  var col:Color3 = new Color3(1, 1, 1);
         //   var light = cast( scene.addLight(new PointLight(col, 20, p, 1, 1)), PointLight);
         
		     var ray = camera.getPointRay(x, y);
			 
			 var target:Vector3 = Vector3.zero;
			 
			 
			 target.x = ray.origin.x + ray.direction.x * 100;
			 target.y = ray.origin.y + ray.direction.y * 100;
			 target.z = ray.origin.z + ray.direction.z * 100;
			 
			 
			 
		     for (bullet in bullets)
			 {
				 if (!bullet.alive)
				 {
					 bullet.shot(ray.origin, target);
					 break;
				 }
				 
			 }
		}
		 
	}
	override public function TouchDown(mx:Float, my:Float, num:Int):Void 
	{
		mouseDow = true;
		
		
	}

	
}
