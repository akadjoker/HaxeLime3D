package com.gdx.util;

import haxe.io.Bytes;
import haxe.io.BytesData;
import lime.utils.ArrayBuffer;
import lime.utils.Bytes in LimeBytes;
import lime.utils.LZMA;

#if sys
import haxe.zip.Compress;
import haxe.zip.Uncompress;
#elseif format
import format.tools.Inflate;
#end

@:access(haxe.io.Bytes)
@:access(openfl.utils.ByteArrayData)
@:forward(bytesAvailable, endian, objectEncoding, position, clear, compress, deflate, inflate, readBoolean, readByte, readBytes, readDouble, readFloat, readInt, readMultiByte, readShort, readUnsignedByte, readUnsignedInt, readUnsignedShort, readUTF, readUTFBytes, toString, uncompress, writeBoolean, writeByte, writeBytes, writeDouble, writeFloat, writeInt, writeMultiByte, writeShort, writeUnsignedInt, writeUTF, writeUTFBytes)


/**
 * ...
 * @author Luis Santos AKA DJOKER
 */

abstract ByteArray(ByteArrayData) from ByteArrayData to ByteArrayData {
{


	public var bytesAvailable (get, null):Int;
	public var endian (get, set):String;
	#if js
	public var length (default, set):Int = 0;
	#end
	public var objectEncoding:Int;
	public var position:Int = 0;
	
	private var allocated:Int = 0;
	private var littleEndian:Bool = false;
	
	#if js
	public var byteView:UInt8Array;
	private var data:DataView;
	#else
	public var bigEndian (get, set):Bool;
	public var byteLength (get, null):Int;
	#end
	
	
	public function new (size = 0):Void {
		
		#if js
		if (size > 0) allocated = size;
		___resizeBuffer (allocated);
		length = allocated;
		#else
		length = 0;
		if (size > 0) {
			
			#if neko
			allocated = size < 16 ? 16 : size;
			var bytes = untyped __dollar__smake (allocated);
			super (size, bytes);
			#else
			var data = new BytesData (#if java size #end);
			#if cpp
			NativeArray.setSize (data, size);
			#elseif neko
			if (size > 0) untyped data[size - 1] = 0;
			#end
			super (size, data);
			#end
			
		}
		#end
		
	}
	
	
	#if !js
	public function asString ():String {
		
		return readUTFBytes (length);
		
	}
	#end
	
	#if !js
	public function checkData (length:Int) {
		
		if (length + position > this.length) {
			
			ThrowEOFi ();
			
		}
		
	}
	#end
	
	
	public function clear ():Void {
		
		length = 0;
		position = 0;
		
	}
	
	#if !js
	private function ensureElem (size:Int, updateLength:Bool) {
		
		var len = size + 1;
		
		#if neko
		if (allocated < len) {
			
			allocated = ((len + 1) * 3) >> 1;
			var new_b = untyped __dollar__smake (allocated);
			if (b != null) 
				untyped __dollar__sblit (new_b, 0, b, 0, length);
			b = new_b;
			
		}
		#else
		if (b == null)
			b = new BytesData (#if java len #end);
		
		if (b.length < len) {
			
			untyped b.__SetSize (len);
			
		}
		#end
		
		if (updateLength && length < len) {
			
			length = len;
			
		}
		
	}
	#end
	
	
	#if js
	@:extern private inline function ensureWrite (lengthToEnsure:Int):Void {
		
		if (this.length < lengthToEnsure) this.length = lengthToEnsure;
		
	}
	#end
	
	
	public static function fromBytes (bytes:Bytes):ByteArray {
		
		var result = new ByteArray ();
		result.__fromBytes (bytes);
		return result;
		
	}
	
	
	#if !js
	public function getLength ():Int { return length; }
	public function getByteBuffer ():ByteArray { return this; }
	public function getStart ():Int { return 0; }
	#end
	
	
	public inline function readBoolean ():Bool {
		
		#if js
		return (this.readByte () != 0);
		#else
		return (position < length) ? __get (position++) != 0 : ThrowEOFi () != 0;
		#end
		
	}
	
	
	public inline function readByte ():Int {
		
		#if js
		var data:Dynamic = data;
		return data.getInt8 (this.position++);
		#else
		var val:Int = readUnsignedByte ();
		return ((val & 0x80) != 0) ? (val - 0x100) : val;
		#end
		
	}
	
	
	public function readBytes (bytes:ByteArray, offset:Int = 0, length:Int = 0):Void {
		
		#if js
		
		if (offset < 0 || length < 0) {
			
			throw ("Read error - Out of bounds");
			
		}
		
		if (length == 0) length = this.bytesAvailable;
		
		bytes.ensureWrite (offset + length);
		
		bytes.byteView.set (byteView.subarray (this.position, this.position + length), offset);
		bytes.position = offset;
		
		this.position += length;
		if (bytes.position + length > bytes.length) bytes.length = bytes.position + length;
		
		#else
		
		if (length == 0) length = this.length - position;
		if (position + length > this.length) ThrowEOFi ();
		
		if (bytes.length < offset + length) {
			
			bytes.ensureElem (offset + length - 1, true);
			
		}
		
		#if neko
		bytes.blit (offset, this, position, length);
		#else
		var b1 = b;
		var b2 = bytes.b;
		var p = position;
		for (i in 0...length) b2[offset + i] = b1[p + i];
		#end
		
		position += length;
		
		#end
		
	}
	
	
	public function readDouble ():Float {
		
		#if js
		var double = data.getFloat64 (this.position, littleEndian);
		this.position += 8;
		return double;
		#else
		if (position + 8 > length) ThrowEOFi ();
		position += 8;
		return getDouble (position - 8);
		#end
		
	}
	
	
	
	
	public function readFloat ():Float {
		
		#if js
		var float = data.getFloat32 (this.position, littleEndian);
		this.position += 4;
		return float;
		#else
		if (position + 4 > length) ThrowEOFi ();
		position += 4;
		return getFloat (position - 4);
		#end
		
	}
	
	
	public function readInt ():Int {
		
		#if js
		var int = data.getInt32 (this.position, littleEndian);
		this.position += 4;
		return int;
		#else
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		return littleEndian ? (ch4 << 24) |(ch3 << 16) | (ch2 << 8) | ch1 : (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
		#end
		
	}
	
	
	public inline function readMultiByte (length:Int, charSet:String):String {
		
		return readUTFBytes (length);
		
	}
	
	
	public function readShort ():Int {
		
		#if js
		var short = data.getInt16 (this.position, littleEndian);
		this.position += 2;
		return short;
		#else
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var val = littleEndian ? ((ch2 << 8) | ch1) : ((ch1 << 8) | ch2);
		return ((val & 0x8000) != 0) ? (val - 0x10000) : val;
		#end
		
	}
	
	
	public inline function readUnsignedByte ():Int {
		
		#if js
		var data:Dynamic = data;
		return data.getUint8 (this.position++);
		#else
		return (position < length) ? __get (position++) : ThrowEOFi ();
		#end
		
	}
	
	
	public function readUnsignedInt ():Int {
		
		#if js
		var uInt = data.getUint32 (this.position, littleEndian);
		this.position += 4;
		return uInt;
		#else
		var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		var ch3 = readUnsignedByte ();
		var ch4 = readUnsignedByte ();
		return littleEndian ? (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1 : (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
		#end
		
	}
	
	
	public function readUnsignedShort ():Int {
		
		#if js
		var uShort = data.getUint16 (this.position, littleEndian);
		this.position += 2;
		return uShort;
		#else
		 var ch1 = readUnsignedByte ();
		var ch2 = readUnsignedByte ();
		return littleEndian ? (ch2 << 8) + ch1 : (ch1 << 8) | ch2;
		#end
		
	}
	
	
	public function readUTF ():String {
		
		var bytesCount = readUnsignedShort ();
		return readUTFBytes (bytesCount);
		
	}
	
	
	public function readUTFBytes (len:Int):String {
		
		#if js
		
		var value = "";
		var max = this.position + len;
		
		// utf8-encode
		while (this.position < max) {
			
			var data:Dynamic = data;
			var c = data.getUint8 (this.position++);
			
			if (c < 0x80) {
				
				if (c == 0) break;
				value += String.fromCharCode (c);
				
			} else if (c < 0xE0) {
				
				value += String.fromCharCode (((c & 0x3F) << 6) | (data.getUint8 (this.position++) & 0x7F));
				
			} else if (c < 0xF0) {
				
				var c2 = data.getUint8 (this.position++);
				value += String.fromCharCode (((c & 0x1F) << 12) | ((c2 & 0x7F) << 6) | (data.getUint8 (this.position++) & 0x7F));
				
			} else {
				
				var c2 = data.getUint8 (this.position++);
				var c3 = data.getUint8 (this.position++);
				value += String.fromCharCode (((c & 0x0F) << 18) | ((c2 & 0x7F) << 12) | ((c3 << 6) & 0x7F) | (data.getUint8 (this.position++) & 0x7F));
				
			}
			
		}
		
		return value;
		
		#else
		
		if (position + len > length) {
			
			ThrowEOFi ();
			
		}
		
		var p = position;
		position += len;
		
		#if neko
		if (b == null || len == 0) {
			return new String("");
		}
		else {
			return new String (untyped __dollar__ssub (b, p, len));
		}
		#elseif cpp
		var result = "";
		if (b != null && len > 0) {
			untyped __global__.__hxcpp_string_of_bytes (b, result, p, len);
		}
		return result;
		#elseif java
		return getString (p, len);
		#else 
		return "-";
		#end
		
		#end
		
	}
	
	
	#if !js
	public function setLength (length:Int):Void {
		
		if (length > 0)
			ensureElem (length - 1, false);
		this.length = length;
		
	}
	#end
	
	
	#if !js
	public function slice (begin:Int, ?inEnd:Int):ByteArray {
		
		if (begin < 0) {
			
			begin += length;
			if (begin < 0)
				begin = 0;
			
		}
		
		var end:Int = inEnd == null ? length : inEnd;
		
		if (end < 0) {
			
			end += length;
			
			if (end < 0)
				end = 0;
			
		}
		
		if (begin >= end)
			return new ByteArray ();
		
		var result = new ByteArray (end - begin);
		
		var opos = position;
		result.blit (0, this, begin, end - begin);
		
		return result;
		
	}
	#end
	
	
	#if !js
	private function ThrowEOFi ():Int {
		
		throw "new EOFError();";
		return 0;
		
	}
	#end
	
	
	public #if !js override #end function toString ():String {
		
		var cachePosition = position;
		position = 0;
		var value = readUTFBytes (length);
		position = cachePosition;
		return value;
		
	}
	
	private inline function write_uncheck (byte:Int) {
		
		#if !js
		#if cpp
		untyped b.__unsafe_set (position++, byte);
		#elseif neko
		untyped __dollar__sset (b, position++, byte & 0xff);
		#else
		b[position++] = byte & 0xff;
		#end
		#end
		
	}
	
	
	
	private inline function __fromBytes (bytes:Bytes):Void {
		
		#if js
		byteView = untyped __new__("Uint8Array", bytes.getData ());
		length = byteView.length;
		allocated = length;
		#else
		b = bytes.b;
		length = bytes.length;
		#if neko
		allocated = length;
		#end
		#end
		
	}
	
	
	
	
	@:keep public inline function __get (pos:Int):Int {
		
		#if js
		return data.getInt8 (pos);
		#else
		// Neko/cpp pseudo array accessors...
		// No bounds checking is done in the cpp case
		#if cpp
		return untyped b[pos];
		#else
		return get (pos);
		#end
		#end
		
	}
	
	
	#if js
	public inline function __getBuffer () {
		
		return data.buffer;
		
	}
	#end
	
	
	
	
	#if js
	private function __getUTFBytesCount (value:String):Int {
		
		var count:Int = 0;
		// utf8-decode
		
		for (i in 0...value.length) {
			
			var c = StringTools.fastCodeAt (value, i);
			
			if (c <= 0x7F) {
				
				count += 1;
				
			} else if (c <= 0x7FF) {
				
				count += 2;
				
			} else if (c <= 0xFFFF) {
				
				count += 3;
				
			} else {
				
				count += 4;
				
			}
			
		}
		
		return count;
		
	}
	#end
	
	
	#if js
	public static function __ofBuffer (buffer:ArrayBuffer):ByteArray {
		
		var bytes = new ByteArray ();
		#if !display
		bytes.length = bytes.allocated = buffer.byteLength;
		bytes.data = untyped __new__("DataView", buffer);
		bytes.byteView = untyped __new__("Uint8Array", buffer);
		#end
		return bytes;
		
	}
	#end
	
	
	#if js
	private function ___resizeBuffer (len:Int):Void {
		
		var oldByteView:Uint8Array = this.byteView;
		var newByteView:Uint8Array = untyped __new__("Uint8Array", len);
		
		if (oldByteView != null) {
			
			if (oldByteView.length <= len) newByteView.set (oldByteView);
			else newByteView.set (oldByteView.subarray (0, len));
			
		}
		
		this.byteView = newByteView;
		this.data = untyped __new__("DataView", newByteView.buffer);
		
	}
	#end
	
	
	@:keep public inline function __set (pos:Int, v:Int):Void {
		
		#if js
		data.setUint8 (pos, v);
		#else
		// No bounds checking is done in the cpp case
		#if cpp
		untyped b[pos] = v;
		#else
		set (pos, v);
		#end
		#end
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	#if !js
	private inline function get_bigEndian ():Bool { return !littleEndian; }
	private inline function set_bigEndian (value:Bool):Bool { littleEndian = !value; return value; }
	#end
	
	
	private inline function get_bytesAvailable ():Int {
		
		return length - position;
		
	}
	
	
	#if !js
	private function get_byteLength ():Int {
		
		return length;
		
	}
	#end
	
	
	private inline function get_endian ():String {
		
		return littleEndian ? "littleEndian" : "bigEndian";
		
	}
	
	
	private inline function set_endian (endian:String):String {
		
		littleEndian = (endian == "littleEndian");
		return endian;
		
	}
	
	
	private inline function set_length (value:Int):Int {
		
		#if js
		if (allocated < value)
			___resizeBuffer (allocated = Std.int (Math.max (value, allocated * 2)));
		else if (allocated > value * 2)
			___resizeBuffer (allocated = value);
		length = value;
		#end
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
}