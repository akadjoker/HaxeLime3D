package com.gdx.gl.shaders;

import com.gdx.Buffer;
import com.gdx.color.Color3;
import com.gdx.gl.material.Material;
import com.gdx.math.Matrix;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.Shadow;
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
/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class ShaderCast extends Shader
{
	
	 
    
 
	 private var wordlMatrixUniform:Dynamic;
  
	
	 
	
	

	public function new() 
	{
		super();
		var sVertexShader="

	attribute vec3 aVertexPosition;
	uniform mat4 world;
    uniform mat4 viewProjection;
	varying vec4 vPosition;
	void main(void) 
	{
	    vPosition=viewProjection *world  * vec4(aVertexPosition, 1.0);
	    gl_Position = vPosition;
	
	}";
	
	
var sFragmentShader=
#if !desktop
"precision mediump float;" +
#end
"

vec4 pack(float depth)
{
	const vec4 bitOffset = vec4(255. * 255. * 255., 255. * 255., 255., 1.);
	const vec4 bitMask = vec4(0., 1. / 255., 1. / 255., 1. / 255.);
	vec4 comp = mod(depth * bitOffset * vec4(254.), vec4(255.)) / vec4(254.);
	comp -= comp.xxyz * bitMask;
	return comp;
}
vec4 packDepth(float depth) 
{
            float depthFrac = fract(depth * 255.0);
            return vec4(depth - depthFrac / 255.0, depthFrac, 1.0, 1.0);
}


vec2 packHalf(float depth) 
{ 
	const vec2 bitOffset = vec2(1.0 / 255., 0.);
	vec2 color = vec2(depth, fract(depth * 255.));
	return color - (color.yy * bitOffset);
}



	varying vec4 vPosition;

	void main()
	{	
		
	//int VSM = 0;
	
	//if ( VSM == 1 )
	//{
	//VSM
	float moment1 = gl_FragCoord.z / gl_FragCoord.w;
	float moment2 = moment1 * moment1;
	gl_FragColor = vec4(packHalf(moment1), packHalf(moment2));
	//}
	//else
	//{
	// float depth = vPosition.z / vPosition.w;
	// depth = depth * 0.5 + 0.5;
	// gl_FragColor = pack(depth);
		
	//}
		//	gl_FragColor = pack(gl_FragCoord.z);
	
		
	   
	}";

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
GL.useProgram (shaderProgram);	   
vertexAttribute = GL.getAttribLocation (shaderProgram, "aVertexPosition");
projMatrixUniform= GL.getUniformLocation (shaderProgram, "viewProjection");
wordlMatrixUniform = GL.getUniformLocation (shaderProgram, "world");
	}
	public function Begin():Void
	{
	GL.useProgram (shaderProgram);
	}
	public function setMatrix(proj:Matrix,world:Matrix):Void
	{
		  
		  GL.uniformMatrix4fv(projMatrixUniform, false, proj.asArray());
		  GL.uniformMatrix4fv(wordlMatrixUniform, false, world.asArray());
	}
	public function End()
	{
		GL.useProgram (null);
	}
}