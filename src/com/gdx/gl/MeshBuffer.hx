package com.gdx.gl;
import com.gdx.Buffer;
import com.gdx.color.Color4;
import com.gdx.gl.material.Material;
import com.gdx.gl.shaders.Shader;
import com.gdx.math.BoundingInfo;
import com.gdx.math.Matrix;
import com.gdx.math.Plane;
import com.gdx.math.Quaternion;
import com.gdx.math.Ray;
import com.gdx.math.Triangle;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import com.gdx.util.Util;
import lime.graphics.opengl.GL;


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
class MeshBuffer extends Buffer
{
		public var Bounding:BoundingInfo;
	   public var vertexbuffer:VertexBuffer;
	   public var packVertexBufer:PackVertexBuffer;
		public var materialIndex:Int;
 
		

		public var   bones:Array<Float>;
	    public var   wights:Array<Float>;
		
		
		public var shaderUse:Shader;
	   public var material:Material;
	
	public var   vert_coords:Array<Float>;
	public var   vert_norm:Array<Float>;
	public var   vert_tex_coords0:Array<Float>;
	public var   vert_tex_coords1:Array<Float>;
	public var   vert_col:Array<Float>;
	
	
	private var isOptimize:Bool;
	
		public var  no_verts:Int;
	    public var  no_tris:Int;
		public var  tris:Array<Int>;

		public var  reset_vbo:Int;
		public var  primitiveType:Int;
		
	public function new(shader:Shader) 
	{
		super();
		shaderUse = shader;
		 var min = new Vector3(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
         var max = new Vector3(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
		
		Bounding = new BoundingInfo(min,max);
	
		no_verts = 0;
		no_tris = 0;
		tris = new Array<Int>();
  
		materialIndex = 0;
		reset_vbo = -1;

		vertexbuffer = new VertexBuffer(shaderUse);
		

		material = new Material();
    
		isOptimize = false;
		
		bones = new Array<Float>();
	    wights = new Array<Float>();

		vert_coords = new Array<Float>();
		vert_norm = new Array<Float>();
		vert_tex_coords0 = new Array<Float>();
		vert_tex_coords1 = new Array<Float>();
		vert_col = new Array<Float>();
	
	
	
	  
		
		
		
		primitiveType = Gdx.GLTRIANGLES;
		
		
	}
	public function Optimize(clean:Bool=true):Void
	{
	
		if (no_verts <= 0) return;
		if(vertexbuffer!=null)vertexbuffer.dispose();
		vertexbuffer = null;
		isOptimize = true;
		packVertexBufer = new PackVertexBuffer(this.shaderUse);
		var data:Array <Float>=[];
		
	
			
		for (i in 0...this.no_verts)
		{
			data.push(this.VertexX(i));
			data.push(this.VertexY(i));
			data.push(this.VertexZ(i));
			
			if (shaderUse.normalAttribute != -1)
			{
			data.push(this.VertexNX(i));
			data.push(this.VertexNY(i));
			data.push(this.VertexNZ(i));
			}
			
			if (shaderUse.texCoord0Attribute != -1)
			{
			data.push(this.VertexU(i,0));
			data.push(this.VertexV(i,0));
			}
			
			if (shaderUse.texCoord1Attribute != -1)
			{
			  data.push(this.VertexU(i,1));
			  data.push(this.VertexV(i, 1));
			}
			
		
			if (shaderUse.colorAttribute != -1)
			{
			data.push(this.VertexColorIndex(i, 0));
			data.push(this.VertexColorIndex(i, 1));
			data.push(this.VertexColorIndex(i, 2));
			data.push(this.VertexColorIndex(i, 3));
			}
			
			
			if (shaderUse.bonesAttribute != -1)
			{
			data.push(this.bones[i * 4 + 0]);
			data.push(this.bones[i * 4 + 1]);
			data.push(this.bones[i * 4 + 2]);
			data.push(this.bones[i * 4 + 3]);
			data.push(this.wights[i * 4 + 0]);
			data.push(this.wights[i * 4 + 1]);
			data.push(this.wights[i * 4 + 2]);
			data.push(this.wights[i * 4 + 3]);
			
			
			}
			
		}
		
		
		
		packVertexBufer.uploadVertex(data);
        packVertexBufer.uploadIndices(this.tris);
		
		if (clean)
		{
			this.vert_col = null;
			this.vert_coords = null;
			this.vert_norm = null;
			this.vert_tex_coords0 = null;
			this.vert_tex_coords1 = null;
			this.bones = null;
			this.wights = null;
		}

		data = null;
		
	}
	public function setShader(s:Shader):Void
	{
		shaderUse = s;
		vertexbuffer.set(shaderUse);
		reset_vbo = -1;
	}
	
	public function AddFullVertexColorVector(Pos:Vector3,Nor:Vector3,uv0:Vector2,uv1:Vector2,color:Color4):Int
	{
	no_verts++;
	
	vert_coords.push(Pos.x);
	vert_coords.push(Pos.y);
	vert_coords.push(Pos.z); 
	
	vert_norm.push(Nor.x);
	vert_norm.push(Nor.y);
	vert_norm.push(Nor.z);
	

	
	vert_col.push(color.r);
	vert_col.push(color.g);
	vert_col.push(color.b);
	vert_col.push(color.a);
	
	vert_tex_coords0.push(uv0.x);
	vert_tex_coords0.push(uv0.y);
    vert_tex_coords1.push(uv1.x);
    vert_tex_coords1.push(uv1.y);
		
	return no_verts-1;

}
	public function AddVertex(x:Float, y:Float, z:Float, u:Float=0.0, v:Float=0.0):Int
	{
	no_verts++;
	vert_coords.push(x);
	vert_coords.push(y);
	vert_coords.push(z); 
	
	vert_norm.push(0.0);
	vert_norm.push(0.0);
	vert_norm.push(0.0);
	
	vert_col.push(1.0);
	vert_col.push(1.0);
	vert_col.push(1.0);
	vert_col.push(1.0);
	
	vert_tex_coords0.push(u);
	vert_tex_coords0.push(v);

	vert_tex_coords1.push(u);
	vert_tex_coords1.push(v);
		
	return no_verts-1;

}
public function AddVertexUv(x:Float, y:Float, z:Float,nx:Float,ny:Float,nz:Float, u:Float=0.0, v:Float=0.0,u2:Float=0.0, v2:Float=0.0):Int
	{
	no_verts++;
	
	vert_coords.push(x);
	vert_coords.push(y);
	vert_coords.push(z); 
	
	vert_norm.push(nx);
	vert_norm.push(ny);
	vert_norm.push(nz);
	
	vert_col.push(1.0);
	vert_col.push(1.0);
	vert_col.push(1.0);
	vert_col.push(1.0);
	
	vert_tex_coords0.push(u);
	vert_tex_coords0.push(v);
    vert_tex_coords1.push(u2);
    vert_tex_coords1.push(v2);
		
	return no_verts-1;

}
	public function AddFullVertex(x:Float, y:Float, z:Float,nx:Float,ny:Float,nz:Float, u:Float=0.0, v:Float=0.0,u2:Float=0.0, v2:Float=0.0):Int
	{
	
	no_verts++;
	
	vert_coords.push(x);
	vert_coords.push(y);
	vert_coords.push(z); 
	
	vert_norm.push(nx);
	vert_norm.push(ny);
	vert_norm.push(nz);
	

	
	vert_col.push(1.0);
	vert_col.push(1.0);
	vert_col.push(1.0);
	vert_col.push(1.0);
	
	vert_tex_coords0.push(u);
	vert_tex_coords0.push(v);
    vert_tex_coords1.push(u2);
    vert_tex_coords1.push(v2);
		
	return no_verts-1;

}
	public function AddFullVertexColor(x:Float, y:Float, z:Float,nx:Float,ny:Float,nz:Float, u:Float=0.0, v:Float=0.0,u2:Float=0.0, v2:Float=0.0,r:Float=1,g:Float=1,b:Float=1,a:Float=1):Int
	{
	no_verts++;
	
	vert_coords.push(x);
	vert_coords.push(y);
	vert_coords.push(z); 
	
	vert_norm.push(nx);
	vert_norm.push(ny);
	vert_norm.push(nz);
	

	
	vert_col.push(r);
	vert_col.push(g);
	vert_col.push(b);
	vert_col.push(a);
	
	vert_tex_coords0.push(u);
	vert_tex_coords0.push(v);
    vert_tex_coords1.push(u2);
    vert_tex_coords1.push(v2);
		
	return no_verts-1;

}

public function VertexX(vid:Int):Float
{
	return vert_coords[vid * 3];
}
public function VertexY(vid:Int):Float
{
	return vert_coords[(vid * 3) + 1];
}
public function VertexZ(vid:Int):Float
{
	return vert_coords[(vid * 3) + 2];
}

public function VertexRed(vid:Int):Int
{
	return Std.int( vert_col[vid * 4]*255);
}
public function VertexGreen(vid:Int):Int
{
		return Std.int(vert_col[(vid*4)+1]*255);
}
public function VertexBlue(vid:Int):Int
{
		return Std.int(vert_col[(vid*4)+2]*255);
}
public function VertexAlpha(vid:Int):Float
{
		return vert_col[(vid*4)+3];
}


public function VertexNX(vid:Int):Float
{
	return vert_norm[vid * 3];
}
public function VertexNY(vid:Int):Float
{
	return vert_norm[(vid * 3) + 1];
}
public function VertexNZ(vid:Int):Float
{
	return vert_norm[(vid * 3) + 2];
}

public function VertexU(vid:Int, coord_set:Int):Float
{

	if(coord_set==0){
		return vert_tex_coords0[vid*2];
	}else if(coord_set==1){
		return vert_tex_coords1[vid*2];
	}else{
		return vert_tex_coords1[vid*3];
	}

}

public function VertexV(vid:Int, coord_set:Int):Float
{

		if(coord_set==0){
		return vert_tex_coords0[(vid*2)+1];
	}else if(coord_set==1){
		return vert_tex_coords1[(vid*2)+1];
	}else{
		return vert_tex_coords1[(vid*3)+1];
	}

}
public function VertexColorIndex(vid:Int,index:Int):Float
{
		return vert_col[(vid*4)+index];
}

public function TriangleX(tri_no:Int,index:Int):Float
{
	 var v:Int=TriangleVertex(tri_no, index);
	 return VertexX(v);
}
public function TriangleY(tri_no:Int,index:Int):Float
{
	 var v:Int=TriangleVertex(tri_no, index);
	 return VertexY(v);
}
public function TriangleZ(tri_no:Int,index:Int):Float
{
	 var v:Int=TriangleVertex(tri_no, index);
	 return VertexZ(v);
}

public function TriangleVertex( tri_no:Int, corner:Int):Int
{

	var vid:Array<Int>=[];

	tri_no=(tri_no+1)*3;
	vid[0]=tris[tri_no-1];
	vid[1]=tris[tri_no-2];
	vid[2]=tris[tri_no-3];

	return vid[corner];

}


	
public function VertexCoords(vid:Int , x:Float, y:Float, z:Float):Void
{
	vid=vid*3;
	vert_coords[vid]=x;
	vert_coords[vid+1]=y;
	vert_coords[vid+2]=z; 
	reset_vbo=reset_vbo|1;
	
}
	

	public function VertexNormal(vid:Int , nx:Float, ny:Float, nz:Float):Void
	{
    vid=vid*3;
	vert_norm[vid]=nx;
	vert_norm[vid+1]=ny;
	vert_norm[vid+2]=nz; 
	reset_vbo=reset_vbo|4;
    }

public function VertexColor( vid:Int, r:Int , g:Int, b:Int, a:Float):Void
{

	vid=vid*4;
	vert_col[vid]=r/255.0;
	vert_col[vid+1]=g/255.0;
	vert_col[vid+2]=b/255.0;
	vert_col[vid+3]=a;
	reset_vbo=reset_vbo|8;

}

public function setTexCoords(data:Array < Float>,layer:Int=0)
{
	for (i in 0... data.length )
	{
		if (layer == 0)
		{
	    this.vert_tex_coords0.push( data[i]);
		} else
		if (layer == 1)
		{
	    this.vert_tex_coords1.push(data[i]);			
		} 
		else
		if (layer == 2)
		{
			    this.vert_tex_coords0.push(data[i]);
	            this.vert_tex_coords1.push(data[i]);			
		}
	 
	}
	reset_vbo=reset_vbo|2;
}

public function addFace(v0:Vector3, v1:Vector3, v2:Vector3, uv0:Vector2, uv1:Vector2, uv2:Vector2):Int
{
	var result:Int = 0;
	
	
	var v0 =this.AddVertex(v0.x, v0.y, v0.z, uv0.x, uv0.y);
	var v1 =this.AddVertex(v1.x, v1.y, v1.z, uv1.x, uv1.y);
	var v2 =this.AddVertex(v2.x, v2.y, v2.z, uv2.x, uv2.y);

	result += v0;
	result += v1;
	result += v2;
	
	AddTriangle(v0, v1, v2);
	
	return result;
	
}

public function VertexTexCoords( vi:Int, u:Float, v:Float,w:Float=0, coords_set:Int=0):Void
{
	
	vi=vi*2;
	
	if(coords_set==0){
	
		vert_tex_coords0[vi]=u;
		vert_tex_coords0[vi+1]=v;
	
	}else{
		
		vert_tex_coords1[vi]=u;
		vert_tex_coords1[vi + 1] = v;
		
	
	}
	
	reset_vbo=reset_vbo|2;
	
}

public function AddTriangle(v0:Int, v1:Int, v2:Int):Int
	{
	
	no_tris++;
	
	tris.push(v2);
	tris.push(v1);
	tris.push(v0);
	
	reset_vbo=reset_vbo|16;
	return no_tris;
    }
	
	public  function getIndex(numface:Int):Int
   {
   
	return tris[numface];
   }
     public  function getIndice(numface:Int,index:Int):Int
   {
	   
	return tris[numface * 3 + index];
   }
    public  function getFace(numface:Int,index:Int):Vector3
   {
	return getVertex(tris[numface * 3 + index]);
   }
   
    public  function getFaceNormal(numface:Int,index:Int):Vector3
   {

	   
	return getNormal(tris[numface * 3 + index]);
   }
    
    public  function setFaceNormal(numface:Int,index:Int,v:Vector3):Void
   {
   setNormal(tris[numface * 3 + index],v);
   }
   
   public  function getFaceUv0(numface:Int,index:Int):Vector2
   {   
	return getUv0(tris[numface * 3 + index]);
   }
   public  function setFaceUv0(numface:Int,index:Int,v:Vector2):Void
   {
   setUv0(tris[numface * 3 + index],v);
   }
   public  function setFaceUv1(numface:Int,index:Int,v:Vector2):Void
   {
   setUv1(tris[numface * 3 + index],v);
   }
   public function getVertex(index:Int):Vector3
   {
	   return new Vector3(vert_coords[index*3+0], vert_coords[index *3+1], vert_coords[index *3+2]);
    }
	 public function getUv0(index:Int):Vector2
   {
	   return new Vector2(vert_tex_coords0[(index*2)+0], vert_tex_coords0[(index *2)+1]);
    }
	 public function getUv1(index:Int):Vector2
   {
	   return new Vector2(vert_tex_coords1[(index*2)+0], vert_tex_coords1[(index *2)+1]);
    }
 	 public function setUv0(index:Int,v:Vector2):Void
   {
	   vert_tex_coords0[(index * 2) + 0] = v.x;
	   vert_tex_coords0[(index * 2) + 1] = v.y;
    }	
 public function setUv1(index:Int,v:Vector2):Void
   {
	   vert_tex_coords1[(index * 2) + 0] = v.x;
	   vert_tex_coords1[(index * 2) + 1] = v.y;
    }	
 public function getNormal(index:Int):Vector3
   {
	   return new Vector3(vert_norm[index * 3 + 0], vert_norm[index * 3 + 1], vert_norm[index * 3 + 2]);
   }  
   public function setNormal(index:Int,v:Vector3):Void
   {
	   vert_norm[index * 3 + 0] = v.x;
	   vert_norm[index * 3 + 1] = v.y;
	   vert_norm[index * 3 + 2] = v.z;
	   
	   reset_vbo=reset_vbo|4;
   }  

  
	public function setVertex(index:Int,v:Vector3):Void
   {
	   vert_coords[index * 3 + 0] = v.x;
	   vert_coords[index * 3 + 1] = v.y;
	   vert_coords[index * 3 + 2] = v.z;
	   	reset_vbo=reset_vbo|1;
   }  
   
    public  function CountFaces():Int
   {
	   return Std.int(tris.length/3);
   }
    public  function CountTriangles():Int
   {
	   return no_tris;
   } 
    public  function CountVertices():Int
   {
	   return no_verts;
   }
   
	public function UpdateVBO():Void
	{
	 
	 if(reset_vbo==-1) reset_vbo=1|2|4|8|16|24|30;

		

	
        if (reset_vbo&1==1)
		{		
			vertexbuffer.uploadVertex(vert_coords);
		}
		
	
	
	
		if (reset_vbo&2==2)
		{
		
			if (vert_tex_coords0.length > 0) vertexbuffer.uploadUVCoord0(vert_tex_coords0);
			if (vert_tex_coords1.length > 0) vertexbuffer.uploadUVCoord1(vert_tex_coords1);
			
			
	      
	
		
		}
		
	
		if (reset_vbo&4==4)
		{
		vertexbuffer.uploadNormals(vert_norm);
	 	}
	
        if (reset_vbo&8==8)
		{
	     vertexbuffer.uploadColors(vert_col);
		}
	

	   
	
			
        if (reset_vbo&16==16)
		{		
	       vertexbuffer.uploadIndices(tris );
		}
		
		if (reset_vbo&24==24)
		{
			if (bones != null)
			{
			if ( bones.length > 1 && wights.length>1)
			{
			 vertexbuffer.uploadBones(bones);
			 vertexbuffer.uploadHeigs(wights);
			}
			}
		}
		
		
		
		reset_vbo = 0;
	
		
	}
	
public function setNormals(data:Array < Float>)
{
	for (i in 0... data.length )
	{
	 this.vert_norm.push(data[i]);
	}
}
public function setIndices(data:Array < Int>)
{
	for (i in 0 ... data.length)
	{
	 this.tris.push(data[i]);
	}
	no_tris = Std.int(data.length / 3);
	reset_vbo=reset_vbo|1|2|16;
}	
public function setVerticesData(data:Array < Float>)
{
	for (i in 0... data.length )
	{
	 vert_coords.push(data[i]);
	 vert_col.push(1.0);
	 vert_col.push(1.0);
	 vert_col.push(1.0);
	 vert_col.push(1.0);
	}
		 no_verts= Std.int(data.length / 3);
		reset_vbo = reset_vbo | 1;
		reset_vbo = reset_vbo | 8;
		
}

	
	
	



	
	public function renderTo(newShader:Shader,useMaterial:Bool):Void
	{
		
		if (newShader == null) return;
		
        if (useMaterial)
	    {
	    newShader.ApplayMaterial(material);
	    }	
	
		if (isOptimize)
		{
		packVertexBufer.renderTo(newShader,primitiveType, no_tris * 3);
    	} else
		{
		UpdateVBO();
	    vertexbuffer.renderTo(newShader,primitiveType, no_tris * 3);
		}
		
		Gdx.Instance().numTris += no_tris;
		Gdx.Instance().numVertex += no_verts;
		Gdx.Instance().numSurfaces += 1;
		
		
	}
	
	public function render():Void
	{
		
		
    	shaderUse.ApplayMaterial(material);
		
		if (isOptimize)
		{
			 packVertexBufer.render(primitiveType, no_tris * 3);
			 
    	} else
		{
		UpdateVBO();
  	    vertexbuffer.render(primitiveType, no_tris * 3);
		}
		
		Gdx.Instance().numTris += no_tris;
		Gdx.Instance().numVertex += no_verts;
		Gdx.Instance().numSurfaces += 1;
		
		
	}
	public function UpdateBoundingBox(m:Matrix):Void
	{
		Bounding.update(m);
	}
	public function CreateBoundingBox(m:Matrix):Void
	{
		 function checkExtends(v:Vector3, min:Vector3, max:Vector3) {
            if (v.x < min.x)
                min.x = v.x;
            if (v.y < min.y)
                min.y = v.y;
            if (v.z < min.z)
                min.z = v.z;

            if (v.x > max.x)
                max.x = v.x;
            if (v.y > max.y)
                max.y = v.y;
            if (v.z > max.z)
                max.z = v.z;
        }

        var min = new Vector3(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
        var max = new Vector3(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);

         for (index in 0...CountTriangles()) 
		 {
			 for (i in 0...3)
			 {
              var v:Vector3 = this.getFace(index, i);
              checkExtends(v, min, max);
			 }
         
			
        }
		
		Bounding = new BoundingInfo(min, max);
		//Bounding.reset(min,max);
		Bounding.update(m);
		
	}

public function recreateBoundingBox():Void
{

		
		Bounding.reset(getVertex(0));
		
         for (index in 1... this.CountVertices()) 
		 {
			 Bounding.addInternalVector(getVertex(index));
          }
		
		
	Bounding.calculate();		
}

	public function setBone(index:Int, layer:Int, boneId:Int, force:Float):Void
	{
		bones [index * 4 + layer] = boneId;
		wights[index * 4 + layer] = force;
	}
	public function getBone(index:Int, layer:Int):Int
	{
		return Std.int( bones [index * 4 + layer]);
	}
	
   

	public function scaleTexCoords(  factorX:Float, factorY:Float, coords_set:Int):Void
{
	for (v in 0...no_verts)
	{
		var vx, vy:Float = 0;
		
		if (coords_set == 0)
		{
	     vert_tex_coords0[v * 2] *= factorX;
		 vert_tex_coords0[(v * 2) + 1] *= factorY; 
		} else
		if (coords_set == 1)
		{
	 	 vert_tex_coords1[v * 2] *= factorX;
		 vert_tex_coords1[(v * 2) + 1] *= factorY; 
		}else
		{
		 vert_tex_coords0[v * 2] *= factorX;
		 vert_tex_coords0[(v * 2) + 1] *= factorY; 
		 vert_tex_coords1[v * 2] *= factorX;
		 vert_tex_coords1[(v * 2) + 1] *= factorY; 
			
		}
		
		reset_vbo=reset_vbo|2;
	
	}
}

  public  function getTriangles():Array<Triangle> 
   {
		var result:Array<Triangle> = [];
	    for (index in 0...Std.int(tris.length / 3)) 
		{
            var i1 = tris[index * 3];
            var i2 = tris[index * 3 + 1];
            var i3 = tris[index * 3 + 2];

			
            var p1 = getVertex(i1);
            var p2 = getVertex(i2);
            var p3 = getVertex(i3);
	        result.push(new Triangle(p3, p2, p1,getNormal(i1)));
       }
        return result;
      
	}	

	override public function dispose()
	{
		super.dispose();
		

		Bounding = null;
		tris = null;
  
		vertexbuffer.dispose();
		

		material.dispose();
		material = null;
    

		vert_coords = null;
		vert_norm = null;
		vert_tex_coords0 = null;
		vert_tex_coords1 = null;

		vert_col = null;
	}

  public function transform( m:Matrix):Void
  {
	for (v in 0... this.CountVertices() )
	{
	var vx:Float =  vert_coords[v * 3];
	var vy:Float =  vert_coords[v * 3 + 1];
	var vz:Float =  vert_coords[v * 3 + 2];
	
	vert_coords[v * 3+0] = m.m11 * vx + m.m21 * vy + m.m31 * vz + m.m41;
	vert_coords[v * 3+1] = m.m12 * vx + m.m22 * vy + m.m32 * vz + m.m42;
	vert_coords[v * 3+2] = m.m13 * vx + m.m23 * vy + m.m33 * vz + m.m43;
	
	
	var nx:Float =  vert_norm[v * 3];
	var ny:Float =  vert_norm[v * 3 + 1];
	var nz:Float =  vert_norm[v * 3 + 2];
	
	vert_norm[v * 3+0] = m.m11 * nx + m.m21 * ny + m.m31 * nz + m.m41;
	vert_norm[v * 3+1] = m.m12 * nx + m.m22 * ny + m.m32 * nz + m.m42;
	vert_norm[v * 3+2] = m.m13 * nx + m.m23 * ny + m.m33 * nz + m.m43;
	
	
   }
	CreateBoundingBox(Matrix.Identity());
	reset_vbo = reset_vbo | 1 | 4;
}
 public function translate( x:Float,y:Float,z:Float):Void
   {
	   var m:Matrix = Matrix.Translation(x, y, z);
	   for (i in 0...no_verts)
	   {
		   var v:Vector3 = getVertex(i);
		   v = m.transformVector(v);
		   var n:Vector3 = getNormal(i);
		   n = m.rotateVect(n);
		   setNormal(i, n);
		   setVertex(i, v);
	   }
	   CreateBoundingBox(Matrix.Identity());
	  	reset_vbo = reset_vbo | 1 | 4;

   }
   public function scale( x:Float,y:Float,z:Float):Void
   {
	   var m:Matrix = Matrix.Scaling(x, y, z);
	   transform(m);

   }
   public function rotate( y:Float,p:Float,r:Float):Void
   {
	   
	   var q:Quaternion = Quaternion.RotationYawPitchRoll(Util.deg2rad(y),Util.deg2rad(p),Util.deg2rad(r));
	   var m:Matrix = Matrix.Identity();
	   q.toRotationMatrix(m);
	   transform(m);
   } 
   
   

	public  function getPlanes():Array<Plane> 
   {
	 var planes:Array<Plane>=[] ;

        for (index in 0...Std.int(tris.length / 3))
   {
            var i1 = tris[index * 3];
            var i2 = tris[index * 3 + 1];
            var i3 = tris[index * 3 + 2];
            var p1 = getVertex(i1);
            var p2 = getVertex(i2);
            var p3 = getVertex(i3);
			var plane:Plane = Plane.FromPoints(p3, p2, p1);
           planes.push(plane);
        }
        return planes;
      
	}	
   public  function ComputeNormal() 
   {
		var positionVectors:Array<Vector3> = [];
        var facesOfVertices:Array<Array<Int>> = [];
		
        var index:Int = 0;

		while (index < vert_coords.length) 
		{
            var vector3 = new Vector3(vert_coords[index], vert_coords[index + 1], vert_coords[index + 2]);
            positionVectors.push(vector3);
            facesOfVertices.push([]);
			index += 3;
        }
		
        // Compute normals
        var facesNormals:Array<Vector3> = [];
        for (index in 0...Std.int(tris.length / 3)) {
            var i1 = tris[index * 3];
            var i2 = tris[index * 3 + 1];
            var i3 = tris[index * 3 + 2];

            var p1 = positionVectors[i1];
            var p2 = positionVectors[i2];
            var p3 = positionVectors[i3];

            var p1p2 = p1.subtract(p2);
            var p3p2 = p3.subtract(p2);

            facesNormals[index] = Vector3.Normalize(Vector3.Cross(p1p2, p3p2));
            facesOfVertices[i1].push(index);
            facesOfVertices[i2].push(index);
            facesOfVertices[i3].push(index);
        }

        for (index in 0...positionVectors.length) 
		{
            var faces:Array<Int> = facesOfVertices[index];

            var normal:Vector3 = Vector3.Zero();
            for (faceIndex in 0...faces.length) 
			{
                normal.addInPlace(facesNormals[faces[faceIndex]]);
            }

            normal = Vector3.Normalize(normal.scale(1.0 / faces.length));

            vert_norm[index * 3] = normal.x;
            vert_norm[index * 3 + 1] = normal.y;
            vert_norm[index * 3 + 2] = normal.z;
        }
		reset_vbo=reset_vbo|4;
	}
	
	public  function ComputeTangents() 
   {
	
  
	/*

	    for (index in 0... CountFaces()) 
		 {
            var vt0 = getFace(index, 0);
			var vt1 = getFace(index, 1);
			var vt2 = getFace(index, 2);
			
			var tc0 = getFaceUv0(index, 0);
			var tc1 = getFaceUv0(index, 1);
			var tc2 = getFaceUv0(index, 2);
			
			var normal:Vector3 = Vector3.Zero();
			var tangent:Vector3 = Vector3.Zero();
			var binormal:Vector3 = Vector3.Zero();
			
            
			Util.calculateTangents(normal, tangent, binormal,
			vt0, vt1, vt2,
			tc0, tc1, tc2);
			setFaceBiTangent(index, 0, tangent, binormal);
			
			
			Util.calculateTangents(normal, tangent, binormal,
			vt1, vt2, vt0,
			tc1, tc2, tc0);
			setFaceBiTangent(index, 1, tangent, binormal);
			
			
		    Util.calculateTangents(normal, tangent, binormal,
			vt2, vt0, vt1,
			tc2, tc0, tc1);
				
			setFaceBiTangent(index, 2, tangent, binormal);
		
          }
		  
		

		  
		  UpdateVBO();
		  */
   }
	public  function ComputeNormalSmoth(smoth:Bool,angleWeighted:Bool) 
   {
	   if (!smoth)
	   {
         for (index in 0... CountFaces()) 
		 {
            var p0 = getFace(index, 2);
			var p1 = getFace(index, 1);
			var p2 = getFace(index, 0);
            var p:Plane = Plane.FromPoints(p0, p1, p2);
			setFaceNormal(index,0, p.normal);
			setFaceNormal(index,1, p.normal);
			setFaceNormal(index,2, p.normal);
          }
		  
	   } else
	   {
		    for (index in 0...CountFaces()) 
		    {
            setFaceNormal(index, 0, Vector3.zero);
			setFaceNormal(index, 1, Vector3.zero);
			setFaceNormal(index, 2, Vector3.zero);
		   }
	
		for (index in 0...CountFaces()) 
		{
        		
			var p0 = getFace(index, 2);
			var p1 = getFace(index, 1);
			var p2 = getFace(index, 0);
			
            var p:Plane = Plane.FromPoints(p0, p1, p2);
			var normal:Vector3 = p.normal;
			
			var w:Vector3 = new Vector3(1, 1, 1);
			
			if (angleWeighted)
			{
			 w = Util.getAngleWeight(p0, p1, p2);
			}
			
			var n0:Vector3 = getFaceNormal(index, 0);
			n0.x += w.x * normal.x;
			n0.y += w.y * normal.y;
			n0.z += w.x * normal.z;
			setFaceNormal(index, 0, n0);
			
			var n1:Vector3 = getFaceNormal(index, 1);
			n1.x += w.x * normal.x;
			n1.y += w.y * normal.y;
			n1.z += w.z * normal.z;
			setFaceNormal(index, 1, n1);
			
			
			var n2:Vector3 = getFaceNormal(index, 2);
			n2.x += w.x * normal.x;
			n2.y += w.y * normal.y;
			n2.z += w.z * normal.z;
			setFaceNormal(index, 2, n2);
			
			
			
			}
			
          }
	   
	   
		
		reset_vbo=reset_vbo|4;
	}
	
	public function makePlanarMapping(resolution:Float):Void
	{
	  var Pos:Vector3 = Vector3.zero;
        for (index in 0...Std.int(tris.length / 3)) 
		{
 
		
			var p0 = getFace(index,2);
			var p1 = getFace(index,1);
			var p2 = getFace(index,0);
			var p:Plane = Plane.FromPoints(p0, p1, p2);
		 	p.normal.normalize();
			
		
		p.normal.x = Math.abs(p.normal.x);
		p.normal.y = Math.abs(p.normal.y);
		p.normal.z = Math.abs(p.normal.z);
	
		//front  / sides
		if(p.normal.x > p.normal.y && p.normal.x > p.normal.z)
		{
			
			for (i in 0 ... 3)
			{
				Pos = getFace(index,i);
				setFaceUv0(index, i, new Vector2(Pos.y * resolution, Pos.z * resolution));
				setFaceUv1(index,i,new Vector2(Pos.y * resolution, Pos.z * resolution));
			}
		 
		 
			
		}
		else if(p.normal.y > p.normal.x && p.normal.y > p.normal.z)
		{
		
		for (i in 0 ... 3)
			{
				Pos = getFace(index,i);
				setFaceUv0(index, i, new Vector2(Pos.x * resolution, Pos.z * resolution));
				setFaceUv1(index,i,new Vector2(Pos.x * resolution, Pos.z * resolution));
			}
		
		}else
		{
	
		for (i in 0 ... 3)
			{
				Pos = getFace(index,i);
				setFaceUv0(index, i, new Vector2(Pos.x * resolution, Pos.y * resolution));
				setFaceUv1(index,i,new Vector2(Pos.x * resolution, Pos.y * resolution));
			}
		 
		}
		
	
		
			
		}
			reset_vbo=reset_vbo|2;	
	}

	
	public function removeDuplicates():Void
	{
	
	  var count:Int = Std.int(vert_coords.length / 3);
		
	 var x:Int = 0;
	 for (i in 0... count - 1)
	 {
        for (j in i + 1 ... count)
		{
			x = i + 1;
            if (
			    vert_coords[i * 3 + 0] == vert_coords[x * 3 + 0] && 
			    vert_coords[i * 3 + 1] == vert_coords[x * 3 + 1] && 
				vert_coords[i * 3 + 2] == vert_coords[x * 3 + 2])
				
			{
				
	           vert_coords.splice(x * 3 + 0, 1);
			   vert_coords.splice(x * 3 + 1, 1);
			   vert_coords.splice(x * 3 + 2, 1);
			   
			   vert_norm.splice(x * 3 + 0, 1);
			   vert_norm.splice(x * 3 + 1, 1);
			   vert_norm.splice(x * 3 + 2, 1);
			   
			   vert_tex_coords0.splice(x * 2 + 0, 1);
			   vert_tex_coords0.splice(x * 2 + 1, 1);
			   vert_tex_coords1.splice(x * 2 + 0, 1);
			   vert_tex_coords1.splice(x * 2 + 1, 1);
			   
			   
			   vert_col.splice(x * 4 + 0, 1);
			   vert_col.splice(x * 4 + 1, 1);
			   vert_col.splice(x * 4 + 2, 1);
			   vert_col.splice(x * 4 + 3, 1);
			   
			   
			 //  x--;
			   
            }
        }
      }
	  
	  no_verts = Std.int(vert_coords.length / 3);
	  
	  reset_vbo=1|2|4|8|16;
	  
	  UpdateVBO();
	}

	public function getHeight(x:Float, z:Float):Float
	{
					   var ray0:Ray = new Ray(new Vector3(x  , 0, z ),new Vector3(0,1,0));
					   return  intersects(ray0, true);
		
		
	}
	public function rayBoundHit(ray:Ray):Bool
	{
		return ray.intersectsBox(this.Bounding.boundingBox);
	}
	public function intersects(ray:Ray,fastCheck:Bool = false):Float
	{
	
		
         var distance = Math.POSITIVE_INFINITY;

		 
		  for (index in 0...Std.int(tris.length / 3)) 
		{
 
		
			var p0 = getFace(index,0);
			var p1 = getFace(index,1);
			var p2 = getFace(index,2);
    		 var currentDistance = ray.intersectsTriangle(p0, p1, p2);
			

            if (currentDistance > 0) 
			{
				
				
                if (fastCheck || currentDistance < distance) 
				{
                    distance = currentDistance;
			
					
					
                    if (fastCheck) 
					{
                        break;
                    }
                }
            }
			
			
        }

        if (!(distance > 0 && distance < Math.POSITIVE_INFINITY)) {
            distance = 0;
		}
		 return distance;
		 

	}
		public function intersectsEx(ray:Ray,pContactPoint:Vector3,fastCheck:Bool = false):Float
	{
		
		
         var distance = Math.POSITIVE_INFINITY;

		 
		  for (index in 0...Std.int(tris.length / 3)) 
		{
 
		
			var p0 = getFace(index,0);
			var p1 = getFace(index,1);
			var p2 = getFace(index,2);
    		 var currentDistance = ray.intersectsTriangle(p0, p1, p2);
			

            if (currentDistance > 0) 
			{
				
				
                if (fastCheck || currentDistance < distance) 
				{
                    distance = currentDistance;
			
					pContactPoint.x = ray.origin.x + (ray.direction.x * distance);
					pContactPoint.y = ray.origin.y + (ray.direction.y * distance);
					pContactPoint.z = ray.origin.z + (ray.direction.z * distance);
					
                    if (fastCheck) 
					{
                        break;
                    }
                }
            }
			
			
        }

        if (!(distance > 0 && distance < Math.POSITIVE_INFINITY)) {
            distance = 0;
		}
		 return distance;
		 

	}
}