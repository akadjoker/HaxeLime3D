package com.gdx.gl ;




import lime.Assets;
import lime.graphics.Image;
import lime.graphics.opengl.GL;



/**
 * ...
 * @author djoker
 */
class TextureCube extends Texture
{

	
	
	
	override public function Bind(i:Int=0)
	{
  	GL.bindTexture(GL.TEXTURE_CUBE_MAP, data);
	}

	

     public function new(rootUrl:String)
     {
		super();
		
     		
			var extensions:Array<String> = new Array<String>();
			extensions= ["_px.jpg", "_py.jpg", "_pz.jpg", "_nx.jpg", "_ny.jpg", "_nz.jpg"];
		
			
			data=GL.createTexture(); 
            GL.bindTexture (GL.TEXTURE_CUBE_MAP, data);

		
	
        
		var faces = [
                GL.TEXTURE_CUBE_MAP_POSITIVE_X, GL.TEXTURE_CUBE_MAP_POSITIVE_Y, GL.TEXTURE_CUBE_MAP_POSITIVE_Z,
                GL.TEXTURE_CUBE_MAP_NEGATIVE_X, GL.TEXTURE_CUBE_MAP_NEGATIVE_Y, GL.TEXTURE_CUBE_MAP_NEGATIVE_Z
            ];
		
		function _setTex(imagePath:String, index:Int) 
		{
		var bitmapData:Image= Assets.getImage(imagePath);	
			
		this.width =bitmapData.width;
		this.height = bitmapData.height;
		this.texWidth =  roundUpToPow2(width);
		this.texHeight = roundUpToPow2(height);
		
		
		  if (isTextureOk(bitmapData))
		{
		
		         
					GL.texImage2D (faces[index], 0, GL.RGBA, bitmapData.buffer.width, bitmapData.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, bitmapData.data);
				
		
				
		
		 		
	
		} else
		{
			#if debug
			trace("INFO : resize image : width:"+width+" to "+texWidth +", height: "+height+" to "+texHeight);
			#end
		
			bitmapData.resize(texWidth, texHeight);
			
			 
					GL.texImage2D (faces[index], 0, GL.RGBA, bitmapData.buffer.width, bitmapData.buffer.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, bitmapData.data);
					
		
				
		}
		
			
		}
		
		GL.bindTexture(GL.TEXTURE_CUBE_MAP, data);	
		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		
		
		for (i in 0...extensions.length) {
			if (Assets.exists(rootUrl + extensions[i])) 
			{	
				_setTex(rootUrl + extensions[i], i);
				#if debug trace("Load :" + rootUrl + extensions[i]);#end
			} else {
				trace("Image '" + rootUrl + extensions[i] + "' doesn't exist !");
			}
		}		

		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
		GL.generateMipmap(GL.TEXTURE_CUBE_MAP);


		
	}  
	
	
	
}