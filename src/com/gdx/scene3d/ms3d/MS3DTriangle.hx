package com.gdx.scene3d.ms3d;

import com.gdx.util.ByteArray;
import com.gdx.math.Vector3;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class MS3DTriangle
{
	public var flags:Int;
	public var indice0:Int;
	public var indice1:Int;
	public var indice2:Int;
	public var normal0:Vector3;
	public var normal1:Vector3;
	public var normal2:Vector3;
	public var s:Vector3;
	public var t:Vector3;
	public var smoothingGroup:Int;
    public var groupIndex:Int;
	
	public function new(file:ByteArray) 
	{
		         flags = file.readUnsignedShort();
				
				indice0 = file.readUnsignedShort();
				indice1 = file.readUnsignedShort();
				indice2 = file.readUnsignedShort();
				
				
				normal0 = Vector3.Zero();
				normal0.x = file.readFloat();
			    normal0.y = file.readFloat();
			    normal0.z = -file.readFloat();
				
			    normal1 = Vector3.Zero();
				normal1.x = file.readFloat();
			    normal1.y = file.readFloat();
			    normal1.z = -file.readFloat();
				
				normal2 = Vector3.Zero();
				normal2.x = file.readFloat();
			    normal2.y = file.readFloat();
			    normal2.z = -file.readFloat();
				
				s = Vector3.Zero();
				s.x = file.readFloat();
			    s.y = file.readFloat();
			    s.z = file.readFloat();
				
				t = Vector3.Zero();
				t.x = file.readFloat();
			    t.y = file.readFloat();
			    t.z = file.readFloat();
				
			//	trace(s + "," + t);
				
				
				smoothingGroup = file.readByte();
			    groupIndex = file.readByte();
	}
	
}