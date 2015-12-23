package com.gdx.scene3d;

import com.gdx.Gdx;
import com.gdx.gl.material.Material;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.Texture;
import com.gdx.gl.VertexBone;
import com.gdx.math.Matrix;
import com.gdx.math.Quaternion;
import com.gdx.math.Vector3;
import com.gdx.math.Vector2;
import com.gdx.scene3d.Node;
import com.gdx.util.Util;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.PixelFormat;
import lime.utils.UInt8Array;

import lime.Assets;
import com.gdx.util.ByteArray;

import haxe.io.Path;

using com.gdx.util.Gdxtypes;
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
typedef Entity = {
  var classname:String;
  var origin:String;
  var spawnflags:String;
  var angle:String;
}

class MeshBSP extends Mesh
{
	private static var   kEntities    = 0;            // Stores player/object positions, etc...
    private static var   kTextures    = 1;            // Stores texture information
    private static var   kPlanes      = 2;            // Stores the splitting planes
    private static var    kNodes       = 3;            // Stores the BSP nodes
    private static var kLeafs       = 4;            // Stores the leafs of the nodes
    private static var kLeafFaces   = 5;            // Stores the leaf's indices into the faces
    private static var kLeafBrushes = 6;            // Stores the leaf's indices into the brushes
    private static var kModels      = 7;            // Stores the info of world models
    private static var kBrushes     = 8;            // Stores the brushes info (for collision)
    private static var kBrushSides  = 9;            // Stores the brush surfaces info
    private static var kVertices    = 10;           // Stores the level vertices
    private static var  kIndices   = 11;           // Stores the model vertices offsets
    private static var kShaders     = 12;           // Stores the shader files (blending, anims..)
   private static var  kFaces       = 13;           // Stores the faces for the level
   private static var  kLightmaps   = 14;           // Stores the lightmaps for the level
   private static var  kLightVolumes= 15;           // Stores extra world lighting information
   private static var  kVisData     = 16;           // Stores PVS and cluster info (visibility)
   private static var  kMaxLumps    = 17;           // A constant to store the number of lumps

   
	private var    strID:String;				// This should always be 'IBSP'
    private var    version:Int;				// This should be 0x2e for Quake 3 files
	
	private var m_numOfVerts:Int;			// The number of verts in the model
	private var m_numOfFaces:Int;			// The number of faces in the model
	private var m_numOfIndices:Int;			// The number of indices for the model
	private var m_numOfTextures:Int;		// The number of texture maps
	private var m_numOfLightmaps:Int;		// The number of light maps
	private var m_numOfNodes:Int;			// The number of nodes in the BSP
	private var m_numOfLeafs:Int;			// The number of leafs
	private var m_numOfLeafFaces:Int;		// The number of faces
	private var m_numOfPlanes:Int;			// The number of planes in the BSP
	private var m_numOfBrushes:Int;			// The number of brushes in our world
	private var m_numOfBrushSides:Int;		// The number of brush sides in our world
	private var m_numOfLeafBrushes:Int;		// The number of leaf brushes

	private var lumps:Array<BSPLump> ;
	private var Vertex:Array<BSPVertex> ;
	private var Faces:Array<BSPFace>;
	private var Indices:Array<Int>;
	private var textures:Array<Texture>;
	private var lightmaps:Array<Texture>;
	private var path:String;
	private var lmgamma:Float;
	private var entitys:List<BspEntity>;
	var count:Int = 0;

	public function new() 
	{
		super();
		entitys = new List<BspEntity>();
	  Vertex = [];
	  lumps = [];
	  Faces = [];
	  Indices = [];
	  textures = [];
	  lightmaps = [];
	}
	public function  loadMap(filename:String,path:String,gamma:Float=5.0,optimize:Bool=true,parseEntitys:Bool=false):Void
	{
		lmgamma =  gamma;
		this.path = path;
		var file:ByteArray =	Util.getBytes(filename);
	
	    	file.endian = "littleEndian";
        if (file.bytesAvailable <= 0) return;
	    file.position = 0;
		
	
		
		
		 strID=file.readUTFBytes(4);
		 version = file.readInt();
		 trace("version:" + version);
		 
		 for (i in 0 ... kMaxLumps)
		 {
			 var lump:BSPLump = { offset:0, length:0 };
			 lump.offset=file.readInt();
			 lump.length = file.readInt();
				 lumps.push(lump);
		 }
		 
		 m_numOfVerts = Std.int(lumps[kVertices].length / (11*4) );
	//	 trace("Number of vertices:"+ m_numOfVerts);
		    
		  m_numOfFaces = Std.int(lumps[kFaces].length / (26*4));
		// trace("Number of faces:" + m_numOfFaces);
		 
		  m_numOfTextures = Std.int(lumps[kTextures].length / (64+2*4));
		// trace("Number of textures:" + m_numOfTextures);
		 
		  m_numOfLightmaps = Std.int(lumps[kLightmaps].length / (128*128*3));
		// trace("Number of Lightmaps:" + m_numOfLightmaps);
			 
		 
	
		  m_numOfIndices = Std.int(lumps[kIndices].length / 4);
	//	 trace("Number of Indices:" + m_numOfIndices);
		 
		 loadtexture(file);
		 loadLightmap(file);
		 loadVertex(file);
		 loadFaces(file);
		 loadIndex(file);
		 if (optimize)
		 {
		  buildBatchMesh();	 
		 }else
		 {
			buildMesh(); 
		 }
		// buildMesh();
		if (parseEntitys)
		{
		LoadEntities(file);
		}
		
		
	}
	public function buildModels():Void
	{
		for (i in 0 ... this.m_numOfFaces)
		{
			var face:BSPFace = Faces[i];
			
			//					// 1=polygon, 2=patch, 3=mesh, 4=billboard 
			
			
			
			if ( face.type==3)
			{
					var surf:MeshBuffer = createSurface();
						surf.material.setMaterialType(Gdx.MaterialSolid);
					
				//	trace(face.startVertIndex + " , " + (face.startVertIndex+face.numOfVerts));
					
					for ( v in face.startVertIndex ... (face.startVertIndex+face.numOfVerts))
					{
						var pos:Vector3 = Vertex[v].vPosition;
						var normal:Vector3 = Vertex[v].vNormal;
						var uv:Vector2 = Vertex[v].vTextureCoord;
						var uv2:Vector2 = Vertex[v].vLightmapCoord;
						var r:Float = Vertex[v].r / 255.0;
						var g:Float = Vertex[v].g / 255.0;
						var b:Float = Vertex[v].b / 255.0;
						var a:Float = Vertex[v].a / 255.0;
						
						
				
					
						
					surf.AddFullVertexColor(pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, uv.x, uv.y, uv2.x, uv2.y, r, g, b, a);
	
			  
					}
					//surf.Bounding.calculate();
		
			  
					//	trace(face.startIndex + " , " + Std.int((face.startIndex + face.numOfIndices)/3));
				
                    var index:Int = face.startIndex;					
					for (x in 0 ...  Std.int(face.numOfIndices/3))
					{
						
						var v0:Int = this.Indices[index];index++;
						var v1:Int = this.Indices[index];index++;
						var v2:Int = this.Indices[index];index++;
						
				
						surf.AddTriangle(v0, v1, v2);
					}
				
				
					
		
					if (textures.length >= 1)
					{
				   if (face.textureID <= textures.length)
					{
						if (textures[face.textureID] != null)	
						{
						  surf.material.BlendFace = true;
						 surf.material.setTexture(	textures[face.textureID], 0);
						}
					}
					}
					
					if (lightmaps.length >= 1)
					{
					if (face.lightmapID <= lightmaps.length)
					{
						if (lightmaps[face.lightmapID] != null)	  
						{
							surf.material.BlendFace = false;
						    surf.material.setTexture(	lightmaps[face.lightmapID], 1);
							surf.material.setMaterialType(Gdx.MaterialSolid2Layer);
						}
					}
					}
				
					
					
						
					surf.materialIndex = face.textureID;
			
				
				 surf.CreateBoundingBox(Matrix.Identity());
                 surf.UpdateVBO();
			}
		}
		
	
		
		sortMaterial();
	}
	public function buildMesh():Void
	{
		
	

      
		
	
		for (i in 0 ... this.m_numOfFaces)
		{
			var face:BSPFace = Faces[i];
			
			//					// 1=polygon, 2=patch, 3=mesh, 4=billboard 
		
			
			if (face.type == 1 )//polygon
			{
					var surf:MeshBuffer = createSurface();
						surf.material.setMaterialType(Gdx.MaterialLightMap);
					
				//	trace(face.startVertIndex + " , " + (face.startVertIndex+face.numOfVerts));
					
					for ( v in face.startVertIndex ... (face.startVertIndex+face.numOfVerts))
					{
						var pos:Vector3 = Vertex[v].vPosition;
						var normal:Vector3 = Vertex[v].vNormal;
						var uv:Vector2 = Vertex[v].vTextureCoord;
						var uv2:Vector2 = Vertex[v].vLightmapCoord;
						var r:Float = Vertex[v].r / 255.0;
						var g:Float = Vertex[v].g / 255.0;
						var b:Float = Vertex[v].b / 255.0;
						var a:Float = Vertex[v].a / 255.0;
						
						
				
					
						
					surf.AddFullVertexColor(pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, uv.x, uv.y, uv2.x, uv2.y, r, g, b, a);
	
			  
					}
					//surf.Bounding.calculate();
		
			  
					//	trace(face.startIndex + " , " + Std.int((face.startIndex + face.numOfIndices)/3));
				
                    var index:Int = face.startIndex;					
					for (x in 0 ...  Std.int(face.numOfIndices/3))
					{
						
						var v0:Int = this.Indices[index];index++;
						var v1:Int = this.Indices[index];index++;
						var v2:Int = this.Indices[index];index++;
						
				
						surf.AddTriangle(v0, v1, v2);
					}
				
				
					
		
					if (textures.length >= 1)
					{
				   if (face.textureID <= textures.length)
					{
						if (textures[face.textureID] != null)	
						{
						//  surf.material.BlendFace = true;
						 surf.material.setTexture(	textures[face.textureID], 0);
						}
					}
					}
					
					if (lightmaps.length >= 1)
					{
					if (face.lightmapID <= lightmaps.length)
					{
						if (lightmaps[face.lightmapID] != null)	  
						{
						//	surf.material.BlendFace = false;
						    surf.material.setTexture(	lightmaps[face.lightmapID], 1);
							surf.material.setMaterialType(Gdx.MaterialLightMap);
						}
					}
					}
				
					
					
						
					surf.materialIndex = face.textureID;
			
				
				 surf.CreateBoundingBox(Matrix.Identity());
                 surf.UpdateVBO();
			}
		}
		
	
		
		sortMaterial();
		
	//
	
		
	}
	public function buildBatchMesh():Void
	{
		
		
		var surfs:Array<MeshBuffer> = [];
	
		for (i in 0 ... this.m_numOfFaces)
		{
			var face:BSPFace = Faces[i];
			if (face.type == 1)//polygon
			{
					var  surf:MeshBuffer = new MeshBuffer(pipline);
			
					surf.materialIndex = face.textureID;
					surf.material.setMaterialType(Gdx.MaterialTransparentAlphaChannel);
					
				//	trace(face.startVertIndex + " , " + (face.startVertIndex+face.numOfVerts));
					
					for ( v in face.startVertIndex ... (face.startVertIndex+face.numOfVerts))
					{
						var pos:Vector3 = Vertex[v].vPosition;
						var normal:Vector3 = Vertex[v].vNormal;
						var uv:Vector2 = Vertex[v].vTextureCoord;
						var uv2:Vector2 = Vertex[v].vLightmapCoord;
						var r:Float = Vertex[v].r / 255.0;
						var g:Float = Vertex[v].g / 255.0;
						var b:Float = Vertex[v].b / 255.0;
						var a:Float = Vertex[v].a / 255.0;
			
						
						//swap z/y
					surf.AddFullVertexColor(pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, uv.x, uv.y, uv2.x, uv2.y,r,g,b,a);
					}
					
					//	trace(face.startIndex + " , " + Std.int((face.startIndex + face.numOfIndices)/3));
				
                    var index:Int = face.startIndex;					
					for (x in 0 ...  Std.int(face.numOfIndices/3))
					{
						
						var v0:Int = this.Indices[index];index++;
						var v1:Int = this.Indices[index];index++;
						var v2:Int = this.Indices[index];index++;
						
					//	trace(v0 + "," + v1 + " ," +v2);
						surf.AddTriangle(v0, v1, v2);
					}
				
					if (textures.length >= 1)
					{
					if (face.textureID <= textures.length)
					{
						if (textures[face.textureID] != null)
						{
						surf.material.setTexture(	textures[face.textureID], 0);
						}
					}
					}
					
					if (lightmaps.length >= 1)
					{
					if (face.lightmapID <= lightmaps.length)
					{
						if (lightmaps[face.lightmapID] != null)
						{
						surf.material.setTexture(	lightmaps[face.lightmapID], 1);
					//	surf.material.setMaterialType(Gdx.MaterialLightMap);
						}
					}
					}
					surf.CreateBoundingBox(Matrix.Identity());
              
							surfs.push(surf);
							surfs.sort(materialIndex);
							
			}
		}
		
		
		trace("create mesh with sort material from " + surfs.length + "surfaces");
	
		for (s1 in 0... surfs.length)
		{
			var surf1:MeshBuffer = surfs[s1];
			
			if (surf1.CountVertices() == 0 && surf1.CountTriangles() == 0 ) continue;
			
			var new_surf:Bool = true;
			
			for (s2 in 0...numMeshBuffer())
			{
				var surf2:MeshBuffer = getMeshBuffer(s2);
				var no_verts2:Int = surf2.CountVertices();
				
				if (Material.CompareMaterial(surf1.material, surf2.material) == true)
				{
					//add vertices
			
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2 = surf2.AddVertex(vx, vy, vz);
		
					surf2.VertexColor(v2,255,255,255,1);
					surf2.VertexNormal(v2,vnx,vny,vnz);
					surf2.VertexTexCoords(v2,vu0,vv0,0,0);
					surf2.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0)+no_verts2;
					var v1=surf1.TriangleVertex(t,1)+no_verts2;
					var v2=surf1.TriangleVertex(t,2)+no_verts2;

					surf2.AddTriangle(v0,v1,v2);
				}
				surf2.reset_vbo = -1;
				surf2.UpdateVBO();
				surf2.CreateBoundingBox(Matrix.Identity());
				new_surf = false;
				break;
				
				}
				
			}
			if (new_surf == true)
			{
				var surf:MeshBuffer = createSurface();
				//add vertices
		
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2=surf.AddVertex(vx,vy,vz);
					surf.VertexColor(v2,255,255,255,1);
					surf.VertexNormal(v2,vnx,vny,vnz);
					surf.VertexTexCoords(v2,vu0,vv0,0,0);
					surf.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0);
					var v1=surf1.TriangleVertex(t,1);
					var v2=surf1.TriangleVertex(t,2);

					surf.AddTriangle(v0,v1,v2);
				}
				if (surf1.material != null)
				{
					surf.material.clone(surf1.material);
				}
				surf.reset_vbo = -1;
				surf.UpdateVBO();
				surf.CreateBoundingBox(Matrix.Identity());
			}
		}
	
	surfs = [];
	surfs = null;
		
		//trace("batch complete");
		sortMaterial();
		

	}
	private function loadIndex(file:ByteArray):Void
	{
	   file.position = lumps[kIndices].offset;
	   for (i in 0...m_numOfIndices)
	   {
		   var indice:Int = file.readInt();
		   this.Indices.push(indice);
	   }
	}
	private function loadFaces(file:ByteArray):Void
	{
	   file.position = lumps[kFaces].offset;
	
	   
	   for ( i in 0...m_numOfFaces)
	   {
		   
		      var face:BSPFace =
	   {
     textureID:0,				// The index o the texture array 
     effect:0,					// The index for the effects (or -1 = n/a) 
     type:0,					// 1=polygon, 2=patch, 3=mesh, 4=billboard 
     startVertIndex:0,			// The starting index o this face's first vertex 
     numOfVerts:0,				// The number of vertices for this face 
     startIndex:0,				// The starting index o the indices array for this face
     numOfIndices:0,			// The number of indices for this face
     lightmapID:0,				// The texture index for the lightmap 
     lMapCorner0:0,			// The face's lightmap corner in the image 
	 lMapCorner1:0,			// The face's lightmap corner in the image 
     lMapSize0:0,			// The size of the lightmap section 
	 lMapSize1:0,			// The size of the lightmap section 
     lMapPos:Vector3.zero,			// The 3D origin of lightmap. 
     lMapVecs0:Vector3.zero,		// The 3D space for s and t unit vectors. 
	 lMapVecs1:Vector3.zero,		// The 3D space for s and t unit vectors. 
     vNormal:Vector3.zero,			// The face normal. 
     size0:0,				// The bezier patch dimensions.  
	 size1:0				// The bezier patch dimensions.
	   }
		        face.textureID             = file.readInt();
                face.effect                = file.readInt();
                face.type                  = file.readInt();
                face.startVertIndex           = file.readInt();
                face.numOfVerts            = file.readInt();
                face.startIndex         = file.readInt();
                face.numOfIndices          = file.readInt();
                face.lightmapID            = file.readInt();
                face.lMapCorner0       = file.readInt();
                face.lMapCorner1       = file.readInt();
                
                face.lMapSize0         = file.readInt();
                face.lMapSize1         = file.readInt();
                
		
                face.lMapPos.x          = file.readFloat();
                face.lMapPos.y          = file.readFloat();
                face.lMapPos.z          = file.readFloat();
    
                face.lMapVecs0.x = file.readFloat();
                face.lMapVecs0.y = file.readFloat();
                face.lMapVecs0.z = file.readFloat();
      
                face.lMapVecs1.x = file.readFloat();
                face.lMapVecs1.y = file.readFloat();
                face.lMapVecs1.z = file.readFloat();
                
          
                face.vNormal.x         = file.readFloat();
                face.vNormal.y          = file.readFloat();
                face.vNormal.z          = file.readFloat();
                
                face.size0             = file.readInt();
                face.size1             = file.readInt();
				//trace( "type=" + face.type + ", verts " + face.numOfVerts + ", " + face.numOfVerts );
				Faces.push(face);
				
	   }
	   

	}
	private function loadVertex(file:ByteArray):Void
	{
	   file.position = lumps[kVertices].offset;

		   
		   
		   
		   for (i in 0...m_numOfVerts)
		   {
			   
			   	   var vertex:BSPVertex =
	   {
      vPosition:Vector3.zero,			// (x, y, z) position. 
     vTextureCoord:Vector2.Zero(),		// (u, v) texture coordinate
     vLightmapCoord:Vector2.Zero(),	// (u, v) lightmap coordinate
     vNormal:Vector3.zero,			// (x, y, z) normal vector
     r:0,				// RGBA color for the vertex 
	 g:0,
	 b:0,
	 a:0
		   }
		 
			 vertex.vPosition.x =  file.readFloat();
			 vertex.vPosition.y=  file.readFloat();
			 vertex.vPosition.z =  file.readFloat();
			 
			 
			 var t:Float = vertex.vPosition.y;
			 vertex.vPosition.y = vertex.vPosition.z;
			 vertex.vPosition.z = t;
			
			 vertex.vTextureCoord.x =  file.readFloat();
			 vertex.vTextureCoord.y =  file.readFloat();
		
		
			 vertex.vLightmapCoord.x =  file.readFloat();
			 vertex.vLightmapCoord.y =  file.readFloat();
		      
			
			 vertex.vNormal.x =  file.readFloat();
			 vertex.vNormal.y =  file.readFloat();
			 vertex.vNormal.z =  file.readFloat();
		
			 var r:Int= file.readByte();
			 if (r < 0)
			 r = -r + 127;
			  var g:Int= file.readByte();
			 if (g < 0)
			 g = -g + 127;
			  var b:Int= file.readByte();
			 if (b < 0)
			 b = -b + 127;
			  var a:Int= file.readByte();
			 if (a < 0)
			 a = -a + 127;
			 
			 vertex.r = r;vertex.g = g;vertex.b = b;vertex.a = a;
			 this.Vertex.push(vertex);
			 
			// trace(vertex.vPosition.toString());
			// trace(vertex.vNormal.toString());
			// trace(vertex.vTextureCoord.toString());
			// trace(vertex.vLightmapCoord.toString());
			// trace(vertex.r+" , "+vertex.g+" , "+vertex.b+" , "+vertex.a);
		   }
		   
	
	}
	private function loadtexture(file:ByteArray):Void
	{
		 var strName:String=" ";			// The name of the texture w/o the extension 
         var flags:Int;					// The surface flags (unknown) 
         var textureType:Int;			// The type of texture (solid, water, slime, etc..) (type & 1) = 1 (solid)
		
			
		file.position = lumps[kTextures].offset;
		for (i in 0 ... this.m_numOfTextures)
		{
			strName = readTextureName(file);
			flags=file.readInt();
			textureType = file.readInt();			
		//	trace( flags + " ," + textureType+", "+strName);
			
			
			var  textureName:String = strName;
			  	 textureName = Path.withoutExtension(textureName);
			
			var  textureNameNoPath:String =   Path.withoutDirectory(strName);
			  	 textureNameNoPath = Path.withoutExtension(textureNameNoPath);
			
			
		if (Assets.exists(path+ textureName+".jpg"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureName+".jpg", true,true,true));
			
		} else
		if (Assets.exists(path+ textureName+".JPG"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureName+".JPG", true,true,true));
			
		} else
		if (Assets.exists(path + textureName+".png"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureName+".png",  true,true,true));
		} else	
		if (Assets.exists(path + textureName+".PNG"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureName+".PNG",  true,true,true));
		} else	
		
		//***no path
		if (Assets.exists(path+ textureNameNoPath+".jpg"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureNameNoPath+".jpg", true,true,true));
			
		} else
		if (Assets.exists(path+ textureNameNoPath+".JPG"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureNameNoPath+".JPG", true,true,true));
			
		} else
		if (Assets.exists(path + textureNameNoPath+".png"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureNameNoPath+".png",  true,true,true));
		} else	
		if (Assets.exists(path + textureNameNoPath+".PNG"))
		{
			textures.push(Gdx.Instance().getTexture(path  + textureNameNoPath+".PNG",  true,true,true));
		} else	
		{
			trace("Texture :(" +textureName+") dont exits");
			textures.push(Gdx.Instance().getTexture("dummy"));
		}
		    
		}
		
		
		
	}
	private function loadLightmap(file:ByteArray):Void
	{
		 var strName:String=" ";			// The name of the texture w/o the extension 
         var flags:Int;					// The surface flags (unknown) 
         var textureType:Int;			// The type of texture (solid, water, slime, etc..) (type & 1) = 1 (solid)
		
	
				
		file.position = lumps[kLightmaps].offset;
		for (i in 0 ... this.m_numOfLightmaps)
		{
		var data:Array<Int> = [];
		for (x in 0... (128 * 128))
		{
			data.push(file.readByte());
			data.push(file.readByte());
			data.push(file.readByte());
		}
		var lightData:UInt8Array = new UInt8Array(128 * 128 * 4);
		
		for (j in 0 ... Std.int(data.length/3))
		{
			var r, g, b,a:Int = 0;
			var rf, gf, bf,af:Float = 0;
			r = data[j * 3 + 2];
			g = data[j * 3 + 1];
			b = data[j * 3 + 0];
			a = 255;
	
			
			rf = r * lmgamma / 255.0;
			gf = g * lmgamma / 255.0;
			bf = b * lmgamma / 255.0;
			af = a * lmgamma / 255.0;
			
			
			var scale:Float = 1.0;
			var temp:Float = 0;
			
			    if (rf > 1.0 && (temp = (1.0 / rf)) < scale) scale = temp;
                if (gf > 1.0 && (temp = (1.0 / gf)) < scale) scale = temp;
                if (bf > 1.0 && (temp = (1.0 / bf)) < scale) scale = temp;
				if (af > 1.0 && (temp = (1.0 / af)) < scale) scale = temp;

                scale *= 255.0;
                r = Std.int(rf * scale);
				g = Std.int(gf * scale);
				b = Std.int(bf * scale);
				a = Std.int(af * scale);
				
              
				
				lightData[j * 4 + 0] = r;
				lightData[j * 4 + 1] = g;
				lightData[j * 4 + 2] = b;
				lightData[j * 4 + 3] = a;
				
				
	
			
		}


    var lm:Image = new Image(new ImageBuffer(lightData,128,128,32,PixelFormat.RGBA32));
	var tlm:Texture = new Texture();
	tlm.loadBitmap(lm, false,true,true);	
	this.lightmaps.push(tlm);
	
	//Util.saveImageToFile(lm, "image_" + i + "_.png");
	
  }
		
		
	
	}
	
		private function readTextureName(byteData:ByteArray):String {
        var name:String = "";
        var k:Int = 0;
        for (j in 0...64) 
		{

			
            var ch:Int = byteData.readUnsignedByte();

			
			 
			if (ch  == 47) 
			{
                name += String.fromCharCode(ch);
				continue;
            }
			
           if (ch > 30 && ch <= 122 && k == 0) 
			{
                name += String.fromCharCode(ch);
            }

          
        }
		
		
        return name;
    }

private function parseProperties(e:BspEntity,entityData:String):Void
{
	

	var end = -1;
	while(true)
	{
		var begin = entityData.indexOf('"', end + 1);
		if(begin == -1)	break;
		end = entityData.indexOf('"', begin + 1);
	
		var key = entityData.substring(begin + 1, end);
		begin = entityData.indexOf('"', end + 1);
		end = entityData.indexOf('"', begin + 1);
		
		var value = entityData.substring(begin + 1, end);
	
		e.addValue(key, value);
		

	}
}

	private function LoadEntities(file:ByteArray):Void
	{
	   file.position = lumps[kEntities].offset;
	   var size:Int = lumps[kEntities].length;
	   
	 var data = file.readUTFBytes(size);
	   
	   
	var end = -1;
		while(true)
		{
			var begin = data.indexOf('{', end + 1);
			if(begin == -1)				break;
			end = data.indexOf('}', begin + 1);
			var entityStr = data.substring(begin + 1, end);
		    var ent = new BspEntity();
			parseProperties(ent, entityStr);
			entitys.add(ent);
			

			
		}
	   

		 
		 
	}
	
	public function getPlayerPosition():Vector3
	{
	for (entity in entitys)
    {
	if ( entity.getType() == "info_player_deathmatch")
	{
		return entity.getVectorValue("origin");
	}
    }
	return Vector3.Zero();
	}
	
}

class BspEntity
{
	private var names:Array<String>;
	private var values:Array<String>;
	public function new() 
	{
		names = new Array<String>();
		values = new Array<String>();
	}
	public function addValue(name:String, value:String):Void
	{
		names.push(name);
		values.push(value);
    //   trace("add  :" + name+", value :" + value);

	}
	
	public function countValues():Int
	{
		return names.length;
	}
	public function getValue(name:String):String
	{
		
		for (i in 0... names.length)
		{
			var n:String = names[i];
			if (n == name)
			{
				return values[i];
			}
		}
		return "";
	}
	public function getName():String
	{
	return names[0];
	}
	public function getType():String
	{
	return values[0];
	}
	public function getFloatValue(name:String):Float
	{
		var v = getValue(name);
		return Std.parseFloat(v);
	}
	public function getVectorValue(name:String):Vector3
	{
		var s = getValue(name);
		
		var arr:Array<String> = [];
		arr.push("");arr.push("");arr.push("");
		
		var j:Int = 0;
	for (i in 0...s.length)
	{
		if (s.charCodeAt(i) != 32)
		{
			arr[j] += s.charAt(i);
		}else
		{
			j++;
		}
	}
		
		var x:Float = Std.parseFloat(arr[0]);
		var y:Float = Std.parseFloat(arr[1]);
		var z:Float = Std.parseFloat(arr[2]);
		
		return new Vector3(x, z, y);
		
		
		
	}
}
