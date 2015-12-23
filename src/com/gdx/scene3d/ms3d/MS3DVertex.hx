package com.gdx.scene3d.ms3d;
import com.gdx.util.ByteArray;
import com.gdx.math.Vector3;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class MS3DVertex
{
	public var flags:Int;
	public var vertex:Vector3;
	public var boneID:Int;
	public var refCount:Int;
	
	public function new(file:ByteArray) 
	{
		vertex = Vector3.Zero();
		
			flags = file.readByte();
			vertex.x = file.readFloat();
			vertex.y = file.readFloat();
			vertex.z = -file.readFloat();//this way look like ms3d editor
			boneID = file.readUnsignedByte();
			refCount= file.readByte();
			
		
	}
	
}