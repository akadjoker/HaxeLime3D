package com.gdx.scene3d;

import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.ScreenQuad;
import com.gdx.gl.shaders.Shader;
import com.gdx.gl.shaders.ShaderCast;
import com.gdx.gl.ShadowBuffer;
import com.gdx.gl.Texture;
import com.gdx.math.BoundingBox;
import com.gdx.math.Matrix;
import com.gdx.math.Ray;
import com.gdx.math.Vector3;
import com.gdx.scene3d.cameras.Camera;
import lime.graphics.opengl.GL;
import lime.math.Matrix4;

import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Shadow
{
	private var shadow:ShaderCast;

	private var shadow_nodes:Array<SceneNode>;
	private var blocks:Array<SceneNode>;
	public var lightPosition:Vector3;
	public var lightMatrix:Matrix;
	private var viewMatrix:Matrix;
	var fbo:GLFramebuffer;
	var fboTexture:GLTexture;
	var rbo:GLRenderbuffer;
	var quad:ScreenQuad;
	private var width:Int;
	private var height:Int;
	var minBound:Vector3;
	var maxBound:Vector3;
	public var shadowOrthoScale:Float;
	private var bound:BoundingBox;
	
	  private  var orthoLeft:Float = Math.POSITIVE_INFINITY;
	  private var orthoRight:Float = Math.NEGATIVE_INFINITY;
	  private var orthoTop:Float = Math.NEGATIVE_INFINITY;
	  private	var orthoBottom:Float = Math.POSITIVE_INFINITY;
	 
		
	public function new(light:Vector3) 
    {
		
	    shadowOrthoScale = 0.5;
		width = 1024;
		height = 1024;
            		 fbo = GL.createFramebuffer();
					fboTexture = GL.createTexture();
					rbo = GL.createRenderbuffer();
		
		shadow = new ShaderCast();

		shadow_nodes = [];
		lightPosition = light;
		quad = new ScreenQuad();
		minBound = new Vector3(99999, 99999, 99999);
		maxBound = new Vector3(-99999, -99999, -99999);
		lightMatrix = Matrix.Zero();
		viewMatrix = Matrix.LookAtLH(lightPosition, new Vector3(0,1,0), Vector3.Up());
		bound = new BoundingBox(minBound, maxBound);
		
		blocks = [];
	}
		public function addNode(node:SceneNode):Void
	{
		shadow_nodes.push(node);
     }
	
	
	public function addBound(m:SceneNode):Void
	{
		 var tempVector3 = Vector3.Zero();
		 
		if (m.mesh != null)
		{
		blocks.push(m);
		for (i in 0...m.mesh.numMeshBuffer())
		{
			
			var boundingBox = m.mesh.getMeshBuffer(i).Bounding.boundingBox;
		    bound.addInternalBox(boundingBox);
		
		for (index in 0...boundingBox.vectorsWorld.length)
		{
				Vector3.TransformCoordinatesToRef(boundingBox.vectorsWorld[index], viewMatrix, tempVector3);
				
				if (tempVector3.x < orthoLeft) {
					orthoLeft = tempVector3.x;
				}
				if (tempVector3.y < orthoBottom) {
					orthoBottom = tempVector3.y;
				}
				
				if (tempVector3.x > orthoRight) {
					orthoRight = tempVector3.x;
				}
				if (tempVector3.y > orthoTop) {
					orthoTop = tempVector3.y;
				}
			}	   
		   
		}
		
		bound.calculate();
		bound.update(viewMatrix);
		/*
	
		orthoLeft = bound.minimum.x;
		orthoBottom = bound.minimum.y;
			
		orthoRight = bound.maximum.x;
		orthoTop = bound.maximum.y;
		*/
		}
				
	}
	private function createFBO(cam:Camera,width:Int, height:Int)
			{
				
				

		
				
				
				//create frambuffer object
				GL.bindFramebuffer(GL.FRAMEBUFFER, fbo);

				//create the texture				
				GL.bindTexture(GL.TEXTURE_2D, fboTexture);
		      	GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
				GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
				GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
				GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);

				GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0,      				GL.RGBA, GL.UNSIGNED_BYTE, null);
				
				//setup the renderbuffer object
				GL.bindRenderbuffer(GL.RENDERBUFFER, rbo);
				GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);
				            
				//setup attachments
			 	 GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0,  GL.TEXTURE_2D, fboTexture, 0);
				 GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, rbo);

			}
	
     public function draw(cam:Camera):Void
	{
	         
				
		
	   
	 
	 
	    viewMatrix.setLookAtLH(lightPosition, new Vector3(0,1,0), Vector3.Up());
	
	
	

		var xOffset = orthoRight - orthoLeft;
		var yOffset = orthoTop - orthoBottom;
		var maxZ:Float = 10000.0;
		
		var projectionMatrix:Matrix =  Matrix.Zero();
		Matrix.OrthoOffCenterLHToRef(orthoLeft   - xOffset * shadowOrthoScale, orthoRight + xOffset * shadowOrthoScale,
                                     orthoBottom - yOffset * shadowOrthoScale, orthoTop   + yOffset * shadowOrthoScale,
                                     -maxZ, maxZ, projectionMatrix);

		
		viewMatrix.multiplyToRef(projectionMatrix, lightMatrix);							  
	 
		
	
				
	   createFBO(cam, width, height);
	   
  		GL.clearColor(0.1, 0.1, 0.1, 1.0); 	
		GL.clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT); 	
				
				 GL.enable(GL.DEPTH_TEST);
				GL.clearDepth(1.0);
				//GL.disable(GL.CULL_FACE);
				GL.enable(GL.CULL_FACE);
				GL.cullFace(GL.FRONT);
			//	GL.depthMask(false);
				GL.viewport(0, 0, width, height);   
	   	      
         	    
			
	  
  

	  shadow.Begin();	
	  
	  for (i in 0...shadow_nodes.length)
	  {
		  var node:SceneNode = shadow_nodes[i];
		  if (node != null)
		  {
		    shadow.setMatrix(lightMatrix,node.world_tform);
		    node.renderTo(shadow, cam, false);
		  }
		  
	  }

	  shadow.End();   
	  
	  
	         //   GL.enable(GL.CULL_FACE);
	         //   GL.depthMask(true);
	            GL.cullFace(GL.BACK);
	            GL.activeTexture(GL.TEXTURE0);
			    GL.bindTexture(GL.TEXTURE_2D, null);
				GL.bindFramebuffer(GL.FRAMEBUFFER, null);
				GL.viewport(0, 0, Gdx.Instance().width,Gdx.Instance().height);
				
				
	}
	
	private function rayClear(ray:Ray):Bool
	{
		for ( i in 0...this.blocks.length)
		{
			for ( m in 0...this.blocks[i].mesh.numMeshBuffer())
			{
				var buffer:MeshBuffer = this.blocks[i].mesh.getMeshBuffer(m);
				if (buffer.rayBoundHit(ray)) return false;
			}
		}
		return true;
	}
	
	public function bindBuffer(layer:Int):Void
	{
      GL.activeTexture(GL.TEXTURE0+layer);
      GL.bindTexture(GL.TEXTURE_2D, fboTexture);
	}
	
	public function drawQuad():Void
	{
		        GL.viewport(0, Gdx.Instance().height-256, 256,256);
				quad.render(fboTexture, 256, 256);
			
			   
				  
	}
	
}