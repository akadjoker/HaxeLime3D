package com.gdx.scene3d.partition;
import com.gdx.gl.MeshBuffer;
import com.gdx.math.BoundingBox;
import com.gdx.math.Ray;
import com.gdx.math.Vector3;
import com.gdx.scene3d.SceneNode;
import com.gdx.util.Util;

import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.shaders.Shader;
import com.gdx.gl.Texture;
import com.gdx.math.Matrix;
import com.gdx.scene3d.cameras.Camera;
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
class NodeMeshOctree extends SceneNode
{
    public var  Root:SurfaceOctreeNode;
	 public var NodeCount:Int;
	 public var MinimalPolysPerNode:Int;
	 public var nodesVisible:Int;


	 
	public function new(mesh:Mesh,minimalPolysPerNode:Int,?parent:Node=null,?id:Int=0,?Name:String="OctreeNode") 
	{
		var beginTime:Float = Gdx.Instance().getTimer();
		
		super(mesh,parent, id,Name);	
	
		this.MinimalPolysPerNode = minimalPolysPerNode;
		this.NodeCount = 0;
		var maxTriangles:Int = mesh.surfaces.length;
		
	nodesVisible = 0;
		
		
		Root = new SurfaceOctreeNode();
		for ( i in 0...mesh.surfaces.length)
		{
		add( mesh.surfaces[i]);
		}

		constructOctree(Root);
		
	
		sort(Root);
	
		var endTime:Float = Gdx.Instance().getTimer();
		var timepass:Float = endTime - beginTime;
		
		trace( "Needed " + timepass + ":ms to create OctTree .(" + NodeCount+ " nodes, "+mesh.surfaces.length+" polys)" );	
	}
	
	private function add(buffer:MeshBuffer):Void
	{
		var node = new SurfaceOctreeNode();
		node.buffer = buffer;
		node.materialIndex = buffer.materialIndex;
		node.Box.minimum.copyFrom(buffer.Bounding.boundingBox.minimum);
		node.Box.maximum.copyFrom(buffer.Bounding.boundingBox.maximum);
		Root.nodes.push(node);
		
	}
	
	override public function render(camera:Camera):Void
	{
		 nodesVisible = 0;
	     if (!Bounding.isInFrustum(camera.frustumPlanes)) return;
         Gdx.Instance().numMesh++;
	     mesh.pipline.Bind(camera.viewMatrix, camera.projMatrix, local_tform);
		 renderNodes(Root,camera);
	  }
	 private function renderNodes(node:SurfaceOctreeNode,cam:Camera):Void
	{
		 if (node == null) return;
	     if (!node.Box.isInFrustum(cam.frustumPlanes)) return;
		
		 
		 nodesVisible += 1;
		 
		 for (i in 0 ... node.nodes.length)
	     {
			       var m:MeshBuffer =  node.nodes[i].buffer;
				    if (!m.Bounding.isInFrustum(cam.frustumPlanes)) continue;
					
					m.render();
					
	     }
		 
	for (i in 0...8)
	{
		if (node.Child[i] != null)
		{
			renderNodes(node.Child[i],cam);
		}
	}
		
	}
	override public function debug(lines:Imidiatemode):Void
	{
	
		
		
		if (this.Root == null) return;
		if ((debugFlags & Gdx.DEBUGNODEOBB) == Gdx.DEBUGNODEOBB)
		{
	    lines.drawABBox(Root.Box, 1, 1, 1);
		}
	    _Debug(this.Root, lines);
		
	}
	

	
private function _Debug(node:SurfaceOctreeNode,l:Imidiatemode):Void
{
	if ( (debugFlags & Gdx.DEBUGSURFOBB) == Gdx.DEBUGSURFOBB) 
	{
	//l.drawABBox(node.Box, 1, 0, 0);
	l.drawOBBox(node.Box, 0, 1, 0);
	
	 
	
	for (i in 0...8)
	{
		if (node.Child[i] != null)
		{
			_Debug(node.Child[i],l);
		}
	}
	}
}

public function sort(node:SurfaceOctreeNode):Void
{
	Root.sortMaterial();
	
	node.Box.calculate();
	node.Box.update(local_tform);
	for (i in 0...8)
	{
		if (node.Child[i] != null)
		{
			sort(node.Child[i]);
		}
	}
	
}

	private function constructOctree(node:SurfaceOctreeNode):Void
{
	++NodeCount;
	
	
	node.Box.reset(node.nodes[0].Box.getCenter());


	
	
	// get bounding box
	var cnt:Int = node.nodes.length;
	for( i in 0... cnt)
	{
		node.Box.addInternalBox(node.nodes[i].Box);
		Bounding.addInternalBox(node.nodes[i].Box);
	}

  
  node.Box.calculate();
  
	
	var middle:Vector3 = node.Box.getCenter();
	var edges:Array<Vector3> = [];
	 node.Box.getEdges(edges);
	 
	 

	var box:BoundingBox = new BoundingBox(Vector3.zero,Vector3.zero);
	
	

	// calculate children

	if (!node.Box.isEmpty() && Std.int(node.nodes.length) > MinimalPolysPerNode)
	for (ch in 0 ...8)
	{
	
		box.reset(middle);
		box.addInternalVector(edges[ch]);

		node.Child[ch] = new SurfaceOctreeNode();
		
 	   var i = 0;
        while (i < node.nodes.length) 
		{
			
			 if (node.nodes[i].Box.isFullInside(box))
			{
			
				node.Child[ch].addNode(node.nodes[i]);
				//node.Child[ch].nodes.push(node.nodes[i]);
				node.nodes.splice(i,1);
				--i;
			} 
			++i;
		}
	
		if (node.Child[ch].nodes.length<=0)
		{
			node.Child[ch].nodes = [];
			node.Child[ch].nodes = null;
			node.Child[ch] = null;

		}
		else
			constructOctree(node.Child[ch]);
	}
	
}
	
}



class SurfaceOctreeNode
{
	
	public var Child:Array<SurfaceOctreeNode>;//octre chils (8)
	public var nodes:Array<SurfaceOctreeNode>;
	public var Box:BoundingBox;
	public var buffer:MeshBuffer;
	public var materialIndex:Int;
	public function new() 
	{
		materialIndex = -1;
		buffer = null;
		Child = [];
		nodes = [];
		Box = new BoundingBox(new Vector3(999999,999999,999999),new Vector3(-999999,-999999,-999999));
	}
	public function addNode(n:SurfaceOctreeNode):Void
	{
		nodes.push(n);
	}
	public function sortMaterial():Void
	{
	nodes.sort(SortmaterialIndex);
	}
	
	private function SortmaterialIndex(a:SurfaceOctreeNode, b:SurfaceOctreeNode):Int
    {

    if (a.materialIndex < b.materialIndex) return -1;
    if (a.materialIndex > b.materialIndex) return 1;
    return 0;
    } 
	
}