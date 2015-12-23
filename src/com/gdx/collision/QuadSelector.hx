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
class QuadSelector
{
	private var ContactPoint:Vector3;
	private var ContactNormal:Vector3;
	private var ContactPlane:Plane;
	private var ContactDistance:Float;
	public var collision:CollisionData;
	
	private var MaxTriangles:Int;
	private var MaxSubdivisions:Int;
	private var qaudtree:QuadTree;
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
		copyVertices = [];
	
	}
	public function addVertices(buffer:Array<Vector3>):Void
	{
			for (i in 0... buffer.length)
			{
				  vertices.push(buffer[i]);
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
	public function addLargeLandscape(land:MeshLargeLandScape):Void
	{
		
		for (chunk in land.chunks)
		{
			for (i in 0... chunk.buffer.CountTriangles())
			{
				  var v0:Vector3 = chunk.buffer.getFace(i, 0);
				  var v1:Vector3 = chunk.buffer.getFace(i, 1);
				  var v2:Vector3 = chunk.buffer.getFace(i, 2);
				  
				  vertices.push(v2);
				  vertices.push(v1);
				  vertices.push(v0);
				  
				
			}
		}
		
	}
	public function build():Void
	{
		qaudtree = new QuadTree(MaxTriangles,MaxSubdivisions);
		qaudtree.build(vertices);
	}

	public function BoxTrace( box:BoundingBox, position:Vector3, radius:Vector3, velocity:Vector3,gravity:Vector3, slidingSpeed:Float):Void
	{
		copyVertices=[];
	    _BoxTraceSimples(qaudtree, box);
		

	collision =   Coldet.collideEllipsoidWithVertices(copyVertices, position, radius, velocity,gravity, slidingSpeed, SceneManager.lines);
	position.copyFrom( collision.finalPosition);
			

	}
	public function BoxTraceSimples( box:BoundingBox, position:Vector3, radius:Vector3, velocity:Vector3, slidingSpeed:Float):Void
	{
		copyVertices=[];
	    _BoxTraceSimples(qaudtree, box);
		
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
			//    SceneManager.lines.drawTriangle(v1, v2, v3, 0, 1, 0, 1);
		
			}
*/
	collision =   Coldet.collideEllipsoidWithVerticesSimple(copyVertices, position, radius, velocity, slidingSpeed, SceneManager.lines);
	position.copyFrom( collision.finalPosition);
			

	}
	
	private function _BoxTraceSimples(node:QuadTree,box:BoundingBox):Void
	{
		if (node != null)
		{
			
			if (node.m_bSubDivided)
			{
				_BoxTraceSimples(node.m_pOctreeNodes[QuadTree.LEFT_FRONT],box);
				_BoxTraceSimples(node.m_pOctreeNodes[QuadTree.LEFT_BACK] ,box);
				_BoxTraceSimples(node.m_pOctreeNodes[QuadTree.RIGHT_BACK],box);
				_BoxTraceSimples(node.m_pOctreeNodes[QuadTree.RIGHT_FRONT],box);
				
		
			} else
			{
			
				if (node.m_pVertices.length <= 0) return;
				if (BoundingBox.IntersectsAAB(box, node.bounding.boundingBox))
				{
     		   	#if debug SceneManager.lines.drawABBox(node.bounding.boundingBox,1,0,0); #end
	    		 copyVertices=node.m_pVertices.copy();
			    }
				
			}
			
		}
	}
	public function RayColect( ray:Ray):Array<Vector3>
	{
		 copyVertices=[];
		_RayColect(qaudtree, ray);
		 return copyVertices;
	}
	private function _RayColect(pNode:QuadTree,ray:Ray):Void
	{
		if (pNode != null)
		{
			if (!ray.intersectsBox(pNode.bounding.boundingBox)) return ;
			
			#if debug SceneManager.lines.drawABBox(pNode.bounding.boundingBox, 1, 0, 1); #end
			
			if (pNode.m_bSubDivided)
			{
		    _RayColect(pNode.m_pOctreeNodes[QuadTree.LEFT_FRONT],ray);
		    _RayColect(pNode.m_pOctreeNodes[QuadTree.LEFT_BACK],ray);
		    _RayColect(pNode.m_pOctreeNodes[QuadTree.RIGHT_BACK],ray);
		    _RayColect(pNode.m_pOctreeNodes[QuadTree.RIGHT_FRONT],ray);
			} else
			{
			 copyVertices=pNode.m_pVertices.copy();
	      	}
		}
		
	}

	
	public function RayTrace( ray:Ray):Bool
	{
		return _RayTrace(qaudtree, ray);
	}
	private function _RayTrace(pNode:QuadTree,ray:Ray):Bool
	{
		if (pNode != null)
		{
			if (!ray.intersectsBox(pNode.bounding.boundingBox)) return false;
		#if debug	SceneManager.lines.drawABBox(pNode.bounding.boundingBox,1,0,1); #end
			
			
			
			if (pNode.m_bSubDivided)
			{
		_RayTrace(pNode.m_pOctreeNodes[QuadTree.LEFT_FRONT],ray);
		_RayTrace(pNode.m_pOctreeNodes[QuadTree.LEFT_BACK],ray);
		_RayTrace(pNode.m_pOctreeNodes[QuadTree.RIGHT_BACK],ray);
		_RayTrace(pNode.m_pOctreeNodes[QuadTree.RIGHT_FRONT],ray);
		
		
			} else
			{
				   if (pNode.m_pVertices.length <= 0) return false;
				
					 var v1:Vector3 = Vector3.zero;
	                 var v2:Vector3 = Vector3.zero;
	                 var v3:Vector3 = Vector3.zero;

	 				
		for (i in 0 ... Std.int(pNode.m_pVertices.length/3))
		{
	
			v1.x = pNode.m_pVertices[i*3+0].x ;
			v1.y = pNode.m_pVertices[i*3+0].y ;
			v1.z = pNode.m_pVertices[i*3+0].z ;
		
			v2.x = pNode.m_pVertices[i*3+1].x ;
			v2.y = pNode.m_pVertices[i*3+1].y ;
			v2.z = pNode.m_pVertices[i*3+1].z;
			
			v3.x = pNode.m_pVertices[i * 3 + 2].x; 
			v3.y = pNode.m_pVertices[i*3+2].y ;
			v3.z = pNode.m_pVertices[i * 3 + 2].z ;
			
			if (ray.intersectsTriangle(v1, v2, v3) > 0)
			{
			//	SceneManager.lines.drawFillTriangle(v3, v2, v1, 1, 0, 0, 1);
			  //  SceneManager.lines.drawTriangle(v1, v2, v3, 0, 1, 0, 1);
				return true;
			}
			
			
		}
					
			
			}
			
		}
		return false;
	}
	public function SphereTraceSimples(sphereRadius:Float,position:Vector3, radius:Vector3, velocity:Vector3, slidingSpeed:Float):Void
	{	copyVertices=[];
		_SphereTraceSimples(this.qaudtree, sphereRadius, position);
		collision =   Coldet.collideEllipsoidWithVerticesSimple(copyVertices, position, radius, velocity, slidingSpeed, SceneManager.lines);
	    position.copyFrom( collision.finalPosition);
	}
	
	private function _SphereTraceSimples(node:QuadTree, sphereRadius:Float,position:Vector3):Void
	{
		if (node != null)
		{
			
			if (node.m_bSubDivided)
			{
				_SphereTraceSimples(node.m_pOctreeNodes[QuadTree.LEFT_FRONT],sphereRadius,position);
				_SphereTraceSimples(node.m_pOctreeNodes[QuadTree.LEFT_BACK] ,sphereRadius,position);
				_SphereTraceSimples(node.m_pOctreeNodes[QuadTree.RIGHT_BACK],sphereRadius,position);
				_SphereTraceSimples(node.m_pOctreeNodes[QuadTree.RIGHT_FRONT],sphereRadius,position);
				
		
			} else
			{
				
				if(BoundingBox.IntersectsSphere(node.bounding.boundingBox.minimumWorld,node.bounding.boundingBox.maximumWorld,position,sphereRadius))
				{
				 
				 copyVertices=node.m_pVertices.copy();
				} 
				
			}
			
		}
	}
	
	private function _debug(node:QuadTree):Void
	{
		if (node != null)
		{
			
			if (node.m_bSubDivided)
			{
				_debug(node.m_pOctreeNodes[QuadTree.LEFT_FRONT]);
				_debug(node.m_pOctreeNodes[QuadTree.LEFT_BACK]);
				_debug(node.m_pOctreeNodes[QuadTree.RIGHT_BACK]);
				_debug(node.m_pOctreeNodes[QuadTree.RIGHT_FRONT]);
				
		
			} else
			{
				SceneManager.lines.drawABBox(node.bounding.boundingBox,0,1,1);
				
			}
			
		}
	}
	
	public function debug():Void
	{
		SceneManager.lines.drawABBox(qaudtree.bounding.boundingBox,1,0,1);
		_debug(qaudtree);
	}
	
	private function _BoxTrace(node:QuadTree,box:BoundingBox,position:Vector3,  velocity:Vector3,radius:Vector3):Void
	{
		if (node != null)
		{
			
			if (node.m_bSubDivided)
			{
				_BoxTrace(node.m_pOctreeNodes[QuadTree.LEFT_FRONT],box,position,velocity,radius);
				_BoxTrace(node.m_pOctreeNodes[QuadTree.LEFT_BACK] ,box,position,velocity,radius);
				_BoxTrace(node.m_pOctreeNodes[QuadTree.RIGHT_BACK],box,position,velocity,radius);
				_BoxTrace(node.m_pOctreeNodes[QuadTree.RIGHT_FRONT],box,position,velocity,radius);
				
		
			} else
			{
			if (BoundingBox.Intersects(box, node.bounding.boundingBox))
			{
			 if (node.m_pVertices.length <= 0) return ;
			 copyVertices=node.m_pVertices.copy();
			}
		   }
		}
	}
	
	
	

}