package com.gdx.scene3d.partition;
import com.gdx.gl.MeshBuffer;
import com.gdx.math.BoundingBox;
import com.gdx.math.Ray;
import com.gdx.math.Vector3;
import com.gdx.scene3d.Node;
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
class NodeOctree extends Node
{
    public var  Root:OctreeNode;
	 public var NodeCount:Int;
	 public var MinimalPolysPerNode:Int;
     private var maxNodes:Int;

	 
	public function new(minimalPolysPerNode:Int,?parent:Node=null,?id:Int=0,?Name:String="OctreeNode") 
	{
		
		super(parent, Name,id);	
	
		this.MinimalPolysPerNode = minimalPolysPerNode;
		this.NodeCount = 0;
		Root = new OctreeNode();
		
		
	}
	
	public function addNode(n:SceneNode):Int
	{
		var node = new OctreeNode();
		n.getTransformBox();
		n.CullMeshBuffers = false;
		node.node = n;
		node.Box.minimum.copyFrom(n.Bounding.minimumWorld);
		node.Box.maximum.copyFrom(n.Bounding.maximumWorld);
		Root.nodes.push(node);
		return Root.nodes.length - 1;
		
	}
	public function build():Void
	{
		NodeCount = 0;
		maxNodes = Root.nodes.length;
		var beginTime:Float = Gdx.Instance().getTimer();
		constructOctree(Root);
		var endTime:Float = Gdx.Instance().getTimer();
		var timepass:Float = endTime - beginTime;
		
		Bounding.update(Matrix.Identity());
		
		trace( "Needed " + timepass + ":ms to create OctTree .(" + NodeCount + " nodes, " + maxNodes + " nodes)" );	
	}
	
	override public function render(cam:Camera):Void
	{
	     renderNodes(Root,cam);
	  }
	 private function renderNodes(node:OctreeNode,cam:Camera):Void
	{
		 if (node == null) return;
	     
	    if (!node.Box.isInFrustum(cam.frustumPlanes)) return;
		
		 for (i in 0 ... node.nodes.length)
	     {
			       var m:Node =  node.nodes[i].node;
				    m.render(cam);
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
		
		return;
		
	    lines.drawOBBox(Root.Box, 1, 1, 1);
	    _Debug(this.Root, lines);
		
	}
	


	
private function _Debug(node:OctreeNode,l:Imidiatemode):Void
{
	
	l.drawOBBox(node.Box, 0, 1, 0);

	
	for (i in 0...8)
	{
		if (node.Child[i] != null)
		{
			_Debug(node.Child[i],l);
		}
	}
}

	
	private function constructOctree(node:OctreeNode):Void
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
  node.Box.update(Matrix.Identity());
	
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

		node.Child[ch] = new OctreeNode();
		
 	    var i = 0;
        while (i < node.nodes.length) 
		{
			
			 if (node.nodes[i].Box.isFullInside(box))
			{
			
				node.Child[ch].nodes.push(node.nodes[i]);
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



class OctreeNode
{
	public var node:SceneNode;
	public var Child:Array<OctreeNode>;
	public var nodes:Array<OctreeNode>;
	public var Box:BoundingBox;
	public function new() 
	{
		node = null;
		Child = [];
		nodes = [];
		Box = new BoundingBox(new Vector3(999999,999999,999999),new Vector3(-999999,-999999,-999999));
	}
	
}