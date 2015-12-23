package com.gdx.scene3d.particles;

import com.gdx.gl.MeshBuffer;
import com.gdx.gl.Texture;
import com.gdx.math.Triangle;
import com.gdx.math.Vector3;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.particles.ParticleSystem;
import com.gdx.util.Util;

/**
 * ...
 * @author djoekr
 */
class MeshEmitter extends ParticleSystem
{
	
	public  var mesh:Mesh;
	public var triangles:Array<Triangle>; 
	
	
	
	
	public function new (MaxParticles:Int=100,node:Mesh,Parent:SceneNode = null , id:Int = 0) 
    {
        super(MaxParticles, Parent, id,"MeshEmitter");
	    mesh = node;
		triangles = [];
		for (i in 0...node.surfaces.length)
		{
			var surf:MeshBuffer = node.surfaces[i];
			var tris:Array<Triangle> = surf.getTriangles();
			for (x in 0...tris.length)
			{
				triangles.push(tris[x]);
			}
		}
		 EmitPosition = triangles[0].c;
    }


	override public function getStartPosition ():Vector3
    {

		
		
		var count:Int = triangles.length;
		var tri:Triangle = triangles[Util.randi(0, count)];
	   	EmitPosition = tri.a;
		EmitPosition=Vector3.TransformCoordinates(	EmitPosition,world_tform);
		return EmitPosition;
	
	}
	
}