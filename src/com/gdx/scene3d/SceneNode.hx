package com.gdx.scene3d;


import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.shaders.Shader;
import com.gdx.gl.Texture;
import com.gdx.math.Matrix;
import com.gdx.scene3d.cameras.Camera;
import lime.graphics.opengl.GL;

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
class SceneNode extends Node
{
	
	private var _cullMeshBuffers:Bool;
    public var mesh:Mesh;
	public function new(mesh:Mesh,?parent:Node=null,?id:Int=0,?Name:String="Node") 
	{
		super(parent, Name, id);	
		this.mesh = mesh;
		_cullMeshBuffers = false;
		
		
    	 for (i in 0... mesh.surfaces.length)
		 {
			var surf = mesh.surfaces[i];
			Bounding.addInternalBox(surf.Bounding.boundingBox);
		 }
		 Bounding.calculate();
	}
	


	
	/*
	 * cull sub mesh buffers with Frustum
	 * on octree this is disable.
	 */
	public var CullMeshBuffers(get, set) : Bool;
	inline function set_CullMeshBuffers(v:Bool):Bool 
	{
		_cullMeshBuffers = v;
		return v;
	}
	inline function get_CullMeshBuffers():Bool 
	{return _cullMeshBuffers;}
	override public function getMaterial(index:Int):Material
	{
		if (mesh != null)
		{
		return	mesh.getMeshBuffer(index).material;
		}
		return null;
	}
	
	override public function renderTo(newShader:Shader,cam:Camera,setMaterial:Bool):Void
	{
	
	 if (Bounding.isInFrustum(cam.frustumPlanes))
	  {
		mesh.renderTo(newShader, cam,_cullMeshBuffers,setMaterial);
      }
	}

	override public function render(cam:Camera):Void
	{
		if (!visible) return;
	   var mat:Matrix = getWorldTform();//get the trasform
       Bounding.update(mat);// convert AAB to OBB
		
	  if (Bounding.isInFrustum(cam.frustumPlanes))
	  {
	     if (_cullMeshBuffers)
		 {
			 //need to update sub mesh box
		  if (posChanged)
		  {
			  
			  mesh.TransformBoundingBox(mat);
		  }
		 }
		mesh.render(mat, cam, _cullMeshBuffers);
		onAnimate();  
		super.render(cam);
	  }
	}
	override public function debug(lines:Imidiatemode):Void
	{
		
		if ((debugFlags & Gdx.DEBUGNODEOBB)==Gdx.DEBUGNODEOBB)
		{
		lines.drawOBBox(this.Bounding,1,0,0);	
		}
		if (mesh != null)
		{
			mesh.debug(lines);
		//	mesh.showNormals(world_tform, lines, 1);
		}
		super.debug(lines);
	}
	
	public function setTexture(tex:Texture,?layer:Int=0)
	{
		if (mesh == null) return;
		
		for (i in 0... mesh.surfaces.length)
		{
			var surf = mesh.surfaces[i];
			surf.material.setTexture(tex,layer);
		}
	}
	public function setTextureIndex(index:Int,tex:Texture,?layer:Int=0)
	{
		if (mesh == null) return;
		if (index < 0) index = 0;
		if (index > mesh.surfaces.length) index = mesh.surfaces.length;
		var surf = mesh.surfaces[index];
		if(surf!=null)	surf.material.setTexture(tex,layer);

	}
	

	public function setShader(i:Int):Void
	{
		if (mesh == null) return;
	    mesh.setShader(i);
	}
	public function setShaderEx(s:Shader):Void
	{
		if (mesh == null) return;
		mesh.setShaderEx(s);
	}

	
}