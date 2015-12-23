package com.gdx.gl.material;

import com.gdx.color.Color3;
import com.gdx.gl.Texture;
import com.gdx.math.Matrix;

import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.Float32Array;
import com.gdx.util.ByteArray;
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
class Material extends Buffer
{
	

  public var textures:Array<Texture>;
  
  public var alpha:Float;
  public var CullingFace:Bool;
  public var BlendFace:Bool;
  public var BlendType:Int;
  public var DiffuseColor:Color3;
  public var AmbientColor:Color3;
  public var SpecularColor:Color3;
  public var Shininess:Float;
  public var DepthTest:Bool;
  public var DepthMask:Bool;
  public var materialId:Int;
  public var materialType:Int;

 
	public function new() 
	{
		super();
	 textures = [];
	 for (i in 0...Gdx.MAXTEXTURES)
	 {
	 textures.push(null);
	 }
	 alpha = 1;
	 CullingFace = true;
	 BlendFace = false;
	 DiffuseColor = new Color3(1.0, 1.0, 1.0);
	 SpecularColor = new Color3(1.0, 1.0, 1.0);
	 AmbientColor = new Color3(1.0, 1.0, 1.0);
	 Shininess = 10;
	 BlendType = BlendMode.NORMAL;
	 DepthTest = true;
	 DepthMask = true;
	 materialId = 0;
	 materialType = 0;

	}
	public function setTexture(tex:Texture,layer:Int=0)
	{
	textures[layer] = tex;
	}
	
    public function setMaterialType(newType:Int):Void
	{
		materialType = newType;
		
	}

	public function Applay():Void
	{
		
		Gdx.Instance().setDepthMask(DepthMask);
		Gdx.Instance().setDepthTest(DepthTest);
		Gdx.Instance().setCullFace(CullingFace);
		Gdx.Instance().setBlend(BlendFace);
		if (BlendFace)
		{
		//Gdx.Instance().setBlendType(BlendType);
		BlendMode.setBlend(BlendType);
		}
		
		Gdx.Instance().numBrush += 1;
		
		
	}
	

	public static function CompareMaterial(brush1:Material, brush2:Material):Bool
	{
		
		
		if (brush1.textures[0] != null)
		{
			if (brush2.textures[0] != null)
			{
				if (brush1.textures[0] != brush2.textures[0]) return false;
			}
		}
			
		if (brush1.textures[1] != null)
		{
			if (brush2.textures[1] != null)
			{
				if (brush1.textures[1] != brush2.textures[1]) return false;
			}
		}
		return true;
	}
	public function clone(b:Material):Void
	{
		this.alpha = b.alpha;
		this.BlendFace = b.BlendFace;
		this.BlendType = b.BlendType;
		this.CullingFace = b.CullingFace;
		this.DepthMask = b.DepthMask;
		this.DepthTest = b.DepthTest;
		this.materialId = b.materialId;
		this.materialType = b.materialType;
		this.DiffuseColor.copyFrom(b.DiffuseColor);
		
		 for (i in 0...Gdx.MAXTEXTURES)
	     {
	      this.textures[i] = b.textures[i];
	     }
		
	}

	override public function dispose() 
	{
		 for (i in 0...Gdx.MAXTEXTURES)
	     {
	      this.textures[i].dispose();
		  this.textures[i] = null;
	     }
		 this.textures = null;
		super.dispose();
	}
	
}