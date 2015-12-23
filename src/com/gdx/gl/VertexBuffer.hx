package com.gdx.gl ;


import com.gdx.Buffer;
import com.gdx.gl.shaders.Shader;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.utils.Int16Array;

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
class VertexBuffer extends Buffer
{
	public var bonesBuffer:GLBuffer;
	public var wighsBuffer:GLBuffer;

  	
	public var coordBuffer:GLBuffer;
	public var tex0Buffer:GLBuffer;
	public var tex1Buffer:GLBuffer;
	public var colBuffer:GLBuffer;
	
	public var normBuffer:GLBuffer;
	
	
	
	public var  indexBuffer:GLBuffer;

	
	public var useDetail:Bool;
	public var useTexture:Bool;
	public var useColors:Bool;
	public var useNormals:Bool;
	public var useBones:Bool;

	public var pipeline:Shader;
	
	public function new(shader:Shader) 
	{
		super();
		this.pipeline = shader;
		
		

		if (shader.colorAttribute>=0 )
		{
			useColors = true;
		} else
		{
			useColors = false;
		}
		
	
		
		if (shader.normalAttribute >=0 )
		{
			useNormals = true;
		} else
		{
			useNormals = false;
		}

		if (shader.texCoord0Attribute  >=0 )
		{
			this.useTexture = true;
		} else
		{
			this.useTexture = false;
		}
		if (shader.texCoord1Attribute >=0 )
		{
			useDetail = true;
		} else
		{
			useDetail = false;
		}
			
		if (pipeline.bonesAttribute >=0)
		{
			useBones = true;
		
		} else
		{
			useBones = false;
		}
		
		//trace( useTexture +" , "+ useDetail);
		
		
		coordBuffer = GL.createBuffer();
		indexBuffer = GL.createBuffer();
		
		
		if (useNormals)
		{
		normBuffer = GL.createBuffer();
	    }
		if (useTexture)
		{
		tex0Buffer = GL.createBuffer();
		if (useDetail)
		{
		tex1Buffer = GL.createBuffer();
		}
		}
	
		if (useColors)
		{
		colBuffer  = GL.createBuffer();
		}
		
	
		
		if (useBones)
		{ 
	
			  bonesBuffer=GL.createBuffer();
              wighsBuffer = GL.createBuffer();
		}
		
		
		
	}
	public function set(shader:Shader) :Void
	{
	
		this.pipeline = shader;
		

		if (shader.colorAttribute>=0 )
		{
			useColors = true;
		} else
		{
			useColors = false;
		}
		
		
		
		if (shader.normalAttribute >=0 )
		{
			useNormals = true;
		} else
		{
			useNormals = false;
		}

		if (shader.texCoord0Attribute  >=0 )
		{
			this.useTexture = true;
		} else
		{
			this.useTexture = false;
		}
		if (shader.texCoord1Attribute >=0 )
		{
			useDetail = true;
		} else
		{
			useDetail = false;
		}
			
		if (pipeline.bonesAttribute >=0)
		{
			useBones = true;
		
		} else
		{
			useBones = false;
		}
		
		
		
		
		
		if (useNormals)
		{
		if(normBuffer==null) normBuffer = GL.createBuffer();
	    }
		if (useTexture)
		{
		if(tex0Buffer==null) tex0Buffer = GL.createBuffer();
		if (useDetail)
		{
		if(tex1Buffer==null)tex1Buffer = GL.createBuffer();
		}
		}
	
		if (useColors)
		{
		if(colBuffer==null) colBuffer  = GL.createBuffer();
		}
		
	
		
		if (useBones)
		{ 
		 
			if(bonesBuffer==null)  bonesBuffer=GL.createBuffer();
            if(wighsBuffer==null)   wighsBuffer = GL.createBuffer();
		}
		
		
		
	}
	public function uploadIndices(v:Array<Int>):Void
    {
	       GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
           GL.bufferData(GL.ELEMENT_ARRAY_BUFFER,  new Int16Array(v), GL.STATIC_DRAW);
		   GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		
		   
   }
     public function uploadBones(v:Array<Float>):Void
    {
	           if (!useBones) return;
			  
	       GL.bindBuffer(GL.ARRAY_BUFFER, bonesBuffer);
           GL.bufferData(GL.ARRAY_BUFFER,  new Float32Array(v), GL.DYNAMIC_DRAW);
		   GL.bindBuffer(GL.ARRAY_BUFFER, null);
   }
   
  
	 public function uploadHeigs(v:Array<Float>):Void
    {
		if (!useBones) return;
		
		    GL.bindBuffer(GL.ARRAY_BUFFER, wighsBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  new Float32Array( v), GL.DYNAMIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }     
	   
	public function uploadVertex(v:Array<Float>):Void
    {
		    GL.bindBuffer(GL.ARRAY_BUFFER, coordBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  new Float32Array( v), GL.DYNAMIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }
	public function uploadNormals(v:Array<Float>):Void
    {
		   if (!useNormals) return;
		    GL.bindBuffer(GL.ARRAY_BUFFER, normBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  new Float32Array( v), GL.DYNAMIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }
	public function uploadColors(v:Array<Float>):Void
    {
		   if (!useColors) return;
		    GL.bindBuffer(GL.ARRAY_BUFFER, colBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  new Float32Array( v), GL.DYNAMIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }
	public function uploadUVCoord0(v:Array<Float>):Void
    {
		   if (!useTexture) return;
		    GL.bindBuffer(GL.ARRAY_BUFFER, tex0Buffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  new Float32Array( v), GL.DYNAMIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }
	public function uploadUVCoord1(v:Array<Float>):Void
    {
		
		   if (!useDetail) return;
		   
		    GL.bindBuffer(GL.ARRAY_BUFFER, tex1Buffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  new Float32Array( v), GL.DYNAMIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }	
			public function setUVCoord0(v:Float32Array):Void
    {
		   if (!useTexture) return;
		    GL.bindBuffer(GL.ARRAY_BUFFER, tex0Buffer);
	        GL.bufferData(GL.ARRAY_BUFFER, v , GL.DYNAMIC_DRAW);
	 }
			public function setColors(v:Float32Array):Void
    {
		   if (!useColors) return;
		    GL.bindBuffer(GL.ARRAY_BUFFER, colBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  v, GL.DYNAMIC_DRAW);
	 }
		public function setVertex(v:Float32Array):Void
    {
		    GL.bindBuffer(GL.ARRAY_BUFFER, coordBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  v, GL.DYNAMIC_DRAW);
	  }	 
		public function setNormals(v:Float32Array):Void
      {
		if (!useNormals) return;
		    GL.bindBuffer(GL.ARRAY_BUFFER, normBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER,  v, GL.DYNAMIC_DRAW);
	  }	 	
	public function render(primitiveType:Int,Num_Triangles:Int):Void
	{
		
		if (pipeline.vertexAttribute == -1) return;
	
		GL.bindBuffer(GL.ARRAY_BUFFER, coordBuffer);
		GL.vertexAttribPointer(pipeline.vertexAttribute, 3, GL.FLOAT, false, 0, 0); 
    	GL.enableVertexAttribArray (pipeline.vertexAttribute);
		
	
			if (pipeline.normalAttribute != -1)
			{
		     GL.bindBuffer(GL.ARRAY_BUFFER, normBuffer);
		     GL.vertexAttribPointer(pipeline.normalAttribute, 3, GL.FLOAT, false, 0, 0); 
	         GL.enableVertexAttribArray (pipeline.normalAttribute);
			}
	
		
		
		
			if (pipeline.texCoord0Attribute != -1)
			{
	         GL.bindBuffer(GL.ARRAY_BUFFER, tex0Buffer);
   	         GL.vertexAttribPointer(pipeline.texCoord0Attribute, 2, GL.FLOAT, false, 0, 0);  
		     GL.enableVertexAttribArray (pipeline.texCoord0Attribute);
			}
	     	
		
				if (pipeline.texCoord1Attribute != -1)
				{
	             GL.bindBuffer(GL.ARRAY_BUFFER, tex1Buffer);
   	             GL.vertexAttribPointer(pipeline.texCoord1Attribute, 2, GL.FLOAT, false, 0, 0); 
		         GL.enableVertexAttribArray (pipeline.texCoord1Attribute);
			
				}
	
			

  
		
			
	if (pipeline.colorAttribute != -1)
			{
	         GL.bindBuffer(GL.ARRAY_BUFFER, colBuffer);
   	         GL.vertexAttribPointer(pipeline.colorAttribute, 4, GL.FLOAT, false, 0, 0);  
	         GL.enableVertexAttribArray (pipeline.colorAttribute);
			}

		
		if (useBones)
		{
		
			if (pipeline.bonesAttribute >=0)
			{
		     GL.bindBuffer(GL.ARRAY_BUFFER, bonesBuffer);
   	         GL.vertexAttribPointer(pipeline.bonesAttribute, 4, GL.FLOAT, false, 0, 0);  
		     GL.enableVertexAttribArray (pipeline.bonesAttribute);
			}
			if ( pipeline.wighsAttribute>=0)
			{
		    
		     GL.bindBuffer(GL.ARRAY_BUFFER, wighsBuffer);
   	         GL.vertexAttribPointer(pipeline.wighsAttribute, 4, GL.FLOAT, false, 0, 0);  
		     GL.enableVertexAttribArray (pipeline.wighsAttribute);
			}
			
	    } 

		
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
        GL.drawElements(primitiveType, Num_Triangles, GL.UNSIGNED_SHORT, 0);
		
		
		
		   
			

	   	GL.disableVertexAttribArray (pipeline.vertexAttribute);
		
	
			if (pipeline.normalAttribute != -1)
			{
		        GL.disableVertexAttribArray (pipeline.normalAttribute);
			}
	
		
		
		
			if (pipeline.texCoord0Attribute != -1)
			{
	           GL.disableVertexAttribArray (pipeline.texCoord0Attribute);
			}
	     	
		
				if (pipeline.texCoord1Attribute != -1)
				{
	              GL.disableVertexAttribArray (pipeline.texCoord1Attribute);
			
				}
	
			

  
		
			
	if (pipeline.colorAttribute != -1)
			{
	          GL.disableVertexAttribArray (pipeline.colorAttribute);
			}

		
		if (useBones)
		{
		
			if (pipeline.bonesAttribute >=0)
			{
		     GL.disableVertexAttribArray (pipeline.bonesAttribute);
			}
			if ( pipeline.wighsAttribute>=0)
			{
		     GL.disableVertexAttribArray (pipeline.wighsAttribute);
			}
		
		}
	}
	
	public function renderTo(shader:Shader,primitiveType:Int,Num_Triangles:Int):Void
	{
		
		if (shader.vertexAttribute == -1) return;
	
		GL.bindBuffer(GL.ARRAY_BUFFER, coordBuffer);
		GL.vertexAttribPointer(shader.vertexAttribute, 3, GL.FLOAT, false, 0, 0); 
    	GL.enableVertexAttribArray (shader.vertexAttribute);
		
	
		if (shader.normalAttribute != -1)
		{
		     GL.bindBuffer(GL.ARRAY_BUFFER, normBuffer);
		     GL.vertexAttribPointer(shader.normalAttribute, 3, GL.FLOAT, false, 0, 0); 
	         GL.enableVertexAttribArray (shader.normalAttribute);
		}
		if (shader.texCoord0Attribute != -1)
		{
	       GL.bindBuffer(GL.ARRAY_BUFFER, tex0Buffer);
   	         GL.vertexAttribPointer(shader.texCoord0Attribute, 2, GL.FLOAT, false, 0, 0);  
		     GL.enableVertexAttribArray (shader.texCoord0Attribute);
		}
	     	
		if (shader.texCoord1Attribute != -1)
	 	{
	             GL.bindBuffer(GL.ARRAY_BUFFER, tex1Buffer);
   	             GL.vertexAttribPointer(shader.texCoord1Attribute, 2, GL.FLOAT, false, 0, 0); 
		         GL.enableVertexAttribArray (shader.texCoord1Attribute);
		}
	
				
	   if (shader.colorAttribute != -1)
			{
	         GL.bindBuffer(GL.ARRAY_BUFFER, colBuffer);
   	         GL.vertexAttribPointer(shader.colorAttribute, 4, GL.FLOAT, false, 0, 0);  
	         GL.enableVertexAttribArray (shader.colorAttribute);
			}

		
		if (useBones)
		{
		
			if (shader.bonesAttribute >=0)
			{
		     GL.bindBuffer(GL.ARRAY_BUFFER, bonesBuffer);
   	         GL.vertexAttribPointer(shader.bonesAttribute, 4, GL.FLOAT, false, 0, 0);  
		     GL.enableVertexAttribArray (shader.bonesAttribute);
			}
			if ( shader.wighsAttribute>=0)
			{
		    
		     GL.bindBuffer(GL.ARRAY_BUFFER, wighsBuffer);
   	         GL.vertexAttribPointer(shader.wighsAttribute, 4, GL.FLOAT, false, 0, 0);  
		     GL.enableVertexAttribArray (shader.wighsAttribute);
			}
			
	    } 

		
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
        GL.drawElements(primitiveType, Num_Triangles, GL.UNSIGNED_SHORT, 0);
		
		
		
		   
			

	   	GL.disableVertexAttribArray (shader.vertexAttribute);
		
	
			if (shader.normalAttribute != -1)
			{
		        GL.disableVertexAttribArray (shader.normalAttribute);
			}
	
		
		
		
			if (shader.texCoord0Attribute != -1)
			{
	           GL.disableVertexAttribArray (shader.texCoord0Attribute);
			}
	    	if (shader.texCoord1Attribute != -1)
			{
	              GL.disableVertexAttribArray (shader.texCoord1Attribute);
			
			}
	
		 if (shader.colorAttribute != -1)
			{
	          GL.disableVertexAttribArray (shader.colorAttribute);
			}

		if (useBones)
		{
		
			if (shader.bonesAttribute >=0)
			{
		     GL.disableVertexAttribArray (shader.bonesAttribute);
			}
			if ( shader.wighsAttribute>=0)
			{
		     GL.disableVertexAttribArray (shader.wighsAttribute);
			}
		
		}
	}
	override public function dispose()
	{
		super.dispose();
		GL.deleteBuffer(coordBuffer);
		GL.deleteBuffer(indexBuffer );
		
		
		if (useNormals)
		{
		GL.deleteBuffer(normBuffer );
	    }
		if (useTexture)
		{
		GL.deleteBuffer(tex0Buffer);
		}
	   if (useDetail)
		{
		GL.deleteBuffer(tex1Buffer);
		}
		if (useBones)
		{
		GL.deleteBuffer(bonesBuffer);
		GL.deleteBuffer(wighsBuffer);
		
	    }
		
		if (useColors)
		{
		GL.deleteBuffer(colBuffer);
		}
		
		
	}
}