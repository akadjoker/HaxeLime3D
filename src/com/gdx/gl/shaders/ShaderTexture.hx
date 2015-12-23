package com.gdx.gl.shaders;


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
class ShaderTexture extends Shader
{
	



	
	
	public function new() 
	{
		super();
		
  var sVertexShader=
"
attribute vec3 inVertexPosition;
attribute vec4 inVertexColor;
attribute vec2 inTexCoord0;


uniform mat4 WorldMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
varying vec4 varVertexColor;
varying vec2 varTexCoord0;

void main(void)
{
	varTexCoord0 = inTexCoord0;
	varVertexColor = inVertexColor;
    gl_Position =   ProjectionMatrix * ViewMatrix * WorldMatrix * vec4(inVertexPosition, 1.0);
}
";
//******************

 var sFragmentShader=

#if !desktop
"precision mediump float;" +
#end
"

uniform sampler2D uTextureUnit0;
varying vec2 varTexCoord0;
varying vec4 varVertexColor;



void main ()
{
				gl_FragColor = varVertexColor * texture2D(uTextureUnit0, varTexCoord0);
				if(gl_FragColor.a < 0.2)
                discard;
		
		
	
	
}";	

//**************************************************

        var vertexShader = GL.createShader (GL.VERTEX_SHADER);
        GL.shaderSource (vertexShader, sVertexShader);
        GL.compileShader (vertexShader);
        if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) 
        {trace ("Load Vert:"+GL.getShaderInfoLog(vertexShader));return;}
		
       var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
       GL.shaderSource (fragmentShader, sFragmentShader);
       GL.compileShader (fragmentShader);
       if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) 
	   { trace("Load Frag:" + GL.getShaderInfoLog(fragmentShader)); return; }
	  
	   
shaderProgram = GL.createProgram ();
GL.attachShader (shaderProgram, vertexShader);
GL.attachShader (shaderProgram, fragmentShader);
GL.linkProgram (shaderProgram);

if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) 
{trace ("Unable to initialize the shader program."); return; }
//{throw "Unable to initialize the shader program.";}

 GL.useProgram (shaderProgram);	   


vertexAttribute = GL.getAttribLocation (shaderProgram, "inVertexPosition");
texCoord0Attribute = GL.getAttribLocation (shaderProgram, "inTexCoord0");
colorAttribute = GL.getAttribLocation (shaderProgram, "inVertexColor");
 projMatrixUniform= GL.getUniformLocation (shaderProgram, "ProjectionMatrix");
 worldMatrixUniform = GL.getUniformLocation (shaderProgram, "WorldMatrix");
 viewMatrixUniform = GL.getUniformLocation (shaderProgram, "ViewMatrix");
 texture0Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit0");

 
 
 
 

preSets();
 

trace(vertexAttribute+","+colorAttribute+","+texCoord0Attribute );
	 
 
	}
	
	
	
	
}