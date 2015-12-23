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



class ScreenQuad
{
   

	private var program:GLProgram;
	private var buffer:GLBuffer;
	

	private var vertexSlot:Int;
	private var texCoordSlot:Int;
	private var imageUniform:GLUniformLocation;
	private var resolutionUniform:GLUniformLocation;


	
public function new()
	{
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
        GL.shaderSource (vertexShader, defaultVertexShader);
        GL.compileShader (vertexShader);
        if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) 
        {trace ("Load Vert:"+GL.getShaderInfoLog(vertexShader));return;}
		
       var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
       GL.shaderSource (fragmentShader,defaultFRagShader);
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


	
	
// default shader variables
		imageUniform = shaderUniform("uImage0");
	    vertexSlot = shaderAttribute("aVertex");
		texCoordSlot = shaderAttribute("aTexCoord");
		



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

	
	 public function render(tex:GLTexture,w:Int,h:Int):Void
	{
		bind();
		GL.enableVertexAttribArray(vertexSlot);
		GL.enableVertexAttribArray(texCoordSlot);

	
		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.vertexAttribPointer(vertexSlot, 2, GL.FLOAT, false, 16, 0);
		GL.vertexAttribPointer(texCoordSlot, 2, GL.FLOAT, false, 16, 8);

		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, tex);
		GL.uniform1i(imageUniform, 0);
	

	

		GL.drawArrays(GL.TRIANGLES, 0, 6);

		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindTexture(GL.TEXTURE_2D, null);
		
	
		GL.disableVertexAttribArray(vertexSlot);
		GL.disableVertexAttribArray(texCoordSlot);

	
	
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

	private static inline var defaultFRagShader:String = "
#ifdef GL_ES
	precision mediump float;
#endif
varying vec2 vTexCoord;
uniform sampler2D uImage0;
void main() {
	
    gl_FragColor = texture2D(uImage0, vTexCoord);
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