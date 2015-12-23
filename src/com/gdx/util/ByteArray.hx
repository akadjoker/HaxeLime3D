package com.gdx.util;
import haxe.io.Bytes;
import haxe.io.BytesData;
import lime.utils.ArrayBuffer;
import lime.utils.Bytes in LimeBytes;
import lime.utils.LZMA;


@:enum abstract Endian(String) from String to String {
	
	public var BIG_ENDIAN:String = "bigEndian";
	public var LITTLE_ENDIAN:String = "littleEndian";
	
}




/**
 * ...
 * @author Luis Santos AKA DJOKER
 */

@:access(haxe.io.Bytes)
@:access(ByteArrayData)
@:forward(bytesAvailable, endian, objectEncoding, position, clear, compress, deflate, inflate, readBoolean, readByte, readBytes, readDouble, readFloat, readInt, readMultiByte, readShort, readUnsignedByte, readUnsignedInt, readUnsignedShort, readUTF, readUTFBytes, toString, uncompress, writeBoolean, writeByte, writeBytes, writeDouble, writeFloat, writeInt, writeMultiByte, writeShort, writeUnsignedInt, writeUTF, writeUTFBytes)
abstract ByteArray(ByteArrayData) from ByteArrayData to ByteArrayData {
	
	
	public static var defaultObjectEncoding:UInt;
	
	public var length (get, set):Int;
	
	
	public inline function new (length:Int = 0):Void {
		
		
		this = new ByteArrayData (length);
	
		
	}
	
	
	@:arrayAccess @:noCompletion private inline function get (index:Int):Int {
		
		
		return this.get (index);
	
		
	}
	
	
	@:arrayAccess @:noCompletion private inline function set (index:Int, value:Int):Int {
		
		
		this.set (index, value);
	
		return value;
		
	}
	
	
	@:from @:noCompletion public static function fromArrayBuffer (buffer:ArrayBuffer):ByteArray {
		
		#if display
		return null;
		#elseif js
		return ByteArrayData.fromBytes (Bytes.ofData (buffer));
		#elseif flash
		return (buffer:Bytes).getData ();
		#else
		return ByteArrayData.fromBytes ((buffer:Bytes));
		#end
		
	}
	
	
	@:from @:noCompletion public static function fromBytes (bytes:Bytes):ByteArray {
		
		
		
		if (Std.is (bytes, ByteArrayData)) {
			
			return cast bytes;
			
		} else {
			
			
			return ByteArrayData.fromBytes (bytes);
			
			
		}
		
	
		
	}
	
	
	@:from @:noCompletion public static function fromBytesData (bytesData:BytesData):ByteArray {
	
		
		#if display
		return null;
		#elseif flash
		return bytesData;
		#else
		return ByteArrayData.fromBytes (Bytes.ofData (bytesData));
		#end
	
		
	}
	
	
	@:to @:noCompletion public static function toArrayBuffer (byteArray:ByteArray):ArrayBuffer {
		
		#if display
		return null;
		#elseif js
		return (byteArray:ByteArrayData).getData ();
		#elseif flash
		return Bytes.ofData (byteArray);
		#else
		return (byteArray:ByteArrayData);
		#end
		
	}
	
	@:to @:noCompletion private static function toBytes (byteArray:ByteArray):Bytes {
		
		
		#if display
		return null;
		#elseif flash
		return Bytes.ofData (byteArray);
		#else
		return (byteArray:ByteArrayData);
		#end
	
	}
	
	
	#if !display
	@:to @:noCompletion private static function toBytesData (byteArray:ByteArray):BytesData {
		
		
	#if display
		return null;
		#elseif flash
		return byteArray;
		#else
		return (byteArray:ByteArrayData).getData ();
		#end
	
		
	}
	#end
	
	
	@:to @:noCompletion private static function toLimeBytes (byteArray:ByteArray):LimeBytes {
		
		
		return new LimeBytes (byteArray.length, (byteArray:ByteArrayData).getData ());
	
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_length ():Int {
		
		
		return this.__length;
		
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		if (value > 0) {
			
			this.__resize (value);
			
		}
		
		this.__length = value;
		
		
		return value;
		
	}
	
	
}





@:autoBuild(lime.Assets.embedByteArray())

@:noCompletion @:dox(hide) class ByteArrayData extends Bytes  {
	
	
	public var bytesAvailable (get, never):UInt;
	public var endian (get, set):Endian;
	public var objectEncoding:UInt;
	public var position:Int;
	
	private var __endian:Endian;
	private var __length:Int;
	
	
	public function new (length:Int = 0) {
		
		var bytes = Bytes.alloc (length);
		
		#if js
		super (bytes.b.buffer);
		#else
		super (length, bytes.b);
		#end
		
		__length = length;
		endian = LITTLE_ENDIAN;
		position = 0;
		
	}
	
	
	public function clear ():Void {
		
		__length = 0;
		position = 0;
		
	}
	
	
	
	
	public static function fromBytes (bytes:Bytes):ByteArrayData {
		
		var result = new ByteArrayData ();
		result.__fromBytes (bytes);
		return result;
		
	}
	
	

	
	
	public function readBoolean ():Bool {
		
		if (position < length) {
			
			return (get (position++) != 0);
			
		} else {
			
			throw  "error";
			return false;
			
		}
		
	}
	
	
	public function readByte ():Int {
		
		var value = readUnsignedByte ();
		
		if (value & 0x80 != 0) {
			
			return value - 0x100;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function readBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {
		
		if (length == 0) length = __length - position;
		
		if (position + length > __length) {
			
			throw  "error";
			
		}
		
		if ((bytes:ByteArrayData).__length < offset + length) {
			
			(bytes:ByteArrayData).__resize (offset + length);
			
		}
		
		(bytes:ByteArrayData).blit (offset, this, position, length);
		position += length;
		
	}
	
	
	public function readDouble ():Float {
		
		if (position + 8 > __length) {
			
		throw  "error";
			
		}
		
		position += 8;
		return getDouble (position - 8);
		
	}
	
	
	public function readFloat ():Float {
		
		if (position + 4 > __length) {
			
			throw  "error";
			
		}
		
		position += 4;
		return getFloat (position - 4);
		
	}
	
	
	public function readInt ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		
		if (endian == LITTLE_ENDIAN) {
			
			return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
			
		} else {
			
			return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
			
		}
		
	}
	
	
	public function readMultiByte (length:Int, charSet:String):String {
		
		return readUTFBytes (length);
		
	}
	
	
	public function readShort ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		
		var value;
		
		if (endian == LITTLE_ENDIAN) {
			
			value = ((ch2 << 8) | ch1);
			
		} else {
			
			value = ((ch1 << 8) | ch2);
			
		}
		
		if ((value & 0x8000) != 0) {
			
			return value - 0x10000;
			
		} else {
			
			return value;
			
		}
		
	}
	
	
	public function readUnsignedByte ():Int {
		
		if (position < __length) {
			
			return get (position++);
			
		} else {
			
			throw  "error";
			return 0;
			
		}
		
	}
	
	
	public function readUnsignedInt ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		
		if (endian == LITTLE_ENDIAN) {
			
			return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;
			
		} else {
			
			return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
			
		}
		
	}
	
	
	public function readUnsignedShort ():Int {
		
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		
		if (endian == LITTLE_ENDIAN) {
			
			return (ch2 << 8) + ch1;
			
		} else {
			
			return (ch1 << 8) | ch2;
			
		}
		
	}
	
	
	public function readUTF ():String {
		
		var bytesCount = readUnsignedShort ();
		return readUTFBytes (bytesCount);
		
	}
	
	
	public function readUTFBytes (length:Int):String {
		
		if (position + length > __length) {
			
			throw  "error";
			
		}
		
		position += length;
		
		return getString (position - length, length);
		
	}
	

	
	public function writeBoolean (value:Bool):Void {
		
		this.writeByte (value ? 1 : 0);
		
	}
	
	
	public function writeByte (value:Int):Void {
		
		__resize (position + 1);
		set (position++, value & 0xFF);
		
	}
	
	
	public function writeBytes (bytes:ByteArray, offset:UInt = 0, length:UInt = 0):Void {
		
		if (bytes.length == 0) return;
		if (length == 0) length = bytes.length - offset;
		
		__resize (position + length);
		blit (position, (bytes:ByteArrayData), offset, length);
		
		position += length;
		
	}
	
	
	public function writeDouble (value:Float):Void {
		
		__resize (position + 8);
		setDouble (position, value);
		position += 8;
		
	}
	
	
	public function writeFloat (value:Float):Void {
		
		__resize (position + 4);
		setFloat (position, value);
		position += 4;
		
	}
	
	
	public function writeInt (value:Int):Void {
		
		__resize (position + 4);
		
		if (endian == LITTLE_ENDIAN) {
			
			set (position++, value);
			set (position++, value >> 8);
			set (position++, value >> 16);
			set (position++, value >> 24);
			
		} else {
			
			set (position++, value >> 24);
			set (position++, value >> 16);
			set (position++, value >> 8);
			set (position++, value);
			
		}
		
	}
	
	
	public function writeMultiByte (value:String, charSet:String):Void {
		
		writeUTFBytes (value);
		
	}
	
	
	public function writeShort (value:Int):Void {
		
		__resize (position + 2);
		
		if (endian == LITTLE_ENDIAN) {
			
			set (position++, value);
			set (position++, value >> 8);
			
		} else {
			
			set (position++, value >> 8);
			set (position++, value);
			
		}
		
	}
	
	
	public function writeUnsignedInt (value:Int):Void {
		
		writeInt (value);
		
	}
	
	
	public function writeUTF (value:String):Void {
		
		var bytes = Bytes.ofString (value);
		
		writeShort (bytes.length);
		writeBytes (bytes);
		
	}
	
	
	public function writeUTFBytes (value:String):Void {
		
		var bytes = Bytes.ofString (value);
		writeBytes (Bytes.ofString (value));
		
	}
	
	
	private function __fromBytes (bytes:Bytes):Void {
		
		__setData (bytes);
		__length = bytes.length;
		
	}
	
	
	private function __resize (size:Int) {
		
		if (size > this.length) {
			
			var bytes = Bytes.alloc (((size + 1) * 3) >> 1);
			bytes.blit (0, this, 0, this.length);
			__setData (bytes);
			
		}
		
		if (__length < size) {
			
			__length = size;
			
		}
		
	}
	
	
	private inline function __setData (bytes:Bytes):Void {
		
		b = bytes.b;
		length = bytes.length;
		#if js
		data = bytes.data;
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private inline function get_bytesAvailable ():Int {
		
		return length - position;
		
	}
	
	
	@:noCompletion private inline function get_endian ():Endian {
		
		return __endian;
		
	}
	
	
	@:noCompletion private inline function set_endian (value:Endian):Endian {
		
		return __endian = value;
		
	}
	
	
}




