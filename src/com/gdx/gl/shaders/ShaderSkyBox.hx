package com.gdx.gl.shaders;

import com.gdx.gl.TextureCube;
import com.gdx.math.Matrix;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
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
class ShaderSkyBox extends Shader
{
	 public var textureCubeUniform:Dynamic;
	 

	public function new() 
	{
		super();
 var SkyBoxVertexShader=
"
attribute vec3 inVertexPosition;
uniform mat4 uProjMatrix;
uniform mat4 uWorldMatrix;
uniform mat4 uViewMatrix;
varying  vec3 vTextureCoord;


void main(void) {
	
	gl_Position = uProjMatrix * uViewMatrix* uWorldMatrix * vec4(inVertexPosition, 1.0);
	vTextureCoord.xyz = inVertexPosition.xyz;
	
}
";

 var SkyBoxFragmentShader=

#if !desktop
"precision mediump float;" +
#end
"
uniform samplerCube uCubeSampler;
varying vec3 vTextureCoord;


void main(void)
{	
    vec3 cube = vec3(textureCube(uCubeSampler, vTextureCoord.xyz));
	gl_FragColor = vec4(cube, 1.0);
		

}";
	 


	 


		 var vertexShader = GL.createShader (GL.VERTEX_SHADER);
        GL.shaderSource (vertexShader, SkyBoxVertexShader);
        GL.compileShader (vertexShader);
        if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) 
        {trace ("Load Vert:"+GL.getShaderInfoLog(vertexShader));}
		
       var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
       GL.shaderSource (fragmentShader, SkyBoxFragmentShader);
       GL.compileShader (fragmentShader);
       if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) 
	   { trace("Load Frag:"+GL.getShaderInfoLog(fragmentShader));}

shaderProgram = GL.createProgram ();
GL.attachShader (shaderProgram, vertexShader);
GL.attachShader (shaderProgram, fragmentShader);
GL.linkProgram (shaderProgram);

if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) 
{trace ("Unable to initialize the shader program.");}


 GL.useProgram (shaderProgram);
 projMatrixUniform  = GL.getUniformLocation (shaderProgram, "uProjMatrix");
 worldMatrixUniform = GL.getUniformLocation (shaderProgram, "uWorldMatrix");
 viewMatrixUniform = GL.getUniformLocation (shaderProgram, "uViewMatrix");
 textureCubeUniform = GL.getUniformLocation (shaderProgram, "uCubeSampler");
 vertexAttribute    = GL.getAttribLocation (shaderProgram, "inVertexPosition");
 #if debug trace(projMatrixUniform +"," + worldMatrixUniform + "," + textureCubeUniform + "," + vertexAttribute); #end
	}
	
	 public function setCubeMap(tex:TextureCube):Void
	{
		if (shaderProgram == null) return;
	   if (tex != null)
		{	
		if(tex != Gdx.Instance().currentBaseTextures[0] )
        {
       		Gdx.Instance().currentBaseTextures[0] = tex;
			tex.Bind();
			GL.uniform1i(textureCubeUniform, 0);
			Gdx.Instance().numTextures+=1;
       }
	 }
	 }
}