package com.gdx.scene3d;

import com.gdx.gl.MeshBuffer;
import com.gdx.gl.shaders.Shader;
import com.gdx.math.Face;
import com.gdx.math.Matrix;
import com.gdx.math.Quaternion;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import com.gdx.scene3d.Node;
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
class MeshMD3 extends AnimatedMesh
{
    public var tags:Array<Md3Tag>;
	public var bones:Array<Node>;
	private var numBoneFrames:Int;
    private var numTags:Int;
	private var scaleFactor:Float;
	private var parent:Node;

	
	public function new(factor:Float=10) 
	{
		super( );
		scaleFactor = factor;
		tags = [];
		bones = [];
		parent = null;
	}

	override public function animate(currentFrame:Int,nextFrame:Int,poll:Float):Void 
	{
	    
		updateTags(currentFrame, nextFrame, poll);
	    for (i in 0...surfaces.length)
		{
			var surf:MD3SubMesh = cast(surfaces[i], MD3SubMesh);
			surf.setFrame(currentFrame, nextFrame, poll);
		}
		
	}
	
	private function updateTags(currentFrame:Int, nexFrame:Int, pol:Float):Void
	{
		var frameOffsetA:Int = currentFrame * numTags;
	    var frameOffsetB :Int= nexFrame * numTags;
	
	//	trace(currentFrame+"," + nexFrame);
		for (i in 0...numTags)
		{
		
			var pos:Vector3 = Vector3.Lerp(tags[frameOffsetA + i].position, tags[frameOffsetB + i].position, pol);
		//	
			bones[i].setLocalPosition(pos);
			bones[i].local_rot=Quaternion.Slerp(tags[frameOffsetA + i].rotation, tags[frameOffsetB + i].rotation, pol);
		
		}
	}
	
	public function getTag(Index:Int):Node
	{
		return bones[Index % numTags];
	}
	
	
	private function readCreatorName(byteData:ByteArray):String 
	{
        var name:String = "";
        var k:Int = 0;
        for (j in 0...16) {
            var ch:Int = byteData.readUnsignedByte();


            if (ch > 0x30 && ch <= 0x7A ) 
			{
                name += String.fromCharCode(ch);
            }

        }
        return name;
    }
	private function readMeshName(byteData:ByteArray):String 
	{
        var name:String = "";
        var k:Int = 0;
        for (j in 0...68) {
            var ch:Int = byteData.readUnsignedByte();

		
            if (ch > 0x30 && ch <= 0x7A ) 
			{
                name += String.fromCharCode(ch);
            }

        }
        return name;
    }
	
	private function readTagName(byteData:ByteArray):String 
	{
        var name:String = "";
        var k:Int = 0;
        for (j in 0...64) {
            var ch:Int = byteData.readUnsignedByte();

            if (ch > 65 && ch <= 122 ) 
			{
                name += String.fromCharCode(ch);
            }

         
        }
        return name;
    }
	public function load(f:String):Void
	{
		
		

	
	var file:ByteArray =	Util.getBytes(f);
	file.endian = "littleEndian";
	
	
	
    var fileid:String=file.readUTFBytes(4);//4IDP3
    var Version:Int=file.readInt();//15
    var strFile:String = readMeshName(file);// file.readUTFBytes(68);//68
	
     numBoneFrames=file.readInt();//num keyframes
     numTags = file.readInt();//number tags per frame
	var numMeshes:Int = file.readInt();//number of mehs/skins
	var numMaxSkins:Int = file.readInt();////maximum number of unique skins used in md3 file.
	
	var frameStart:Int = file.readInt();//starting position of frame-structur
	
	var tagStart:Int = file.readInt();//starting position of tag-structures
	var tagEnd:Int = file.readInt();//ending position of tag-structures/starting position of mesh-structures
	
	var fileSize:Int = file.readInt();


	#if debug
	trace("INFO: Header Size: "+fileSize);
	trace("INFO: Num Bone Frames: "+numBoneFrames);
	trace("INFO: Num Tags: " + numTags);
	trace("INFO: Num Sub Meshs: "+numMeshes);
	trace("INFO: Num Max Skins: " + numMaxSkins);
	#end
	


		file.position = tagStart;
//		trace("INFO: start read tags: " + numTags);
		
	
		
		for (i in 0...(numBoneFrames*numTags))
		{
		 var tag:Md3Tag = new Md3Tag();
		 
		  tag.name = readTagName(file);

	//	 trace(tag.name);
		 tag.position.x = file.readFloat()/scaleFactor;
		 tag.position.z = file.readFloat()/scaleFactor;
		 tag.position.y = file.readFloat()/scaleFactor;
		 var f:Float = 0;
		 f = file.readFloat();
		 f = file.readFloat();
		 f = file.readFloat();
		 
		 f = file.readFloat();
		 f = file.readFloat();
		 f = file.readFloat();
		 
		 tag.axe.y = file.readFloat();
 		 tag.axe.x = file.readFloat();
 		 tag.axe.z = file.readFloat();
		 
	

 		 tag.UpdateRotation();
		 this.tags.push(tag); 
		 
		}
		
		for (i in 0...numTags)
		{
			var b:Node = new Node(null, tags[i].name,i);
			b.name = tags[i].name;
			bones.push ( b);
			//trace(b.name);
			//parent.addChild(b);
		}
		
		var offset:Int =  tagEnd;
		
			
	#if debug	trace("INFO: start read meshs "); #end
		
		for ( i in 0...numMeshes)
		{
			file.position = offset;
			var mesh:MD3SubMesh = new MD3SubMesh(pipline,scaleFactor);
			surfaces.push(mesh);
			mesh.load(file, offset);
			offset += mesh.meshSize;
			mesh.build();
		}
		
	  
		NumFrames = numBoneFrames - 1;
		duration = (numBoneFrames / 15);
		framesPerSecond = 15;
        #if debug trace("Max Frames :" + numBoneFrames);#end

	}
	
}

//***********************************************************************************

class MD3SubMesh extends MeshBuffer
{

		

	public var 	    meshID:String;//4					// This stores the mesh ID (We don't care)
	public var      Imageskin:String;//68;				// This stores the mesh name (We do care)
	public var 		numMeshFrames:Int;				// This stores the mesh aniamtion frame count
	public var    	numSkins:Int;					// This stores the mesh skin count
	public var      numVertices:Int;				// This stores the mesh vertex count
	public var 	    numTriangles:Int;				// This stores the mesh face count
	public var 		triStart:Int;					// This stores the starting offset for the triangles
	public var 		headerSize:Int;					// This stores the header size for the mesh
	public var      TexVectorStart:Int;					// This stores the starting offset for the UV coordinates
	public var 		vertexStart:Int;				// This stores the starting offset for the vertex indices
	public var 		meshSize:Int;					// This stores the total mesh size
	public var      triangles:Array < Face>;
    public var      vertex:Array < Vector3>;
	public var      TexCoord:Array < Vector2>;
	public var      scaleFactor:Float;





	
	public function new(s:Shader,f:Float) 
	{
		super(s);
		scaleFactor = f;
		triangles = [];
		vertex = [];
		TexCoord = [];
	
	}
	public function load(f:ByteArray,MeshOffset:Int)
	{
		
		
		
		
	 meshID = f.readUTFBytes(4);
	 Imageskin = readFrameName(f);
	// trace("skin:"+Imageskin);
	 numMeshFrames = f.readInt();
	 numSkins = f.readInt();
	 numVertices = f.readInt();
	 numTriangles = f.readInt();
	 triStart = f.readInt();
	 headerSize = f.readInt();
	 TexVectorStart = f.readInt();
	 vertexStart = f.readInt();
	 meshSize = f.readInt();
	 

	#if debug trace("read triangles..."); #end
	 
	f.position = MeshOffset + triStart;
	for ( i in 0...numTriangles)
	{
		var v0:Int = f.readInt();
		var v1:Int = f.readInt();
		var v2:Int = f.readInt();
		triangles.push(new Face(v0, v1, v2));
		
		
	}
	 
	#if debug trace("read UV..."); #end
	f.position = MeshOffset + TexVectorStart;
	for ( i in 0...numVertices)
	{
		
	     var uvx = f.readFloat();
		 var uvy = f.readFloat();
		 var v:Vector2=new Vector2(uvx, uvy);
		 TexCoord.push(v); 
		
	}
	 
	#if debug trace("read vertices..."); #end
	f.position = MeshOffset + vertexStart;
	for ( i in 0...numVertices*numMeshFrames)
	{
		
	     var x = f.readShort()/64;
		 var y = f.readShort()/64;
		 var z = f.readShort()/64;
		 var n1:Int = f.readUnsignedByte();
		 var n2:Int = f.readUnsignedByte();
		 var v:Vector3 = new Vector3(x/scaleFactor, z/scaleFactor, y/scaleFactor);
		 vertex.push(v); 
	}
	
	}
	
	
	private function readFrameName(byteData:ByteArray):String 
	{
        var name:String = "";
        var k:Int = 0;
        for (j in 0...68) {
            var ch:Int = byteData.readUnsignedByte();
//48 122
            if (ch > 33 && ch <= 126 ) 
			{
                name += String.fromCharCode(ch);
            } 

        }
        return name;
    }

	
	public function build()
	{
		
	
		 var uv_count:Int = this.TexCoord.length;
	

	    for (index in 0... this.triangles.length)
		{
            var i1 = this.triangles[index].v0;
            var i2 = this.triangles[index].v1;
            var i3 = this.triangles[index].v2;

            var v0 = vertex[i1];
            var v1 = vertex[i2];
            var v2 = vertex[i3];
	
     			
					
	var uv0:Vector2 = TexCoord[0 * uv_count + triangles[index].v0];
	var uv1:Vector2 = TexCoord[0 * uv_count + triangles[index].v1];
	var uv2:Vector2 = TexCoord[0 * uv_count + triangles[index].v2];
	
	
	var i0 =AddVertex(v0.x, v0.y, v0.z, uv0.x, uv0.y);
	var i1 =AddVertex(v1.x, v1.y, v1.z, uv1.x, uv1.y);
	var i2 =AddVertex(v2.x, v2.y, v2.z, uv2.x, uv2.y);
	AddTriangle(i0, i1, i2);
	
		
       }

	    CreateBoundingBox(Matrix.Identity());
		 UpdateVBO();
		 
	}
	
	public function setFrame(currentFrame:Int, nexFrame:Int, pol:Float):Void
	{
		
		var currentOffsetVertex:Int = currentFrame * numVertices;
		var nextCurrentOffsetVertex:Int = nexFrame * numVertices;
		
		//trace(currentOffsetVertex + " , " + nextCurrentOffsetVertex);
	
		  var index = 0;
		  

		
		 
		for (i in 0...numTriangles)
		{
			var v0:Int = triangles[i].v0;
			var v1:Int = triangles[i].v1;
			var v2:Int = triangles[i].v2;
         	var vx1:Vector3 = Vector3.Lerp(vertex[currentOffsetVertex + v0], vertex[nextCurrentOffsetVertex + v0], pol);
	        var vx2:Vector3 = Vector3.Lerp(vertex[currentOffsetVertex + v1], vertex[nextCurrentOffsetVertex + v1], pol);
	        var vx3:Vector3 = Vector3.Lerp(vertex[currentOffsetVertex + v2], vertex[nextCurrentOffsetVertex + v2], pol);
	
			  setVertex(index++,vx1);
		      setVertex(index++,vx2);
		      setVertex(index++,vx3);
	

			
	
	}
	
	
	}


	
	
}

//************************************************************************************

class Md3Tag 
{
	public var position:Vector3;
	public var name:String;
	public var axe:Vector3;
	public var rotation:Quaternion;
	
	public function new()  
	{
		
		position = Vector3.Zero();
		axe =Vector3.Zero();
		
		
		
	}
	
	public function UpdateRotation()
	{
		rotation = new Quaternion(
		axe.x,//rotationMatrix[7],
		0.0,
		-axe.y,//-rotationMatrix[6],
		1 + axe.z);//1 + rotationMatrix[8]);
		
		rotation.normalize();
		
		
		
	}

	
}
