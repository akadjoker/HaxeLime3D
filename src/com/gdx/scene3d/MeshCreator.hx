package com.gdx.scene3d;
import com.gdx.color.Color4;
import com.gdx.gl.material.Material;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.VertexBone;
import com.gdx.math.Matrix;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import com.gdx.scene3d.ms3d.MS3DMaterial;
import com.gdx.scene3d.ms3d.MS3DMesh;
import com.gdx.scene3d.ms3d.MS3DTriangle;
import com.gdx.scene3d.ms3d.MS3DVertex;
import com.gdx.util.Util;
import haxe.io.Path;
import lime.Assets;
import lime.graphics.Image;
import com.gdx.util.ByteArray;
using com.gdx.util.ByteArray;


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
class MeshCreator
{

	public function new() 
	{
		
	}
	 public static function createCone(segments:Int=8, solid:Bool=true):Mesh
	{
		var m:Mesh = new Mesh();
		
		
	var top=0,br=0,bl=0; // side of cone
	var bs0=0,bs1=0,newbs=0; // bottom side vertices

	if(segments<3 || segments>100) return m ;
	
	var thissurf:MeshBuffer = m.createSurface();
	var thissidesurf:MeshBuffer = null;

		
	if (solid )
	{
		thissidesurf = m.createSurface();
	}
	var div:Float=(360.0/segments);

	var height:Float=1.0;
	var upos:Float=1.0;
	var udiv:Float=(1.0/(segments));
	var RotAngle:Float=90.0;

	// first side
	var XPos:Float=-Util.cosdeg(RotAngle);
	var ZPos:Float=Util.sindeg(RotAngle);

	top=thissurf.AddVertex(0.0,height,0.0,upos-(udiv/2.0),0);
	br=thissurf.AddVertex(XPos,-height,ZPos,upos,1);

	// 2nd tex coord set
	thissurf.VertexTexCoords(top,upos-(udiv/2.0),0,0.0,1);
	thissurf.VertexTexCoords(br,upos,1,0.0,1);

	if(solid) bs0=thissidesurf.AddVertex(XPos,-height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);
	if(solid) thissidesurf.VertexTexCoords(bs0,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1); // 2nd tex coord set

	RotAngle=RotAngle+div;

	XPos=-Util.cosdeg(RotAngle);
	ZPos=Util.sindeg(RotAngle);

	bl=thissurf.AddVertex(XPos,-height,ZPos,upos-udiv,1);
	thissurf.VertexTexCoords(bl,upos-udiv,1,0.0,1); // 2nd tex coord set

	if(solid) bs1=thissidesurf.AddVertex(XPos,-height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);
	if(solid) thissidesurf.VertexTexCoords(bs1,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1); // 2nd tex coord set

	thissurf.AddTriangle(bl,top,br);

	// rest of sides
	for (i in 1 ... segments)
	{
		//trace(i);
		br=bl;
		upos=upos-udiv;
		top=thissurf.AddVertex(0.0,height,0.0,upos-(udiv/2.0),0);
		thissurf.VertexTexCoords(top,upos-(udiv/2.0),0,0.0,1); // 2nd tex coord set

		RotAngle=RotAngle+div;

		XPos=-Util.cosdeg(RotAngle);
		ZPos=Util.sindeg(RotAngle);

		bl=thissurf.AddVertex(XPos,-height,ZPos,upos-udiv,1);
		thissurf.VertexTexCoords(bl,upos-udiv,1,0.0,1); // 2nd tex coord set

		if(solid) newbs=thissidesurf.AddVertex(XPos,-height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);
		if(solid) thissidesurf.VertexTexCoords(newbs,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1); // 2nd tex coord set

		thissurf.AddTriangle(bl,top,br);

		if (solid)
		{
			thissidesurf.AddTriangle(newbs,bs1,bs0);

			if(i<(segments-1)){
				bs1=newbs;
			}

		}
	}
	
	if (solid)
		{
	
			thissidesurf.UpdateVBO();
			thissidesurf.CreateBoundingBox(Matrix.Identity());
			}

	
	thissurf.CreateBoundingBox(Matrix.Identity());
		
	return m;

	}
	 public static function createTorus(diameter:Float=5, thickness:Float=1.0, tessellation:Int=10):Mesh
	{
		    var m:Mesh = new Mesh();
			var surf:MeshBuffer = m.createSurface();
	
		   var stride = tessellation + 1;

        for (i in 0...tessellation + 1)
		{
            var u:Float = i / tessellation;

            var outerAngle:Float = i * Math.PI * 2.0 / tessellation - Math.PI / 2.0;

            var transform = Matrix.Translation(diameter / 2.0, 0, 0).multiply(Matrix.RotationY(outerAngle));

			
			
	
            for (j in 0...tessellation+1) {
                var v = 1 - j / tessellation;

                var innerAngle = j * Math.PI * 2.0 / tessellation + Math.PI;
                var dx = Math.cos(innerAngle);
                var dy = Math.sin(innerAngle);

                // Create a vertex.
                var normal = new Vector3(dx, dy, 0);
                var position:Vector3 = normal.scale(thickness / 2);
                var textureCoordinate = new Vector2(u, v);

                 position = Vector3.TransformCoordinates(position, transform);
                 normal = Vector3.TransformNormal(normal, transform);

		
                surf.vert_coords.push(position.x);
				surf.vert_coords.push(position.y);
				surf.vert_coords.push(position.z);
				surf.vert_col.push(1);surf.vert_col.push(1);surf.vert_col.push(1);surf.vert_col.push(1);
                surf.vert_norm.push(normal.x);
				surf.vert_norm.push(normal.y);
				surf.vert_norm.push(normal.z);
                surf.vert_tex_coords0.push(-textureCoordinate.x);
				surf.vert_tex_coords0.push(textureCoordinate.y);
                surf.vert_tex_coords1.push(-textureCoordinate.x);
				surf.vert_tex_coords1.push(textureCoordinate.y);
				surf.no_verts += 1;
		
			
                // And create indices for two triangles.
                var nextI = (i + 1) % stride;
                var nextJ = (j + 1) % stride;

		
                surf.tris.push(i * stride + j);
                surf.tris.push(i * stride + nextJ);
                surf.tris.push(nextI * stride + j);
				surf.no_tris += 1;

                surf.tris.push(i * stride + nextJ);
                surf.tris.push(nextI * stride + nextJ);
                surf.tris.push(nextI * stride + j);
				surf.no_tris += 1;
				
            }
        }

      
		
	
		surf.UpdateVBO();
		surf.CreateBoundingBox(Matrix.Identity());
		return m;
	}
	
		 public static function createSphere(segments:Int = 8):Mesh
	{
		var m:Mesh = new Mesh();
		
			if(segments<3 || segments>100) return m;

	var thissurf = m.createSurface();
		
	
	var div:Float=360.0/(segments*2);
	var height:Float=1.0;
	var upos:Float=1.0;
	var udiv:Float=1.0/(segments*2);
	var vdiv:Float=1.0/segments;
	var RotAngle:Float=90;

	if(segments<3){ // diamond shape - no center strips

		for ( i in 1 ... segments * 2)
		{
			var np:Int=thissurf.AddVertex(0.0,height,0.0,upos-(udiv/2.0),0);//northpole
			var sp:Int=thissurf.AddVertex(0.0,-height,0.0,upos-(udiv/2.0),1);//southpole
			var XPos:Float=-Util.cosdeg(RotAngle);
			var ZPos:Float=Util.sindeg(RotAngle);
			var v0:Int=thissurf.AddVertex(XPos,0,ZPos,upos,0.5);
			RotAngle=RotAngle+div;
			if(RotAngle>=360.0) RotAngle=RotAngle-360.0;
			XPos=-Util.cosdeg(RotAngle);
			ZPos=Util.sindeg(RotAngle);
			upos=upos-udiv;
			var v1:Int=thissurf.AddVertex(XPos,0,ZPos,upos,0.5);
			thissurf.AddTriangle(np,v0,v1);
			thissurf.AddTriangle(v1,v0,sp);
		}

	}

	if (segments > 2)
	{

		// poles first
		for ( i in 1 ... (segments) * 2+1)
		{
			//trace(i);

			var np:Int=thissurf.AddVertex(0.0,height,0.0,upos-(udiv/2.0),0);//northpole
			var sp:Int=thissurf.AddVertex(0.0,-height,0.0,upos-(udiv/2.0),1);//southpole

			var YPos:Float=Util.cosdeg(div);

			var XPos:Float=-Util.cosdeg(RotAngle)*(Util.sindeg(div));
			var ZPos:Float=Util.sindeg(RotAngle)*(Util.sindeg(div));

			var v0t:Int=thissurf.AddVertex(XPos,YPos,ZPos,upos,vdiv);
			var v0b:Int=thissurf.AddVertex(XPos,-YPos,ZPos,upos,1-vdiv);

			RotAngle=RotAngle+div;

			XPos=-Util.cosdeg(RotAngle)*(Util.sindeg(div));
			ZPos=Util.sindeg(RotAngle)*(Util.sindeg(div));

			upos=upos-udiv;

			var v1t:Int=thissurf.AddVertex(XPos,YPos,ZPos,upos,vdiv);
			var v1b:Int=thissurf.AddVertex(XPos,-YPos,ZPos,upos,1-vdiv);

			thissurf.AddTriangle(np,v0t,v1t);
			thissurf.AddTriangle(v1b,v0b,sp);

		}

		// then center strips

		upos=1.0;
		RotAngle=90;
		for ( i in 1 ... segments * 2 +1 )
		{

		//	trace(i);
			
			var mult:Float=1;
			var YPos:Float=Util.cosdeg(div*(mult));
			var YPos2:Float=Util.cosdeg(div*(mult+1.0));
			var Thisvdiv:Float=vdiv;

				for ( j in 1 ... segments-1 )
		{

		
				var XPos:Float=-Util.cosdeg(RotAngle)*(Util.sindeg(div*(mult)));
				var ZPos:Float=Util.sindeg(RotAngle)*(Util.sindeg(div*(mult)));

				var XPos2:Float=-Util.cosdeg(RotAngle)*(Util.sindeg(div*(mult+1.0)));
				var ZPos2:Float=Util.sindeg(RotAngle)*(Util.sindeg(div*(mult+1.0)));

				var v0t:Int=thissurf.AddVertex(XPos,YPos,ZPos,upos,Thisvdiv);
				var v0b:Int=thissurf.AddVertex(XPos2,YPos2,ZPos2,upos,Thisvdiv+vdiv);

				// 2nd tex coord set
				thissurf.VertexTexCoords(v0t,upos,Thisvdiv,0.0,1);
				thissurf.VertexTexCoords(v0b,upos,Thisvdiv+vdiv,0.0,1);

				var tempRotAngle:Float=RotAngle+div;

				XPos=-Util.cosdeg(tempRotAngle)*(Util.sindeg(div*(mult)));
				ZPos=Util.sindeg(tempRotAngle)*(Util.sindeg(div*(mult)));

				XPos2=-Util.cosdeg(tempRotAngle)*(Util.sindeg(div*(mult+1.0)));
				ZPos2=Util.sindeg(tempRotAngle)*(Util.sindeg(div*(mult+1.0)));

				var temp_upos=upos-udiv;

				var v1t:Int=thissurf.AddVertex(XPos,YPos,ZPos,temp_upos,Thisvdiv);
				var v1b:Int=thissurf.AddVertex(XPos2,YPos2,ZPos2,temp_upos,Thisvdiv+vdiv);

				// 2nd tex coord set
				thissurf.VertexTexCoords(v1t,temp_upos,Thisvdiv,0.0,1);
				thissurf.VertexTexCoords(v1b,temp_upos,Thisvdiv+vdiv,0.0,1);

				thissurf.AddTriangle(v1t,v0t,v0b);
				thissurf.AddTriangle(v1b,v1t,v0b);

				Thisvdiv=Thisvdiv+vdiv;
				mult=mult+1;

				YPos=Util.cosdeg(div*(mult));
				YPos2=Util.cosdeg(div*(mult+1.0));

			}

			upos=upos-udiv;
			RotAngle=RotAngle+div;

		}

	}
	
	thissurf.CreateBoundingBox(Matrix.Identity());
		
		return m;
	}
	 public static function createPlane(y:Float,w:Float=1000,d:Float=1000):Mesh
	{
		var m:Mesh = new Mesh();
		var surf:MeshBuffer = m.createSurface();
			 
	surf.AddVertex(-w,y,-d);
	surf.AddVertex(-w,y, d);
	surf.AddVertex( w,y, d);
	surf.AddVertex( w,y,-d);


	surf.VertexNormal(0,0.0,0.0,-1.0);
	surf.VertexNormal(1,0.0,0.0,-1.0);
	surf.VertexNormal(2,0.0,0.0,-1.0);
	surf.VertexNormal(3,0.0,0.0,-1.0);
	
	surf.VertexTexCoords(0,0.0,1.0,0.0,0);
	surf.VertexTexCoords(1,0.0,0.0,0.0,0);
	surf.VertexTexCoords(2,1.0,0.0,0.0,0);
	surf.VertexTexCoords(3,1.0,1.0,0.0,0);

		
	surf.VertexTexCoords(0,0.0,1.0,0.0,1);
	surf.VertexTexCoords(1,0.0,0.0,0.0,1);
	surf.VertexTexCoords(2,1.0,0.0,0.0,1);
	surf.VertexTexCoords(3,1.0, 1.0, 0.0, 1);
	
	surf.AddTriangle(0,1,2); // front
	surf.AddTriangle(0, 2, 3);
	
	
	surf.CreateBoundingBox(Matrix.Identity());
	surf.UpdateVBO();
	return m;
	
	}
	 public static function createGround(width:Float, height:Float, subdivisions:Int):Mesh
	{
		var m:Mesh = new Mesh();
		var surf:MeshBuffer = m.createSurface();
	
	
		//surf.primitiveType = Gdx.GLLINE_LOOP;
		
		for (row in 0...subdivisions + 1) 
		{
			for (col in 0...subdivisions + 1) 
			{
				var position = new Vector3((col * width) / subdivisions - (width / 2.0), 0, ((subdivisions - row) * height) / subdivisions - (height / 2.0));
				var normal = new Vector3(0, 1.0, 0);
				
				
				surf.vert_coords.push(position.x);
				surf.vert_coords.push(position.y);
				surf.vert_coords.push(position.z);
				surf.vert_col.push(1);surf.vert_col.push(1);surf.vert_col.push(1);surf.vert_col.push(1);
				surf.vert_norm.push(normal.x);
				surf.vert_norm.push(normal.y);
				surf.vert_norm.push(normal.z);
			    surf.vert_tex_coords0.push(col / subdivisions);
			    surf.vert_tex_coords0.push(1.0 - row / subdivisions);
				surf.vert_tex_coords1.push(col / subdivisions);
			    surf.vert_tex_coords1.push(1.0 - row / subdivisions);
				surf.no_verts += 1;
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
	surf.CreateBoundingBox(Matrix.Identity());
	return m;
	
	}
	 public static function createGrid(x_seg:Int,y_seg:Int, repeat_tex:Bool=false):Mesh
	{
		var m:Mesh = new Mesh();
		var surf:MeshBuffer = m.createSurface();
		
		var yhalf:Int = Std.int(y_seg * 0.5);
		var xhalf:Int = Std.int(x_seg * 0.5);
		var txstep = 1.0 / x_seg;
		var tystep = -1.0 / y_seg;
		
		var texx:Float = 0.0;
		var texy:Float = 1.0;
		var  v0, v1, v2, v3:Int = 0;
		v0 = 0;
		v1 = 0;
		v2 = 0;
		v3 = 0;
		
		var pv2:Array<Int> = new Array<Int>();
		var qv2:Array<Int> = new Array<Int>();
		if (!repeat_tex)
		{
			for ( y in  -yhalf ... yhalf  )
			{
				v0 = surf.AddVertex( -xhalf - 0.5, 0.0, y - 0.5);
				v1 = surf.AddVertex( -xhalf - 0.5, 0.0, y + 0.5);	

				for ( x in  -xhalf ... xhalf  )
				{
					
					if (x != -xhalf)  
					{
					v1 = v2; 
					v0 = v3;
					}
					if (y == -yhalf)
					{
						
						v3 = surf.AddVertex( x + 0.5, 0.0, y - 0.5);
	
					} else
					{
						v3 = pv2[xhalf + x];
										
					}
					
					v2 = surf.AddVertex( x + 0.5, 0.0, y + 0.5);
					qv2[xhalf + x] = v2;
					
				
					surf.VertexNormal(v0, 0.0, 1.0, 0.0);
					surf.VertexNormal(v1, 0.0, 1.0, 0.0);
					surf.VertexNormal(v2, 0.0, 1.0, 0.0);
					surf.VertexNormal(v3, 0.0, 1.0, 0.0);
					surf.VertexTexCoords(v0, texx, texy);
					surf.VertexTexCoords(v1, texx, texy + tystep);
					surf.VertexTexCoords(v2, texx + txstep, texy + tystep);
					surf.VertexTexCoords(v3, texx + txstep, texy);
					
					surf.VertexTexCoords(v0, texx, texy,0,1);
					surf.VertexTexCoords(v1, texx, texy + tystep,0,1);
					surf.VertexTexCoords(v2, texx + txstep, texy + tystep,0,1);
					surf.VertexTexCoords(v3, texx + txstep, texy,0,1);		
					
					surf.AddTriangle(v0, v1, v2);
					surf.AddTriangle(v0, v2, v3);
					
		//		trace( "tx " + texx + " " + texy + " " + (texx + txstep) + " " + (texy + tystep) + " :: " + txstep + " " + tystep			);
		
					texx += txstep;
					
					if (texx > 1.0)  texx = 0.0;
		
				}
				
				for (i in 0... x_seg)
				{
					pv2[i]  = qv2[i];
				}
				//qv2 = New Int[x_seg+1]
				
				texx = 0.0;
				texy += tystep;
				
				if (texy < 0.0)  texy = 1.0;


			}

			
		} else
		{
			for ( y in  -yhalf ... yhalf )
			{
			
				for ( x in  -xhalf ... xhalf  )
				{
								
					v0 = surf.AddVertex( x - 0.5, 0.0, y - 0.5);
					v1 = surf.AddVertex( x - 0.5, 0.0, y + 0.5);
					v2 = surf.AddVertex( x + 0.5, 0.0, y + 0.5);
					v3 = surf.AddVertex( x + 0.5, 0.0, y - 0.5);
					surf.VertexNormal(v0, 0.0, 1.0, 0.0);
					surf.VertexNormal(v1, 0.0, 1.0, 0.0);
					surf.VertexNormal(v2, 0.0, 1.0, 0.0);
					surf.VertexNormal(v3, 0.0, 1.0, 0.0);
					surf.VertexTexCoords(v0, 0.0, 0.0);
					surf.VertexTexCoords(v1, 0.0, 1.0);
					surf.VertexTexCoords(v2, 1.0, 1.0);
					surf.VertexTexCoords(v3, 1.0, 0.0);
					surf.VertexTexCoords(v0, 0.0, 0.0,0,1);
					surf.VertexTexCoords(v1, 0.0, 1.0,0,1);
					surf.VertexTexCoords(v2, 1.0, 1.0,0,1);
					surf.VertexTexCoords(v3, 1.0, 0.0,0,1);
					surf.AddTriangle(v0, v1, v2);
					surf.AddTriangle(v0, v2, v3);

				}
			}
		}

		  
			surf.UpdateVBO();
			surf.CreateBoundingBox(Matrix.Identity());
			return m;
	}
	 public static function createCube():Mesh
	{
		var m:Mesh = new Mesh();
		var surf = m.createSurface();
		
	surf.AddVertex(-1.0,-1.0,-1.0);
	surf.AddVertex(-1.0, 1.0,-1.0);
	surf.AddVertex( 1.0, 1.0,-1.0);
	surf.AddVertex( 1.0,-1.0,-1.0);
	
	surf.AddVertex(-1.0,-1.0, 1.0);
	surf.AddVertex(-1.0, 1.0, 1.0);
	surf.AddVertex( 1.0, 1.0, 1.0);
	surf.AddVertex( 1.0,-1.0, 1.0);
	
	surf.AddVertex(-1.0,-1.0, 1.0);
	surf.AddVertex(-1.0, 1.0, 1.0);
	surf.AddVertex( 1.0, 1.0, 1.0);
	surf.AddVertex( 1.0,-1.0, 1.0);
	
	surf.AddVertex(-1.0,-1.0,-1.0);
	surf.AddVertex(-1.0, 1.0,-1.0);
	surf.AddVertex( 1.0, 1.0,-1.0);
	surf.AddVertex( 1.0,-1.0,-1.0);
	
	surf.AddVertex(-1.0,-1.0, 1.0);
	surf.AddVertex(-1.0, 1.0, 1.0);
	surf.AddVertex( 1.0, 1.0, 1.0);
	surf.AddVertex( 1.0,-1.0, 1.0);
	
	surf.AddVertex(-1.0,-1.0,-1.0);
	surf.AddVertex(-1.0, 1.0,-1.0);
	surf.AddVertex( 1.0, 1.0,-1.0);
	surf.AddVertex( 1.0,-1.0,-1.0);
	
	surf.VertexNormal(0,0.0,0.0,-1.0);
	surf.VertexNormal(1,0.0,0.0,-1.0);
	surf.VertexNormal(2,0.0,0.0,-1.0);
	surf.VertexNormal(3,0.0,0.0,-1.0);
	
	surf.VertexNormal(4,0.0,0.0,1.0);
	surf.VertexNormal(5,0.0,0.0,1.0);
	surf.VertexNormal(6,0.0,0.0,1.0);
	surf.VertexNormal(7,0.0,0.0,1.0);
	
	surf.VertexNormal(8,0.0,-1.0,0.0);
	surf.VertexNormal(9,0.0,1.0,0.0);
	surf.VertexNormal(10,0.0,1.0,0.0);
	surf.VertexNormal(11,0.0,-1.0,0.0);
	
	surf.VertexNormal(12,0.0,-1.0,0.0);
	surf.VertexNormal(13,0.0,1.0,0.0);
	surf.VertexNormal(14,0.0,1.0,0.0);
	surf.VertexNormal(15,0.0,-1.0,0.0);
	
	surf.VertexNormal(16,-1.0,0.0,0.0);
	surf.VertexNormal(17,-1.0,0.0,0.0);
	surf.VertexNormal(18,1.0,0.0,0.0);
	surf.VertexNormal(19,1.0,0.0,0.0);
	
	surf.VertexNormal(20,-1.0,0.0,0.0);
	surf.VertexNormal(21,-1.0,0.0,0.0);
	surf.VertexNormal(22,1.0,0.0,0.0);
	surf.VertexNormal(23,1.0,0.0,0.0);
	
	surf.VertexTexCoords(0,0.0,1.0,0.0,0);
	surf.VertexTexCoords(1,0.0,0.0,0.0,0);
	surf.VertexTexCoords(2,1.0,0.0,0.0,0);
	surf.VertexTexCoords(3,1.0,1.0,0.0,0);
	
	surf.VertexTexCoords(4,1.0,1.0,0.0,0);
	surf.VertexTexCoords(5,1.0,0.0,0.0,0);
	surf.VertexTexCoords(6,0.0,0.0,0.0,0);
	surf.VertexTexCoords(7,0.0,1.0,0.0,0);
	
	surf.VertexTexCoords(8,0.0,1.0,0.0,0);
	surf.VertexTexCoords(9,0.0,0.0,0.0,0);
	surf.VertexTexCoords(10,1.0,0.0,0.0,0);
	surf.VertexTexCoords(11,1.0,1.0,0.0,0);
	
	surf.VertexTexCoords(12,0.0,0.0,0.0,0);
	surf.VertexTexCoords(13,0.0,1.0,0.0,0);
	surf.VertexTexCoords(14,1.0,1.0,0.0,0);
	surf.VertexTexCoords(15,1.0,0.0,0.0,0);
	
	surf.VertexTexCoords(16,0.0,1.0,0.0,0);
	surf.VertexTexCoords(17,0.0,0.0,0.0,0);
	surf.VertexTexCoords(18,1.0,0.0,0.0,0);
	surf.VertexTexCoords(19,1.0,1.0,0.0,0);
	
	surf.VertexTexCoords(20,1.0,1.0,0.0,0);
	surf.VertexTexCoords(21,1.0,0.0,0.0,0);
	surf.VertexTexCoords(22,0.0,0.0,0.0,0);
	surf.VertexTexCoords(23,0.0,1.0,0.0,0);
	
	surf.VertexTexCoords(0,0.0,1.0,0.0,1);
	surf.VertexTexCoords(1,0.0,0.0,0.0,1);
	surf.VertexTexCoords(2,1.0,0.0,0.0,1);
	surf.VertexTexCoords(3,1.0,1.0,0.0,1);
	
	surf.VertexTexCoords(4,1.0,1.0,0.0,1);
	surf.VertexTexCoords(5,1.0,0.0,0.0,1);
	surf.VertexTexCoords(6,0.0,0.0,0.0,1);
	surf.VertexTexCoords(7,0.0,1.0,0.0,1);
	
	surf.VertexTexCoords(8,0.0,1.0,0.0,1);
	surf.VertexTexCoords(9,0.0,0.0,0.0,1);
	surf.VertexTexCoords(10,1.0,0.0,0.0,1);
	surf.VertexTexCoords(11,1.0,1.0,0.0,1);
	
	surf.VertexTexCoords(12,0.0,0.0,0.0,1);
	surf.VertexTexCoords(13,0.0,1.0,0.0,1);
	surf.VertexTexCoords(14,1.0,1.0,0.0,1);
	surf.VertexTexCoords(15,1.0,0.0,0.0,1);
	
	surf.VertexTexCoords(16,0.0,1.0,0.0,1);
	surf.VertexTexCoords(17,0.0,0.0,0.0,1);
	surf.VertexTexCoords(18,1.0,0.0,0.0,1);
	surf.VertexTexCoords(19,1.0,1.0,0.0,1);
	
	surf.VertexTexCoords(20,1.0,1.0,0.0,1);
	surf.VertexTexCoords(21,1.0,0.0,0.0,1);
	surf.VertexTexCoords(22,0.0,0.0,0.0,1);
	surf.VertexTexCoords(23,0.0,1.0,0.0,1);
	
	surf.AddTriangle(0,1,2); // front
	surf.AddTriangle(0,2,3);
	surf.AddTriangle(6,5,4); // back
	surf.AddTriangle(7,6,4);
	surf.AddTriangle(6+8,5+8,1+8); // top
	surf.AddTriangle(2+8,6+8,1+8);
	surf.AddTriangle(0+8,4+8,7+8); // bottom
	surf.AddTriangle(0+8,7+8,3+8);
	surf.AddTriangle(6+16,2+16,3+16); // right
	surf.AddTriangle(7+16,6+16,3+16);
	surf.AddTriangle(0+16,1+16,5+16); // left
	surf.AddTriangle(0 + 16, 5 + 16, 4 + 16);
	
	surf.UpdateVBO();
	surf.CreateBoundingBox(Matrix.Identity());

	
	return m;
	}
	 public static function createCylinder(verticalsegments:Int = 8, solid:Bool=true) :Mesh
	{
		var m:Mesh = new Mesh();
		
			
	var ringsegments:Int=0; // default?

	var tr:Int = 0;
	var tl:Int = 0;
	var br:Int = 0;
	var bl:Int = 0;// 		side of cylinder
	var ts0:Int = 0;
	var ts1:Int = 0;
	var newts:Int = 0;// 	top side vertexs
	var bs0:Int = 0;
	var bs1 :Int= 0;
	var newbs:Int = 0;// 	bottom side vertexs
	
	if (verticalsegments<3 || verticalsegments>100) return m;
	if (ringsegments<0 || ringsegments>100) return m;

	var thissurf:MeshBuffer = m.createSurface();

	
	
	var div:Float =  (360.0 / verticalsegments);

	var height:Float=1.0;
	var ringSegmentHeight:Float=(height*2.0)/(ringsegments+1);
	var upos:Float=1.0;
	var udiv:Float=1.0/(verticalsegments);
	var vdiv:Float = 1.0 / (ringsegments + 1);
	
//	trace (div + "," + udiv + "," + vdiv);

	var SideRotAngle:Float=90.0;

	// re-diminsion arrays to hold needed memory.
	// this is used just for helping to build the ring segments...

	var tRing:Array<Int> = new Array<Int>();
	var bRing:Array<Int> = new Array<Int>();

	// render end caps if solid
	if (solid )
	{

     	var thissidesurf:MeshBuffer = m.createSurface();
 
		var XPos:Float=-Util.cosdeg(SideRotAngle);
		var ZPos:Float=Util.sindeg(SideRotAngle);

		 ts0=thissidesurf.AddVertex(XPos,height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);
		 bs0=thissidesurf.AddVertex(XPos,-height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);

		// 2nd tex coord set
		thissidesurf.VertexTexCoords(ts0,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1);
		thissidesurf.VertexTexCoords(bs0,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1);

		SideRotAngle=SideRotAngle+div;

		XPos=-Util.cosdeg(SideRotAngle);
		ZPos=Util.sindeg(SideRotAngle);

		ts1=thissidesurf.AddVertex(XPos,height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);
		bs1=thissidesurf.AddVertex(XPos,-height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);

		// 2nd tex coord set
		thissidesurf.VertexTexCoords(ts1,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1);
		thissidesurf.VertexTexCoords(bs1,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1);

		for ( i in 1...verticalsegments-1 )
		{
		
			SideRotAngle=SideRotAngle+div;

			XPos=-Util.cosdeg(SideRotAngle);
			ZPos=Util.sindeg(SideRotAngle);

			newts=thissidesurf.AddVertex(XPos,height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);
			newbs=thissidesurf.AddVertex(XPos,-height,ZPos,XPos/2.0+0.5,ZPos/2.0+0.5);

			// 2nd tex coord set
			thissidesurf.VertexTexCoords(newts,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1);
			thissidesurf.VertexTexCoords(newbs,XPos/2.0+0.5,ZPos/2.0+0.5,0.0,1);

			thissidesurf.AddTriangle(ts0,ts1,newts);
			thissidesurf.AddTriangle(newbs,bs1,bs0);

			if (i < (verticalsegments-2 ))
			{
				ts1=newts;
				bs1 = newbs;
		
			}

		}
		
			  thissidesurf.UpdateVBO();
			  thissidesurf.CreateBoundingBox(Matrix.Identity());
			
	}

	// -----------------------
	// middle part of cylinder
	var thisHeight:Float=height;

	// top ring first
	SideRotAngle=90.0;
	var XPos:Float=-Util.cosdeg(SideRotAngle);
	var ZPos:Float=Util.sindeg(SideRotAngle);
	var thisUPos:Float=upos;
	var thisVPos:Float=0.0;
	tRing[0]=thissurf.AddVertex(XPos,thisHeight,ZPos,thisUPos,thisVPos);
	thissurf.VertexTexCoords(tRing[0],thisUPos,thisVPos,0.0,1); // 2nd tex coord set
	for ( i in 0 ... verticalsegments)
	{
		SideRotAngle=SideRotAngle+div;
		XPos=-Util.cosdeg(SideRotAngle);
		ZPos=Util.sindeg(SideRotAngle);
		thisUPos=thisUPos-udiv;
		tRing[i+1]=thissurf.AddVertex(XPos,thisHeight,ZPos,thisUPos,thisVPos);
		thissurf.VertexTexCoords(tRing[i + 1], thisUPos, thisVPos, 0.0, 1); // 2nd tex coord set
    //   trace(i);
	}

	for ( ring in 0 ... Std.int(ringsegments + 1))
	{
		
  
		// decrement vertical segment
		thisHeight=thisHeight-ringSegmentHeight;

		// now bottom ring
		SideRotAngle=90;
		XPos=-Util.cosdeg(SideRotAngle);
		ZPos=Util.sindeg(SideRotAngle);
		thisUPos=upos;
		thisVPos=thisVPos+vdiv;
		bRing[0]=thissurf.AddVertex(XPos,thisHeight,ZPos,thisUPos,thisVPos);
		thissurf.VertexTexCoords(bRing[0],thisUPos,thisVPos,0.0,1); // 2nd tex coord set
		for ( i in 0 ... verticalsegments)
		{
			SideRotAngle=SideRotAngle+div;
			XPos=-Util.cosdeg(SideRotAngle);
			ZPos=Util.sindeg(SideRotAngle);
			thisUPos=thisUPos-udiv;
			bRing[i+1]=thissurf.AddVertex(XPos,thisHeight,ZPos,thisUPos,thisVPos);
			thissurf.VertexTexCoords(bRing[i + 1], thisUPos, thisVPos, 0.0, 1); // 2nd tex coord set
		//	trace(i);
		}

		// Fill in ring segment sides with triangles
		for (v in 1 ... verticalsegments+1)
		{
			tl=tRing[v];
			tr=tRing[v-1];
			bl=bRing[v];
			br=bRing[v-1];

				
			thissurf.AddTriangle(tl,tr,br);
			thissurf.AddTriangle(bl, tl, br);
		
		}

		// make bottom ring segment the top ring segment for the next loop.
		for ( v in 0 ... verticalsegments+1)
		{
			tRing[v] = bRing[v];
		}
	}

	 tRing = [];
	 bRing = [];


	
    thissurf.UpdateVBO();
	
	thissurf.CreateBoundingBox(Matrix.Identity());
	return m;

		
	}
	
	 public static function createMeshGroundHeighMap(url:String,width:Float, height:Float, subdivisions:Int, minHeight:Float, maxHeight:Float) :Mesh
	{
		var m:Mesh = new Mesh();
		
		    var img:Image = null; 
       	if (Assets.exists(url)) 
		{
			 img = Assets.getImage(url);
		
		} 
		else 
		{
			trace("Error: Image '" + url + "' doesn't exist !");
			return createCube();
		}
		
	//	m.setShader(Gdx.SHADERDETAIL);

	
		var surf:MeshBuffer = m.createSurface();
	
		
	
		
		
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
				
				surf.material.materialType = Gdx.MaterialDetailMap;
				
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
		surf.CreateBoundingBox(Matrix.Identity());
		return m;
	}


	 public static function loadStaticH3DMesh(f:String,path:String) :Mesh
	{	
        var mesh:Mesh = new Mesh();
      	var textures:Array<String> = [];
		var  materials:Array<Material> = [];
		
		
		mesh.setShader(Gdx.SHADERDEFAULT);
		

		var file:ByteArray =	Util.getBytes(f);
	
        if (file.bytesAvailable <= 0) return createCube();
	    file.position = 0;
		
	
		
		var  hSize:Int = file.readInt();
		var header:String = file.readUTFBytes(hSize);
		var id:Int = file.readInt();
		
		var numMaterials:Int = file.readInt();
		
		var brushes:Map<Int,Material> = new Map<Int,Material>();
		
			for (i in 0 ... numMaterials)
		{
			
			var  flags:Int = file.readInt();//
			var brush:Material = new Material();
			
			var r = file.readFloat();
			var g = file.readFloat();
			var b = file.readFloat();
			var alpha = file.readFloat();
			brush.DiffuseColor.set(r, g, b);
			brush.alpha = alpha;
			brush.materialId = i;
			
			var  nameSize:Int = file.readInt();
			if (nameSize >= 255) 
			{
				trace("ERROR:file dont match -"+nameSize+" color texture");
			
			}
			var filename:String = file.readUTFBytes(nameSize);
			
			var  texture:String = Path.withoutDirectory(filename);
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
			
			
			
			
			if (Assets.exists(path  + texture))
			{
				
		    brush.setTexture( Gdx.Instance().getTexture(path  + texture),0);
			} else
			{
				trace("ERROR : dont find "+path  + texture+" color texture");
				
			}
			
			//****************
			
			//detail texture
			var  useDetail:Int = file.readInt();
			if (useDetail >= 1)
			{
			  var  nameSize:Int = file.readInt();
		  	var filename:String=file.readUTFBytes(nameSize);
			var  texture:String = Path.withoutDirectory(filename);
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
			
				  
		     if (Assets.exists(path  + texture))
			{
		     brush.setTexture( Gdx.Instance().getTexture(path  + texture, true),1);
			} else
			{
				trace("ERROR : dont find"+path  + texture+" detail texture");
				
			}
			}
			
		
			brushes.set(i, brush);
	    }
		
	
		
		       
				
				
		var  countMeshs:Int = file.readInt();
	
	    for (i in 0 ... countMeshs)
		{

			var  nameSize:Int = file.readInt();//
			var name:String = file.readUTFBytes(nameSize);
			var  flags:Int = file.readInt();//
			var surf:MeshBuffer = mesh.createSurface();
			surf.materialIndex = file.readInt();
			var numVertices:Int=file.readInt();
			var numFaces:Int=file.readInt();
			var numUVCoords:Int = file.readInt();
	
			var b = brushes.get(surf.materialIndex);
			surf.material.clone(b);
		//	surf.material.setTexture(Gdx.Instance().getTexture("dummy"), 0);
			
			
		
			
        var Pos:Vector3 = Vector3.Zero();
		var Normal:Vector3 = Vector3.Zero();
		var TCoords0:Vector2 = Vector2.Zero();
		var TCoords1:Vector2 = Vector2.Zero();
			
			for (x in 0...numVertices)
			{
			
				
				Pos.x = file.readFloat();
				Pos.y = file.readFloat();
				Pos.z = file.readFloat();
				
				
			
				Normal.x = file.readFloat();
				Normal.y = file.readFloat();
				Normal.z = file.readFloat();
		
				
				TCoords0.x = file.readFloat();
				TCoords0.y =1*- file.readFloat();
			if (numUVCoords == 2)
			{
					TCoords1.x = file.readFloat();
				    TCoords1.y =1*- file.readFloat();
					surf.AddFullVertex(Pos.x, Pos.y, Pos.z, Normal.x,  Normal.y,  Normal.z,  TCoords0.x, TCoords0.y, TCoords1.x, TCoords1.y);

			} else
			{
			surf.AddFullVertex(Pos.x, Pos.y, Pos.z, Normal.x,  Normal.y,  Normal.z,  TCoords0.x, TCoords0.y, TCoords0.x, TCoords0.y);
			}
			
			
		
		}
		
		
		
			
			for (x in 0...numFaces)
			{
				var v0:Int = file.readInt();
				var v1:Int = file.readInt();
				var v2:Int = file.readInt();
	    		surf.AddTriangle(v0, v1, v2);
			}
	
		
		 surf.CreateBoundingBox(Matrix.Identity());	
	     surf.UpdateVBO();
		}
		
		//var numBones:Int = file.readInt();
		//trace("Num of bones:"+numBones);
		
	
		mesh.sortMaterial();

		brushes = null;
		file = null;
        textures = null;

		return mesh;
		
	
	}
	
	//*****************************
		 public static function loadStaticB3DMesh(f:String,path:String) :Mesh
	{	
      
 var  file:ByteArray =	Util.getBytes(f);
 if (file.bytesAvailable <= 0) return createCube();

		
 var b3d_tos:Int=0;
 var b3d_stack:Array<Int> = [];
 var textures:Array<String> = [];
 var brushes:Array<Material> = new Array<Material>();
 var listVertex:Array<VertexBone> = [];

 var m:Mesh = new Mesh();
 
 var AnimatedVertices_VertexID:Array<Int> = [];
 var AnimatedVertices_BufferID:Array<Int> = [];
 
 var VerticesStart:Int = 0;
		
 
  function  ReadChunk():String
	{
    var tag:String = file.readUTFBytes(4);
    var size = file.readInt();
    b3d_tos++;
     b3d_stack[b3d_tos] = file.position +size;
	return tag;
	}
	
	 function getChunkSize():Int
    { 
    return b3d_stack[b3d_tos] - file.position;
	}

	 function breakChunk():Void
    {
    file.position = b3d_stack[b3d_tos];
    --b3d_tos;
	}
	
	 function readstring():String
	{
        var name:String = "";
         for (j in 0...256) 
		{
            var ch:Int = file.readUnsignedByte();
			if (ch == 0) break;
            name += String.fromCharCode(ch);
        }
        return name;
    }
   function readANIM():Void
   {

	 var flags:Int=  file.readInt();//flags
	   file.readInt();//ketframecount
	   file.readFloat();//fps
	
   }
 
	   
    function readBone():Void
   {
	   while (getChunkSize()!=0) 
      {
	   var id:Int  =file.readInt();//vertexid
	   var vw:Float =  file.readFloat();//wight
	  }
   }

	 function readTEX():Void
   {
    while (getChunkSize()!=0) 
   {
	  var  texture:String = Path.withoutDirectory(readstring());

	//  trace("texture name:"+texture);
	  
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
   function readBRUS():Void
  {
	  var count = file.readInt();//num textures
  while (getChunkSize()!=0) 
  {
	  var brush:Material = new Material();
	  if (count == 2)
	  {
	
		brush.materialType = Gdx.MaterialDetailMap;
		//brush.materialType = Gdx.MaterialLightMap;
			
	  }

	  
	     readstring();
	     brush.DiffuseColor.r= file.readFloat();//r
	     brush.DiffuseColor.g= file.readFloat();//g
		 brush.DiffuseColor.b=file.readFloat();//b
		 brush.alpha = file.readFloat();//a
		 
		 
		 file.readFloat();//shiness
		var blend:Int= file.readInt();//blend
		var fx:Int = file.readInt();//fx
	//	trace(blend + ',' + fx);
		 
		 for (i in 0...count)
		 {
			var textid = file.readInt();//texid
			
			if (Assets.exists(path+textures[textid]))
			{
				if (i == 0)
				{
				brush.setTexture(Gdx.Instance().getTexture(path + textures[textid], true,true,true),0);
				} else
				{
				brush.setTexture(Gdx.Instance().getTexture(path + textures[textid], true,true,false),1);

				}
				
			} else
			{
				trace("ERROR: Texture ("+path+textures[textid]+") dont find..");
			}
			
		 }
		 

	brushes.push(brush);
  }
  }
     function readKEYS():Void
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
				
				
	
	 
			 
				
			}
	
			
	  }
	  
   }
   
      function readVTS():Void
  {
	 
		

        var flags = file.readInt();
		var tex_coord = file.readInt();
		var texsize = file.readInt();
		
		var Size:Int = 12 + tex_coord * texsize * 4;
		if (flags & 1 == 1) Size += 12;
	    if (flags & 2 == 2) Size += 16;
		
			  
	  var VertexCount:Int = Std.int(getChunkSize() / Size);
	  
	//    AnimatedVertices_VertexID = [];
	 //  AnimatedVertices_BufferID = [];
	 
	
	  
	 
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
			AnimatedVertices_VertexID.push( -1);
			AnimatedVertices_BufferID.push( -1);
			listVertex.push(vertex);
		}
		
		
	
		
	//	trace('Num vertex:' + listVertex.length);

  }


   function readTRIS(surf:MeshBuffer,surfaceId:Int,vtStar:Int):Void
  {
	  
	
	  
	   var brushid = file.readInt();
	   var TriangleCount:Int = Std.int(getChunkSize() / 12);
	   
	   
	   var showwarning:Bool = false;
	


	   var vertex_id:Array<Int> = [];
	   
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
	


	
	
		surf.material.clone(brushes[brushid]);
		surf.CreateBoundingBox(Matrix.Identity());
	
		
	
  }
  
  
      function  readMESH():Void
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
		var surf = m.createSurface();
	 	readTRIS(surf,m.surfaces.length-1,VerticesStart);
        } 
	 breakChunk();
	}  
	 
  }

   function readNODE():Void
  {
     var n:String = readstring();

 
		 
	  file.readFloat();//x
      file.readFloat();//y
	  file.readFloat();//z

	  
	
	  file.readFloat();//sx
	  file.readFloat();//sy
	  file.readFloat();//sz
	  
	
     var rw:Float=file.readFloat();//rx
	 var rx:Float=file.readFloat();//ry
	 var ry:Float=file.readFloat();//rz
	 var rz:Float =file.readFloat();//rw
	

	 
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
 	 readBone();
     } 
	 if(ChunkName=='ANIM') 
     {
		
	  readANIM();
	
     }  else  
     if(ChunkName=='KEYS') 
     {
		 
	  readKEYS(); 
     } else
    if(ChunkName=='NODE') 
     {
	
	  readNODE();
	}
	breakChunk();
}

}

  
  
    if (!Assets.exists(f))
			{
				trace("ERROR:Model " + f+"dont exists..");
				return createCube();
			}
			
				
	
			
	
		
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
	readNODE();
  }
   breakChunk();
}
breakChunk();

AnimatedVertices_VertexID = null;
AnimatedVertices_BufferID = null;


      listVertex = null;
	  textures = null;
	  brushes = null;
	  b3d_tos = 0;
	  b3d_stack = null;
	  
return m;

	}
	
	/**
	 *Load Quake3 BSP maps
	 *  @param filename : full path to map.bsp
	 *  @param path : full path to get textures
	 *  @param gamma: lightmaps force
	 *  @param optimize:try to merge subMeshes with the same Texture
	 *  @parem parseEntitys : load entitys from bsmp map (player position , angle, lights)
	 * (on  large messhes this is very slow)
	 */
	 public static function loadBSPMap(filename:String,path:String,gamma:Float=5.0,?optimize:Bool=false,parseEntitys:Bool=false) :MeshBSP
	{
		var mesh:MeshBSP = new MeshBSP();
		mesh.loadMap(filename, path, gamma, optimize,parseEntitys);
		return mesh;
	}
	//***********************************
	public static function loadMs3dStatic(filename:String,path:String):Mesh
	{
		var file:ByteArray = Util.getBytes(filename);
		file.endian = "littleEndian";
		
	var id:String =Util.readString(	file, 10);
	var version:Int=	file.readInt();
		
//	trace(id);
//	trace(version);
	
	
    	var vertices:Array<MS3DVertex> = [];
		var numVerts:Int = file.readUnsignedShort();
		//trace("Nume vertex:" + numVerts);
		for (i in 0...numVerts)
		{
			var tri:MS3DVertex = new MS3DVertex(file);
			vertices.push(tri);
		}
		
		
		 var triangles:Array<MS3DTriangle> = [];
		 var numTriangles:Int = file.readUnsignedShort();
	//	trace("Nume Triangles:" + numTriangles);
        for (i in 0...numTriangles)
		{
				var tri:MS3DTriangle = new MS3DTriangle(file);
				triangles.push(tri);
		}
		
		
		var meshes:Array<MS3DMesh> = [];
		 var numMeshes:Int = file.readUnsignedShort();
		// trace("Nume Meshes:" + numMeshes);
		 for (i in 0...numMeshes)
		{
			var mesh:MS3DMesh = new MS3DMesh(file);
			meshes.push(mesh);
		
		}
		
		var m:Mesh = new Mesh();
		
		for (i in 0...numMeshes)
		{
			var mesh:MS3DMesh = meshes[i];
			
			var buffer:MeshBuffer =   m.createSurface();
			
			for (j in 0...mesh.numTriangles)
			{
				var index0:Int = triangles[mesh.TriangleIndices[j]].indice0;
				var v0:Vector3 = vertices[index0].vertex;
				var n0:Vector3 = triangles[mesh.TriangleIndices[j]].normal0;
				var u0:Float = triangles[mesh.TriangleIndices[j]].s.x;
				var t0:Float = 1 * -triangles[mesh.TriangleIndices[j]].t.x;
				
				var index1:Int = triangles[mesh.TriangleIndices[j]].indice1;
				var v1:Vector3 = vertices[index1].vertex;
				var n1:Vector3 = triangles[mesh.TriangleIndices[j]].normal1;
				var u1:Float = triangles[mesh.TriangleIndices[j]].s.y;
				var t1:Float = 1 * -triangles[mesh.TriangleIndices[j]].t.y;
				
				var index2:Int = triangles[mesh.TriangleIndices[j]].indice2;
				var v2:Vector3 = vertices[index2].vertex;
				var n2:Vector3 = triangles[mesh.TriangleIndices[j]].normal2;
				var u2:Float = triangles[mesh.TriangleIndices[j]].s.z;
				var t2:Float = 1 * -triangles[mesh.TriangleIndices[j]].t.z;
				
				var f0 = buffer.AddFullVertexColorVector(v0, n0, new Vector2(u0, t0), new Vector2(u0, t0), new Color4());
				var f1 = buffer.AddFullVertexColorVector(v1, n1, new Vector2(u1, t1), new Vector2(u1, t1), new Color4()); 
				var f2 = buffer.AddFullVertexColorVector(v2, n2, new Vector2(u2, t2), new Vector2(u2, t2), new Color4());
				
					buffer.AddTriangle(f0, f2, f1);//this way look like ms3d editor
				
				
				
				
				
			}
			
		}
		
		
		var numMaterials:Int = file.readUnsignedShort();
		var materials:Array<MS3DMaterial> = [];
		for (i in 0...numMaterials)
		{
			var material:MS3DMaterial = new MS3DMaterial(file, path);
			materials.push(material);
		}
		
		
		for (i in 0...numMeshes)
		{
			var mesh:MS3DMesh = meshes[i];
			var buffer:MeshBuffer = m.getMeshBuffer(i);
			
			if (mesh.MaterialIndex <= materials.length)
			{
			var mat:MS3DMaterial = materials[mesh.MaterialIndex];
			if (mat != null)
			{
			if (mat.texture != null)
			{
			buffer.material.setTexture(mat.texture);
			}
			}
		 }
			
		}
		
		
		return m;
		
	}
	
}
