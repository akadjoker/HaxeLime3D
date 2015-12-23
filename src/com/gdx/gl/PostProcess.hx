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

typedef Uniform = {
	var id:GLUniformLocation;
	var value:Float;
};

class PostProcess
{
    private var framebuffer:GLFramebuffer;
	private var renderbuffer:GLRenderbuffer;
	private var texture:GLTexture;

	private var program:GLProgram;
	private var buffer:GLBuffer;
	private var renderTo:GLFramebuffer;
	private var defaultFramebuffer:GLFramebuffer = null;

	/* @private Time accumulator passed to the shader */
	private var time:Float = 0;

	private var vertexSlot:Int;
	private var texCoordSlot:Int;
	private var imageUniform:GLUniformLocation;
	private var resolutionUniform:GLUniformLocation;
	private var timeUniform:GLUniformLocation;
	private var uniforms:Map<String, Uniform>;
	
public function new(sFragmentShader:String)
	{
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
        GL.shaderSource (vertexShader, defaultVertexShader);
        GL.compileShader (vertexShader);
        if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) 
        {trace ("Load Vert:"+GL.getShaderInfoLog(vertexShader));return;}
		
       var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
       GL.shaderSource (fragmentShader,Assets.getText( sFragmentShader));
       GL.compileShader (fragmentShader);
       if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) 
	   { trace("Load Frag:" + GL.getShaderInfoLog(fragmentShader)); return; }
	  
	   
program = GL.createProgram ();
GL.attachShader (program, vertexShader);
GL.attachShader (program, fragmentShader);
GL.linkProgram (program);

if (GL.getProgramParameter (program, GL.LINK_STATUS) == 0) 
{
	        trace(GL.getProgramInfoLog(program));
			trace("VALIDATE_STATUS: " + GL.getProgramParameter(program, GL.VALIDATE_STATUS));
			trace("ERROR: " + GL.getError());
			return;
			
}

	uniforms = new Map<String, Uniform>();
	
	
// default shader variables
		imageUniform = shaderUniform("uImage0");
		timeUniform = shaderUniform("uTime");
		resolutionUniform = shaderUniform("uResolution");
		vertexSlot = shaderAttribute("aVertex");
		texCoordSlot = shaderAttribute("aTexCoord");
		


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


		buffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vertices), GL.STATIC_DRAW);
		GL.bindBuffer(GL.ARRAY_BUFFER, null);

	

		
	}

	
	private inline function shaderAttribute(a:String):Int
	{
		return GL.getAttribLocation(program, a);
	}

	/**
	 * Return the uniform location in this shader
	 * @param a  The uniform name to find
	 */
	private inline function shaderUniform(u:String):GLUniformLocation
	{
		return GL.getUniformLocation(program, u);
	}
	private inline function bind()
	{
		GL.useProgram(program);
	}

	/**
	 * Enables the PostProcess object for rendering
	 * @param to  (Optional) Render to PostProcess framebuffer instead of screen
	 */
	public function enable(?frameBuffer:PostProcess):Void
	{
			renderTo =  (frameBuffer == null ? defaultFramebuffer : frameBuffer.framebuffer);
	}
	 public function render():Void
	{
		time += Gdx.Instance().deltaTime;
		GL.bindFramebuffer(GL.FRAMEBUFFER, renderTo);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		bind();
		GL.enableVertexAttribArray(vertexSlot);
		GL.enableVertexAttribArray(texCoordSlot);

		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, texture);

		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.vertexAttribPointer(vertexSlot, 2, GL.FLOAT, false, 16, 0);
		GL.vertexAttribPointer(texCoordSlot, 2, GL.FLOAT, false, 16, 8);

		GL.uniform1i(imageUniform, 0);
		GL.uniform1f(timeUniform, time);
		GL.uniform2f(resolutionUniform,Gdx.Instance().width, Gdx.Instance().height);

		for (u in uniforms) GL.uniform1f(u.id, u.value);

		GL.drawArrays(GL.TRIANGLES, 0, 6);

		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindTexture(GL.TEXTURE_2D, null);
		
	
		GL.disableVertexAttribArray(vertexSlot);
		GL.disableVertexAttribArray(texCoordSlot);

	
		// check gl error
		if (GL.getError() == GL.INVALID_FRAMEBUFFER_OPERATION)
		{
			trace("INVALID_FRAMEBUFFER_OPERATION!!");
		}
	}
	/**
	 * Rebuilds the renderbuffer to match screen dimensions
	 */
	public function rebuild()
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);

		if (texture != null) GL.deleteTexture(texture);
		if (renderbuffer != null) GL.deleteRenderbuffer(renderbuffer);

		createTexture(Gdx.Instance().width, Gdx.Instance().height);
		createRenderbuffer(Gdx.Instance().width, Gdx.Instance().height);
		GL.bindFramebuffer(GL.FRAMEBUFFER, null);
	}

	/* @private creates a renderbuffer object */
	private inline function createRenderbuffer(width:Int, height:Int)
	{
		// Bind the renderbuffer and create a depth buffer
		renderbuffer = GL.createRenderbuffer();
		GL.bindRenderbuffer(GL.RENDERBUFFER, renderbuffer);
		GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);

		// Specify renderbuffer as depth attachement
		GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderbuffer);
	}

	/* @private creates a texture */
	private inline function createTexture(width:Int, height:Int)
	{
		texture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGB,  width, height,  0,  GL.RGB, GL.UNSIGNED_BYTE, null);

		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER , GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);

		// specify texture as color attachment
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture, 0);
	}

	/**
	 * Capture what is subsequently rendered to this framebuffer
	 */
	public function capture()
	{
		GL.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
		GL.viewport(0, 0,Gdx.Instance().width, Gdx.Instance().height);
		GL.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT);
	}
	/**
	 * Set a uniform value in the shader
	 * @param uniform  The uniform name within the shader source
	 * @param value    Value to set the uniform to
	 */
	public function setUniform(uniform:String, value:Float):Void
	{
		if (uniforms.exists(uniform))
		{
			var uniform = uniforms.get(uniform);
			uniform.value = value;
		}
		else
		{
			var id:GLUniformLocation = shaderUniform(uniform);
			uniforms.set(uniform, {id: id, value: value});
		}
	}
	
	private static inline var defaultVertexShader:String = "
#ifdef GL_ES
	precision mediump float;
#endif
attribute vec4 aVertex;
attribute vec2 aTexCoord;
varying vec2 vTexCoord;
void main() {
	vTexCoord = aTexCoord;
	gl_Position = vec4(aVertex.x, aVertex.y, 0.0, 1.0);
}";

	private static var vertices(get, never):Array<Float>;
	private static inline function get_vertices():Array<Float>
	{
		return [
			-1.0, -1.0, 0, 0,
			 1.0, -1.0, 1, 0,
			-1.0,  1.0, 0, 1,
			 1.0, -1.0, 1, 0,
			 1.0,  1.0, 1, 1,
			-1.0,  1.0, 0, 1
		];
	}

}