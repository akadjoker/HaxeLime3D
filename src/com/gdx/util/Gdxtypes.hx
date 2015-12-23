package com.gdx.util;


import com.gdx.math.Matrix;
import com.gdx.math.Quaternion;
import com.gdx.math.Vector3;
import com.gdx.math.Vector2;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */

 // This is our BSP lump structure

 typedef BSPLump = { 

	  offset:Int,					// The offset into the file for the start of this lump
	  length:Int					// The length in bytes for this lump
};

// This is our BSP vertex structure
typedef BSPVertex=
{
     vPosition:Vector3,			// (x, y, z) position. 
     vTextureCoord:Vector2,		// (u, v) texture coordinate
     vLightmapCoord:Vector2,	// (u, v) lightmap coordinate
     vNormal:Vector3,			// (x, y, z) normal vector
     r:Int,				// RGBA color for the vertex 
	 g:Int,
	 b:Int,
	 a:Int
};

typedef BSPFace=
{
     textureID:Int,				// The index o the texture array 
     effect:Int,					// The index for the effects (or -1 = n/a) 
     type:Int,					// 1=polygon, 2=patch, 3=mesh, 4=billboard 
     startVertIndex:Int,			// The starting index o this face's first vertex 
     numOfVerts:Int,				// The number of vertices for this face 
     startIndex:Int,				// The starting index o the indices array for this face
     numOfIndices:Int,			// The number of indices for this face
     lightmapID:Int,				// The texture index for the lightmap 
     lMapCorner0:Int,			// The face's lightmap corner in the image 
	 lMapCorner1:Int,			// The face's lightmap corner in the image 
     lMapSize0:Int,			// The size of the lightmap section 
	 lMapSize1:Int,			// The size of the lightmap section 
     lMapPos:Vector3,			// The 3D origin of lightmap. 
     lMapVecs0:Vector3,		// The 3D space for s and t unit vectors. 
	 lMapVecs1:Vector3,		// The 3D space for s and t unit vectors. 
     vNormal:Vector3,			// The face normal. 
     size0:Int,				// The bezier patch dimensions.  
	 size1:Int				// The bezier patch dimensions.  
};

class Gdxtypes
{

	public function new() 
	{
		
	}
	
}