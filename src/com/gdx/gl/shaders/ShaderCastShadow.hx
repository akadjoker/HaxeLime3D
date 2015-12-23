package com.gdx.gl.shaders;

import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
import com.gdx.scene3d.Shadow;
import lime.Assets;
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
class ShaderCastShadow extends Shader
{
	

private var LightMatrixUniform:Dynamic;
private var NormalMatrixUniform:Dynamic;
 private var FBOTexture:Dynamic;
 private var shadow:Shadow;

	
	
	public function new() 
	{
		super();
		
  var sVertexShader =
 #if !desktop
"precision mediump float;" +
#end 
"


attribute vec3 inVertexPosition;
attribute vec3 inVertexNormal;
attribute vec4 inVertexColor;
attribute vec2 inTexCoord0;
attribute vec2 inTexCoord1;

uniform mat4 WorldMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 LightMVMatrix;

uniform vec3 uLightPosition;
varying vec4 varVertexColor;
varying vec2 varTexCoord0;
varying vec2 varTexCoord1;
varying vec3 varVertexNormal;


varying  vec4 shadowPosition;



void main(void) 
{
    varTexCoord0 = inTexCoord0;
	varTexCoord1 = inTexCoord1;
	varVertexColor = inVertexColor;
	varVertexNormal = inVertexNormal;

	   vec4 worldPos =  WorldMatrix * vec4(inVertexPosition, 1.0);
       vec4 pos =  ProjectionMatrix * ViewMatrix * worldPos;
 
	    mat4 uShadowBiasMatrix = mat4( 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.5, 0.5, 0.5, 1.0);
 		

		shadowPosition =   LightMVMatrix  * worldPos;
		gl_Position = pos;
		
	
	
	
//	vec4 worldPos =  WorldMatrix * vec4(inVertexPosition, 1.0);
  //  shadowPosition =  LightMVMatrix  * worldPos;
  //  gl_Position = ProjectionMatrix * ViewMatrix * WorldMatrix * worldPos;
 
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



uniform sampler2D uTextureUnit0;
uniform sampler2D uTextureUnit1;
uniform sampler2D uFBOTexture;
uniform int uMaterialType;

varying vec2 varTexCoord0;
varying vec2 varTexCoord1;
varying vec4 varVertexColor;
varying vec3 varVertexNormal;

varying  vec4 shadowPosition;


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
vec4 Color = Texel0 ;

	
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



float unpack_depth( const in  vec4 rgba_depth ) 
	 {
		const  vec4 bit_shift = vec4( 1.0 / ( 256.0 * 256.0 * 256.0 ), 1.0 / ( 256.0 * 256.0 ), 1.0 / 256.0, 1.0 );
		 float depth = dot( rgba_depth, bit_shift );
		return depth;
	}
float unpack(vec4 color)
{
	const vec4 bitShift = vec4(1. / (255. * 255. * 255.), 1. / (255. * 255.), 1. / 255., 1.);
	return dot(color, bitShift);
}

float unpackHalf(vec2 color)
{
	return color.x + (color.y / 255.0);
}

float computeShadow(vec4 vPositionFromLight, sampler2D shadowSampler)
{
	float bias = 0.005;
	vec3 shadowCoordZDivide = vPositionFromLight.xyz / vPositionFromLight.w;
	
	float depth = unpack_depth(texture2D(shadowSampler, shadowCoordZDivide.xy));
 
	  if(vPositionFromLight.w > 0.1)
		{
			if( (shadowCoordZDivide.z) > (depth - bias) )
			{
				return  0.5;
			}
		}
		
	return 1.;
}

float computeShadowWithPCF(vec4 vPositionFromLight, sampler2D shadowSampler)
{
	vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
	vec2 uv = 0.5 * depth.xy + vec2(0.5, 0.5);

	if (uv.x < 0. || uv.x > 1.0 || uv.y < 0. || uv.y > 1.0)
	{
		return 1.0;
	}

	float visibility = 1.;

	vec2 poissonDisk[4];
	poissonDisk[0] = vec2(-0.94201624, -0.39906216);
	poissonDisk[1] = vec2(0.94558609, -0.76890725);
	poissonDisk[2] = vec2(-0.094184101, -0.92938870);
	poissonDisk[3] = vec2(0.34495938, 0.29387760);

	// Poisson Sampling
	for (int i = 0; i<4; i++){
		if (unpack(texture2D(shadowSampler, uv + poissonDisk[i] / 1500.0))  <  depth.z){
			visibility -= 0.2;
		}
	}
	return visibility;
}

// Thanks to http://devmaster.net/
float ChebychevInequality(vec2 moments, float t)
{
	if (t <= moments.x)
	{
		return 1.0;
	}

	float variance = moments.y - (moments.x * moments.x);
	variance = max(variance, 0.);

	float d = t - moments.x;
	return variance / (variance + d * d);
}

float computeShadowWithVSM(vec4 vPositionFromLight, sampler2D shadowSampler)
{
    vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
	vec2 uv = 0.5 * depth.xy + vec2(0.5, 0.5);

	if (uv.x < 0. || uv.x > 1.0 || uv.y < 0. || uv.y > 1.0)
	{
		return 1.0;
	}

	vec4 texel = texture2D(shadowSampler, uv);

	vec2 moments = vec2(unpackHalf(texel.xy), unpackHalf(texel.zw));
	return clamp(1.3 - ChebychevInequality(moments, depth.z), 0., 1.0);
}

void main(void)
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
		
   
  // float bias = 0.00000000000001;
  
 // float shadow = 1.;
  

 
					
		
		 float shadow = 1.0;
	  
		 shadow = computeShadowWithVSM(shadowPosition, uFBOTexture);
		 
		
	vec4 LightColor = vec4(1.0,1.0,1.0,0.0);

	

    gl_FragColor =  shadow * FragColor * LightColor;
	

}";	

//**************************************************

 // var vs_source = Assets.getText("data/point_light.vs");
//  var fs_source = Assets.getText("data/point_light.fs");
		  

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
normalAttribute= GL.getAttribLocation (shaderProgram, "inVertexNormal");


 projMatrixUniform= GL.getUniformLocation (shaderProgram, "ProjectionMatrix");
 worldMatrixUniform = GL.getUniformLocation (shaderProgram, "WorldMatrix");
 viewMatrixUniform = GL.getUniformLocation (shaderProgram, "ViewMatrix");
 LightMatrixUniform = GL.getUniformLocation (shaderProgram, "LightMVMatrix");

 
 texture0Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit0");
 texture1Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit1");
 FBOTexture= GL.getUniformLocation (shaderProgram, "uFBOTexture");
 MaterialType = GL.getUniformLocation (shaderProgram, "uMaterialType");

 setMaterialType(0);

 
 
 
shadow = null;

trace(vertexAttribute+","+colorAttribute+","+texCoord0Attribute );
	 
 
	}
	
	override public function Bind(view:Matrix,proj:Matrix,world:Matrix):Void
	{
		  GL.useProgram (shaderProgram);
		  
		  if (shadow != null)
		  {
		   GL.uniformMatrix4fv(LightMatrixUniform, false, shadow.lightMatrix.asArray());
		   shadow.bindBuffer(5);
		   GL.uniform1i(FBOTexture, 5);
		  }
		  
		   
		  
		  setProjMatrix(proj);
		  setViewMatrix(view);
		  setWorldMatrix(world);
			
		
		
	  	
	}
	
	
	public function setShadow(s:Shadow):Void
	{
		shadow = s;
		
	}
	
}