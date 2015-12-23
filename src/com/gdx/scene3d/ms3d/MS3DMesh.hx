package com.gdx.scene3d.ms3d;
import com.gdx.util.ByteArray;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class MS3DMesh
{
	public var flags:Int;
	public var name:String;
	public var numTriangles:Int;
	public var TriangleIndices:Array<Int>;
	public var MaterialIndex:Int;

	public function new(file:ByteArray) 
	{
			 flags = file.readByte();
			name= readString(file, 32);//	file.position += 32;//if you do'nt nedd name just skeep :P
			numTriangles = file.readUnsignedShort();
			TriangleIndices = [];
			for (f in 0...numTriangles)
			{
				var indice:Int = file.readUnsignedShort();
				TriangleIndices.push(indice);
			}
			MaterialIndex = file.readUnsignedByte();
		//	trace("Mesh name:"+name +" tris:"+numTriangles+" material:"+MaterialIndex);
	}
	
	private function readString(byteData:ByteArray, count:Int):String 
	{
        var name:String = "";
        var k:Int = 0;
        for (j in 0...count) {
            var ch:Int = byteData.readByte();

            if (ch > 33 && ch <= 125 ) 
			{
                name += String.fromCharCode(ch);
            }	
				
            
        }
		
        return name;
    }
}