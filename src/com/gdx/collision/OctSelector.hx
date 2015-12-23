package com.gdx.collision;
import com.gdx.gl.MeshBuffer;
import com.gdx.math.BoundingBox;
import com.gdx.math.BoundingInfo;
import com.gdx.math.Matrix;
import com.gdx.math.Plane;

import com.gdx.math.Ray;
import com.gdx.math.Triangle;
import com.gdx.math.Vector3;
import com.gdx.gl.Imidiatemode;
import com.gdx.scene3d.MeshLargeLandScape;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.Mesh;
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
/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class OctSelector
{
		private var ContactPoint:Vector3;
	private var ContactNormal:Vector3;
	private var ContactPlane:Plane;
	private var ContactDistance:Float;
	public var collision:CollisionData;

	private var MaxTriangles:Int;
	private var MaxSubdivisions:Int;
	private var octree:Octree;
	private var vertices:Array<Vector3>;
	private var copyVertices:Array<Vector3>;

	public function new(MaxTriangles:Int,MaxSubdivisions:Int) 
	{
		 ContactPoint = Vector3.Zero();
		  ContactNormal = Vector3.Zero();
		  ContactPlane = new Plane(0, 0, 0, 0);
		  ContactDistance = 0;
	
		  collision = new CollisionData();
	
		this.MaxTriangles = MaxTriangles;
		this.MaxSubdivisions = MaxSubdivisions;
		vertices = [];
	}
	public function addLargeLandscape(land:MeshLargeLandScape):Void
	{
		
		for (chunk in land.chunks)
		{
			addMeshBuffer(chunk.buffer);
		}
		
	}
	public function addMesh(buffer:Mesh):Void
	{
		for (i in 0 ... buffer.numMeshBuffer())
		{
			addMeshBuffer(buffer.getMeshBuffer(i));
		}
	}
	public function addMeshBuffer(buffer:MeshBuffer):Void
	{
		
	
			for (i in 0... buffer.CountTriangles())
			{
				  var v0:Vector3 = buffer.getFace(i, 0);
				  var v1:Vector3 = buffer.getFace(i, 1);
				  var v2:Vector3 = buffer.getFace(i, 2);
				  
				  vertices.push(v2);
				  vertices.push(v1);
				  vertices.push(v0);
				  
				
			}
		
		
	}
	public function addVertices(buffer:Array<Vector3>):Void
	{
			for (i in 0... buffer.length)
			{
				  vertices.push(buffer[i]);
			}
	}
	public function build():Void
	{
		octree = new Octree(MaxTriangles,MaxSubdivisions);
		octree.build(vertices);
	}
	
	public function BoxTraceSimples( box:BoundingBox, position:Vector3, radius:Vector3, velocity:Vector3, slidingSpeed:Float):Void
	{
		copyVertices=[];
	    _BoxTrace(octree, box);


		/*
                     var v1:Vector3 = Vector3.zero;
	                 var v2:Vector3 = Vector3.zero;
	                 var v3:Vector3 = Vector3.zero;

	 			
		for (i in 0 ... Std.int(copyVertices.length/3))
		{
	
			v1.x = copyVertices[i*3+0].x ;
			v1.y = copyVertices[i*3+0].y ;
			v1.z = copyVertices[i*3+0].z ;
		
			v2.x = copyVertices[i*3+1].x ;
			v2.y = copyVertices[i*3+1].y ;
			v2.z = copyVertices[i*3+1].z;
			
			v3.x = copyVertices[i * 3 + 2].x; 
			v3.y = copyVertices[i*3+2].y ;
			v3.z = copyVertices[i * 3 + 2].z ;
			    SceneManager.lines.drawTriangle(v1, v2, v3, 0, 1, 0, 1);
		
			}
			*/

    	collision=   Coldet.collideEllipsoidWithVerticesSimple(copyVertices, position, radius, velocity, slidingSpeed, SceneManager.lines);
	    position.copyFrom( collision.finalPosition);
			

		
	}
	
	public function BoxTrace( box:BoundingBox, position:Vector3, radius:Vector3, velocity:Vector3,gravity:Vector3, slidingSpeed:Float):Void
	{
		copyVertices=[];
		_BoxTrace(octree, box);

		             var v1:Vector3 = Vector3.zero;
	                 var v2:Vector3 = Vector3.zero;
	                 var v3:Vector3 = Vector3.zero;

	 				
		for (i in 0 ... Std.int(copyVertices.length/3))
		{
	
			v1.x = copyVertices[i*3+0].x ;
			v1.y = copyVertices[i*3+0].y ;
			v1.z = copyVertices[i*3+0].z ;
		
			v2.x = copyVertices[i*3+1].x ;
			v2.y = copyVertices[i*3+1].y ;
			v2.z = copyVertices[i*3+1].z;
			
			v3.x = copyVertices[i * 3 + 2].x; 
			v3.y = copyVertices[i*3+2].y ;
			v3.z = copyVertices[i * 3 + 2].z ;
			//    SceneManager.lines.drawTriangle(v1, v2, v3, 0, 1, 0, 1);
		
			}

	collision =   Coldet.collideEllipsoidWithVertices(copyVertices, position, radius, velocity,gravity, slidingSpeed, SceneManager.lines);
	position.copyFrom( collision.finalPosition);
			

		
	}
	private function _BoxTrace(pNode:Octree,box:BoundingBox):Void
	{
		if (pNode != null)
		{
		
			
			
			if (pNode.m_bSubDivided)
			{
		_BoxTrace(pNode.m_pOctreeNodes[Octree.TOP_LEFT_FRONT],box);
		_BoxTrace(pNode.m_pOctreeNodes[Octree.TOP_LEFT_BACK],box);
		_BoxTrace(pNode.m_pOctreeNodes[Octree.TOP_RIGHT_BACK],box);
		_BoxTrace(pNode.m_pOctreeNodes[Octree.TOP_RIGHT_FRONT],box);
		_BoxTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_LEFT_FRONT],box);
		_BoxTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_LEFT_BACK],box);
		_BoxTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_RIGHT_BACK],box);
		_BoxTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_RIGHT_FRONT],box);
		
			} else
			{
				if (pNode.m_pVertices.length <= 0) return;
				if (BoundingBox.IntersectsAAB(box, pNode.bounding.boundingBox))
				{
     		      #if  debug	 SceneManager.lines.drawABBox(pNode.bounding.boundingBox,1,0,0); #end
	    		 copyVertices=pNode.m_pVertices.copy();
			    }
			}
		}
	}
	
	public function RayTrace( ray:Ray):Bool
	{
		return _RayTrace(octree, ray);
	}
	private function _RayTrace(pNode:Octree,ray:Ray):Bool
	{
		
		var t0:Bool = false;
		var t1:Bool = false;
		var t2:Bool = false;
		var t3:Bool = false;
		var t4:Bool = false;
		var t5:Bool = false;
		var t6:Bool = false;
		var t7:Bool = false;
		
		
		if (pNode != null)
		{
		
		if (pNode.m_bSubDivided)
		{
		t0=_RayTrace(pNode.m_pOctreeNodes[Octree.TOP_LEFT_FRONT],ray);
		t1=_RayTrace(pNode.m_pOctreeNodes[Octree.TOP_LEFT_BACK],ray);
		t2=_RayTrace(pNode.m_pOctreeNodes[Octree.TOP_RIGHT_BACK],ray);
		t3=_RayTrace(pNode.m_pOctreeNodes[Octree.TOP_RIGHT_FRONT],ray);
		t4=_RayTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_LEFT_FRONT],ray);
		t5=_RayTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_LEFT_BACK],ray);
		t6=_RayTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_RIGHT_BACK],ray);
		t7=_RayTrace(pNode.m_pOctreeNodes[Octree.BOTTOM_RIGHT_FRONT], ray);
		}else
		if (ray.intersectsBox(pNode.bounding.boundingBox))
		{
				   if (pNode.m_pVertices.length <= 0) return false;
				
				   	var distance = Math.POSITIVE_INFINITY;
				   
					 var v1:Vector3 = Vector3.zero;
	                 var v2:Vector3 = Vector3.zero;
	                 var v3:Vector3 = Vector3.zero;

	 				
		for (i in 0 ... Std.int(pNode.m_pVertices.length/3))
		{
	
			v1.x = pNode.m_pVertices[i * 3 + 0].x ;
			v1.y = pNode.m_pVertices[i * 3 + 0].y ;
			v1.z = pNode.m_pVertices[i * 3 + 0].z ;		
			v2.x = pNode.m_pVertices[i * 3 + 1].x ;
			v2.y = pNode.m_pVertices[i * 3 + 1].y ;
			v2.z = pNode.m_pVertices[i * 3 + 1].z ;						
			v3.x = pNode.m_pVertices[i * 3 + 2].x ; 
			v3.y = pNode.m_pVertices[i * 3 + 2].y ;
			v3.z = pNode.m_pVertices[i * 3 + 2].z ;
			
			ContactPlane.copyFromPoints(v1, v2, v3);
			if ( !ContactPlane.isFrontFacingTo(ray.direction, 0)) continue;
			var currentDistance = ray.intersectsTriangle(v1,v2,v3);
	
			 if (currentDistance > 0) 
			{
				
                    distance = currentDistance;
					ContactPoint.x = ray.origin.x + (ray.direction.x * distance);
					ContactPoint.y = ray.origin.y + (ray.direction.y * distance);
					ContactPoint.z = ray.origin.z + (ray.direction.z * distance);
					
					
					
					ContactNormal.copyFrom(ContactPlane.normal);
					ContactDistance = distance;
					
			
					
				#if debug	SceneManager.lines.drawTriangle(v1, v2, v3, 1, 0, 0, 1); #end
				return true;
			}
			
		}	
	 }
	 }
	
	 		
	return (t0 || t1 || t2 || t3 || t4 || t5|| t6|| t7);
	
	}
	public function getContactPoint():Vector3
	{
		return ContactPoint;
	}
	public function getContactNormal():Vector3
	{
		return ContactNormal;
	}
	
	public function getContactPlane():Plane
	{
		return ContactPlane;
	}
	public function getContactDistance():Float
	{
		return ContactDistance;
	}
	private function _debug(pNode:Octree):Void
	{
		if (pNode != null)
		{
			SceneManager.lines.drawABBox(pNode.bounding.boundingBox,1,1,0);
				
			
			if (pNode.m_bSubDivided)
			{
		_debug(pNode.m_pOctreeNodes[Octree.TOP_LEFT_FRONT]);
		_debug(pNode.m_pOctreeNodes[Octree.TOP_LEFT_BACK]);
		_debug(pNode.m_pOctreeNodes[Octree.TOP_RIGHT_BACK]);
		_debug(pNode.m_pOctreeNodes[Octree.TOP_RIGHT_FRONT]);
		_debug(pNode.m_pOctreeNodes[Octree.BOTTOM_LEFT_FRONT]);
		_debug(pNode.m_pOctreeNodes[Octree.BOTTOM_LEFT_BACK]);
		_debug(pNode.m_pOctreeNodes[Octree.BOTTOM_RIGHT_BACK]);
		_debug(pNode.m_pOctreeNodes[Octree.BOTTOM_RIGHT_FRONT]);
				
		
			} 
			
		}
	}
	
	public function debug():Void
	{
		SceneManager.lines.drawABBox(octree.bounding.boundingBox,0,1,1);
		_debug(octree);
	}
	
}