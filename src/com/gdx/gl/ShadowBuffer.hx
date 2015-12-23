package com.gdx.gl;

import com.gdx.Buffer;
import com.gdx.gl.shaders.Shader;
import com.gdx.gl.shaders.ShaderCast;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.utils.Int16Array;
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
class ShadowBuffer extends Buffer
{
	public var vertexBuffer:GLBuffer;
	public var indexBuffer:GLBuffer;
	public var buffer:Float32Array;
	public var tris:Int;
	public function new() 
	{
		super();
		vertexBuffer = GL.createBuffer();
		indexBuffer = GL.createBuffer();
	}
	public function uploadVertex(v:Array<Float>):Void
    {
		    GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
	        GL.bufferData(GL.ARRAY_BUFFER, new Float32Array( v), GL.DYNAMIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
    }
	
	public function uploadIndices(v:Array<Int>):Void
    {
	       GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
           GL.bufferData(GL.ELEMENT_ARRAY_BUFFER,  new Int16Array(v), GL.STATIC_DRAW);
		   GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
		   tris = Std.int(v.length);
		
		   
   }
	public function render(s:ShaderCast):Void
	{
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		GL.enableVertexAttribArray (s.vertexAttribute);
		GL.vertexAttribPointer(s.vertexAttribute, 3, GL.FLOAT, false, 0, 0); 
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		GL.drawElements(GL.TRIANGLES, tris, GL.UNSIGNED_SHORT, 0);
		GL.disableVertexAttribArray (s.vertexAttribute);
		
		
	}
	override public function dispose()
	{
		super.dispose();
		GL.deleteBuffer(vertexBuffer);
		GL.deleteBuffer(indexBuffer );
	}
}