package com.gdx.scene3d.ms3d;
import com.gdx.color.Color4;
import com.gdx.gl.Texture;
import com.gdx.util.Util;
import lime.Assets;
import com.gdx.util.ByteArray;
import haxe.io.Path;


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class MS3DMaterial
{
	public var name:String;
	public var ambient:Color4;
	public var diffuse:Color4;
	public var specular:Color4;
	public var emissive:Color4;
	public var shininess:Float;
	public var transparency:Float;
	public var mode:Int;
	public var textureMap:String;
	public var alphaMap :String;
	public var texture:Texture;
	public var textureDetail:Texture;
	
	
	public function new(file:ByteArray,path:String) 
	{
		
		   name = Util.readString(file, 32);
		   
	
		   
		   
		   ambient = redColor(file);
		   diffuse = redColor(file);
		   specular = redColor(file);
		   emissive = redColor(file);
		   shininess = file.readFloat();
		   transparency = file.readFloat();
		   mode = file.readUnsignedByte();
		
		   textureMap = Path.withoutDirectory( Util.nextToken(file, 128,93));//break on ] ;)
		   alphaMap =  Path.withoutDirectory(Util.nextToken(file, 128,93));
		   
		   
		   
		   {
		   var  textureName:String = textureMap;
			  	 textureName = Path.withoutExtension(textureName);
			
			
			
		if (Assets.exists(path+ textureName+".jpg"))
		{
			texture = Gdx.Instance().getTexture(path  + textureName+".jpg", true, true, true);
			
		} else
		if (Assets.exists(path+ textureName+".JPG"))
		{
			texture=Gdx.Instance().getTexture(path  + textureName+".JPG", true,true,true);
			
		} else
		if (Assets.exists(path + textureName+".png"))
		{
			texture=Gdx.Instance().getTexture(path  + textureName+".png",  true,true,true);
		} else	
		if (Assets.exists(path + textureName+".PNG"))
		{
			texture=Gdx.Instance().getTexture(path  + textureName+".PNG",  true,true,true);
		} else	
		{
			texture = Gdx.Instance().getTexture("dummy");
			trace("Texture "+textureName+" dont exits in path");
		}
		}
		   /*
		trace("---------   MATERIAL");
		trace(name);
		trace(textureMap);
		trace(alphaMap);
		trace(ambient);
		trace(diffuse);
		trace(specular);
		trace(emissive);
		trace(shininess);
		trace(transparency);
		*/
	}
	
	private function redColor(f:ByteArray):Color4
	{
		
		var r:Float = f.readFloat();
		var g:Float = f.readFloat();
		var b:Float = f.readFloat();
		var a:Float = f.readFloat();
		
		return  new Color4(r,g,b,a);
	}
	
}