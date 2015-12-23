package com.gdx.gl;
import com.gdx.Buffer;
import com.gdx.gl.material.Material;
import com.gdx.math.Matrix;
import com.gdx.scene3d.cameras.Camera;
import lime.Assets;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
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
/**
 * ...
 * @author Luis Santos AKA DJOKER
 */

 
class RenderTexture extends Texture
{
    private var framebuffer:GLFramebuffer;
	private var renderbuffer:GLRenderbuffer;
	private var program:GLProgram;
	private var buffer:GLBuffer;
	private var renderTo:GLFramebuffer;
	private var defaultFramebuffer:GLFramebuffer = null;
	
	
	public function new(tex_width:Int=128,tex_height:Int=128) 
	{
		super();
		this.texWidth = tex_width;
		this.texHeight = tex_height;
		
		// create and bind the framebuffer
		framebuffer = GL.createFramebuffer();
		
		rebuild();

		var status = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
		switch (status)
		{
			case GL.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
				trace("FRAMEBUFFER_INCOMPLETE_ATTACHMENT");
			case GL.FRAMEBUFFER_UNSUPPORTED:
				trace("GL_FRAMEBUFFER_UNSUPPORTED");
			case GL.FRAMEBUFFER_COMPLETE:
			default:
				trace("Check frame buffer: " + status);
		}


	}
	
	/**
	 * Rebuilds the renderbuffer to match screen dimensions
	 */
	public function rebuild()
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
		if (data != null) GL.deleteTexture(data);
		if (renderbuffer != null) GL.deleteRenderbuffer(renderbuffer);
		createRenderbuffer(texWidth,texHeight);

	}

	/* @private creates a renderbuffer object */
	private inline function createRenderbuffer(width:Int, height:Int)
	{
		
		data = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, data);
	
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
	

		var mipMap:Bool = false;
		
		if (mipMap)
		{
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER , GL.LINEAR_MIPMAP_NEAREST);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.generateMipmap(GL.TEXTURE_2D);
		
		
		}else
		{
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER , GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
			
		}
		
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB,  width, height,  0,  GL.RGB, GL.UNSIGNED_BYTE, null);
		
		// Bind the renderbuffer and create a depth buffer
		renderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);
		
		
		

		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, data, 0);
		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
		
		
		GL.bindTexture(GL.TEXTURE_2D, null);
        GL.bindRenderbuffer(GL.RENDERBUFFER, null);
        GL.bindFramebuffer(GL.FRAMEBUFFER, null);
	}

	
	/**
	 * Capture what is subsequently rendered to this framebuffer
	 */
	public function Begin()
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
		GL.viewport(0, 0, texWidth, texHeight);
		GL.clearColor(0, 0, 0, 0);
		GL.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);
		GL.bindTexture(GL.TEXTURE_2D, data);
     
	}
	public function End()
	{
		GL.viewport(0, 0,Gdx.Instance().width,Gdx.Instance().height);
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
		
	}
	public function enable(?frameBuffer:RenderTexture):Void
	{
			renderTo =  (frameBuffer == null ? defaultFramebuffer : frameBuffer.framebuffer);
	}
}