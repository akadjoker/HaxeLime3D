package com.gdx.gl.shaders;

import com.gdx.Buffer;
import com.gdx.color.Color3;
import com.gdx.gl.material.Material;
import com.gdx.math.Matrix;
import com.gdx.scene3d.cameras.Camera;
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
class Shader extends Buffer
{

	 
    private var shaderProgram:GLProgram;
	
	 private var texture0Uniform:Dynamic;
     private var texture1Uniform:Dynamic;
     private var texture2Uniform:Dynamic;
     private var texture3Uniform:Dynamic;
 
	 private var projMatrixUniform:Dynamic;
     private var worldMatrixUniform:Dynamic;
     private var viewMatrixUniform:Dynamic;
	
	 
	 public var bonesAttribute :Int;
     public var wighsAttribute :Int;
     public var boneMatrixUniform:Array<Dynamic>;

 
	 private var MaterialType:Dynamic;
	 private var UseFog:Dynamic;
	 private var FogInfos:Dynamic;
	 private var FogColor:Dynamic;
	

	
	 
	public var vertexAttribute :Int;
    public var normalAttribute :Int;
    public var colorAttribute :Int;
    public var texCoord0Attribute :Int;
	public var texCoord1Attribute :Int;
	

	
	public function new() 
	{
		super();
		vertexAttribute = -1;
		normalAttribute = -1;
		colorAttribute = -1;
		texCoord0Attribute = -1;
		texCoord1Attribute = -1;
		bonesAttribute = -1;
		wighsAttribute = -1;

		boneMatrixUniform = [];
		MaterialType = null;

		
		
	}
	public function setBoneMatrix(index:Int,m:Matrix):Void
	{
	 	GL.uniformMatrix4fv(boneMatrixUniform[index], false,  m.asArray());
	}
	
	public function setProjMatrix(m:Matrix):Void
	{
	    
	    GL.uniformMatrix4fv(projMatrixUniform, false, m.asArray() );
		
	
 	
	}
	public function setViewMatrix(m:Matrix):Void
	{
      
	GL.uniformMatrix4fv(viewMatrixUniform, false,m.asArray());
		

	}
	public function setWorldMatrix(m:Matrix):Void
	{

    
	     GL.uniformMatrix4fv(worldMatrixUniform, false, m.asArray());
		

	}
	
	public function setMaterialType(m:Int):Void
	{
         GL.uniform1i(MaterialType, m);
		

	}
	
	
	public function setTexture0(tex:Texture):Void
	{
	
		if (texCoord0Attribute == -1) return;
		
		if(tex != Gdx.Instance().currentBaseTextures[0] )
       {
       		
			tex.Bind(0);
			GL.uniform1i(texture0Uniform, 0);
			Gdx.Instance().numTextures+=1;
			Gdx.Instance().currentBaseTextures[0]= tex;
       }
	

	 
		
	}

  
	 
	
	 public function preSets():Void
	 {
	 }
	 
	public function Use():Void
	{
		  GL.useProgram (shaderProgram);
	}
	
	public function Bind(view:Matrix,proj:Matrix,world:Matrix):Void
	{
		  GL.useProgram (shaderProgram);
		  setProjMatrix(proj);
		  setViewMatrix(view);
		  setWorldMatrix(world);
			
		  preSets();
		
	  	
	}
	public function unBind()
	{
		  GL.useProgram (null);
	}
	
	public function ApplayMaterial(mat:Material):Void
	{
	
		
		if (mat !=Gdx.Instance().currentMaterial)
		{
		  mat.Applay();
		  setMaterialType(mat.materialType);
		  Gdx.Instance().currentMaterial = mat;
		}
		  
		  

		 for (i in 0...Gdx.MAXTEXTURES)
	     {
			 if (mat.textures[i] != null)
			 {
			 
			//	trace("apply :"+i); 
		if(mat.textures[i] != Gdx.Instance().currentBaseTextures[i])
        {
       		Gdx.Instance().currentBaseTextures[i] = mat.textures[i];
			
			
			switch(i)
			{
				case 0:
					{
		 			 mat.textures[i].Bind(0);	
					 GL.uniform1i(texture0Uniform, 0);
			
					}
				case 1:
					{
					mat.textures[i].Bind(1);		
					GL.uniform1i(texture1Uniform, 1);
				
					}
				 case 2:
					{
					mat.textures[i].Bind(2);		
					GL.uniform1i(texture2Uniform, 2);
					}
				case 3:
					{
					mat.textures[i].Bind(3);		
					GL.uniform1i(texture3Uniform, 3);
					}	
			}
			
			
			Gdx.Instance().numTextures+=1;
          }
	  } else 
			 {
				 //	trace("break :"+i); 
				 break;
			 }
			 
	     
		}
		
		
	  	
	}

	override public function dispose() 
	{
		shaderProgram = null;
		super.dispose();
	}
}