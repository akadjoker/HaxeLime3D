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
class ShaderDefault extends Shader
{
	



	
	
	public function new() 
	{
		super();
		
  var sVertexShader=
"
attribute vec3 inVertexPosition;
attribute vec4 inVertexColor;
attribute vec2 inTexCoord0;
attribute vec2 inTexCoord1;



uniform mat4 WorldMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;



varying vec4 varVertexColor;

varying vec2 varTexCoord0;
varying vec2 varTexCoord1;




void main(void)
{

	varTexCoord0 = inTexCoord0;
	varTexCoord1 = inTexCoord1;
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

#define Solid 0
#define Solid2Layer 1
#define LightMap 2
#define DetailMap 3
#define Reflection2Layer 4
#define TransparentAlphaChannel 5
#define TransparentAlphaChannelRef 6
#define TransparentVertexAlpha 7
#define TransparentReflection2Layer 8


#define FOGMODE_EXP 1.
#define FOGMODE_EXP2 2.
#define FOGMODE_LINEAR 3.
#define E 2.71828




/* Uniforms */

uniform int uMaterialType;
uniform int uUseFog;
uniform vec4 uFogInfos;
uniform vec3 uFogColor;

uniform sampler2D uTextureUnit0;
uniform sampler2D uTextureUnit1;



varying vec2 varTexCoord0;
varying vec2 varTexCoord1;
varying vec4 varVertexColor;


 vec4 pack_depth( const in  float depth ) {
		const  vec4 bit_shift = vec4( 256.0 * 256.0 * 256.0, 256.0 * 256.0, 256.0, 1.0 );
		const  vec4 bit_mask  = vec4( 0.0, 1.0 / 256.0, 1.0 / 256.0, 1.0 / 256.0 );
		 vec4 res = fract( depth * bit_shift );
		res -= res.xxyz * bit_mask;
		return res;
	}
	

vec4 renderSolid()
{
	vec4 Color = varVertexColor;
	Color *= texture2D(uTextureUnit0, varTexCoord0);
	Color.a = 1.0;
	return Color;
}

vec4 render2LayerSolid()
{
	float BlendFactor = varVertexColor.a;
	
	vec4 Texel0 = texture2D(uTextureUnit0, varTexCoord0);
	vec4 Texel1 = texture2D(uTextureUnit1, varTexCoord1);
	
	vec4 Color = Texel0 * BlendFactor + Texel1 * (1.0 - BlendFactor);
	
	return Color;
}

vec4 renderLightMap()
{
	vec4 Texel0 = texture2D(uTextureUnit0, varTexCoord0);
	vec4 Texel1 = texture2D(uTextureUnit1, varTexCoord1);
	
	
	vec4 Color = Texel0 * Texel1 * 4.0;
	Color.a = Texel0.a * Texel0.a;
	
	return Color;
}

vec4 renderDetailMap()
{
	vec4 Texel0 = texture2D(uTextureUnit0, varTexCoord0);
	vec4 Texel1 = texture2D(uTextureUnit1, varTexCoord1);
	
	//vec4 Color = Texel0 ;
	//Color += Texel1 - 0.2;
//	vec4 Color =mix(Texel0, Texel1, 0.4);
vec4 Color = Texel0 * Texel1;

	
	return Color;
}

vec4 renderReflection2Layer()
{
	vec4 Color = varVertexColor;
	
	vec4 Texel0 = texture2D(uTextureUnit0, varTexCoord0);
	vec4 Texel1 = texture2D(uTextureUnit1, varTexCoord1);
	
	Color *= Texel0 * Texel1;
	
	return Color;
}

vec4 renderTransparent()
{
	vec4 Color =  vec4(1.0, 1.0, 1.0, 1.0);


		Color *= texture2D(uTextureUnit0, varTexCoord0);

	return Color;
}

float calcFogFactor() {

    // gets distance from camera to vertex
    float fogDistance = gl_FragCoord.z / gl_FragCoord.w;

    float fogCoeff = 1.0;
    float fogStart = uFogInfos.y;
    float fogEnd = uFogInfos.z;
    float fogDensity = uFogInfos.w;

    if (FOGMODE_LINEAR == uFogInfos.x) {
        fogCoeff = (fogEnd - fogDistance) / (fogEnd - fogStart);
    }
    else if (FOGMODE_EXP == uFogInfos.x) {
        fogCoeff = 1.0 / pow(E, fogDistance * fogDensity);
    }
    else if (FOGMODE_EXP2 == uFogInfos.x) {
        fogCoeff = 1.0 / pow(E, fogDistance * fogDistance * fogDensity * fogDensity);
    }

    return clamp(fogCoeff, 0.0, 1.0);
}
void main ()
{
   vec4 FragColor= vec4(1.0, 1.0, 1.0, 1.0);
	
 if (uMaterialType == Solid)
		FragColor = renderSolid();
	else if(uMaterialType == Solid2Layer)
		FragColor = render2LayerSolid();
	else if(uMaterialType == LightMap)
		FragColor = renderLightMap();
	else if(uMaterialType == DetailMap)
		FragColor = renderDetailMap();
	else if(uMaterialType == Reflection2Layer)
		FragColor = renderReflection2Layer();
	else if(uMaterialType == TransparentAlphaChannel)
		FragColor = renderTransparent();
	else if(uMaterialType == TransparentAlphaChannelRef)
	{
		vec4 Color = renderTransparent();
		
		if (Color.a < 0.4)
			discard;
		
		FragColor = Color;
	}
	else if(uMaterialType == TransparentVertexAlpha)
	{
		vec4 Color = renderTransparent();
		Color.a = varVertexColor.a;
		
		FragColor = Color;
	}
	else if(uMaterialType == TransparentReflection2Layer)
	{
		vec4 Color = renderReflection2Layer();
		Color.a = varVertexColor.a;
		
		FragColor = Color;
	}
	else
		FragColor = vec4(1.0, 1.0, 1.0, 1.0);
		
		
		
				

		
   	    // vec4 fog_color = FragColor;
       //  float fog = calcFogFactor();
       //  fog_color.rgb = fog * fog_color.rgb + (1.0 - fog) * uFogColor;
	
		
		
		gl_FragColor = FragColor;// +pack_depth( gl_FragCoord.z );
		
		
				
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
texCoord1Attribute = GL.getAttribLocation (shaderProgram, "inTexCoord1");
colorAttribute = GL.getAttribLocation (shaderProgram, "inVertexColor");
 projMatrixUniform= GL.getUniformLocation (shaderProgram, "ProjectionMatrix");
 worldMatrixUniform = GL.getUniformLocation (shaderProgram, "WorldMatrix");
 viewMatrixUniform = GL.getUniformLocation (shaderProgram, "ViewMatrix");
 texture0Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit0");
 texture1Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit1");
 MaterialType = GL.getUniformLocation (shaderProgram, "uMaterialType");
 FogInfos=GL.getUniformLocation (shaderProgram, "uFogInfos");
 FogColor = GL.getUniformLocation (shaderProgram, "uFogColor");
 UseFog= GL.getUniformLocation (shaderProgram, "uUseFog");
 setMaterialType(0);

preSets();
 

trace(vertexAttribute+","+colorAttribute+","+texCoord0Attribute );
	 
 
	}
	
	
	
	
}