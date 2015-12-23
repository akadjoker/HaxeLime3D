package com.gdx.gl.shaders;

import com.gdx.color.Color3;
import com.gdx.math.Matrix;
import com.gdx.math.Vector3;
import com.gdx.scene3d.lights.PointLight;
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
class ShaderPointLight extends Shader
{
	private var COLOR_DEPTH:Int = 256;
	
	private var ambientLightUniform:Dynamic;
	
	private var colorUniform:Dynamic;
	private var intensityUniform:Dynamic;
	
	private var positionLightUniform:Dynamic;
	private var rangeUniform:Dynamic;
	
	//Attenuation
	private var constantUniform:Dynamic;
	private var linearUniform:Dynamic;
	private var exponentUniform:Dynamic;
	
	
	private var normalMatrixUniform:Dynamic;
	
		private var specularIntensityUniform:Dynamic;
		private var specularPowerIntensityUniform:Dynamic;
		private var eyePositionIntensityUniform:Dynamic;
	
	
		
	public var position:Vector3;
	public var range:Float;
	
	public var intensity:Float;
	public var color:Color3;
	
	public var ambient:Color3;
	
	public var constant:Float;
	public var linear:Float;
	public var exponent:Float;
	
	
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
	varWorldPos =(WorldMatrix * vec4(inVertexPosition, 1.0)).xyz;
	
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


uniform vec3  eyePosition;

uniform float specularIntensity;
uniform float specularPower;

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



struct Attenuation
{
    float constant;
    float linear;
    float exponent;
};

struct PointLight
{
    BaseLight base;
    Attenuation atten;
    vec3 position;
    float range;
};



uniform vec3 ambientLight;
uniform PointLight pointLight;

vec4 CalcLight(BaseLight base, vec3 direction, vec3 normal, vec3 worldPos)
{
    float diffuseFactor = dot(normal, -direction);
    
    vec4 diffuseColor = vec4(0.0,0.0,0.0,0.0);
    vec4 specularColor = vec4(0.0,0.0,0.0,0.0);
    
    if(diffuseFactor > 0.0)
    {
        diffuseColor = vec4(base.color, 1.0) * base.intensity * diffuseFactor;
        
        vec3 directionToEye = normalize(eyePosition - worldPos);
        //vec3 reflectDirection = normalize(reflect(direction, normal));
        vec3 halfDirection = normalize(directionToEye - direction);
        
        float specularFactor = dot(halfDirection, normal);
        //float specularFactor = dot(directionToEye, reflectDirection);
        specularFactor = pow(specularFactor, specularPower);
        
        if(specularFactor > 0.0)
        {
            specularColor = vec4(base.color, 1.0) * specularIntensity * specularFactor;
        }
    }
    
    return diffuseColor + specularColor;
}

vec4 CalcPointLight(PointLight pointLight, vec3 normal, vec3 worldPos)
{
    vec3 lightDirection = worldPos - pointLight.position;
    float distanceToPoint = length(lightDirection);
    
    if(distanceToPoint > pointLight.range)
        return vec4(0.0,0.0,0.0,0.0);
    
    lightDirection = normalize(lightDirection);
    
    vec4 color = CalcLight(pointLight.base, lightDirection, normal, worldPos);
    
    float attenuation = pointLight.atten.constant +
                         pointLight.atten.linear * distanceToPoint +
                         pointLight.atten.exponent * distanceToPoint * distanceToPoint +
                         0.0001;
                         
    return color / attenuation;
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
			
		totalLight += CalcPointLight(pointLight, normal,varWorldPos);
		
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
 ambientLightUniform = GL.getUniformLocation (shaderProgram, "ambientLight");



constantUniform= GL.getUniformLocation (shaderProgram, "pointLight.atten.constant");
linearUniform= GL.getUniformLocation (shaderProgram, "pointLight.atten.linear");
exponentUniform = GL.getUniformLocation (shaderProgram, "pointLight.atten.exponent");

//base
colorUniform = GL.getUniformLocation (shaderProgram, "pointLight.base.color");
intensityUniform = GL.getUniformLocation (shaderProgram, "pointLight.base.intensity");

positionLightUniform = GL.getUniformLocation (shaderProgram, "pointLight.position");
rangeUniform= GL.getUniformLocation (shaderProgram, "pointLight.range");
	


 
position = new Vector3(0, 1,0);
specularIntensity = 1;
specularPower = 8;
intensity = 10.8;
color = new Color3(0, 0, 0);
ambient = new Color3(0.1, 0.1, 0.1);
constant = 0;
linear = 0;
exponent = 1;
camarePosition = Vector3.zero;
 

 setMaterialType(0);



trace(vertexAttribute+","+colorAttribute+","+texCoord0Attribute+","+normalAttribute );
	 
 
	}

    override	public function Bind(view:Matrix,proj:Matrix,world:Matrix):Void
	{
		  super.Bind(view, proj, world);
	
	GL.uniform3f(ambientLightUniform, ambient.r, ambient.g, ambient.b);
     
	//base
	 GL.uniform3f(colorUniform,color.r,color.g,color.b);
     GL.uniform1f(intensityUniform, intensity);
	 
	 //specular
	     GL.uniform1f(specularIntensityUniform, specularIntensity);
		 GL.uniform1f(specularPowerIntensityUniform, specularPower);
	

		 
//atte
         GL.uniform1f(constantUniform, constant);
	     GL.uniform1f(linearUniform, linear);
		 GL.uniform1f(exponentUniform, exponent);
	     var a:Float = exponent;
    	 var b:Float = linear;
	     var c:Float = constant - COLOR_DEPTH  * intensity * color.Max();
         range =  (( -b + Math.sqrt(b * b - 4 * a * c)) / (2 * a));
         GL.uniform1f(rangeUniform, range);
		 
		 
		 GL.uniform3f(eyePositionIntensityUniform,camarePosition.x,camarePosition.y,camarePosition.z);
//point     
        GL.uniform3f(positionLightUniform, position.x, position.y, position.z);
	 
	 
	}
	
	 public function setLightData(light:PointLight,camPos:Vector3):Void
	{
		                 specularIntensity = light.specularIntensity;
						 specularPower = light.specularPower;
						 
						 position = light.local_pos;
						 
						 color = light.color;
						 ambient = light.ambient;
						 
						 intensity = light.intensity;
						 camarePosition = camPos;
						 
						 exponent = light.exponent;
						 linear = light.linear;
						 constant = light.constant;
						 
		
	}

	

}