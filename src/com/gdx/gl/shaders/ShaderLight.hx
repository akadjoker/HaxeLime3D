package com.gdx.gl.shaders;

import com.gdx.color.Color3;
import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
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
class ShaderLight extends Shader
{
	
	private var ambientLightUniform:Dynamic;
	private var directionalLightUniform:Dynamic;
	private var colorUniform:Dynamic;
	private var intensityUniform:Dynamic;
	private var directionUniform:Dynamic;
	private var normalMatrixUniform:Dynamic;
	
		private var specularIntensityUniform:Dynamic;
		private var specularPowerIntensityUniform:Dynamic;
		private var eyePositionIntensityUniform:Dynamic;
	
	
	
	public var direction:Vector3;
	public var intensity:Float;
	public var color:Color3;
	public var ambient:Color3;
	public var specularIntensity:Float;
	public var specularPower:Float;
	public var camarePosition:Vector3;

	
	
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



varying vec4 varVertexColor;
varying vec3 varVertexNormal;
varying vec2 varTexCoord0;
varying vec2 varTexCoord1;
varying vec3 varWorldPos;




void main(void)
{
	
	
	
	varVertexNormal = (WorldMatrix * vec4(inVertexNormal, 0.0)).xyz;
	varWorldPos=(WorldMatrix * vec4(inVertexPosition, 1.0)).xyz;
	
	varTexCoord0 = inTexCoord0;
	varTexCoord1 = inTexCoord1;
	varVertexColor = inVertexColor;
    gl_Position =   ProjectionMatrix * ViewMatrix * vec4(varWorldPos, 1.0); //WorldMatrix * vec4(inVertexPosition, 1.0);
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





/* Uniforms */

uniform int uMaterialType;


uniform sampler2D uTextureUnit0;
uniform sampler2D uTextureUnit1;

uniform float specularIntensity;
uniform float specularPower;
uniform vec3  eyePosition;



varying vec2 varTexCoord0;
varying vec2 varTexCoord1;
varying vec4 varVertexColor;
varying vec3 varVertexNormal;
varying vec3 varWorldPos;


struct BaseLight
{
	vec3 color;
	float intensity;
};

struct DirectionalLight
{
 BaseLight base;
 vec3 direction;
};
uniform DirectionalLight directionalLight;
uniform vec3 ambientLight;


vec4 calcLight(BaseLight base , vec3 direction, vec3 normal)
{
	float  diffuseFactor = dot (normal, direction);
	
	vec4 diffuseColor = vec4(0.0, 0.0, 0.0, 0.0);
	vec4 specularColor = vec4(0.0, 0.0, 0.0, 0.0);
	
	if (diffuseFactor > 0.0)
	{
		diffuseColor = vec4 (base.color, 1.0) * base.intensity * diffuseFactor;
		vec3 directionToEye = normalize (eyePosition - varWorldPos);
		//vec3 reflectDirection = normalize(reflect(-direction, normal));
		
		 vec3 halfDirection = normalize(directionToEye - (-direction));
		 
		float specularFactor = dot(halfDirection, normal);
		  
		//float specularFactor = dot (directionToEye, reflectDirection);
		
		specularFactor = pow(specularFactor, specularPower);
		if (specularFactor > 0.0)
		{
			specularColor = vec4(base.color, 1.0) * specularIntensity * specularFactor;
		}
		
		
	}
	
	return diffuseColor   + specularColor;
}
vec4 calDirectionalLight(DirectionalLight directionalLight, vec3 normal)
{
	return calcLight(directionalLight.base, directionalLight.direction, normal);
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
	
	vec4 Color = Texel0 ;
	Color += Texel1 - 0.4;
	
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
	vec4 Color = vec4(1.0, 1.0, 1.0, 1.0);


		Color *= texture2D(uTextureUnit0, varTexCoord0);

	return Color;
}


void main ()
{
   vec4 textureColor= vec4(1.0, 1.0, 1.0, 1.0);
	
 if (uMaterialType == Solid)
		textureColor = renderSolid();
	else if(uMaterialType == Solid2Layer)
		textureColor = render2LayerSolid();
	else if(uMaterialType == LightMap)
		textureColor = renderLightMap();
	else if(uMaterialType == DetailMap)
		textureColor = renderDetailMap();
	else if(uMaterialType == Reflection2Layer)
		textureColor = renderReflection2Layer();
	else if(uMaterialType == TransparentAlphaChannel)
		textureColor = renderTransparent();
	else if(uMaterialType == TransparentAlphaChannelRef)
	{
		vec4 Color = renderTransparent();
		
		if (Color.a < 0.5)
			discard;
		
		textureColor = Color;
	}
	else if(uMaterialType == TransparentVertexAlpha)
	{
		vec4 Color = renderTransparent();
		Color.a = varVertexColor.a;
		
		textureColor = Color;
	}
	else if(uMaterialType == TransparentReflection2Layer)
	{
		vec4 Color = renderReflection2Layer();
		Color.a = varVertexColor.a;
		
		textureColor = Color;
	}
	else
		textureColor = vec4(1.0, 1.0, 1.0, 1.0);
		
		
	    vec4 totalLight = vec4 (ambientLight, 1.0);
	
		vec3 normal = normalize(varVertexNormal );
			
		totalLight += calDirectionalLight(directionalLight, normal);
		
		gl_FragColor = textureColor * totalLight;
		
		
				
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
normalAttribute= GL.getAttribLocation (shaderProgram, "inVertexNormal");
 projMatrixUniform= GL.getUniformLocation (shaderProgram, "ProjectionMatrix");
 worldMatrixUniform = GL.getUniformLocation (shaderProgram, "WorldMatrix");
 viewMatrixUniform = GL.getUniformLocation (shaderProgram, "ViewMatrix");
 normalMatrixUniform= GL.getUniformLocation (shaderProgram, "NormalMatrix");
 texture0Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit0");
 texture1Uniform = GL.getUniformLocation (shaderProgram, "uTextureUnit1");
 MaterialType = GL.getUniformLocation (shaderProgram, "uMaterialType");
 
 specularIntensityUniform= GL.getUniformLocation (shaderProgram, "specularIntensity");
 specularPowerIntensityUniform= GL.getUniformLocation (shaderProgram, "specularPower");
 eyePositionIntensityUniform= GL.getUniformLocation (shaderProgram, "eyePosition");
	
 
 
 ambientLightUniform = GL.getUniformLocation (shaderProgram, "ambientLight");
 
colorUniform = GL.getUniformLocation (shaderProgram, "directionalLight.base.color");
intensityUniform= GL.getUniformLocation (shaderProgram, "directionalLight.base.intensity");
directionUniform= GL.getUniformLocation (shaderProgram, "directionalLight.direction");
	

 
 direction = new Vector3(0, -1, 0);
 intensity = 0.1;
 color = new Color3(0.1, 0.1, 0.1);
 ambient = new Color3(0.01, 0.01, 0.01);
 specularIntensity = 0.2;
 specularPower = 1;
 camarePosition = Vector3.zero;
 setMaterialType(0);



trace(vertexAttribute+","+colorAttribute+","+texCoord0Attribute+","+normalAttribute );
	 
 
	}

    override	public function Bind(view:Matrix,proj:Matrix,world:Matrix):Void
	{
	 super.Bind(view, proj, world);
	 GL.uniform3f(ambientLightUniform, ambient.r, ambient.g, ambient.b);
     GL.uniform3f(colorUniform,color.r,color.g,color.b);
     GL.uniform1f(intensityUniform, intensity);
	 GL.uniform1f(specularIntensityUniform, specularIntensity);
	 GL.uniform1f(specularPowerIntensityUniform, specularPower);
	 GL.uniform3f(eyePositionIntensityUniform,camarePosition.x,camarePosition.y,camarePosition.z);
     direction.normalize();
     GL.uniform3f(directionUniform, direction.x,direction.y,direction.z);
	 
	}
	

	

}