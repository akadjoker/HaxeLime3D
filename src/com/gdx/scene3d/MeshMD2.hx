package com.gdx.scene3d;

import com.gdx.gl.MeshBuffer;
import com.gdx.math.Face;
import com.gdx.math.Matrix;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
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
class MeshMD2 extends AnimatedMesh

{
	
	

	
	

	public var vertex_Count:Int;
	public var uv_count:Int;
	public var face_Count:Int;
	public var frames_Count:Int;

	var faces:Array<Face>;
	var tfaces:Array<Face>;
	var uvCoords:Array<Vector2>;
	var vertex:Array<Vector3>;
	
	public function new() 
	{
   
	super();
	
	     faces = [];
	     vertex = [];
		 tfaces = [];
		 uvCoords = [];
		 
		 
	 
	 
	}
	private function readFrameName(byteData:ByteArray):String {
        var name:String = "";
        var k:Int = 0;
        for (j in 0...16) {
            var ch:Int = byteData.readUnsignedByte();

            if (ch > 0x39 && ch <= 0x7A && k == 0) {
                name += String.fromCharCode(ch);
            }

            if (ch >= 0x30 && ch <= 0x39) {
                k++;
            }
        }
        return name;
    }
	
	public function load(f:String,?scaleFactor=10):Void
	{
		
		
	

	var file:ByteArray =	Util.getBytes(f);
	file.endian = "littleEndian";
	
	
	trace("read header");
	
    var Magic:Int=file.readInt();
    var Version:Int=file.readInt();
    var SkinWidth:Int=file.readInt();
    var SkinHeight:Int=file.readInt();
    var FrameSize:Int=file.readInt();
    var NumSkins:Int=file.readInt();
    var NumVertices:Int=file.readInt();
    var NumTexCoords:Int=file.readInt();
    var NumTriangles:Int=file.readInt();
    var NumGlCommands:Int=file.readInt();
    var NumFrames:Int=file.readInt();
    var OffsetSkins:Int=file.readInt();
    var OffsetTexCoords:Int=file.readInt();
    var OffsetTriangles:Int=file.readInt();
    var OffsetFrames:Int=file.readInt();
    var OffsetGlCommands:Int=file.readInt();
    var OffsetEnd:Int = file.readInt();

    frames_Count = NumFrames;
	vertex_Count=NumVertices ;
	face_Count = NumTriangles;
	uv_count = NumTexCoords;
	trace("Num vertex:" + vertex_Count);
	trace("Num uvs:"+uv_count);
	trace("Num FRames:"+frames_Count);
	
	
	
  

	file.position = OffsetTriangles;
	for (i in 0...NumTriangles)
	{
		var v0, v1, v2:Int;
		v0=file.readUnsignedShort();
		v1=file.readUnsignedShort();
		v2=file.readUnsignedShort();
        var vt:Face = new Face(v0, v1, v2);
		faces.push(vt);
		
		v0=file.readUnsignedShort();
		v1=file.readUnsignedShort();
		v2=file.readUnsignedShort();
		var vc:Face = new Face(v0, v1, v2);
		tfaces.push(vc);
		
	}
	
		
	var  dmaxs:Float = 1.0/(SkinWidth);
    var  dmaxt:Float = 1.0/(SkinHeight);
  

		

	file.position = OffsetTexCoords;
	for (i in 0...NumTexCoords)
	{
		var u:Float = file.readShort()/SkinWidth;
		var v:Float = file.readShort()/SkinHeight;
		uvCoords.push(new Vector2(u,v));
	}
	file.position = OffsetFrames;
	var lastname:String = " ";
	var count:Int = 0;
	var endFrame:Int = 0;
		
		   

	
	for (i in 0...NumFrames)
	{
		var scale:Vector3 = Vector3.Zero();
		var Translate:Vector3 = Vector3.Zero();
		
		scale.x = file.readFloat();
		scale.y = file.readFloat();
		scale.z = file.readFloat();
		
		Translate.x = file.readFloat();
		Translate.y = file.readFloat();
		Translate.z = file.readFloat();
		
		var name:String = readFrameName(file);

	
		
		if (lastname != name)
		{
			lastname = name;
			endFrame = i;
			count = 0;
		}
		count++;
		

		for (j in 0...NumVertices) 
		{
			   var x:Int= file.readUnsignedByte() ;
			   var y:Int= file.readUnsignedByte() ;
			   var z:Int = file.readUnsignedByte() ;     
               var sx:Float = scale.x * x  + Translate.x;
			   var sy:Float = scale.z * z  + Translate.z;
			   var sz:Float = scale.y * y  + Translate.y;
			   vertex.push(new Vector3(sz/scaleFactor, sy/scaleFactor, -sx/scaleFactor));		
               file.position ++;				
		}
		
	}
	

	
	
	  var surface = createSurface();

	   for (i in 0 ... this.faces.length)
	   {
	    var v0:Vector3 = vertex[0 * vertex_Count + faces[i].v0];
	    var v1:Vector3 = vertex[0 * vertex_Count + faces[i].v1];
	    var v2:Vector3 = vertex[0 * vertex_Count + faces[i].v2];
        var uv0:Vector2 = uvCoords[0 * uv_count + tfaces[i].v0];
	    var uv1:Vector2 = uvCoords[0 * uv_count + tfaces[i].v1];
	    var uv2:Vector2 = uvCoords[0 * uv_count + tfaces[i].v2];
		
	var i0 =surface.AddVertex(v0.x, v0.y, v0.z, uv0.x, uv0.y);
	var i1 =surface.AddVertex(v1.x, v1.y, v1.z, uv1.x, uv1.y);
	var i2 =surface.AddVertex(v2.x, v2.y, v2.z, uv2.x, uv2.y);
	surface.AddTriangle(i0, i1, i2);
	

	  }
   surface.CreateBoundingBox(Matrix.Identity());	  
   
   surface.UpdateVBO();


	 tfaces = [];
	 uvCoords = [];
}
	
  

	
	
	override public function animate(currentFrame:Int,nextFrame:Int,poll:Float):Void 
	{
		
		
	  var index = 0;
	  var surf:MeshBuffer=getMeshBuffer(0);
      for (i in 0 ... this.faces.length)
	  {
  	 
		var v1:Vector3 = Vector3.Lerp(vertex[currentFrame * vertex_Count + faces[i].v0], vertex[nextFrame * vertex_Count + faces[i].v0], poll);
	    var v2:Vector3 = Vector3.Lerp(vertex[currentFrame * vertex_Count + faces[i].v1], vertex[nextFrame * vertex_Count + faces[i].v1], poll);
		var v3:Vector3 = Vector3.Lerp(vertex[currentFrame * vertex_Count + faces[i].v2], vertex[nextFrame * vertex_Count + faces[i].v2], poll);
		surf.setVertex(index++, v1);
		surf.setVertex(index++, v2);
		surf.setVertex(index++, v3);
     
	  }
	
	}
}