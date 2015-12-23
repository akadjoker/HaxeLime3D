package com.gdx.scene3d;

import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.shaders.Shader;
import com.gdx.gl.shaders.ShaderCast;
import com.gdx.gl.ShadowBuffer;
import com.gdx.gl.Texture;
import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
import com.gdx.scene3d.cameras.Camera;
import lime.graphics.opengl.GL;
import lime.math.Matrix4;
/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class ShadowNode 
{
    public var mesh:Mesh;
	public var transform:Node;
	private var buffers:Array<ShadowBuffer>;
	public var isStatic:Bool;
	private var timePass:Int;
	private var timedelay:Int;


	public function new(_Mesh:Mesh, node:Node, ?timeToUpdate:Int=0) 
	{
		transform = node;
		isStatic = (timeToUpdate == 0)? true: false;
		timedelay = timeToUpdate;
		this.mesh = _Mesh;
		timePass = Gdx.Instance().getTimer();
		
		_Mesh.TransformBoundingBox(node.getWorldTform());
		
		buffers = [];
		if (mesh != null)
		{
		for (i in 0...mesh.numMeshBuffer())
		{
			var buffer:ShadowBuffer = new  ShadowBuffer();
			
			buffer.uploadIndices(mesh.getMeshBuffer(i).tris);
			buffer.uploadVertex(mesh.getMeshBuffer(i).vert_coords);
			buffers.push(buffer);
		}
		}
	}
	
	public function render(light:Vector3,cam:Camera,s:ShaderCast):Void
	{
		if (!isStatic)
		{
			if (Gdx.Instance().getTimer() >= (timePass + timedelay))
			{
			 
	         for (i in 0...mesh.numMeshBuffer())
		     {
			 var buffer:ShadowBuffer = buffers[i];
			 buffer.uploadVertex(mesh.getMeshBuffer(i).vert_coords);
		     }
			
			 timePass = Gdx.Instance().getTimer();
			}
			
		//	trace(Gdx.Instance().getTimer() +";"+ (timePass + timedelay));
		}
		
		
		
	   for (i in 0...buffers.length)
	   {
		//  if (cam.BoundingBoxInFrustum(mesh.getMeshBuffer(i).Bounding.boundingBox))
		  {
		   buffers[i].render(s);
		  }
	   }
      
	}
	
}