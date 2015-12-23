package com.gdx.scene3d;


import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.gl.BlendMode;
import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.Texture;
import com.gdx.gl.VertexBuffer;
import com.gdx.input.Keys;
import com.gdx.math.BoundingBox;
import com.gdx.math.Matrix;
import com.gdx.math.Triangle;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import com.gdx.scene3d.cameras.Camera;
import lime.Assets;
import lime.graphics.Image;
import sys.db.Types.STinyInt;


import com.gdx.util.Clip;
import com.gdx.util.Util;
import lime.graphics.opengl.GL;
import lime.utils.Float32Array;

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

 private class SPatch
 {
	
	 public var CurrentLOD:Int;
	 public var boundingBox:BoundingBox;
	 public var Center:Vector3;
	 public var Top:SPatch;
	 public var Bottom:SPatch;
	 public var Right:SPatch;
	 public var Left:SPatch;
	 
	 
	 public function new()
	 {
		 CurrentLOD = -1;
		 Top = null;
		 Bottom = null; 
		 Left = null;
		 Right = null;
		 Center = Vector3.Zero();
		 boundingBox= new BoundingBox(new Vector3 ( 999999.9, 999999.9, 999999.9), new Vector3( -999999.9, -999999.9, -999999.9 ));
	 
	 }
	 
 }
 
 private class STerrainData
 {
	 public var Size:Int;
	 public var Position:Vector3;
	 public var Scale:Vector3;
	 public var Center:Vector3;
	 public var PatchSize:Int;
	 public var CalcPatchSize:Int;
	 public var PatchCount:Int;
	 public var MaxLOD:Int;
	 public var LODDistanceThreshold:Array<Float>;
	 public var Patches:Array<SPatch>;

			
	 public function new()
	 {
		 Patches = [];
		 LODDistanceThreshold = [];
		 Size= PatchSize= CalcPatchSize= PatchCount= MaxLOD = 0;
		 Position = new Vector3(0, 0, 0);
		 Scale = new Vector3(1, 1, 1);
		 Center = Vector3.Zero();
		 
	 }
 }
 
class GeoTerrain extends Node
{

	public static inline var ETPS_9 = 9;
	public static inline var ETPS_17 = 17;
	public static inline var ETPS_33 = 33;
	public static inline var ETPS_65 = 65;
	public static inline var ETPS_129 = 129;
		
	
	var TerrainData:STerrainData;
	
	var OldCameraRotation:Vector3;
	var OldCameraPosition:Vector3;
	var CameraMovementDelta:Float;
	var CameraRotationDelta:Float;
	


	var	 OverrideDistanceThreshold:Bool;


	var meshBuffer:MeshBuffer;
	
		var vert_tex_coords:Float32Array;
	    var vert_col :Float32Array;
		var vert_coords:Float32Array;
	
		private var vertexbuffer:VertexBuffer;
	

    public function new (maxLOD:Int, patchSize:Int, scale:Vector3, position:Vector3, ?parent:Node = null, ?id:Int = 0, ?Name:String = "ParticlesSystem") 
    {
        super(parent, name,id);
		
		TerrainData = new STerrainData();
		TerrainData.PatchSize = patchSize;
		TerrainData.CalcPatchSize = patchSize - 1;
		TerrainData.MaxLOD = maxLOD;
		TerrainData.Scale = scale;
		TerrainData.Position = position;
		
		OverrideDistanceThreshold = false;
		
		    
	
		
		OldCameraPosition =new Vector3(-99999.9, -99999.9, -99999.9 );
		OldCameraRotation =new Vector3(-99999.9, -99999.9, -99999.9 );
		CameraMovementDelta = 1.0;
		CameraRotationDelta = 0.5 * Util.Deg2Rad;
		
	
		 meshBuffer = new MeshBuffer(Gdx.Instance().materials[Gdx.SHADERDEFAULT]);
		 meshBuffer.material.setMaterialType(Gdx.MaterialDetailMap);
		 
		// meshBuffer = new MeshBuffer(Gdx.Instance().materials[Gdx.SHADERCOLOR]);
		 
		// meshBuffer.primitiveType = Gdx.GLLINES;
    }
	public function setVertexHeight(X:Int, Z:Int,newHeight:Float):Void
	{
		if( X >= 0 && X <= TerrainData.Size && Z >= 0 && Z <= TerrainData.Size )
		{
			 var i:Int = Z * TerrainData.Size + X;
			 
			 var v:Vector3 = meshBuffer.getVertex( i );
			 v.y = newHeight;

						
			 meshBuffer.setVertex(i, v);
			
			 var patchIndex:Int =Std.int( ( X / TerrainData.PatchSize ) * TerrainData.PatchCount + ( Z / TerrainData.PatchSize ));
			 
			 TerrainData.Patches[ patchIndex ].boundingBox.addInternalVector( v );

			calculateDistanceThresholds( true );
			
			
		}
		
	}
	public function getVertexHeight(X:Int, Z:Int):Float
	{
		if( X >= 0 && X <= TerrainData.Size && Z >= 0 && Z <= TerrainData.Size )
		{
			var a = meshBuffer.getVertex( Z * TerrainData.Size + X );
			return a.y;
			
		}
		return 0;
	}
	
	public function getHeight(x:Float, z:Float):Float
	{
		var height:Float = -999999.9;
		var pos:Vector3 = new Vector3(x, 0, z);
		pos.x -= TerrainData.Position.x;
		pos.y -= TerrainData.Position.y;
		pos.z -= TerrainData.Position.z;
		
		pos.x /= TerrainData.Scale.x;
		pos.y /= TerrainData.Scale.y;
		pos.z /= TerrainData.Scale.z;
		
		var X:Int = Math.floor(pos.x);
		var Z:Int = Math.floor(pos.y);
		
		if( X >= 0 && X <= TerrainData.Size && Z >= 0 && Z <= TerrainData.Size )
		{
			var a = meshBuffer.getVertex( X * TerrainData.Size + Z );
			var b = meshBuffer.getVertex( (X + 1) * TerrainData.Size + Z );
			var c = meshBuffer.getVertex( X * TerrainData.Size + ( Z + 1 ));
			var d = meshBuffer.getVertex( (X + 1) * TerrainData.Size + ( Z + 1 ) );

			var dx:Float = pos.x - X;
			var dz:Float = pos.z - Z;
			var invDX:Float = 1.0 - dx;

			if( dz < invDX )
			{
				var uy:Float = a.y - c.y;
				var vy:Float = d.y - c.y;
				height = c.y + Util.Lerp( 0.0, uy, dx ) + Util.Lerp( 0.0, vy, dz );
				
					height *= TerrainData.Scale.y;
					height += TerrainData.Position.y;
				
			}
			else 
			{
				{
					var uy:Float = a.y - b.y;
					var vy:Float = d.y - b.y;
					height = b.y + Util.Lerp( 0.0, uy, invDX ) + Util.Lerp( 0.0, vy, 1.0 - dz );
					
						height *= TerrainData.Scale.y;
						height += TerrainData.Position.y;
					
				}
			}
		}

		return height;
	}

		
		
	
	public function setTexture(tex:Texture,layer:Int=0):Void
	{
		if (meshBuffer == null) return;
		
			meshBuffer.material.setTexture(tex,layer);
	
	}
	public  function getMeshBuffer():MeshBuffer
	{
		return meshBuffer;
		
	}
	override public function getMaterial(index:Int):Material
	{
		if (meshBuffer != null)
		{
		return	meshBuffer.material;
		}
		return null;
	}
	

	public function loadTerrain(img:String,heightScale:Float):Void
	{
		var startTimer:Int = Gdx.Instance().getTimer();
		
		var image:Image = Assets.getImage(img);
		TerrainData.Size = image.width;
	
		correctMaxLOD();
	
		 for( x in 0...TerrainData.Size)
				{
					for( z in 0...TerrainData.Size)
					{
						var color = image.getPixel32(x, z);
						var hi:Float =   ((Util.getRed(color) / 255) + (Util.getGreen(color) / 255) + (Util.getBlue(color) / 255)) / 3.0 * heightScale;
						
						var v:Vector3 = new Vector3(x, hi, z);
						
						
						v.x = (v.x * TerrainData.Scale.x) + TerrainData.Position.x;
			            v.y = (v.y * TerrainData.Scale.y) + TerrainData.Position.y;
			            v.z = (v.z * TerrainData.Scale.z) + TerrainData.Position.z;
						
						
						meshBuffer.AddVertex(v.x, v.y, v.z, x /( TerrainData.Size - 1 ),  ( z / ( TerrainData.Size - 1 ) ) );
					}
				}
			/*
        for (i in 0...meshBuffer.CountVertices())
		{
			var v:Vector3 = meshBuffer.getVertex(i);
			v.x = (v.x * TerrainData.Scale.x) + TerrainData.Position.x;
			v.y = (v.y * TerrainData.Scale.y) + TerrainData.Position.y;
			v.z = (v.z * TerrainData.Scale.z) + TerrainData.Position.z;
			meshBuffer.setVertex(i, v);
			
		}
		*/
		
		calculateDistanceThresholds();
		createPatches();
		calculatePatchNeighbors();
		
		
		var endTimer:Int = Gdx.Instance().getTimer();
		
		trace ("Generated terrain data(" + TerrainData.Size+"," + TerrainData.Size+") in " + ( endTimer - startTimer ) / 1000.0 + "seconds" );
		
		
		
	}


	
	//! Manually sets the LOD of a patch
	//! \param patchX: Patch x coordinate.
	//! \param patchZ: Patch z coordinate.
	//! \param LOD: The level of detail to set the patch to.
	public function setLODOfPatch( patchX:Int, patchZ:Int, LOD:Int ):Void
	{
		TerrainData.Patches[patchZ * TerrainData.PatchCount + patchX].CurrentLOD = LOD;
	}

	public function getCurrentLODOfPatches( LODs:Array < Int>):Int
	{
		for( numLODs in 0...  TerrainData.PatchCount * TerrainData.PatchCount)
			LODs.push( TerrainData.Patches[numLODs].CurrentLOD );

		return LODs.length;
	}
	public function preRenderIndicesCalculations():Void
	{
		var index11:Int = 0;
		var index21:Int = 0;
		var index12:Int = 0;
		var index22:Int = 0;

		//reset mesh buffer 

		meshBuffer.tris = [];
		meshBuffer.no_tris = 0;
		
		// Then generate the indices for all patches that are visible.
		for( i in 0...TerrainData.PatchCount)
		{
			for(j in 0...TerrainData.PatchCount)
			{
				var index:Int = i * TerrainData.PatchCount + j;
				if( TerrainData.Patches[index].CurrentLOD >= 0 )
				{
					var x:Int = 0;
					var z:Int = 0;

					// calculate the step we take this patch, based on the patches current LOD
					var step:Int = 1 << TerrainData.Patches[index].CurrentLOD;

					// Loop through patch and generate indices
					while( z < TerrainData.CalcPatchSize )
					{
						index11 = getIndex( j, i, index, x, z );
						index21 = getIndex( j, i, index, x + step, z );
						index12 = getIndex( j, i, index, x, z + step );
						index22 = getIndex( j, i, index, x + step, z + step );
							
						meshBuffer.AddTriangle(index22, index12, index11);
						meshBuffer.AddTriangle(index21, index22, index11);
						
						

						// increment index position horizontally
						x += step;

						if( x >= TerrainData.CalcPatchSize ) // we've hit an edge
						{
							x = 0;
							z += step;
						}
					}
				}
			}
		}


		
	}
	
	public function getMeshBufferForLOD(LOD:Int):MeshBuffer
	{
		if( LOD > TerrainData.MaxLOD - 1 )
			LOD = TerrainData.MaxLOD - 1;
			
		

		var buffer:MeshBuffer = new MeshBuffer(meshBuffer.shaderUse);
		buffer.material.clone(meshBuffer.material);
		
		for (i in 0... meshBuffer.CountVertices())
		{
			var v:Vector3 = meshBuffer.getVertex(i);
			var u:Vector2 = meshBuffer.getUv0(i);
			buffer.AddVertex(v.x, v.y, v.z, u.x, u.y);
		}
		
		

		var step:Int = 1 << LOD;
		var index11:Int = 0;
		var index21:Int = 0;
		var index12:Int = 0;
		var index22:Int = 0;
		
		
		// Then generate the indices for all patches that are visible.
		for( i in 0...TerrainData.PatchCount)
		{
			for(j in 0...TerrainData.PatchCount)
			{
				var index:Int = i * TerrainData.PatchCount + j;
				
					var x:Int = 0;
					var z:Int = 0;

			

					// Loop through patch and generate indices
					while( z < TerrainData.CalcPatchSize )
					{
						index11 = getIndex( j, i, index, x, z );
						index21 = getIndex( j, i, index, x + step, z );
						index12 = getIndex( j, i, index, x, z + step );
						index22 = getIndex( j, i, index, x + step, z + step );
						
						
						
						
						buffer.AddTriangle(index11, index12, index22);
						buffer.AddTriangle(index11, index22, index21);
						
						

						// increment index position horizontally
						x += step;

						if( x >= TerrainData.CalcPatchSize ) // we've hit an edge
						{
							x = 0;
							z += step;
						}
					
				}
			}
		}

		return buffer;
		
	}
	
	public function getTriangles(LOD:Int):Array<Triangle>
	{
		var triangles:Array<Triangle> = [];
		var indexCount:Int = 0;
		var indices:Array<Int> = [];
		for (x in 0...TerrainData.PatchCount)
		{
		for (z in 0...TerrainData.PatchCount)
		{
		  var index:Int = x * TerrainData.PatchCount + z;
		  indexCount = getIndicesForPatch(indices, x, z, LOD);
		  
		  var index:Int = 0;
		  while (index <= indexCount)
		  {
			  var a:Vector3 = meshBuffer.getVertex(indices[index]);
			  var b:Vector3 = meshBuffer.getVertex(indices[index+1]);
			  var c:Vector3 = meshBuffer.getVertex(indices[index+2]);
			  
			  
			  
			  triangles.push(new Triangle(a, b, c, Vector3.Up()));
			  
			  index += 3;
		  }
		 
	    }
		}
		  
		return triangles;
	}

	public function getVertices(LOD:Int):Array<Vector3>
	{
		var vertices:Array<Vector3> = [];
		var indexCount:Int = 0;
		var indices:Array<Int> = [];
		for (x in 0...TerrainData.PatchCount)
		{
		for (z in 0...TerrainData.PatchCount)
		{
		  var index:Int = x * TerrainData.PatchCount + z;
		  indexCount = getIndicesForPatch(indices, x, z, LOD);
		  
		  var index:Int = 0;
		  while (index <= indexCount)
		  {
		      var a:Vector3 = meshBuffer.getVertex(indices[index]);
			  var b:Vector3 = meshBuffer.getVertex(indices[index+1]);
			  var c:Vector3 = meshBuffer.getVertex(indices[index+2]);
			
			  
			 vertices.push(a);
			 vertices.push(b);
			 vertices.push(c);
			  
			  index += 3;
		  }
		 
	    }
		}
		  
		return vertices;
	}

	public function getSize():Float
	{
		return TerrainData.Size;
	}
	public function getIndicesForPatch(indices:Array<Int>,  patchX:Int, patchZ:Int, LOD:Int ):Int
	{
		if( patchX < 0 || patchX > TerrainData.PatchCount - 1 || patchZ < 0 || patchZ > TerrainData.PatchCount - 1 )
			return -1;

		if( LOD < -1 || LOD > TerrainData.MaxLOD - 1 )
			return -1;

		var rv:Int = 0;
		var cLODs:Array<Int>=[];
		var setLODs:Bool = false;

		// If LOD of -1 was passed in, use the CurrentLOD of the patch specified
		if( LOD == -1 )
		{
			LOD = TerrainData.Patches[patchZ * TerrainData.PatchCount + patchX].CurrentLOD;
		}
		else
		{
			getCurrentLODOfPatches(cLODs);
			setCurrentLODOfPatches(LOD);
			setLODs = true;
		}

		if( LOD < 0 )
			return -2; // Patch not visible, don't generate indices.

		// calculate the step we take for this LOD
		var step:Int = 1 << LOD;

		// Generate the indices for the specified patch at the specified LOD
		var index:Int = patchZ * TerrainData.PatchCount + patchX;

		var x:Int = 0;
		var z:Int = 0;
		var index11:Int = 0;
		var index21:Int = 0;
		var index12:Int = 0;
		var index22:Int = 0;
	
		
		// Loop through patch and generate indices
		while (z<TerrainData.CalcPatchSize)
		{
			index11 = getIndex( patchX, patchZ, index, z, x );
			index21 = getIndex( patchX, patchZ, index, z + step, x );
			index12 = getIndex( patchX, patchZ, index, z, x + step );
			index22 = getIndex( patchX, patchZ, index, z + step, x + step );

			indices[rv++] = index11;
			indices[rv++] = index12;
			indices[rv++] = index22;
			indices[rv++] = index11;
			indices[rv++] = index22;
			indices[rv++] = index21;

			// increment index position horizontally
			x += step;

			if(x >= TerrainData.CalcPatchSize) // we've hit an edge
			{
				x = 0;
				z += step;
			}
		}

		if( setLODs )
			setCurrentLODOfPatchesArray (cLODs);

		return rv;
	}
	private function calculateDistanceThresholds(scalechanged:Bool=false):Void
	{
		if(!OverrideDistanceThreshold)
		{
			

			// Determine new distance threshold for determining what LOD to draw patches at
			TerrainData.LODDistanceThreshold = [];// new f64[TerrainData.MaxLOD];

			for(i in 0...TerrainData.MaxLOD)
			{
				TerrainData.LODDistanceThreshold[i]=(TerrainData.PatchSize * TerrainData.PatchSize) * (TerrainData.Scale.x * TerrainData.Scale.z) * ((i+1+ i / 2) * (i+1+ i / 2));
				TerrainData.LODDistanceThreshold[i] *= 1.1;
			
			}
		}
		
	}
	
  
	private function calculatePatchNeighbors():Void
	{
	
		for (x in 0...TerrainData.PatchCount)
		{
		for (z in 0...TerrainData.PatchCount)
		{
		  var index:Int = x * TerrainData.PatchCount + z;
		  
		  // Assign Neighbours
		  //1º pass
		// Top
				if( x > 0 )
					TerrainData.Patches[index].Top = TerrainData.Patches[(x-1) * TerrainData.PatchCount + z];
				else
					TerrainData.Patches[index].Top = null;

				// Bottom
				if( x < TerrainData.PatchCount - 1 )
					TerrainData.Patches[index].Bottom = TerrainData.Patches[(x+1) * TerrainData.PatchCount + z];
				else
					TerrainData.Patches[index].Bottom = null;

				// Left
				if( z > 0 )
					TerrainData.Patches[index].Left = TerrainData.Patches[x * TerrainData.PatchCount + z - 1];
				else
					TerrainData.Patches[index].Left = null;

				// Right
				if( z < TerrainData.PatchCount - 1 )
					TerrainData.Patches[index].Right = TerrainData.Patches[x * TerrainData.PatchCount + z + 1];
				else
					TerrainData.Patches[index].Right = null;
			
		  
					TerrainData.Patches[index].CurrentLOD = 0;

					
				//2º pass ;)	
				// For each patch, calculate the bounding box ( mins and maxes )
				
				
				var xstart = x*TerrainData.CalcPatchSize;
				var xend = (xstart+1)+TerrainData.CalcPatchSize;
				var zstart = z*TerrainData.CalcPatchSize;
				var zend = (zstart+1) + TerrainData.CalcPatchSize;
				
			
			  var min = new Vector3(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
              var max = new Vector3(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
		
		
				for (  xx in  xstart...  xend )
				{
					for (  zz in zstart ... zend)
					{
						var v:Vector3 = meshBuffer.getVertex(Std.int(xx * TerrainData.Size + zz));
						Vector3.checkExtends(v, min, max);
					}
				}


				TerrainData.Patches[index].boundingBox=new BoundingBox(min, max);
				TerrainData.Patches[index].Center.copyFrom(TerrainData.Patches[index].boundingBox.center);
			this.Bounding.addInternalBox( TerrainData.Patches[index].boundingBox );
		}
		}
		//create main boundig box
		this.Bounding.calculate();
		this.Bounding.update(Matrix.Identity());

		// get center of Terrain
		TerrainData.Center.copyFrom(this.Bounding.center);
	}
	private function createPatches():Void
	{
		TerrainData.PatchCount = Std.int( (TerrainData.Size - 1) / ( TerrainData.CalcPatchSize ));
		
		trace("Num patches :" + TerrainData.PatchCount);

		if(TerrainData.Patches!=null)
			TerrainData.Patches = null;
		
			TerrainData.Patches = [];
			for (i in 0... (TerrainData.PatchCount * TerrainData.PatchCount))
			{
				TerrainData.Patches.push(new SPatch());
			}
			

		
	}
	private function getIndex(PatchX:Int,  PatchZ:Int, PatchIndex:Int, x:Int, z:Int):Int
	{
		var vX:Int = 0;
		var vZ:Int = 0;

		vX = x;
		vZ = z;

		// top border 
		if( vZ == 0 )
		{
			if( (TerrainData.Patches[PatchIndex].Top!=null) &&  (TerrainData.Patches[PatchIndex].CurrentLOD < TerrainData.Patches[PatchIndex].Top.CurrentLOD) &&
				( vX % ( 1 << TerrainData.Patches[PatchIndex].Top.CurrentLOD ) ) != 0 )
			{
				vX = vX - vX % ( 1 << TerrainData.Patches[PatchIndex].Top.CurrentLOD );
			}
		}
		
		else if( vZ == TerrainData.CalcPatchSize ) // bottom border
		{
			if( (TerrainData.Patches[PatchIndex].Bottom!=null) && (TerrainData.Patches[PatchIndex].CurrentLOD < TerrainData.Patches[PatchIndex].Bottom.CurrentLOD) &&
				( vX % ( 1 << TerrainData.Patches[PatchIndex].Bottom.CurrentLOD ) ) != 0 )
			{
				vX = vX - vX % ( 1 << TerrainData.Patches[PatchIndex].Bottom.CurrentLOD );
			}
		}
	    
		// left border
		if( vX == 0 )
		{
			if( (TerrainData.Patches[PatchIndex].Left!=null) && (TerrainData.Patches[PatchIndex].CurrentLOD < TerrainData.Patches[PatchIndex].Left.CurrentLOD) &&
				( vZ % ( 1 << TerrainData.Patches[PatchIndex].Left.CurrentLOD ) ) != 0 )
			{
				vZ = vZ - vZ % ( 1 << TerrainData.Patches[PatchIndex].Left.CurrentLOD );
			}
		}
		else if  ( vX == TerrainData.CalcPatchSize ) // right border
		{
			if( (TerrainData.Patches[PatchIndex].Right!=null) && (TerrainData.Patches[PatchIndex].CurrentLOD < TerrainData.Patches[PatchIndex].Right.CurrentLOD) &&
				( vZ % ( 1 << TerrainData.Patches[PatchIndex].Right.CurrentLOD ) ) != 0 )
			{
				vZ = vZ - vZ % ( 1 << TerrainData.Patches[PatchIndex].Right.CurrentLOD );
			}
		}
	             
		if( vZ >= TerrainData.PatchSize )
			vZ = TerrainData.CalcPatchSize;

		if( vX >= TerrainData.PatchSize )
			vX = TerrainData.CalcPatchSize;

		return ( vZ + ( TerrainData.CalcPatchSize * PatchZ ) ) * TerrainData.Size + ( vX + ( TerrainData.CalcPatchSize * PatchX ) );
	}
	private function overrideLODDistance( LOD:Int, newDistance:Float):Bool
	{
		OverrideDistanceThreshold = true;

		if( LOD < 0 || LOD > TerrainData.MaxLOD - 1 )
			return false;

		TerrainData.LODDistanceThreshold[LOD] = newDistance * newDistance;

		return true;
	}
	
	private function setCurrentLODOfPatches(lod:Int):Void
	{
		for(i in 0...TerrainData.PatchCount * TerrainData.PatchCount)
			TerrainData.Patches[i].CurrentLOD = lod;
	}

	private function setCurrentLODOfPatchesArray(lodarray:Array<Int>):Void
	{
		for(i in 0...TerrainData.PatchCount * TerrainData.PatchCount)
			TerrainData.Patches[i].CurrentLOD = lodarray[i];	
	}
	private function  correctMaxLOD():Void
	{
		switch( TerrainData.PatchSize )
		{
			case ETPS_9:
				if( TerrainData.MaxLOD > 3 )
				{
					TerrainData.MaxLOD = 3;
					trace( "WARNING! Terrain Patch Size is less than or equal to 9 and MaxLOD was greater than 3!  Forcing MaxLOD to 3!" );
				}
			
			case ETPS_17:
				if( TerrainData.MaxLOD > 4 )
				{
					TerrainData.MaxLOD = 4;
					trace( "WARNING! Terrain Patch Size is less than or equal to 17 and MaxLOD was greater than 4!  Forcing MaxLOD to 4!" );
				}
			
			case ETPS_33:
				if( TerrainData.MaxLOD > 5 )
				{
					TerrainData.MaxLOD = 5;
					trace( "WARNING! Terrain Patch Size is less than or equal to 33 and MaxLOD was greater than 5!  Forcing MaxLOD to 5!" );
				}
				
			case ETPS_65:
				if( TerrainData.MaxLOD > 6 )
				{
					TerrainData.MaxLOD = 6;
					trace( "WARNING! Terrain Patch Size is less than or equal to 65 and MaxLOD was greater than 6!  Forcing MaxLOD to 6!" );
				}
			
			case ETPS_129:
				if( TerrainData.MaxLOD > 7 )
				{
					TerrainData.MaxLOD = 7;
					trace( "WARNING! Terrain Patch Size is less than or equal to 129 and MaxLOD was greater than 7!  Forcing MaxLOD to 7!" );
				}
				
		}
	}
	
	override public function debug(lines:Imidiatemode):Void
	{
	  if ( (debugFlags & Gdx.DEBUGNODEOBB) == Gdx.DEBUGNODEOBB) 
	  {
		lines.drawABBox(this.Bounding, 1, 0, 0);
	  }
	  
	  if ( (debugFlags & Gdx.DEBUGSURFOBB) == Gdx.DEBUGSURFOBB) 
	  {
		  
		if ((TerrainData.PatchCount * TerrainData.PatchCount) < 0) return;
		var count:Int = TerrainData.PatchCount * TerrainData.PatchCount;
		
		for (j in 0...count)
		{
				var patchBox:BoundingBox = TerrainData.Patches[j].boundingBox;
				
				if (TerrainData.Patches[j].CurrentLOD == 0)
				{
				lines.drawABBox(patchBox, 1, 1, 1);	
				}else
				if (TerrainData.Patches[j].CurrentLOD == 1)
				{
				lines.drawABBox(patchBox, 1, 0, 0);	
				}else
				if (TerrainData.Patches[j].CurrentLOD == 2)
				{
				lines.drawABBox(patchBox, 0, 1, 0);	
				}else
				if (TerrainData.Patches[j].CurrentLOD == 3)
				{
				lines.drawABBox(patchBox, 0, 0, 1);	
				}else
				if (TerrainData.Patches[j].CurrentLOD == 4)
				{
				lines.drawABBox(patchBox, 1, 0, 1);	
				}else
				if (TerrainData.Patches[j].CurrentLOD == 5)
				{
				lines.drawABBox(patchBox, 0, 1, 1);	
				}else
				{
				lines.drawABBox(patchBox, 1, 0, 1);	
				}
				
				
				
				
				
			    
			
			
		}
	  }

		//super.debug(lines);
	}
	
override public function render(cam:Camera):Void
	{
		
	    var mat:Matrix = getWorldTform();
		if (!cam.BoundingBoxInFrustum(this.Bounding)) return;
		
		Gdx.Instance().numMesh += 1;
		
		var m:Matrix = cam.viewMatrix;	
	  	if ( preRenderLODCalculations(cam) )
			{
				preRenderIndicesCalculations();
				
			} 
			
	
		
		

		  meshBuffer.shaderUse.Bind(cam.viewMatrix, cam.projMatrix, mat);
	
		  meshBuffer.render();
			 
		
		

	
			
  	}

	public function preRenderLODCalculations(cam:Camera):Bool
	{

		
		var cameraRotation:Vector3=cam.viewMatrix.getRotationDegrees();
		var cameraPosition:Vector3 = cam.local_pos;
		
		//trace(cameraRotation);

		if( ( Math.abs( cameraRotation.x - OldCameraRotation.x ) < CameraRotationDelta ) && 
			( Math.abs( cameraRotation.y - OldCameraRotation.y ) < CameraRotationDelta ) &&
			( Math.abs( cameraRotation.z - OldCameraRotation.z ) < CameraRotationDelta ) )
		{
			if( ( Math.abs( cameraPosition.x - OldCameraPosition.x ) < CameraMovementDelta ) && 
				( Math.abs( cameraPosition.y - OldCameraPosition.y ) < CameraMovementDelta ) &&
				( Math.abs( cameraPosition.z - OldCameraPosition.z ) < CameraMovementDelta ) )
			{

				return false;
			}
		}
		
		OldCameraPosition.copyFrom(cam.local_pos);
		OldCameraRotation.copyFrom(cameraRotation);
		
		var render:Int = 0;
		
		
		// Determine each patches LOD based on distance from camera ( and whether or not they are in the view frustrum ).
		for( j in 0... (TerrainData.PatchCount * TerrainData.PatchCount))
		{
			var patchBox:BoundingBox = TerrainData.Patches[j].boundingBox;

			 if (patchBox.isInFrustum(cam.frustumPlanes))
	        {
				Gdx.Instance().numSurfaces += 1;
				//var distance:Float=Vector3.Distance(cameraPosition, TerrainData.Patches[j].Center);
				
					var distance = (cameraPosition.x - TerrainData.Patches[j].Center.x) * (cameraPosition.x - TerrainData.Patches[j].Center.x) + 
						(cameraPosition.y - TerrainData.Patches[j].Center.y) * (cameraPosition.y - TerrainData.Patches[j].Center.y) + 
						(cameraPosition.z - TerrainData.Patches[j].Center.z) * (cameraPosition.z - TerrainData.Patches[j].Center.z);

						
						
					TerrainData.Patches[j].CurrentLOD = 0;

					var l:Int = TerrainData.MaxLOD - 1;
					
					while (l>0)
					{
					var temp:Float = TerrainData.LODDistanceThreshold[l];
						
						if( distance >= temp )
						{
							TerrainData.Patches[j].CurrentLOD = l;
							break;
						}
						else if( l == 0 )
						{
							TerrainData.Patches[j].CurrentLOD = 0;
						}
						l--;
					}
				}
			
			else
			{
				TerrainData.Patches[j].CurrentLOD = -1;
			}
		}

		return true;
	}
	

 
}


