package com.gdx.scene3d;
import com.gdx.collision.Coldet;
import com.gdx.collision.CollisionData;
import com.gdx.gl.MeshBuffer;
import com.gdx.math.Ray;
import com.gdx.math.Triangle;
import com.gdx.math.Vector3;
import com.gdx.util.Util;
import lime.Assets;
import lime.graphics.Image;






#if neko
import sys.io.File;
import sys.io.FileOutput;
#end

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

class Chunk
{
	public var x:Float;
	public var z:Float;
	public var width:Float;
	public var height:Float;
	public var buffer:MeshBuffer;
	public var Precision:Float;
	
	public function new()
	{
		x = 0;
		z = 0;
		width = 0;
		height = 0;
		buffer = null;
		Precision=0;
		
	}
	
}
 
class MeshLargeLandScape extends Mesh

{
	public var chunks:Array<Chunk>;
	private var heighMap:Image;
	private var tile:Float;

	var triangles:Array<Triangle>;
	private var numChunks:Int;
	public function new(url:String) 
	{
		
		
		super();

	
		
		//setShader(Gdx.SHADERDETAIL);
	
		
			if (Assets.exists(url)) 
			{
			 heighMap = Assets.getImage(url);
		
		} else 
		{
			trace("Error: Image '" + url + "' doesn't exist !");
			return;
		}
	     
    numChunks = 0;       
	tile  = 256;//  heighMap.width;
	triangles = [];

	chunks = [];
	
	
   }
   public function GenerateHugeTerrain( Precision:Float, width:Int, height:Int, YFactor:Float, PositionX:Float , PositionZ:Float):Void
   {
	   for (x in 0...width)
	    {
			for (y in 0...height)
			{
				
				this.GenerateTerrainEx(Precision, YFactor, PositionX + x * 256, PositionZ + y * 256, x / width, y / height, 1 / width, 1 / height);
				trace("Create : Terrain ("+x+" "+y+") progress:"+ Std.int((x*width+y)/(width*height)*100)+"%");
				numChunks++;

			}
		}

   }
	
   public function GenerateTerrain( Precision:Float, YFactor:Float,PositionX:Float ,PositionZ:Float):Void
   {
			this.GenerateTerrainEx(Precision, YFactor, PositionX , PositionZ , 0,0,1,1);
   }
	 public function GenerateTerrainEx(  Precision:Float,YFactor:Float,
		 PositionX:Float ,PositionZ:Float,
		 SrcPosX:Float , SrcPosY:Float ,
		 SingWidth:Float , SingHeight:Float):Void
   {
	   
	  
 
	var chunk:Chunk = new Chunk();
	chunk.width  = 256  / Precision + 1;
	chunk.height = 256 / Precision + 1;
	chunk.x = PositionX;
	chunk.z = PositionZ;
	chunk.Precision = Precision;
	chunk.buffer = createSurface();
	





	
	

		   	
         
				var surf:MeshBuffer = createSurface();
	            surf.material.materialType = Gdx.MaterialDetailMap;
					
            // Vertices
            for (y in 0... Std.int(chunk.height)) 
			{
                for (x in 0... Std.int(chunk.width)) 
				{
                 
            		
					
				  var  xl = Std.int(x / (chunk.width  - 1) * heighMap.width  * SingWidth  + SrcPosX * heighMap.width)  ;
		          var  yl = Std.int(y / (chunk.height - 1) * heighMap.height * SingHeight + SrcPosY * heighMap.height);
					
					var color:Int = heighMap.getPixel(xl,yl);
					var r = Util.getRed(color)  / 255;
		            var g = Util.getGreen(color) / 255;
		            var b = Util.getBlue(color) / 255;
		           var gradient = r * 0.3 + g * 0.59 + b * 0.11;
			
			
		

			
				  
				 // chunk.buffer.AddFullVertex(x * Precision,gradient*YFactor, y * Precision,
				 	 chunk.buffer.AddFullVertex((x * Precision)+PositionX,gradient*YFactor, (y * Precision)+PositionZ,
				   0.0, 1.0, 0.0,
				   (x / (chunk.width - 1)),
				   (y / (chunk.height - 1)),
				
				   
				
				   (x / (chunk.width - 1)  * 1 * 0.995 + 0.0025 ),
				   (y / (chunk.height - 1) * 1 * 0.995 + 0.0025 ));
				  
				   
				   

                }
            }

			
			
			
            // Indices

       for (y in 0... Std.int(chunk.height)-1) 
			{
                for (x in 0... Std.int(chunk.width)-1) 
				{
                       
                   
         var v  = Std.int(y *  chunk.width + x);
					  
		  
		  chunk.buffer.AddTriangle(
		  v + 1,
		  v,
		  Std.int(v + chunk.width));
		 
		  chunk.buffer.AddTriangle(
		  v + 1,
		  Std.int(v + chunk.width),
		  Std.int(v + chunk.width+1));
		  
		  
			
                }
            }


	chunks.push(chunk);

   }
   
  public function enableCollision():Void
  {
	   for (i in 0... Std.int(this.chunks.length) )
	   {
		  var tris:Array<Triangle> = this.chunks[i].buffer.getTriangles();
		  for (tri in tris)
		  {
			  this.triangles.push(tri);
		  }
	   }
  }
  public function  ExpandTexture( TerrainMinX:Int, TerrainMinZ:Int,TerrainMaxX:Int, TerrainMaxZ:Int ):Void
  {
  var ScaleX:Float = 1 / (TerrainMaxX - TerrainMinX);
  var ScaleY:Float = 1 / (TerrainMaxZ - TerrainMinZ);


   for (X in TerrainMinX ... TerrainMaxX)
   {
    for (Y in  TerrainMinZ ... TerrainMaxZ)
	{

   
	  var DecalX:Float = (X - TerrainMinX) * ScaleX;
      var DecalY:Float = (Y - TerrainMinZ) * ScaleY;
       
	   for (count in 0... Std.int(this.chunks.length) )
	   {

		   
		 if ((chunks[count].x/tile)==X && (chunks[count].z/tile)==Y)
		 {
			 	for (cx in 0 ... Std.int(chunks[count].width))
				{
			     for ( cy in 0 ... Std.int(chunks[count].height))
				   {
			         var V:Int = Std.int(chunks[count].width) * cy + cx;
					 var ux:Float = cx / (chunks[count].width - 1) * ScaleX * 0.995 + 0.0025 + DecalX;
					 var vy:Float = cy / (chunks[count].height - 1) * ScaleY * 0.995 + 0.0025 + DecalY;
					  chunks[count].buffer.VertexTexCoords(V, ux, vy,0,0);
             	   }
		   }
			      
		 }
		 
		 chunks[count].buffer.UpdateVBO();
	   }
	}
   }
	}
	 public function  ExpandDetail( TerrainMinX:Int, TerrainMinZ:Int,TerrainMaxX:Int, TerrainMaxZ:Int ):Void
  {
  var ScaleX:Float = 1 / (TerrainMaxX - TerrainMinX);
  var ScaleY:Float = 1 / (TerrainMaxZ - TerrainMinZ);


   for (X in TerrainMinX ... TerrainMaxX)
   {
    for (Y in  TerrainMinZ ... TerrainMaxZ)
	{

   
	  var DecalX:Float = (X - TerrainMinX) * ScaleX;
      var DecalY:Float = (Y - TerrainMinZ) * ScaleY;
       
	   for (count in 0... Std.int(this.chunks.length) )
	   {

		   
		 if ((chunks[count].x/tile)==X && (chunks[count].z/tile)==Y)
		 {
			 	for (cx in 0 ... Std.int(chunks[count].width))
				{
			     for ( cy in 0 ... Std.int(chunks[count].height))
				   {
			         var V:Int = Std.int(chunks[count].width) * cy + cx;
					 var ux:Float = cx / (chunks[count].width - 1) * ScaleX * 0.995 + 0.0025 + DecalX;
					 var vy:Float = cy / (chunks[count].height - 1) * ScaleY * 0.995 + 0.0025 + DecalY;
					  chunks[count].buffer.VertexTexCoords(V, ux, vy,0,1);
             	   }
		   }
			      
		 }
		 
		 chunks[count].buffer.UpdateVBO();
	   }
	}
   }
	}
	
	 public function  setTextureScale(tuScale:Float,tvScale:Float):Void
  {
       
	   for (count in 0... Std.int(this.chunks.length) )
	   {

		   
			 	for (cx in 0 ... Std.int(chunks[count].width))
				{
			      for ( cy in 0 ... Std.int(chunks[count].height))
				   {
			         var V:Int = Std.int(chunks[count].width) * cy + cx;
					 var ux:Float = cx / (chunks[count].width - 1) * tuScale * 0.995 + 0.0025 ;
					 var vy:Float = cy / (chunks[count].height - 1) * tvScale * 0.995 + 0.0025 ;
					  chunks[count].buffer.VertexTexCoords(V, ux, vy,0,0);
             	   }
		   }
			      
		 
		 
		 chunks[count].buffer.UpdateVBO();
	   }
	}
	 public function  setTextureDetailScale(tuScale:Float,tvScale:Float):Void
  {
       
	   for (count in 0... Std.int(this.chunks.length) )
	   {

		   
			 	for (cx in 0 ... Std.int(chunks[count].width))
				{
			      for ( cy in 0 ... Std.int(chunks[count].height))
				   {
			         var V:Int = Std.int(chunks[count].width) * cy + cx;
					 var ux:Float = cx / (chunks[count].width - 1) * tuScale * 0.995 + 0.0025 ;
					 var vy:Float = cy / (chunks[count].height - 1) * tvScale * 0.995 + 0.0025 ;
					  chunks[count].buffer.VertexTexCoords(V, ux, vy,0,1);
             	   }
		   }
			      
		 
		 
		 chunks[count].buffer.UpdateVBO();
	   }
	}
	public function setHeight(x:Float, z:Float, h:Float):Void
	{
		
		for (i in 0... Std.int(this.chunks.length) )
	   {
		   if ((chunks[i].x <= x) &&  (chunks[i].z <= z) && 
		       (chunks[i].x+tile+chunks[i].Precision >= x) && (chunks[i].z+tile+chunks[i].Precision >= z))
		   {
			   var posX:Int = Std.int((x - chunks[i].x) / chunks[i].Precision);
			   var posZ:Int = Std.int((z - chunks[i].z) / chunks[i].Precision);
			   
			 
			   		   var v:Int = Std.int(posZ * chunks[i].width  + posX);					   
				       var t1:Vector3 = chunks[i].buffer.getVertex(v);					  
					   chunks[i].buffer.VertexCoords(v, t1.x, h, t1.z);
						
			   }
		   }
	   
	   

	}
	public function getHeight(x:Float, z:Float):Float
	{

		for (i in 0 ... Std.int(this.chunks.length) )
	   {
		   if ((chunks[i].x <= x) &&  (chunks[i].z <= z) && 
		      (chunks[i].x+tile >= x) && (chunks[i].z+tile >= z))
		   {
			   var posX:Int = Std.int((x - chunks[i].x) / chunks[i].Precision);
			   var posZ:Int = Std.int((z - chunks[i].z) / chunks[i].Precision);
			   
			   for (xl in posX-1 ... posX+1)
			   {
				   for (yl in posZ-1 ... posZ+1)
				   {
					   if  ((xl >= 0) && (xl < chunks[i].width) && (yl >= 0) && (yl < chunks[i].height))
					   {
						   var v:Int = Std.int(chunks[i].width * yl + xl);
						   
				  var v1:Int = v +1;
                  var v2:Int = v ;
                  var v3:Int = v + Std.int(chunks[i].width);
                  var v4:Int = v + 1;
                  var v5:Int = v + Std.int(chunks[i].width);
                  var v6:Int = v + Std.int(chunks[i].width) + 1;
				  
				       var t1:Vector3 = chunks[i].buffer.getVertex(v1);
					   var t2:Vector3 = chunks[i].buffer.getVertex(v2);
					   var t3:Vector3 = chunks[i].buffer.getVertex(v3);
					   var t4:Vector3 = chunks[i].buffer.getVertex(v4);
					   var t5:Vector3 = chunks[i].buffer.getVertex(v5);
					   var t6:Vector3 = chunks[i].buffer.getVertex(v6);
					   
				
					   
					   
					   
					   
				
					   
					   var ray0:Ray = new Ray(new Vector3(x  , 0, z ),Vector3.Up());
					   
					   var pick0:Float= ray0.intersectsTriangle(t1, t2, t3);
					   if (pick0 != 0)
					   {
						// SceneManager.lines.drawFillTriangle(t1, t2, t3, 1, 0, 0, 1);
						  return pick0;
					   }
					   
					  
					   
					   
					    var ray1:Ray = new Ray(new Vector3(x , 0, z ),Vector3.Up());
					    var pick1:Float = ray1.intersectsTriangle(t6, t5, t4);
					    if (pick1 != 0)
					    {
						//	SceneManager.lines.drawFillTriangle(t6, t5, t4, 0, 1, 0, 1);
						  return pick1;
					    }
						
					   
					
					   
					   
				  
					   }
				   }
				   
			   }
		   }
	   }
	   
	   return 0;
		
	}
	
	public function colide(pos:Vector3, radius:Vector3, velocity:Vector3,slidingSpeed:Float):Bool
	{

	
					var coll:CollisionData =   Coldet.collideEllipsoidWithTrianglesSimple(triangles, pos, radius, velocity, slidingSpeed, SceneManager.lines);
					
					
				//	if (coll.foundCollision)
					{
						pos.copyFrom( coll.finalPosition);
						return true;
					}
					   
					   
					   
	return false;
		
	}
	public function lineTrace(ray:Ray):Float
	{
		
		var dest2:Vector3 = Vector3.Zero();
		var scale:Float = 90;
		
		
		dest2.x = ray.origin.x + (ray.direction.x * scale);
		dest2.z = ray.origin.z + (ray.direction.z * scale);
		
	
		
			var x:Float = dest2.x;
    		var z:Float = dest2.z;
	
		
	

		for (i in 0... Std.int(this.chunks.length) )
	   {
		   if ((chunks[i].x <= x) &&  (chunks[i].z <= z) && 
		       (chunks[i].x+tile >= x) && (chunks[i].z+tile >= z))
		   {
			   var posX:Int = Std.int((x - chunks[i].x) / chunks[i].Precision);
			   var posZ:Int = Std.int((z - chunks[i].z) / chunks[i].Precision);
			   
			 
			   var xl:Int=posX;
			   var yl:Int=posZ;
			   
					   if  ((xl >= 0) && (xl < chunks[i].width-1) && (yl >= 0) && (yl < chunks[i].height-1))
					   {
						   var v:Int = Std.int(chunks[i].width * yl + xl);
						   
				  var v1:Int = v ;
                  var v2:Int = v +1;
                  var v3:Int = v + Std.int(chunks[i].width);
                  var v4:Int = v + 1;
                  var v5:Int = v + Std.int(chunks[i].width);
                  var v6:Int = v + Std.int(chunks[i].width) + 1;
				  
				       var t1:Vector3 = chunks[i].buffer.getVertex(v1);
					   var t2:Vector3 = chunks[i].buffer.getVertex(v2);
					   var t3:Vector3 = chunks[i].buffer.getVertex(v3);
					   var t4:Vector3 = chunks[i].buffer.getVertex(v4);
					   var t5:Vector3 = chunks[i].buffer.getVertex(v5);
					   var t6:Vector3 = chunks[i].buffer.getVertex(v6);
					   
				
					   SceneManager.lines.drawTriangle(t1, t2, t3, 1, 0, 0, 1);
					   SceneManager.lines.drawTriangle(t6, t5, t4, 0, 1, 0, 1);
					   
					   
				
					  
						
					   
					   
					   
				  
				
			   }
		   }
	   }
	   
	   return 0;
		
	}
	public function GetSlope(x:Float, z:Float,x1:Float,z1:Float):Float
	{

     var V:Float =  Math.sqrt(Math.pow((x1 - x), 2) + Math.pow((z1 - z) , 2));
     var V1 = getHeight(x, z);
     var V2 = getHeight(x1, z1);
    
    return   (V2 - V1) / V;


	}
	public function GetSlopeAngle(x:Float, z:Float,x1:Float,z1:Float):Float
	{
     var slope:Float =GetSlope(x,z,x1,z1);
    return   Math.atan(slope) * 180/3.1415;
	}
	public function GetInterpolatedHeight(x:Float, y:Float):Float
	{
		
	


var X:Float= x - Math.floor(x);
var Z:Float= y - Math.floor(y);


     if(X+Z<=1)
     {
	  var a:Float= getHeight(x, y);
	  var b:Float = getHeight(x+1, y+1);
	  //Heights.z = getHeight(x, y+1);
	  return (a+(b-a)*X+(b-a)*Z);
	} 
	else
	{

	  var a:Float = getHeight(x+1, y+1);
	  var b:Float = getHeight(x, y+1);
	  var c:Float = getHeight(x+1, y);
	     return (a+(b-a)*(1-X)+(c-a)*(1-Z)) ;
	}
	 
	  
	  
	 
	
  
  
  
	}
/*
override public function render(cam:Camera,?drawMehs:Bool=true):Void
	{
		Gdx.Instance().numMesh += 1;

		if (drawMehs)
		{
		  
		  
		for (i in 0... Std.int(this.chunks.length) )
	   {
		  
			  chunks[i].buffer.Bounding.update(chunks[i].mat);
			  if (chunks[i].buffer.Bounding.isInFrustum(cam.frustumPlanes))
			  {
			  chunks[i].buffer.render(chunks[i].mat, cam);
			  }
		  }
		}
	}
*/
}