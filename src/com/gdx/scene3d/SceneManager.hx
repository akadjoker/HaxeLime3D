package com.gdx.scene3d;

import com.gdx.color.Color3;
import com.gdx.gl.shaders.ShaderPointLight;
import com.gdx.gl.shaders.ShaderSpotLight;
import com.gdx.scene3d.lights.Light;
import com.gdx.scene3d.lights.PointLight;
import com.gdx.scene3d.lights.SpotLight;
import lime.graphics.opengl.GL;
import com.gdx.Buffer;
import com.gdx.gl.Imidiatemode;
import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
import com.gdx.scene2d.Graphic;
import com.gdx.scene2d.render.SpriteBatch;
import com.gdx.scene2d.ui.ImageFont;
import com.gdx.scene3d.cameras.ArcBallCamera;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.cameras.OrbitCamera;
import com.gdx.scene3d.cameras.OrthoCamera;
import com.gdx.scene3d.cameras.TargetCamera;
import com.gdx.scene3d.lensflare.LensFlareSystem;
import com.gdx.scene3d.partition.NodeMeshOctree;
import com.gdx.util.SpriteSheet;



/*
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
         Version 0.002, 14, January, 1978

Copyright (C) 2014 Luis Santos AKA DJOKER <djokertheripper@gmail.com>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

 0. You just DO WHAT THE FUCK YOU WANT TO.
*/
class SceneManager extends Buffer
{
	
	public  static var lines:Imidiatemode;
    public  static var matIden:Matrix = Matrix.Identity();

private var nodes:List<Node>;
private var nodesToDelete:List<Node>;
private var nodesToAdd:List<Node>;
private var graphics:List<Graphic>;
private var cameras:List<Camera>;
public var mainCamera:Camera;
public var uiCamera:OrthoCamera;
public var spritebatch:SpriteBatch;
public var shadow:Shadow;
private var useShadow:Bool;


private var sSpotLight:ShaderSpotLight;
private var sPointLight:ShaderPointLight;
private var LightsList:List<Light>;

private var skyBox:MeshSkyBox;

	public function new(spritesAlloc:Int=500, ?useShadow:Bool=false) 
	{
		super();
		this.useShadow = useShadow;
		if (useShadow)
		{
			shadow = new Shadow(new Vector3(53, 50, -15));
		}
		nodes = new List<Node>();
		nodesToDelete = new List<Node>();
		nodesToAdd =new List<Node>();
		graphics = new List<Graphic>();
		cameras = new List<Camera>();
		mainCamera = null;
		uiCamera = new OrthoCamera();
		spritebatch = new SpriteBatch(uiCamera,spritesAlloc);
		lines = null;
		#if debug
		
		lines = new Imidiatemode(9000);
		#else
		lines = new Imidiatemode(1);
		#end
		skyBox = null;
		
		sSpotLight = new ShaderSpotLight();
		sPointLight = new ShaderPointLight();
		LightsList = new List<Light>();
		/*
		{
		var l:SpotLight = new SpotLight(new Color3(1, 0, 0), 200, new Vector3(-0.2, -1, 0), new Vector3( -8, 8, 0),0.3,4,12);
		LightsList.add(l);
		}
		{
		var l:SpotLight = new SpotLight(new Color3(0, 1, 0), 40, new Vector3(0, -1, 0), new Vector3( 8, 2, 0));
		LightsList.add(l);
		}
		{
		var l:SpotLight = new SpotLight(new Color3(0, 0, 1), 80, new Vector3(0, -1, 0), new Vector3( 8, 4, 8));
		
		LightsList.add(l);
		}
		{
		var l:SpotLight = new SpotLight(new Color3(1, 1, 1), 30, new Vector3(0, -1, 0), new Vector3( -8, 2, 8));
		LightsList.add(l);
		}*/
		
		/*
		{
		var l:PointLight = new PointLight(new Color3(1, 0, 0), 200,  new Vector3( -8, 8, 0),0.3,4,12);
		LightsList.add(l);
		}
		{
		var l:PointLight = new PointLight(new Color3(0, 1, 0), 40,  new Vector3( 8, 2, 0));
		LightsList.add(l);
		}
		{
		var l:PointLight = new PointLight(new Color3(0, 0, 1), 80,  new Vector3( 8, 4, 8));
		
		LightsList.add(l);
		}
		{
		var l:PointLight = new PointLight(new Color3(1, 1, 1), 30,  new Vector3( -8, 2, 8));
		LightsList.add(l);
		}*/
	}
	public function addLight(light:Light):Light
	{
		LightsList.add(light);
		return light;
	}
	
	//***************************
	public function addCamera(fovY = 45,  zNear = 0.1, zFar = 4000):Camera
	{
		var cam:Camera = new Camera(fovY ,  zNear , zFar);
		setCamera(cam);
		cameras.add(cam);
		return cam;
	}
	public function addFreeCamera(x:Float,y:Float,z:Float):FreeCamera
	{
		var cam:FreeCamera = new FreeCamera(x,y,z);
		// cast(cam, FreeCamera);
		setCamera(cam);
		cameras.add(cam);
		return cam;
	}
	public function addTargetCamera(x:Float,y:Float,z:Float,lx:Float,ly:Float,lz:Float):TargetCamera
	{
		var cam:TargetCamera = new TargetCamera(x, y, z, lx, ly, lz);
		setCamera(cam);
		cameras.add(cam);
		//return cast(mainCamera, TargetCamera);
		return cam;
	}
    public function addOrbitCamera(offset:Vector3):OrbitCamera
	{
		var cam:OrbitCamera = new OrbitCamera(offset);
		//return cast(mainCamera, OrbitCamera);
		setCamera(cam);
		cameras.add(cam);
		
		return cam;
	}
	public function addArcBallCamera(  targetPosition:Vector3,
             initialElevation:Float,
             initialRotation:Float,
             minDistance:Float,
             maxDistance:Float,
             initialDistance:Float):ArcBallCamera
	{
		var cam:ArcBallCamera = new ArcBallCamera(  targetPosition,
             initialElevation,
             initialRotation,
             minDistance,
             maxDistance,
             initialDistance);
		//return cast(mainCamera, ArcBallCamera);
		setCamera(cam);
		cameras.add(cam);
		return cam;
	}
	public function setCamera(cam:Camera):Void
	{
		mainCamera = cam;
	}
	
	
	public function addSceneNode(mesh:Mesh,?parent:Node=null, ?id:Int=0,?name:String="node",?castShadows:Bool = false):SceneNode
	{
		var m = new SceneNode(mesh, parent, id, name);
		if (parent == null)			addNode(m);
	if (castShadows && useShadow)
	{
	 shadow.addNode(m);
	}
	
		return m;
	}
	public function addAnimatedSceneNode(mesh:AnimatedMesh, ?parent:Node = null, ?id:Int = 0, ?name:String = "node", ?castShadows:Bool = false):AnimatedSceneNode
	{
		var m = new AnimatedSceneNode(mesh, parent, id, name);
		if (parent == null)	addNode(m);
		
	if (castShadows && useShadow)
	{
	shadow.addNode(m);
	}
		
		return m;
	}
	
	public function addH3DAnimatin(f:String,path:String,mesh:AnimatedMesh,?parent:Node, ?id:Int,?name:String):AnimatedSceneNode
	{
		var m:MeshH3D = new MeshH3D();		m.load(f, path);
		var n = new AnimatedSceneNode(m, parent, id, name);
		if(parent==null)	addNode(n);
		return n;
	}
	
	
	
	public function addB3DAnimatin(f:String,path:String,mesh:AnimatedMesh,?parent:Node, ?id:Int,?name:String):AnimatedSceneNode
	{
		var m:MeshB3D = new MeshB3D();		m.load(f, path);
		var n = new AnimatedSceneNode(m, parent, id, name);
		if(parent==null)	addNode(n);
		return n;
	}
	
	/*
	 * Create node Octree with mesh  
	 * cull all submesh on Octree
	 * 
	 */
	public function addNodeMeshOctree(mesh:Mesh, minimalPolysPerNode:Int,?id:Int, ?name:String):NodeMeshOctree
	{
		var m:NodeMeshOctree = new NodeMeshOctree(mesh, minimalPolysPerNode, null, id, name);
		addNode(m);
		return m;
		
	}
	
	public function addSkyBox(size:Float,tex:String):MeshSkyBox
	{
		if (skyBox != null)
		{
			skyBox.dispose();
			skyBox = null;
		}
		skyBox = new MeshSkyBox(size, Gdx.Instance().getTextureCubemap(tex));
		return skyBox;
		
	}
	
	
		 
	
	///**************************
	public function addImageFont(f:String,caption:String,x:Float,y:Float,spacing:Int=-8):ImageFont
	{
		var img:ImageFont = new ImageFont(Gdx.Instance().getTexture(f, false, false, false), spacing);
		img.caption = caption;
		img.x = x;
		img.y = y;
		addUI(img);
		return img;
	}
	public function addLensFlare(spr:SpriteSheet, x:Float, y:Float, z:Float):LensFlareSystem
	{
	  var lensflare = new LensFlareSystem(mainCamera, spr, x,y,z);
	  addUI(lensflare);
	  return lensflare;
	}
	
	public function addNode(n:Node):Node
	{
		nodesToAdd.add(n);
		return n;
	}
	public function removeNode(n:Node):Void
	{
		nodesToDelete.add( n);
		
	}
	
	public function addUI(g:Graphic):Graphic
	{
		graphics.add(g);
		return g;
	}
	public function removeUI(g:Graphic):Graphic
	{
		graphics.remove(g);
		return g;
	}
	
	public function update()
	{
		#if debug
		SceneManager.lines.reset();
		#end
	
		
		for (camera in cameras)
		{
			camera.update();
		}
		
		
		
		for (node in nodes )
		{
			if (node.active)
			{
				node.update();
			}
			if (!node.active)
			{
				nodesToDelete.add(node);
			}
			
			#if debug
			node.debug(SceneManager.lines);
			#end
		}
		
		
	
		
		
	    for ( node in nodesToAdd)
        {
            if (node.active)
                nodes.add(node);
        }
        for ( node in nodesToDelete)
        {
            if (!node.active)
                nodes.remove(node);
        }
        nodesToDelete.clear();
        nodesToAdd.clear();
	
	
	}
	
	public function render()
	{
		
	
		if (skyBox != null)
		{
			skyBox.render(mainCamera);
		}
		
		
		if (useShadow)
		{
			shadow.draw(mainCamera);
		}
		
		for (node in nodes )
		{
			if (node.active)
			{
					node.render(mainCamera);
			}
			
			
			#if debug
			node.debug(SceneManager.lines);
			#end
		}
		
		//forword render
		Gdx.Instance().setBlend(true);
		Gdx.Instance().setBlendFunc(GL.ONE, GL.ONE );
		Gdx.Instance().setDepthMask(false);
		Gdx.Instance().setDepthFunc(GL.EQUAL);

		
		
		
		for (node in nodes )
		{
			if (node.UseLights)
			{
			if (Std.is(node, SceneNode))
			{
				var n:SceneNode = cast(node, SceneNode);
				if (n != null)
				{
			      if (n.active)
			      {
					  for (light in LightsList)
					  {
						 light.update();
						if (light.active)
						{  
							if ( light.visible)
							{
						if (Std.is(light, PointLight))
						{
							var lData:PointLight = cast(light, PointLight);
							sPointLight.setLightData(lData,mainCamera.local_pos);
							sPointLight.Bind(mainCamera.viewMatrix, mainCamera.projMatrix, n.world_tform);
							
							n.renderTo(sPointLight, mainCamera, false);
							sPointLight.unBind();
						} else
						if (Std.is(light, SpotLight))
						{
							var lData:SpotLight = cast(light, SpotLight);
							sSpotLight.setLightData(lData,mainCamera.local_pos);
							sSpotLight.Bind(mainCamera.viewMatrix, mainCamera.projMatrix, n.world_tform);
							n.renderTo(sSpotLight, mainCamera, false);
							sSpotLight.unBind();
						}
							}//visible
						} else//l active
						{
							
							LightsList.remove(light);
							
							break;
						}
					  }
				  }
			     }
			}
		  }
		}
		//

		Gdx.Instance().setBlend(false);
		Gdx.Instance().setDepthMask(true);
		Gdx.Instance().setDepthFunc(GL.LESS);

		
		#if debug
		SceneManager.lines.render(mainCamera, SceneManager.matIden);
		
		#end
	
	
	}
	public function getCamera():Camera
	{
		return mainCamera;
	}
	public function renderUI():Void
	{
	
		uiCamera.update();	
	
	
		spritebatch.Begin();
		for (graphic in graphics)
		{
			graphic.render(spritebatch);
		}
		spritebatch.End();	
	}
	
	override public function dispose() 
	{
		super.dispose();
		lines.dispose();
		spritebatch.dispose();
		graphics.clear();
		nodes.clear();
		nodesToAdd.clear();
		nodesToDelete.clear();
	}
	
}