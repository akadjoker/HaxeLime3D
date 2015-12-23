package ;

import com.gdx.Gdx;
import com.gdx.gl.shaders.ShaderLight;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.Screen;








/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoBS3DMeshStatic extends Screen
{

	
	
		var font:ImageFont;

	var camera:TargetCamera;
	
	var scene:SceneManager;

	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2= Vector2.Zero();
	

	var levelMesh:Mesh;
	var levelNode:SceneNode;
	
	var light:SceneNode;
	
	var currFrame:Int = 0;
	var nextFrame:Int = 0;

	var lightPosition:Vector3 = Vector3.Zero();
	var angle:Float = 0;


	override public function show():Void 
	{
		Gdx.Instance().clearColor(0, 0, 0.4);
		
			scene = new SceneManager();
		
		camera = scene.addTargetCamera(0, 20, -90, 0, 0, 100);
	
		font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);






levelMesh = MeshCreator.loadMs3dStatic("data/models/normals.ms3d", "data/models/textures/");


levelNode = scene.addSceneNode(levelMesh);




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
		 
		 
		 	 font.caption = Gdx.Instance().status+"\n\n Milkshape MS3D static" ;
		
		 scene.update();
	}
	
	
	override public function render():Void 
	{
		
	 
	 
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
	}
	override public function TouchDown(mx:Float, my:Float, num:Int):Void 
	{
		mouseDow = true;
		
		
	}

	
}
