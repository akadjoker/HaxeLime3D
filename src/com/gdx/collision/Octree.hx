package com.gdx.collision;

import com.gdx.math.BoundingInfo;
import com.gdx.math.Matrix;
import com.gdx.math.Plane;
import com.gdx.math.Ray;
import com.gdx.math.Triangle;
import com.gdx.math.Vector3;
import com.gdx.gl.Imidiatemode;

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
class Octree
{
	
	private var v1:Vector3 = Vector3.zero;
	private var v2:Vector3 = Vector3.zero;
	private var v3:Vector3 = Vector3.zero;
	 
	public  static var numNodes:Int = 0;
	
	private   var g_CurrentSubdivision:Int = 0;
	private   var g_MaxTriangles:Int;

// The maximum amount of subdivisions allow (Levels of subdivision)
	private   var g_MaxSubdivisions:Int;

// The amount of end nodes created in the octree (That hold vertices)
	private   var g_EndNodeCount:Int=0;




	
	   public static inline  var TOP_LEFT_FRONT:Int = 0;
	   public static inline   var TOP_LEFT_BACK:Int = 1;
	   public static inline  var TOP_RIGHT_BACK:Int = 2;
	   public static inline   var TOP_RIGHT_FRONT:Int = 3;
	   public static inline  var BOTTOM_LEFT_FRONT:Int = 4;
	   public static inline  var BOTTOM_LEFT_BACK:Int = 5;
	   public static inline  var BOTTOM_RIGHT_BACK:Int = 6;
	   public static inline  var BOTTOM_RIGHT_FRONT:Int = 7;
	

	public var m_bSubDivided:Bool;

	// This is the size of the cube for this current node
	public var m_Width:Float;

	// This holds the amount of triangles stored in this node
	public var m_TriangleCount:Int;

	// This is the center (X, Y, Z) point in this node
	public var m_vCenter:Vector3;
	
	public var bounding:BoundingInfo;
	
	public var m_pVertices:Array<Vector3>;
	
	public var m_pOctreeNodes:Array<Octree>;
	


	
	public function new(MaxTriangles:Int,MaxSubdivisions:Int) 
	{
		g_MaxSubdivisions = MaxSubdivisions;
		g_MaxTriangles = MaxTriangles;
		m_pVertices = [];
		m_pOctreeNodes = [];

		m_bSubDivided = false;

		
	// Set the dimensions of the box to false
	m_Width = 0; 

	// Initialize the triangle count
	m_TriangleCount = 0;


	// Initialize the center of the box to the 0
	m_vCenter = Vector3.zero;
	g_CurrentSubdivision = 0;

	}
	public function build(pVertices:Array<Vector3>):Void
	{
		Octree.numNodes = 0;
		var beginTime:Float = Gdx.Instance().getTimer();
		
		GetSceneDimensions(pVertices);
		CreateNode(pVertices, pVertices.length, m_vCenter, m_Width);
		
		var endTime:Float = Gdx.Instance().getTimer();
		var timepass:Float = endTime - beginTime;
		
		
			
		
		
		trace( "Needed " + timepass + ":ms to create OctTree .(" + Octree.numNodes + " nodes.");
		

		
	}
	
	


	public function GetSceneDimensions(pVertices:Array<Vector3>):Void
{
	// We pass in the list of vertices and the vertex count to get the
	// center point and width of the whole scene.  We use this information
	// to subdivide our octree.  Eventually, in the next tutorial it won't
	// just be a list of vertices, but another structure that holds all the
	// normals and texture information.  It's easy to do once you understand vertices.

	// Initialize some temporary variables to hold the max dimensions found
	var maxWidth:Float = 0; 
	var maxHeight:Float = 0;
	var maxDepth :Float = 0;

	
	// Below we calculate the center point of the scene.  To do this, all you
	// need to do is add up ALL the vertices, then divide that total by the
	// number of vertices added up.  So all the X's get added up together, then Y's, etc..
	// This doesn't mean in a single number, but 3 separate floats (totalX, totalY, totalZ).
	// Notice that we are adding 2 vectors together.  If you look in the CVector3 class
	// I overloaded the + and - operator to handle it correctly.  It cuts down on code
	// instead of added the x, then the y, then the z separately.  If you don't want
	// to use operator overloading just make a function called CVector AddVector(), etc...

	var numberOfVerts:Int = pVertices.length;
	
		// Go through all of the vertices and add them up to eventually find the center
	for(i in 0 ... numberOfVerts )
	{
		// Add the current vertex to the center variable (Using operator overloading)
		m_vCenter.x = m_vCenter.x + pVertices[i].x;
		m_vCenter.y = m_vCenter.y + pVertices[i].y;
		m_vCenter.z = m_vCenter.z + pVertices[i].z;
	}

	// Divide the total by the number of vertices to get the center point.
	// We could have overloaded the / symbol but I chose not to because we rarely use it.
	m_vCenter.x /= numberOfVerts;
	m_vCenter.y /= numberOfVerts;	
	m_vCenter.z /= numberOfVerts;

	// Now that we have the center point, we want to find the farthest distance from
	// our center point.  That will tell us how big the width of the first node is.
	// Once we get the farthest height, width and depth, we then check them against each
	// other.  Which ever one is higher, we then use that value for the cube width.

	// Go through all of the vertices and find the max dimensions
	for(i in 0 ... numberOfVerts)
	{
		// Get the current dimensions for this vertex.  We use the fabsf() function
		// to get the floating point absolute value because it might return a negative number.
		var currentWidth:Float  = Math.abs(pVertices[i].x - m_vCenter.x);	
		var currentHeight:Float = Math.abs(pVertices[i].y - m_vCenter.y);		
		var currentDepth:Float  = Math.abs(pVertices[i].z - m_vCenter.z);	

		// Check if the current width value is greater than the max width stored.
		if(currentWidth  > maxWidth)	maxWidth  = currentWidth;

		// Check if the current height value is greater than the max height stored.
		if(currentHeight > maxHeight)	maxHeight = currentHeight;

		// Check if the current depth value is greater than the max depth stored.
		if(currentDepth > maxDepth)		maxDepth  = currentDepth;
	}

	// Set the member variable dimensions to the max ones found.
	// We multiply the max dimensions by 2 because this will give us the
	// full width, height and depth.  Otherwise, we just have half the size
	// because we are calculating from the center of the scene.
	maxWidth *= 2;		maxHeight *= 2;		maxDepth *= 2;

	// Check if the width is the highest value and assign that for the cube dimension
	if(maxWidth > maxHeight && maxWidth > maxDepth)
		m_Width = maxWidth;

	// Check if the height is the heighest value and assign that for the cube dimension
	else if(maxHeight > maxWidth && maxHeight > maxDepth)
		m_Width = maxHeight;

	// Else it must be the depth or it's the same value as some of the other ones
	else
		m_Width = maxDepth;
		
		
	//trace(this.m_vCenter.toString()+" + " + m_Width);
 }

 
 public function GetNewNodeCenter( vCenter:Vector3,  width:Float, nodeID:Int):Vector3
{
	// I created this function which takes an enum ID to see which node's center
	// we need to calculate.  Once we find that we need to subdivide a node we find
	// the centers of each of the 8 new nodes.  This is what that function does.
	// We just tell it which node we want.

	// Initialize the new node center
	var vNodeCenter:Vector3 = Vector3.zero;

	// Create a dummy variable to cut down the code size
	 var vCtr:Vector3 = vCenter;

	// Switch on the ID to see which subdivided node we are finding the center
	switch nodeID 
	{
		case Octree.TOP_LEFT_FRONT:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x - width/4, vCtr.y + width/4, vCtr.z + width/4);


		case Octree.TOP_LEFT_BACK:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x - width/4, vCtr.y + width/4, vCtr.z - width/4);


		case Octree.TOP_RIGHT_BACK:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x + width/4, vCtr.y + width/4, vCtr.z - width/4);


		case Octree.TOP_RIGHT_FRONT:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x + width/4, vCtr.y + width/4, vCtr.z + width/4);


		case Octree.BOTTOM_LEFT_FRONT:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x - width/4, vCtr.y - width/4, vCtr.z + width/4);


		case Octree.BOTTOM_LEFT_BACK:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x - width/4, vCtr.y - width/4, vCtr.z - width/4);
		

		case Octree.BOTTOM_RIGHT_BACK:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x + width/4, vCtr.y - width/4, vCtr.z - width/4);
	

		case Octree.BOTTOM_RIGHT_FRONT:
			// Calculate the center of this new node
			vNodeCenter = new Vector3(vCtr.x + width/4, vCtr.y - width/4, vCtr.z + width/4);
	
	}

	// Return the new node center
	return vNodeCenter;
}
/////	This allocates memory for the vertices to assign to the current end node

public function AssignVerticesToNode(pVertices:Array<Vector3>,  numberOfVerts:Int):Void
{
	// Since we did not subdivide this node we want to set our flag to false
	m_bSubDivided = false;

	// Initialize the triangle count of this end node (total verts / 3 = total triangles)
	m_TriangleCount = Std.int(numberOfVerts / 3);

	// Allocate enough memory to hold the needed vertices for the triangles
	m_pVertices = [];// new CVector3 [numberOfVerts];

	// Initialize the vertices to 0 before we copy the data over to them
	//memset(m_pVertices, 0, sizeof(CVector3) * numberOfVerts);
	for (i in 0 ... numberOfVerts)
	{
		m_pVertices.push(pVertices[i]);
	}
	


	// Copy the passed in vertex data over to our node vertice data
	//memcpy(m_pVertices, pVertices, sizeof(CVector3) * numberOfVerts);

	// Increase the amount of end nodes created (Nodes with vertices stored)
	g_EndNodeCount++;
	
	Octree.numNodes++;
	
}

///////////////////////////////// CREATE NEW NODE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*
/////
/////	This figures out the new node information and then passes it into CreateNode()
/////
///////////////////////////////// CREATE NEW NODE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

public function CreateNewNode(pVertices:Array<Vector3>,pList:Array<Bool>,numberOfVerts:Int, vCenter:Vector3 ,width:Float,  triangleCount:Int,nodeID:Int ):Void
{
	// This function helps us set up the new node that is being created.  We only
	// want to create a new node if it found triangles in it's area.  If there were
	// no triangle found in this node's cube, then we ignore it and don't create a node.

	// Check if the first node found some triangles in it

		// Allocate memory for the triangles found in this node (tri's * 3 for vertices)
		var pNodeVertices:Array<Vector3> =  [];

		// Create an counter to count the current index of the new node vertices
		var index:Int = 0;

		// Go through all the vertices and assign the vertices to the node's list
		for(i in 0 ... pVertices.length )
		{
			// If this current triangle is in the node, assign it's vertices to it
			if(pList[Std.int(i / 3)])	
			{
				pNodeVertices[index] = pVertices[i];
				index++;
			}
		}

		// Now comes the initialization of the node.  First we allocate memory for
		// our node and then get it's center point.  Depending on the nodeID, 
		// GetNewNodeCenter() knows which center point to pass back (TOP_LEFT_FRONT, etc..)

		// Allocate a new node for this octree
		m_pOctreeNodes[nodeID] = new Octree(g_MaxTriangles, g_MaxSubdivisions);
		
		
		
		
		
		

		// Get the new node's center point depending on the nodexIndex (which of the 8 subdivided cubes).
		var vNodeCenter:Vector3 = GetNewNodeCenter(vCenter, width, nodeID);
		
		// Below, before and after we recurse further down into the tree, we keep track
		// of the level of subdivision that we are in.  This way we can restrict it.

		// Increase the current level of subdivision
		g_CurrentSubdivision++;
		//trace(Octree.g_CurrentSubdivision);

		// Recurse through this node and subdivide it if necessary
		m_pOctreeNodes[nodeID].CreateNode(pNodeVertices, triangleCount * 3, vNodeCenter, width / 2);

		// Decrease the current level of subdivision
		g_CurrentSubdivision--;

		// Free the allocated vertices for the triangles found in this node
	 pNodeVertices = null;
	}
	/////	This is our recursive function that goes through and subdivides our nodes
/////
///////////////////////////////// CREATE NODE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*

	public function CreateNode(pVertices:Array<Vector3>, numberOfVerts:Int,  vCenter:Vector3, width:Float):Void
{
	// This is our main function that creates the octree.  We will recurse through
	// this function until we finish subdividing.  Either this will be because we
	// subdivided too many levels or we divided all of the triangles up.

	// Create a variable to hold the number of triangles
	var numberOfTriangles = Std.int(numberOfVerts / 3);

	// Initialize this node's center point.  Now we know the center of this node.
	m_vCenter = vCenter;

	// Initialize this nodes cube width.  Now we know the width of this current node.
	m_Width = width;
	
	

		var min:Vector3 = new Vector3(m_vCenter.x - (m_Width/2) , m_vCenter.y - (m_Width/2), m_vCenter.z - (m_Width/2) );
		var max:Vector3 = new Vector3(m_vCenter.x + (m_Width/2) , m_vCenter.y + (m_Width/2) , m_vCenter.z + (m_Width/2) );
		bounding = new BoundingInfo(min, max);
		
	

	
	// Add the current node to our debug rectangle list so we can visualize it.
	// We can now see this node visually as a cube when we render the rectangles.
	// Since it's a cube we pass in the width for width, height and depth.
//	AddDebugRectangle(vCenter, width, width, width);

	// Check if we have too many triangles in this node and we haven't subdivided
	// above our max subdivisions.  If so, then we need to break this node into
	// 8 more nodes (hence the word OCTree).  Both must be true to divide this node.
	if( (numberOfTriangles > g_MaxTriangles) && (g_CurrentSubdivision < g_MaxSubdivisions) )
	{
		// Since we need to subdivide more we set the divided flag to true.
		// This let's us know that this node does NOT have any vertices assigned to it,
		// but nodes that perhaps have vertices stored in them (Or their nodes, etc....)
		// We will querey this variable when we are drawing the octree.
		m_bSubDivided = true;

		// Create a list for each new node to store if a triangle should be stored in it's
		// triangle list.  For each index it will be a true or false to tell us if that triangle
		// is in the cube of that node.  Below we check every point to see where it's
		// position is from the center (I.E. if it's above the center, to the left and 
		// back it's the TOP_LEFT_BACK node).  Depending on the node we set the pList 
		// index to true.  This will tell us later which triangles go to which node.
		// You might catch that this way will produce doubles in some nodes.  Some
		// triangles will intersect more than 1 node right?  We won't split the triangles
		// in this tutorial just to keep it simple, but the next tutorial we will.

		// Create the list of booleans for each triangle index
		var  pList1:Array<Bool> = [];		// TOP_LEFT_FRONT node list
		var  pList2:Array<Bool> = [];		// TOP_LEFT_BACK node list
		var  pList3:Array<Bool> = [];		// TOP_RIGHT_BACK node list
		var  pList4:Array<Bool> = [];		// TOP_RIGHT_FRONT node list
		var  pList5:Array<Bool> = [];		// BOTTOM_LEFT_FRONT node list
		var  pList6:Array<Bool> = [];		// BOTTOM_LEFT_BACK node list
		var  pList7:Array<Bool> = [];		// BOTTOM_RIGHT_BACK node list
		var  pList8:Array<Bool> = [];		// BOTTOM_RIGHT_FRONT node list
	
		// Create this variable to cut down the thickness of the code below (easier to read)
		var vCtr:Vector3 = vCenter;

		// Go through all of the vertices and check which node they belong too.  The way
		// we do this is use the center of our current node and check where the point
		// lies in relationship to the center.  For instance, if the point is 
		// above, left and back from the center point it's the TOP_LEFT_BACK node.
		// You'll see we divide by 3 because there are 3 points in a triangle.
		// If the vertex index 0 and 1 are in a node, 0 / 3 and 1 / 3 is 0 so it will
		// just set the 0'th index to TRUE twice, which doesn't hurt anything.  When
		// we get to the 3rd vertex index of pVertices[] it will then be checking the
		// 1st index of the pList*[] array.  We do this because we want a list of the
		// triangles in the node, not the vertices.
		for(i in 0... numberOfVerts)
		{
			// Create some variables to cut down the thickness of the code (easier to read)
			var vPoint:Vector3 = pVertices[i];

			// Check if the point lines within the TOP LEFT FRONT node
			if( (vPoint.x <= vCtr.x) && (vPoint.y >= vCtr.y) && (vPoint.z >= vCtr.z) ) 
				pList1[Std.int(i / 3)] = true;

			// Check if the point lines within the TOP LEFT BACK node
			if( (vPoint.x <= vCtr.x) && (vPoint.y >= vCtr.y) && (vPoint.z <= vCtr.z) ) 
				pList2[Std.int(i / 3)] = true;

			// Check if the point lines within the TOP RIGHT BACK node
			if( (vPoint.x >= vCtr.x) && (vPoint.y >= vCtr.y) && (vPoint.z <= vCtr.z) ) 
				pList3[Std.int(i / 3)] = true;

			// Check if the point lines within the TOP RIGHT FRONT node
			if( (vPoint.x >= vCtr.x) && (vPoint.y >= vCtr.y) && (vPoint.z >= vCtr.z) ) 
				pList4[Std.int(i / 3)] = true;

			// Check if the point lines within the BOTTOM LEFT FRONT node
			if( (vPoint.x <= vCtr.x) && (vPoint.y <= vCtr.y) && (vPoint.z >= vCtr.z) ) 
				pList5[Std.int(i / 3)] = true;

			// Check if the point lines within the BOTTOM LEFT BACK node
			if( (vPoint.x <= vCtr.x) && (vPoint.y <= vCtr.y) && (vPoint.z <= vCtr.z) ) 
				pList6[Std.int(i / 3)] = true;

			// Check if the point lines within the BOTTOM RIGHT BACK node
			if( (vPoint.x >= vCtr.x) && (vPoint.y <= vCtr.y) && (vPoint.z <= vCtr.z) ) 
				pList7[Std.int(i / 3)] = true;

			// Check if the point lines within the BOTTOM RIGHT FRONT node
			if( (vPoint.x >= vCtr.x) && (vPoint.y <= vCtr.y) && (vPoint.z >= vCtr.z) ) 
				pList8[Std.int(i / 3)] = true;
		}	

		// Here we create a variable for each list that holds how many triangles
		// were found for each of the 8 subdivided nodes.
		var triCount1:Int = 0;	var triCount2:Int = 0;	var triCount3:Int = 0;	var triCount4:Int = 0;
		var triCount5:Int = 0;	var triCount6:Int = 0;	var triCount7:Int = 0;	var triCount8:Int = 0;
		
		// Go through each of the lists and increase the triangle count for each node.
		for(i in 0... numberOfTriangles)  
		{
			// Increase the triangle count for each node that has a "true" for the index i.
			if(pList1[i])	triCount1++;	if(pList2[i])	triCount2++;
			if(pList3[i])	triCount3++;	if(pList4[i])	triCount4++;
			if(pList5[i])	triCount5++;	if(pList6[i])	triCount6++;
			if(pList7[i])	triCount7++;	if(pList8[i])	triCount8++;
		}
	
		// Next we do the dirty work.  We need to set up the new nodes with the triangles
		// that are assigned to each node, along with the new center point of the node.
		// Through recursion we subdivide this node into 8 more nodes.

		// Create the subdivided nodes if necessary and then recurse through them.
		// The information passed into CreateNewNode() are essential for creating the
		// new nodes.  We pass the 8 ID's in so it knows how to calculate it's new center.
		CreateNewNode(pVertices, pList1, numberOfVerts, vCenter, width, triCount1, TOP_LEFT_FRONT);
		CreateNewNode(pVertices, pList2, numberOfVerts, vCenter, width, triCount2, TOP_LEFT_BACK);
		CreateNewNode(pVertices, pList3, numberOfVerts, vCenter, width, triCount3, TOP_RIGHT_BACK);
		CreateNewNode(pVertices, pList4, numberOfVerts, vCenter, width, triCount4, TOP_RIGHT_FRONT);
		CreateNewNode(pVertices, pList5, numberOfVerts, vCenter, width, triCount5, BOTTOM_LEFT_FRONT);
		CreateNewNode(pVertices, pList6, numberOfVerts, vCenter, width, triCount6, BOTTOM_LEFT_BACK);
		CreateNewNode(pVertices, pList7, numberOfVerts, vCenter, width, triCount7, BOTTOM_RIGHT_BACK);
		CreateNewNode(pVertices, pList8, numberOfVerts, vCenter, width, triCount8, BOTTOM_RIGHT_FRONT);
	}
	else
	{
		// If we get here we must either be subdivided past our max level, or our triangle
		// count went below the minimum amount of triangles so we need to store them.
		
		// Assign the vertices to this node since we reached the end node.
		// This will be the end node that actually gets called to be drawn.
		// We just pass in the vertices and vertex count to be assigned to this node.
		AssignVerticesToNode(pVertices, numberOfVerts);
		

	}
	
	
	

}





}

