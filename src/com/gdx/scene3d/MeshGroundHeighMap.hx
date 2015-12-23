package com.gdx.scene3d;
import com.gdx.gl.MeshBuffer;
import com.gdx.math.Vector3;
import lime.Assets;
import lime.graphics.Image;
import com.gdx.util.ByteArray;


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
class MeshGroundHeighMap extends Mesh

{
	
	
	public function new(url:String,width:Float, height:Float, subdivisions:Int, minHeight:Float, maxHeight:Float) 
	{
		super();
		
		
		    var img:Image = null; 
        
			if (Assets.exists(url)) 
			{
			 img = Assets.getImage(url);
		
		} else 
		{
			trace("Error: Image '" + url + "' doesn't exist !");
			return;
		}
		
		
		
	  
           	
		var surf:MeshBuffer = createSurface();
	
	
		
		
		for (row in 0...subdivisions + 1) 
		{
			for (col in 0...subdivisions + 1) 
			{
				var position = new Vector3((col * width) / subdivisions - (width / 2.0), 0, ((subdivisions - row) * height) / subdivisions - (height / 2.0));
				var normal = new Vector3(0, 1.0, 0);
				
				var heightMapX = Std.int(((position.x + width / 2) / width) * (img.width - 1));
				var heightMapY = Std.int((1.0 - (position.z + height / 2) / height) * (img.height - 1));
				
				var pos = Std.int((heightMapX + heightMapY * img.width) * 4);
				var r:Float;
				var g:Float;
				var b:Float;
				
			

				
				 r = img.data[pos] / 255.0;
				 g = img.data[pos+1] / 255.0;
				 b = img.data[pos+2] / 255.0;
				 
				 
				

				
	
				
				var gradient = r * 0.3 + g * 0.59 + b * 0.11;
				position.y = minHeight + (maxHeight - minHeight) * gradient;
				
				
				
				surf.vert_coords.push(position.x);
				surf.vert_coords.push(position.y);
				surf.vert_coords.push(position.z);
				surf.vert_col.push(1);surf.vert_col.push(1);surf.vert_col.push(1);surf.vert_col.push(1);
				surf.vert_norm.push(normal.x);
				surf.vert_norm.push(normal.y);
				surf.vert_norm.push(normal.z);
			    surf.vert_tex_coords0.push(col / subdivisions);
			    surf.vert_tex_coords0.push(row / subdivisions);
				surf.vert_tex_coords1.push(col / subdivisions);
			    surf.vert_tex_coords1.push( row / subdivisions);
			}
		}
		
		for (row in 0...subdivisions) {
			for (col in 0...subdivisions) {
				surf.tris.push(col + 1 + (row + 1) * (subdivisions + 1));
				surf.tris.push(col + 1 + row * (subdivisions + 1));
				surf.tris.push(col + row * (subdivisions + 1));
				surf.no_tris += 1;
				
				surf.tris.push(col + (row + 1) * (subdivisions + 1));
				surf.tris.push(col + 1 + (row + 1) * (subdivisions + 1));
				surf.tris.push(col + row * (subdivisions + 1));
				surf.no_tris += 1;
			}
		}
		
	surf.reset_vbo = -1;
		
		surf.UpdateVBO();
   
	}
	
	
}