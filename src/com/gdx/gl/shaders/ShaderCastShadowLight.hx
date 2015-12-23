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
class ShaderCastShadowLight extends Shader
{
	

private var LightMatrixUniform:Dynamic;
private var NormalMatrixUniform:Dynamic;
 private var FBOTexture:Dynamic;
 private var shadow:Shadow;

	
	
	public function new() 
	{
		super();
		
  var sVertexShader=
"


attribute vec3 inVertexPosition;
attribute vec3 inVertexNormal;
attribute vec4 inVertexColor;
attribute vec2 inTexCoord0;
attribute vec2 inTexCoord1;

uniform mat4 WorldMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 NormalMatrix;
uniform mat4 LightMVMatrix;

uniform vec3 uLightPosition;
varying vec4 varVertexColor;
varying vec2 varTexCoord0;
varying vec2 varTexCoord1;


varying vec3 vNormal;
varying vec3 vLightRay;
varying vec3 vEyeVec;
varying  vec4 shadowPosition;



void main(void) 
{
    varTexCoord0 = inTexCoord0;
	varTexCoord1 = inTexCoord1;
	varVertexColor = inVertexColor;
	
 //Transformed normal position
 vNormal = vec3(NormalMatrix * vec4(inVertexNormal, 1.0));

 
 //Transformed vertex position
 vec4 vertex = ViewMatrix * vec4(inVertexPosition, 1.0);
 //Transformed light position
 vec4 light = ViewMatrix * vec4(uLightPosition,1.0);
	
 //Light position
 vLightRay = vertex.xyz-light.xyz;
 
 //Vector Eye
 vEyeVec = -vec3(vertex.xyz);
 	
	vec4 worldPos =  WorldMatrix * vec4(inVertexPosition, 1.0);
	
   
	
	shadowPosition =  LightMVMatrix  * worldPos;
	
 //Final vertex position
 gl_Position = ProjectionMatrix * ViewMatrix * WorldMatrix * vec4(inVertexPosition, 1.0);
 
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

varying  vec4 shadowPosition;

uniform vec4 uLightAmbient;
uniform vec4 uLightDiffuse;
uniform vec4 uLightSpecular;

uniform vec4 uMaterialAmbient;
uniform vec4 uMaterialDiffuse;
uniform vec4 uMaterialSpecular;
uniform float uShininess;       

varying vec3 vNormal;
varying vec3 vLightRay;
varying vec3 vEyeVec;

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

float unpack(vec4 color)
{
	const vec4 bit_shift = vec4(1.0 / (255.0 * 255.0 * 255.0), 1.0 / (255.0 * 255.0), 1.0 / 255.0, 1.0);
	return dot(color, bit_shift);
}

float unpackHalf(vec2 color)
{
	return color.x + (color.y / 255.0);
}

float computeShadow(vec4 vPositionFromLight, sampler2D shadowSampler,  float bias)
{
	vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
	depth = 0.5 * depth + vec3(0.5);
	vec2 uv = depth.xy;

	if (uv.x < 0. || uv.x > 1.0 || uv.y < 0. || uv.y > 1.0)
	{
		return 1.0;
	}

	float shadow = unpack(texture2D(shadowSampler, uv)) + bias;

	if (depth.z > 0.1)
	{
		return 0.5;
	}
	return 1.;
}

float computeShadowWithPCF(vec4 vPositionFromLight, sampler2D shadowSampler, float mapSize, float bias)
{
	vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
	depth = 0.5 * depth + vec3(0.5);
	vec2 uv = depth.xy;

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
	if (unpack(texture2D(shadowSampler, uv + poissonDisk[0] / mapSize)) + bias  <  depth.z) visibility -= 0.25;
	if (unpack(texture2D(shadowSampler, uv + poissonDisk[1] / mapSize)) + bias  <  depth.z) visibility -= 0.25;
	if (unpack(texture2D(shadowSampler, uv + poissonDisk[2] / mapSize)) + bias  <  depth.z) visibility -= 0.25;
	if (unpack(texture2D(shadowSampler, uv + poissonDisk[3] / mapSize)) + bias  <  depth.z) visibility -= 0.25;

	return visibility;
}

// Thanks to http://devmaster.net/
float ChebychevInequality(vec2 moments, float t)
{
	if (t <= moments.x)
	{
		return 0.0;
	}

	float variance = moments.y - (moments.x * moments.x);
	variance = max(variance, 0.002);

	float d = t - moments.x;

	return clamp(variance / (variance + d * d) - 0.05, 0.0, 1.0);
}

float computeShadowWithVSM(vec4 vPositionFromLight, sampler2D shadowSampler, float bias)
{
	vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
	depth = 0.5 * depth + vec3(0.5);
	vec2 uv = depth.xy;

	if (uv.x < 0. || uv.x > 1.0 || uv.y < 0. || uv.y > 1.0 || depth.z > 1.0)
	{
		return 1.0;
	}

	vec4 texel = texture2D(shadowSampler, uv);

	vec2 moments = vec2(unpackHalf(texel.xy), unpackHalf(texel.zw));
	return 1.0 - ChebychevInequality(moments, depth.z - bias);
}

vec4 computeLight(vec3 N ,vec3 L)
{
	 //Lambert's cosine law
    float lambertTerm = dot(N,-L);
    
    //Ambient Term  
    vec4 Ia = uLightAmbient * uMaterialAmbient;

    //Diffuse Term
    vec4 Id = vec4(0.0,0.0,0.0,1.0);

    //Specular Term
    vec4 Is = vec4(0.0,0.0,0.0,1.0);

    if(lambertTerm > 0.0)
    {
        Id = uLightDiffuse * uMaterialDiffuse * lambertTerm; 
        vec3 E = normalize(vEyeVec);
        vec3 R = reflect(L, N);
        float specular = pow( max(dot(R, E), 0.0), uShininess);
        Is = uLightSpecular * uMaterialSpecular * specular;
    }

    //Final color
    return  Ia + Id + Is;
	
    
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
		
    vec3 L = normalize(vLightRay);
    vec3 N = normalize(vNormal);

   
	
	     float bias = 0.00000000000001;

	
	//float bias = 0.00005;
	vec4 finalColor =  computeShadowWithVSM(shadowPosition, uFBOTexture, bias);
    gl_FragColor = FragColor * finalColor;
	

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
normalAttribute = GL.getAttribLocation (shaderProgram, "inVertexNormal");

 projMatrixUniform= GL.getUniformLocation (shaderProgram, "ProjectionMatrix");
 worldMatrixUniform = GL.getUniformLocation (shaderProgram, "WorldMatrix");
 viewMatrixUniform = GL.getUniformLocation (shaderProgram, "ViewMatrix");
 LightMatrixUniform = GL.getUniformLocation (shaderProgram, "LightMVMatrix");
 NormalMatrixUniform = GL.getUniformLocation (shaderProgram, "NormalMatrix");
 
 texture0Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit0");
 texture1Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit1");
 FBOTexture= GL.getUniformLocation (shaderProgram, "uFBOTexture");
 MaterialType = GL.getUniformLocation (shaderProgram, "uMaterialType");

 setMaterialType(0);

 
 
		  
		  
		  
Uniform4f(0.1,0.1,0.1,1.0,"uLightAmbient");
Uniform4f(1.0,1.0,1.0,1.0,"uLightDiffuse");
Uniform4f(1.0,1.0,1.0,1.0,"uLightSpecular");

//Object Uniforms
Uniform4f( 0.2,0.2,0.2,1.0,"uMaterialAmbient");
Uniform4f( 1.0,1.0,1.0,1.0,"uMaterialDiffuse");
Uniform4f( 1.0,1.0,1.0,1.0,"uMaterialSpecular");
Uniform1f(500, "uShininess");

 
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
		   UniformVector3(shadow.lightPosition, "uLightPosition");
		  }
		  

		  
		   var mvMatrix = Matrix.Identity();
		   mvMatrix = mvMatrix.multiply(view);
		   mvMatrix = mvMatrix.multiply(world);
		   var normal:Matrix = Matrix.Transpose(Matrix.Invert(mvMatrix));
		   GL.uniformMatrix4fv(NormalMatrixUniform, false, normal.asArray());
		   
		  
		  setProjMatrix(proj);
		  setViewMatrix(view);
		  setWorldMatrix(world);
			
		
		
	  	
	}
	public function UniformVector3(v:Vector3,s:String):Void
	{
		var u:GLUniformLocation = GL.getUniformLocation(shaderProgram, s);
		GL.uniform3f(u,v.x,v.y,v.z);
	}
	private function Uniform1f(a:Float,s:String):Void
	{
		var u:GLUniformLocation = GL.getUniformLocation(shaderProgram, s);
		GL.uniform1f(u, a);
	}
	
	private function Uniform4f(x:Float,y:Float,z:Float,w:Float,s:String):Void
	{
		var u:GLUniformLocation = GL.getUniformLocation(shaderProgram, s);
		GL.uniform4f(u,x,y,z,w);
	}
	
	public function setShadow(s:Shadow):Void
	{
		shadow = s;
		
	}
	
}