package com.djokersoft.gdxparticles;

import com.gdx.collision.OctSelector;
import com.gdx.collision.QuadSelector;
import com.gdx.Gdx;
import com.gdx.input.Keys;
import com.gdx.math.*;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.GeoTerrain;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.bolt.BilboardNode;
import com.gdx.scene3d.particles.GrassNode;
import com.gdx.scene3d.SceneManager;
import com.gdx.Screen;
import com.gdx.util.Util;






/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DemoGeoTerrain extends Screen
{


	var font:ImageFont;

var scene:SceneManager;

	var camera:TargetCamera;

	var mousex:Float = 0;
	var mousey:Float = 0;
	
	var mouseDow:Bool = false;
	var MouseSpeed:Vector2=Vector2.Zero();
	var previousMouse:Vector2 = Vector2.Zero();

	var selector:QuadSelector;

	var terrain:GeoTerrain;
	var ToolSensitivity:Float = 40;
	var pContactPoint:Vector3 = Vector3.zero;

	override public function show():Void 
	{
		
		scene = new SceneManager( 50000);
		
		camera = scene.addTargetCamera(865, 1000, 1800, 1000, 1000, -1000);
		camera.setFarValue(42000.0);


		
	font =	scene.addImageFont("data/arial.png", Gdx.Instance().status , 50, Gdx.Instance().height - 100);

	


	
	terrain = new GeoTerrain(6,GeoTerrain.ETPS_17,new Vector3(40, 8.0, 40),new Vector3(0,0,0));
	terrain.loadTerrain("data/terrain-heightmap.jpg", 100);
	terrain.setTexture(getTexture("data/terrain-texture.jpg",true,false,true),0);
	terrain.setTexture(getTexture("data/detailmap3.jpg", true,true,true),1);
	
	terrain.getMeshBuffer().scaleTexCoords(20.0, 20, 1);
	
	/*
	selector = new QuadSelector(500, 4);
	selector.addMeshBuffer(terrain.getMeshBufferForLOD(0));
	selector.build();
	*/
	
	scene.addNode(terrain);
		 
		
	
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
		 var speed:Float= 120;
		 
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
		 


	
	
		 
		 /*
		 
		 var ray:Ray=camera.getPointRay(mousex, mousey);
		 var vertives:Array<Vector3> = selector.RayColect(ray);
		 
		             var v1:Vector3 = Vector3.zero;
	                 var v2:Vector3 = Vector3.zero;
	                 var v3:Vector3 = Vector3.zero;
		
					var CurrentVertexX:Int = 0;
					var CurrentVertexY:Int = 0;
					
					
			var delta:Float = dt * ToolSensitivity / 4.0;
					

		    var distance = Math.POSITIVE_INFINITY;
			var currentHeight:Float = 0;
		
	
		 for (i in 0 ... Std.int(vertives.length/3))
		{
	
			v1.x = vertives[i*3+0].x ;
			v1.y = vertives[i*3+0].y ;
			v1.z = vertives[i*3+0].z ;
		
			v2.x = vertives[i*3+1].x ;
			v2.y = vertives[i*3+1].y ;
			v2.z = vertives[i*3+1].z;
			
			v3.x = vertives[i * 3 + 2].x; 
			v3.y = vertives[i*3+2].y ;
			v3.z = vertives[i * 3 + 2].z ;
			
			 var currentDistance = ray.intersectsTriangle(v1, v2, v3);
            if (currentDistance > 0) 
			{
			
				
                if ( currentDistance < distance) 
				{
                    distance = currentDistance;
			
					pContactPoint.x = ray.origin.x + (ray.direction.x * distance);
					pContactPoint.y = ray.origin.y + (ray.direction.y * distance);
					pContactPoint.z = ray.origin.z + (ray.direction.z * distance);
					SceneManager.lines.drawFillTriangle(v1, v2, v3, 1, 0, 0);
					break;
				} 
            }
		}
		 
		      var startx:Int = Std.int(pContactPoint.z / 40); 
			  var startz:Int = Std.int(pContactPoint.x / 40);
		
			  
			  
					
		 if (keyPress(Keys.P))
		  {
			
			  for (x in startx - 4 ...startx + 4)
			  {
				  for (z in startz - 4 ...startz + 4)
				  {
				  
			 	    CurrentVertexX = Std.int(x % terrain.getSize());
			        CurrentVertexY = Std.int(z % terrain.getSize());
			        currentHeight = terrain.getVertexHeight(CurrentVertexX, CurrentVertexY) + delta ;
					terrain.setVertexHeight(CurrentVertexX, CurrentVertexY, currentHeight);
				  }
			  }
	
		  }
			
		   if (keyPress(Keys.L))
		  {
			
			  for (x in startx - 4 ...startx + 4)
			  {
				  for (z in startz - 4 ...startz + 4)
				  {
				  
			 	    CurrentVertexX = Std.int(x % terrain.getSize());
			        CurrentVertexY = Std.int(z % terrain.getSize());
			        currentHeight = terrain.getVertexHeight(CurrentVertexX, CurrentVertexY) - delta ;
					terrain.setVertexHeight(CurrentVertexX, CurrentVertexY, currentHeight);
				  }
			  }
	
		  }
		  */
		 
		 scene.update();
		 scene.renderUI();
		
		 
		 font.caption = Gdx.Instance().status ;
		 

		//selector.debug();
		 
	
		
	 
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
