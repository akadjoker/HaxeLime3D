package com.gdx.scene3d;

import com.gdx.gl.material.Material;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.VertexBone;
import com.gdx.math.Matrix;
import com.gdx.math.Quaternion;
import com.gdx.math.Vector3;
import com.gdx.scene3d.MeshB3D.B3DJoint;
import com.gdx.scene3d.Node;
import com.gdx.util.PosKeyFrame;
import com.gdx.util.RotKeyFrame;
import haxe.io.Path;
import lime.Assets;
import com.gdx.util.ByteArray;
import com.gdx.util.Util;



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
class MeshB3D extends AnimatedMesh

{
	
private var  file:ByteArray;
private var b3d_tos:Int;
private var b3d_stack:Array<Int>;
private var listVertex:Array<VertexBone>;

private var textures:Array<String>;
private var brushes:Array<Material> = new Array<Material>();
private var AnimatedVertices_VertexID:Array<Int> ;
private var AnimatedVertices_BufferID:Array<Int>;
 
private var texturepath:String;
var VerticesStart:Int = 0;
private var haveBones:Bool;
public var Joints:Array<B3DJoint>;
private var Id:Int;
private var Bones:Array<B3DBone>;
private var isSkinning:Bool = true;


	public function new() 
	{
		super();
		
		 b3d_tos = 0;
		 b3d_stack = [];
	
		 textures = [];
		 brushes = [];
		 Joints = [];
   		 Id = 0;
		 listVertex = [];
		 	Bones = [];
		 
		AnimatedVertices_VertexID=[];
        AnimatedVertices_BufferID =[];

		
	}
	
	
override public function getJoint(name:String):B3DJoint
{
	for (i in 0...Joints.length)
	{
		if (Joints[i].name == name)
		{
			return Joints[i];
		}
	}
	return null;
}
override public function getJointIndex(name:String):Int
{
	for (i in 0...Joints.length)
	{
		if (Joints[i].name == name)
		{
			return i;
		}
	}
	return -1;
}
override public function numJoints():Int
{
	return Joints.length;
}

	public function load(f:String,path:String):Void
	{
	
		
		  if (!Assets.exists(f))
			{
				trace("ERROR:Model " + f+"dont exists..");
				return;
			}
			
				  
	
     haveBones = false;
			
		texturepath = path;
		file =	Util.getBytes(f);
	    file.endian = "littleEndian";
        if (file.bytesAvailable <= 0) return;
	    file.position = 0;
		
		ReadChunk();
		file.readInt();
		
while (getChunkSize() != 0)
{
  var ChunkName = ReadChunk();
  if(ChunkName=='TEXS') 
  {
	 readTEX(); 
  } else
  if(ChunkName=='BRUS') 
  {
	readBRUS();
   } else
  if(ChunkName=='NODE') 
  {
	readNODE(null);
  }
   breakChunk();
}
breakChunk();

if (isAnimated && haveBones && isSkinning)
{
	setShader(Gdx.SHADERTEXTURESKIN);
}


       
//free some memory
      listVertex = null;
	  textures = null;
	  brushes = null;
	  b3d_tos = 0;
	  b3d_stack = null;
	
	    
	  
	  	for (s in 0... numMeshBuffer())
		{
		
			var surf:MeshBuffer = surfaces[s];
			surf.bones = [];
			surf.wights = [];
			
	
		for (i in 0... Bones[s].vertex.length)
		{
		   var vertex:VertexBone = Bones[s].vertex[i];
		   surf.bones.push(vertex.bones[0].boneId);
		   surf.bones.push(vertex.bones[1].boneId);
		   surf.bones.push(vertex.bones[2].boneId);
		   surf.bones.push(vertex.bones[3].boneId);
		   surf.wights.push(vertex.bones[0].Wight);
		   surf.wights.push(vertex.bones[1].Wight);
		   surf.wights.push(vertex.bones[2].Wight);
		   surf.wights.push(vertex.bones[3].Wight);
		 }
		 surf.reset_vbo = surf.reset_vbo | 24;
	     surf.UpdateVBO();
		 surf.bones = null;
		 surf.wights = null;
			
			}
	  
	  
		AnimatedVertices_VertexID=null;
        AnimatedVertices_BufferID = null;
		
		if (isSkinning)
		{
		Bones = null;
		}
	
		trace("Read OK..");
	
    }
	
	private function  ReadChunk():String
	{
    var tag:String = file.readUTFBytes(4);
    var size = file.readInt();
    b3d_tos++;
     b3d_stack[b3d_tos] = file.position +size;
	return tag;
	}
	
	private function getChunkSize():Int
    { 
    return b3d_stack[b3d_tos] - file.position;
	}

	private function breakChunk():Void
    {
    file.position = b3d_stack[b3d_tos];
    --b3d_tos;
	}
	
	private function readstring():String {
        var name:String = "";
         for (j in 0...256) 
		{
            var ch:Int = file.readUnsignedByte();
			if (ch == 0) break;
            name += String.fromCharCode(ch);
        }
        return name;
    }
	private function readANIM():Void
   {
   	 isAnimated=true;
	 var flags:Int=  file.readInt();//flags
	 NumFrames=  file.readInt();//ketframecount
	 framesPerSecond =  file.readFloat();//fps
	 if (framesPerSecond <= 0) 
	 {
	 framesPerSecond = 25.0;
	 }
	  duration =  (NumFrames / framesPerSecond);
	 trace('Animation - duration :' +duration +',flags:' + flags + ', totalframes:' + NumFrames + ', fps:' + framesPerSecond);

   }
 
	   
   private function readBone(bone:B3DJoint):Void
   {
	   var vertex_id:Int = 0;
	   var buffer_id:Int = 0;
	   haveBones = true;
	   while (getChunkSize()!=0) 
      {
	  var globalVertexID:Int  =file.readInt();//vertexid
	   var strength:Float =  file.readFloat();//wight
	   
	   
   
	   globalVertexID += VerticesStart;

	        if (AnimatedVertices_VertexID[globalVertexID]==-1)
    		{
				trace(" Weight has bad vertex id (no link to meshbuffer index found)");
			} else 
			{
			
				vertex_id = AnimatedVertices_VertexID[globalVertexID];
				buffer_id = AnimatedVertices_BufferID[globalVertexID];
		
				
				
				var surf:MeshBuffer = surfaces[buffer_id];
			
				
				
			
				
				
				
				if (strength > Bones[buffer_id].vertex[vertex_id].bones[0].Wight)
				{
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId = Bones[buffer_id].vertex[vertex_id].bones[2].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = Bones[buffer_id].vertex[vertex_id].bones[2].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[1].boneId = Bones[buffer_id].vertex[vertex_id].bones[0].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[1].Wight = Bones[buffer_id].vertex[vertex_id].bones[0].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[0].boneId = bone.index;
					Bones[buffer_id].vertex[vertex_id].bones[0].Wight = strength;
					Bones[buffer_id].vertex[vertex_id].numBones = 1;
					
					
				} else
				
				if (strength > Bones[buffer_id].vertex[vertex_id].bones[1].Wight)
				{
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId = Bones[buffer_id].vertex[vertex_id].bones[2].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = Bones[buffer_id].vertex[vertex_id].bones[2].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[2].boneId = Bones[buffer_id].vertex[vertex_id].bones[1].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[2].Wight = Bones[buffer_id].vertex[vertex_id].bones[1].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[1].boneId = bone.index;
					Bones[buffer_id].vertex[vertex_id].bones[1].Wight = strength;
				    Bones[buffer_id].vertex[vertex_id].numBones = 2;
					
				} else
					if (strength > Bones[buffer_id].vertex[vertex_id].bones[2].Wight)
				{
					
					
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId = Bones[buffer_id].vertex[vertex_id].bones[2].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = Bones[buffer_id].vertex[vertex_id].bones[2].Wight;
					Bones[buffer_id].vertex[vertex_id].bones[2].boneId = bone.index;
					Bones[buffer_id].vertex[vertex_id].bones[2].Wight = strength;
					Bones[buffer_id].vertex[vertex_id].numBones = 3;
					
					
					
				} else
				if (strength > Bones[buffer_id].vertex[vertex_id].bones[3].Wight)
				{
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId = bone.index;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = strength;
					Bones[buffer_id].vertex[vertex_id].numBones = 4;
		
				}
				
		
				}
				
			
			

   
	  }
	  
	  //trace(buffer_id+ " ," +VerticesStart);
   }

	private function readTEX():Void
   {
    while (getChunkSize()!=0) 
   {
	  var  texture:String = Path.withoutDirectory(readstring());
	  
	  if (Path.extension(texture) == 'bmp')
			{
				texture = Path.withoutExtension(texture);
				texture+= '.jpg';
			}else
			if (Path.extension(texture) == 'tga')
			{
				texture = Path.withoutExtension(texture);
				texture+= '.png';
			}
			
			
	  trace('Texture name:'+texture);
	  textures.push(texture);
	  file.readInt();//flags
	  file.readInt();//blend
	  file.readFloat();//x
	  file.readFloat();//y
	  file.readFloat();//scalex
	  file.readFloat();//sclaey
	  file.readFloat();//rotation
  }

  
  }
  private function readBRUS():Void
  {
	  var count = file.readInt();//num textures
	//  trace('num textures in brush:' + count);

  while (getChunkSize()!=0) 
  {
	  var brush:Material = new Material();
	

	  
	     readstring();
	     brush.DiffuseColor.r= file.readFloat();//r
	     brush.DiffuseColor.g= file.readFloat();//g
		 brush.DiffuseColor.b=file.readFloat();//b
		 brush.alpha= file.readFloat();//a
		 
		 file.readFloat();//shiness
		var blend:Int= file.readInt();//blend
		var fx:Int = file.readInt();//fx
	//	trace(blend + ',' + fx);
		 
		 for (i in 0...count)
		 {
			var textid = file.readInt();//texid
			
			if (Assets.exists(texturepath+textures[textid]))
			{
				if (i == 0)
				{
				brush.setTexture(Gdx.Instance().getTexture(texturepath + textures[textid]),0);
				} else
				{
				brush.setTexture(Gdx.Instance().getTexture(texturepath + textures[textid]),1);
				}
				
			} else
			{
				trace("ERROR: Texture ("+texturepath+textures[textid]+") dont find..");
			}
			
		 }
		 

	brushes.push(brush);
  }
  }
    private function readKEYS(bone:B3DJoint):Void
   {
	   var Flags:Int = file.readInt();
	   var Size:Int = 4;
	   if (Flags & 1 > 0) Size += 12;
	   
       if (Flags & 2 > 0) Size += 12;
	   
       if (Flags & 4 > 0) Size += 16;
	
	
	
	      
	   
	   while (getChunkSize()!=0) 
      {
	         var frame:Int=file.readInt();
	  	 
	   	    if ((Flags & 1)>0)//position
            {
				var x:Float = file.readFloat();
				var y:Float = file.readFloat();
				var z:Float = file.readFloat();
	
			   bone.Pos.push( new PosKeyFrame(frame,new Vector3(x, y, z)));
				
			}
	        if ((Flags & 2)>0)//scale
            {
				var x:Float = file.readFloat();
				var y:Float = file.readFloat();
				var z:Float = file.readFloat();
	
			}
			 if ((Flags & 4)>0)//rotation
            {
				var w:Float = file.readFloat();
				var x:Float = file.readFloat();
				var y:Float = file.readFloat();
				var z:Float = file.readFloat();
				
				
	
	 
			    bone.Rot.push(new RotKeyFrame( frame, new Quaternion(x, y, z, -w)));
				 
				
			}
	
			
	  }
	  
   }
  private function readNODE(parent:Node):Node
  {
     var n:String = readstring();
	 var child:Node = null;
	 
	 

	var lastBone = new B3DJoint( parent,n.toUpperCase(), Id + Joints.length);
	
		 
	lastBone.Position.x=  file.readFloat();//x
	lastBone.Position.y=  file.readFloat();//y
	lastBone.Position.z=  file.readFloat();//z

	  
	
	lastBone.Scaling.x=  file.readFloat();//sx
	lastBone.Scaling.y=  file.readFloat();//sy
	lastBone.Scaling.z =  file.readFloat();//sz
	  
	
     var rw:Float=file.readFloat();//rx
	 var rx:Float=file.readFloat();//ry
	 var ry:Float=file.readFloat();//rz
	 var rz:Float =file.readFloat();//rw
	 var q:Quaternion = new Quaternion(rx, ry, rz, -rw);

	 lastBone.setRotationQuat(q);

	 lastBone.initialize();
	 lastBone.index = Joints.length;

		
	 Joints.push(lastBone);
	 

	 
while (getChunkSize() != 0)
{
	  var ChunkName = ReadChunk();
	 if(ChunkName=='MESH') 
     {
	  VerticesStart = listVertex.length;
 	  readMESH();
     } else  
	 if(ChunkName=='BONE') 
     {
	 readBone(lastBone);
     } 
	 if(ChunkName=='ANIM') 
     {
	  readANIM();
	
     }  else  
     if(ChunkName=='KEYS') 
     {
	readKEYS(lastBone); 
     } else
    if(ChunkName=='NODE') 
     {
	 child = readNODE(lastBone);
	}
	breakChunk();
}
lastBone.numKeys = lastBone.Pos.length;



  	 
  return lastBone;
}
  private function  readMESH():Void
  {
	
  var brushID:Int = file.readInt();//brushID

	 
   
	while (getChunkSize() != 0)
    {
	   var ChunkName = ReadChunk();
	   if(ChunkName=='VRTS') 
       {
	   readVTS();
      } else  
      if(ChunkName=='TRIS') 
       {
    	var surf = this.createSurface();
	 	readTRIS(surf,surfaces.length-1,VerticesStart);
     } 
	 breakChunk();
	}  
	 
  }
  private function readVTS():Void
  {
	
		

        var flags = file.readInt();
		var tex_coord = file.readInt();
		var texsize = file.readInt();
		
		var Size:Int = 12 + tex_coord * texsize * 4;
		if (flags & 1 == 1) Size += 12;
	    if (flags & 2 == 2) Size += 16;
		
			  
	  var VertexCount:Int = Std.int(getChunkSize() / Size);
	  
	   
	//	trace('Num Vextex:'+ VertexCount +' flags:'+ flags + ', numUVC:' + tex_coord);
		
		while (getChunkSize() > 0)
		{
			var vertex:VertexBone = new VertexBone();
			vertex.Pos.x=file.readFloat();//x
            vertex.Pos.y=file.readFloat();//y
            vertex.Pos.z=file.readFloat();//z
			 if ((flags & 1)>0)
            {
            vertex.Normal.x=file.readFloat();// nx
            vertex.Normal.y=file.readFloat();//ny
            vertex.Normal.z=file.readFloat();//nz
			//trace(vertex.Normal.toString());
            }
		    if ((flags & 2)>0)
            {
            vertex.Color.r=file.readFloat();//r
            vertex.Color.g=file.readFloat();//g
            vertex.Color.b=file.readFloat();//b
			vertex.Color.a = file.readFloat();//a
			//trace(vertex.Color.toString());
			}
		
			if (tex_coord == 1)
			{
			    if (texsize == 2)
			   {
               vertex.TCoords0.x=file.readFloat();//u
               vertex.TCoords0.y = file.readFloat();//v
			   } else
			   {
			    vertex.TCoords0.x =file.readFloat();//u
                vertex.TCoords0.y = file.readFloat();//v
			    file.readFloat();//w
		     	}
			} else
			{
				 if (texsize == 2)
			   {
               vertex.TCoords0.x=file.readFloat();//u
               vertex.TCoords0.y=file.readFloat();//v
			   vertex.TCoords1.x=file.readFloat();//u
               vertex.TCoords1.y=file.readFloat();//v
			   } else
			   {
			    vertex.TCoords0.x =file.readFloat();//u
                vertex.TCoords0.y = file.readFloat();//v
			    file.readFloat();//w
		        vertex.TCoords1.x =file.readFloat();//u
                vertex.TCoords1.y = file.readFloat();//v
			    file.readFloat();//w
		     	}
			}
			
			listVertex.push(vertex);
			AnimatedVertices_VertexID.push( -1);
			AnimatedVertices_BufferID.push( -1);
		}
		
	
		
	//	trace('Num vertex:' + listVertex.length);

  }


  public function readTRIS(surf:MeshBuffer,surfaceId:Int,vtStar:Int):Void
  {
	   var brushid = file.readInt();
	   var TriangleCount:Int = Std.int(getChunkSize() / 12);
	   
	    
	   var showwarning:Bool = false;
	
	   trace("face start:" + vtStar );

	   var vertex_id:Array<Int> = [];
	   
	   var bone:B3DBone = new B3DBone();
	   
	   while (getChunkSize() != 0)
		{
			vertex_id[0] = file.readInt();
			vertex_id[1] = file.readInt();
			vertex_id[2] = file.readInt();
			
			
			vertex_id[0] += vtStar;
			vertex_id[1] += vtStar;
			vertex_id[2] += vtStar;
			
			for (i in 0...3)
			{
				if (vertex_id[i] >= AnimatedVertices_VertexID.length)
			{
				trace("Illegal vertex index found");
				return ;
			}
			
				if (AnimatedVertices_VertexID[ vertex_id[i] ] != -1)
			{
				if ( AnimatedVertices_BufferID[ vertex_id[i] ] != surfaceId ) //If this vertex is linked in a different meshbuffer
				{
					AnimatedVertices_VertexID[ vertex_id[i] ] = -1;
					AnimatedVertices_BufferID[ vertex_id[i] ] = -1;
					showwarning = true;
					
				}
			}
			
			if (AnimatedVertices_VertexID[ vertex_id[i] ] == -1) //If this vertex is not in the meshbuffer
			{
				
				var vertex = listVertex[ vertex_id[i] ];
			    surf.AddFullVertexColorVector(vertex.Pos, vertex.Normal, vertex.TCoords0, vertex.TCoords1, vertex.Color);
			    bone.vertex.push(vertex);
				
				
				//create vertex id to meshbuffer index link:
				AnimatedVertices_VertexID[ vertex_id[i] ] = surf.CountVertices()-1;
				AnimatedVertices_BufferID[ vertex_id[i] ] = surfaceId;
			
			}
			
			
		
	
			}
			
			surf.AddTriangle(
			AnimatedVertices_VertexID[ vertex_id[0] ],
			AnimatedVertices_VertexID[ vertex_id[1] ],
			AnimatedVertices_VertexID[ vertex_id[2] ]);
			
			
			
		
			
		}
	
	
		if (showwarning)
		{
			trace("Warning, different meshbuffers linking to the same vertex, this will cause problems with animated meshes");
		}
	
		
	
	
	
		
trace("Vertex Count:" +surf.no_verts+" Index Count:"+ surf.tris.length);

	Bones.push(bone);
	
		surf.material.clone(brushes[brushid]);
		surf.CreateBoundingBox(Matrix.Identity());
	
	
  }
  

 

	override public function animate(currentFrame:Int,nextFrame:Int,poll:Float):Void 
	{
	
		

		if(!isAnimated) return;

		if (isSkinning)
		{
	
	    pipline.Use();
	  
	    for  (i in 0... Joints.length)
		{
			var bone:B3DJoint = Joints[i];
			bone.animateJoints(currentFrame);
			pipline.setBoneMatrix(i, bone.tform_mat);
		}
        pipline.unBind();

		} else
		{

		
        for  (i in 0... Joints.length)
		{
			var bone:B3DJoint = Joints[i];
			bone.animateJoints(currentFrame);
			
		}
		for ( s in 0...surfaces.length)
	
		{
		
		var surf:MeshBuffer = surfaces[s];
		var Bone = Bones[s];
		
		
		
		for (i in 0...Bone.vertex.length)
		{
			
			
		var vertex:VertexBone = Bone.vertex[i];
		   
		var x:Float = 0;
		var y:Float = 0;
		var z:Float = 0;
		var ovx:Float = 0;
		var ovy:Float = 0;
		var ovz:Float = 0;
		
		  if (vertex.bones[0].boneId != -1)
		   {
			  var pos:Vector3 = vertex.Pos;
	
	
			  var tform_mat:Matrix=  Joints[vertex.bones[0].boneId].tform_mat;
			  
			  
			  var w:Float = vertex.bones[0].Wight;
		
		      
			  ovx=pos.x;
              ovy=pos.y;
              ovz=pos.z;
            
			   x = ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y = ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z = ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
			   
			   
			
		
			   
			  if (vertex.bones[1].boneId != -1)
		      {
			
			   var tform_mat:Matrix=  Joints[vertex.bones[1].boneId].tform_mat;
			
			   var w:Float = vertex.bones[1].Wight;
		       x =x+ ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y =y+ ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z =z+ ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
		
			   
			  if (vertex.bones[2].boneId != -1)
		      {
		
		    	var tform_mat:Matrix  =Joints[vertex.bones[2].boneId].tform_mat;
			
			    var w:Float = vertex.bones[2].Wight;
		       x =x+ ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y =y+ ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z =z+ ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
		
			   
			   if (vertex.bones[3].boneId != -1)
		      {
			
		   	   var tform_mat:Matrix=  Joints[vertex.bones[3].boneId].tform_mat;
			   var w:Float = vertex.bones[3].Wight;
		       x =x+ ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y =y+ ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z =z+ ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
		
		      }
			  
		      }
			 
		     }
			
		    
			
		}
				

		surf.VertexCoords(i, x, y, z);
		}
		surf.UpdateVBO();
		}
		
	
	
}

		
	}
}





class B3DBone
{
  public var vertex:Array<VertexBone>;
  public function new() 
	{
		vertex=[];
	}
}




class B3DJoint extends Node
{
	  
	   
     	public var Pos:Array<PosKeyFrame>;
		public var Scl:Array<PosKeyFrame>;
		public var Rot:Array<RotKeyFrame>;

		public var index:Int;
		public var numKeys:Int;
	

	    public  var offMatrix:Matrix;

		public var tform_mat:Matrix;
	

		public function new(Parent:Node,name:String,id:Int)
	    {
		 super( Parent, name,id);
	   
		 Pos = [];
		 Rot = [];
	     Scl = [];
        offMatrix = Matrix.Identity();

		 tform_mat = Matrix.Identity();
		
		 
		 index = 0;
	

		
		
		}
		
		private function updatePose():Void
		{
		local_rot.toRotationMatrix(local_tform);
	    local_tform.m41 = local_pos.x;
		local_tform.m42 = local_pos.y;
		local_tform.m43 = local_pos.z;
		if (this.parent != null)
		{
			if (Std.is(this.parent, B3DJoint))
			{
				var p:B3DJoint = cast(parent, B3DJoint);
		        local_tform.append(p.local_tform);
			} 
		
		} 	
		
		Bounding.update(local_tform);
		Matrix.multiply2x(tform_mat, offMatrix, local_tform);
		}
	
	public function initialize():Void
	{
	  updatePose();
  	local_tform.invertToRef(offMatrix);
	}
		
	private function FindPosition(time:Float):Int
	{
		for (i in 0...Pos.length-1)
		{
			if (time < Pos[i + 1].time)
			{
				return i;
			}
		}
		return 0;
	}
	private function FindRotation(time:Float):Int
	{
		for (i in 0...Rot.length-1)
		{
			if (time < Rot[i + 1].time)
			{
				return i;
			}
		}
		return 0;
	}

	private function FindScale(time:Float):Int
	{
		for (i in 0...Scl.length-1)
		{
			if (time < Scl[i + 1].time)
			{
				return i;
			}
		}
		return 0;
	}

	
	private function animteRotation(movetime:Float):Void
	{
		    if (Rot.length <= 0) return;
		    var currentIndex:Int = FindRotation(movetime);
            var nextIndex:Int = (currentIndex + 1);
			
			if (nextIndex > Pos.length)
			{
				return;
			}  
			
			 var DeltaTime :Float= (Rot[nextIndex].time -Rot[currentIndex].time);
             var Factor = (movetime - Rot[currentIndex].time) / DeltaTime;
			 setRotationQuat(Quaternion.Slerp(Rot[currentIndex].Rot, Rot[nextIndex].Rot, Factor));
			 
			
	}
	
	private function animteScale(movetime:Float):Void
	{
		if (Scl.length <= 0) return;
		    var currentIndex:Int = FindScale(movetime);
            var nextIndex:Int = (currentIndex + 1);
			
			if (nextIndex > Scl.length)
			{
	
				return;
			}  
			
			 var DeltaTime :Float= (Scl[nextIndex].time -Scl[currentIndex].time);
             var Factor = (movetime - Scl[currentIndex].time) / DeltaTime;
			// this.scaling = Vector3.Lerp(Scl[currentIndex].Pos, Scl[nextIndex].Pos, Factor);
			
	}
	private function animtePosition(movetime:Float):Void
	{
		  if (Pos.length <= 0) return;
		    var currentIndex:Int = FindPosition(movetime);
            var nextIndex:Int = (currentIndex + 1);
			
			if (nextIndex > Pos.length)
			{
	
				return;
			}  
			
			 var DeltaTime :Float= (Pos[nextIndex].time - Pos[currentIndex].time);
             var Factor = (movetime - Pos[currentIndex].time) / DeltaTime;
		     setLocalPosition(Vector3.Lerp(Pos[currentIndex].Pos, Pos[nextIndex].Pos, Factor));
	}
	public function animateJoints(TimeInSeconds:Float):Void
	{
		
		   animtePosition(TimeInSeconds);
		   animteRotation(TimeInSeconds);
		   updatePose();
		   
			
		 
		
	
 	}
}