package com.gdx.scene3d;
import com.gdx.Buffer;
import com.gdx.Gdx;
import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.shaders.Shader;
import com.gdx.math.BoundingBox;
import com.gdx.math.Matrix;
import com.gdx.math.Plane;
import com.gdx.math.Ray;
import com.gdx.math.Vector3;
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
class Mesh extends Buffer
{
	

	private var ContactPoint:Vector3;
	private var ContactNormal:Vector3;
	private var ContactPlane:Plane;
	private var ContactDistance:Float;
	
	public var surfaces:Array<MeshBuffer>;
	public var pipline:Shader;
	
	public var debugFlags:Int;

	public function new() 
	{
		  super();
		  pipline = Gdx.Instance().materials[Gdx.SHADERDEFAULT];
		  surfaces = [];
		  debugFlags = Gdx.DEBUGNONE;// Gdx.DEBUGSURFOBB ;
		  ContactPoint = Vector3.Zero();
		  ContactNormal = Vector3.Zero();
		  ContactPlane = new Plane(0, 0, 0, 0);
		  ContactDistance = 0;
	}
	
	public function setDebug(flags:Int):Void 
	{
	 debugFlags = flags;	
	}
	public function setShader(i:Int):Void
	{
		var max:Int = Gdx.Instance().materials.length;
		if (i <= 0) i = 0;
		if (i >= max) i = max;
		setShaderEx(Gdx.Instance().materials[i]);
	}
	public function setShaderEx(s:Shader):Void
	{
		pipline = s;
		for (i in 0... surfaces.length)
		  {
			  surfaces[i].setShader(pipline);
		  }
		
	}
	public  function createSurface():MeshBuffer
	{
		var surf:MeshBuffer = new  MeshBuffer(pipline);
		surfaces.push(surf);
		return surf;
	}
	
	 public function renderTo(newShader:Shader,cam:Camera,cullSubMesh:Bool,setMaterial:Bool):Void
	{
		if (newShader == null) return;
		 
		  for (i in 0... surfaces.length)
		  {
			 var surf:MeshBuffer = surfaces[i];
			 if (surf == null) continue;
			  if (cullSubMesh)
			 {
			  if (cam.BoundingInFrustum(surf.Bounding))
			  {
				    surf.renderTo(newShader, setMaterial);
			  }
			 }else
			 {
			  surf.renderTo(newShader, setMaterial);
			 }
		  }
		  

		
	}
	
	 public function render(mat:Matrix,cam:Camera,cullSubMesh:Bool):Void
	{
		
		  Gdx.Instance().numMesh += 1;
		  pipline.Bind(cam.viewMatrix, cam.projMatrix, mat);
		  
		  
		  for (i in 0... surfaces.length)
		  {
			 var surf:MeshBuffer = surfaces[i];
			 if (cullSubMesh)
			 {
			  if (cam.BoundingInFrustum(surf.Bounding))
			  {
			   surf.render();
			   }
			 } else
			  {
			  surf.render();
			  }
		  }
		  
		  pipline.unBind();
		
	}

	public function UpdateNormals():Void
	{
		for (i in 0... surfaces.length)
		{
		 	surfaces[i].ComputeNormal();
		
		}
		
	}
		//! Recalculates all normals of the mesh.
		/**
		\param smooth: If the normals shall be smoothed.
		\param angleWeighted: If the normals shall be smoothed in relation to their angles. More expensive, but also higher precision. */

	
	public function ComputeNormalSmoth(smoth:Bool,angleWeighted:Bool):Void
	{
		for (i in 0... surfaces.length)
		{
		 	surfaces[i].ComputeNormalSmoth(smoth,angleWeighted);
			
		}
	}
	public function ComputeTangents():Void
	{
		for (i in 0... surfaces.length)
		{
		 	surfaces[i].ComputeTangents();
			
		}
	}
	public function setColor(r:Int,g:Int,b:Int,?a:Float=1):Void
	{
		for (i in 0... surfaces.length)
		{
			for (x in 0...surfaces[i].CountVertices())
			{
		 	surfaces[i].VertexColor(x, r, g, b, a);
			}
			
		}
	}
	
	/* Optimize mesh..
	 * create the surfaces with static VBO
	 */
	public function Optimize():Void
	{

		var startTimer:Int = Gdx.Instance().getTimer();
		
		for (i in 0... surfaces.length)
		{
		 	surfaces[i].Optimize();
			
		}
		var endTimer:Int = Gdx.Instance().getTimer();
		
		trace ("Optimize mesh  in " + ( endTimer - startTimer ) / 1000.0 + "seconds" );
		
	}
	public function sortMaterial():Void
	{
	surfaces.sort(materialIndex);
	}
	
	function materialIndex(a:MeshBuffer, b:MeshBuffer):Int
    {

    if (a.materialIndex < b.materialIndex) return -1;
    if (a.materialIndex > b.materialIndex) return 1;
    return 0;
    } 
		
	public function addSurface(surf:MeshBuffer):Void
	{
		if ( (surf.CountTriangles() == 0) || (surf.CountVertices() == 0)) return;
		
					
			var new_surf:Bool = true;
			
			for (s2 in 0...numMeshBuffer())
			{
					var surf2:MeshBuffer = getMeshBuffer(s2);
				    var no_verts2:Int = surf2.CountVertices();
				
				
				//if (Brush.CompareBrushes(surf2.brush, surf.brush) == true)
			//	if (Brush.CompareBrushesMaterial(surf2.brush,surf.brush)==true)
			   if(surf.materialIndex==surf2.materialIndex)
				{
				
					for (v in 0...surf.CountVertices())
					{
					var vx=surf.VertexX(v);
					var vy=surf.VertexY(v);
					var vz=surf.VertexZ(v);
					
					var vnx=surf.VertexNX(v);
					var vny=surf.VertexNY(v);
					var vnz=surf.VertexNZ(v);
					var vu0=surf.VertexU(v,0);
					var vv0=surf.VertexV(v,0);
					var vu1=surf.VertexU(v,1);
					var vv1=surf.VertexV(v,1);
		

					var v2 = surf2.AddVertex(vx, vy, vz);
		
					surf2.VertexColor(v2,255,255,255,1);
					surf2.VertexNormal(v2,vnx,vny,vnz);
					surf2.VertexTexCoords(v2,vu0,vv0,0,0);
					surf2.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf.CountTriangles())
				  {
					var v0=surf2.TriangleVertex(t,0)+no_verts2;
					var v1=surf2.TriangleVertex(t,1)+no_verts2;
					var v2=surf2.TriangleVertex(t,2)+no_verts2;

					surf2.AddTriangle(v0,v1,v2);
				}
				surf2.reset_vbo = -1;
				surf2.UpdateVBO();
				new_surf = false;
				break;
				
				}
				
			}
			if (new_surf == true)
			{
				var surf2:MeshBuffer = createSurface();
	
					for (v in 0...surf.CountVertices())
					{
					var vx=surf.VertexX(v);
					var vy=surf.VertexY(v);
					var vz=surf.VertexZ(v);
					
					var vnx=surf.VertexNX(v);
					var vny=surf.VertexNY(v);
					var vnz=surf.VertexNZ(v);
					var vu0=surf.VertexU(v,0);
					var vv0=surf.VertexV(v,0);
					var vu1=surf.VertexU(v,1);
					var vv1=surf.VertexV(v,1);
		

					var v2=surf2.AddVertex(vx,vy,vz);
					surf2.VertexColor(v2,255,255,255,1);
					surf2.VertexNormal(v2,vnx,vny,vnz);
					surf2.VertexTexCoords(v2,vu0,vv0,0,0);
					surf2.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf.CountTriangles())
				  {
					var v0=surf.TriangleVertex(t,0);
					var v1=surf.TriangleVertex(t,1);
					var v2=surf.TriangleVertex(t,2);

					surf2.AddTriangle(v0,v1,v2);
				}
			    surf2.material.clone(surf.material);
				surf2.materialIndex = surf.materialIndex;
				surf2.reset_vbo = -1;
				surf2.UpdateVBO();
			
			}
		
      //  sortMaterial();
		
		
	}
	public function AddMesh(mesh2:Mesh):Void
	{
		for (s1 in 0...mesh2.numMeshBuffer())
		{
			var surf1:MeshBuffer = mesh2.getMeshBuffer(s1);
			
			if (surf1.CountVertices() == 0 && surf1.CountTriangles() == 0 ) continue;
			
			var new_surf:Bool = true;
			
			for (s2 in 0...numMeshBuffer())
			{
				var surf2:MeshBuffer = getMeshBuffer(s2);
				var no_verts2:Int = surf2.CountVertices();
				
				if (Material.CompareMaterial(surf1.material, surf2.material) == true)
				{
					//add vertices
			
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2 = surf2.AddVertex(vx, vy, vz);
		
					surf2.VertexColor(v2,255,255,255,1);
					surf2.VertexNormal(v2,vnx,vny,vnz);
					surf2.VertexTexCoords(v2,vu0,vv0,0,0);
					surf2.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0)+no_verts2;
					var v1=surf1.TriangleVertex(t,1)+no_verts2;
					var v2=surf1.TriangleVertex(t,2)+no_verts2;

					surf2.AddTriangle(v0,v1,v2);
				}
				surf2.reset_vbo = -1;
				surf2.UpdateVBO();
				surf2.CreateBoundingBox(Matrix.Identity());
				new_surf = false;
				break;
				
				}
				
			}
			if (new_surf == true)
			{
				var surf:MeshBuffer = createSurface();
				//add vertices
		
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2=surf.AddVertex(vx,vy,vz);
					surf.VertexColor(v2,255,255,255,1);
					surf.VertexNormal(v2,vnx,vny,vnz);
					surf.VertexTexCoords(v2,vu0,vv0,0,0);
					surf.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0);
					var v1=surf1.TriangleVertex(t,1);
					var v2=surf1.TriangleVertex(t,2);

					surf.AddTriangle(v0,v1,v2);
				}
				if (surf1.material != null)
				{
					surf.material.clone(surf1.material);
				}
				surf.reset_vbo = -1;
				surf.UpdateVBO();
				surf.CreateBoundingBox(Matrix.Identity());
			}
		}
		sortMaterial();
	
	}
	/* Optimize mesh..
	 * search in all mesh surfaces  that have the same texture 
	 * and merge all in one 
	 */
	public function CleanMesh():Void
	{
		
		var total:Int = numMeshBuffer();
		
		var newList:Array<MeshBuffer> = [];
		for (s1 in 0...numMeshBuffer())
		{
			var s:MeshBuffer = getMeshBuffer(s1);
		    newList.push(s);
		}
		
		surfaces = [];
		
		
		
		for (s1 in 0... newList.length)
		{
				var surf1:MeshBuffer = newList[s1];
			
			if (surf1.CountVertices() == 0 && surf1.CountTriangles() == 0 ) continue;
			
			var new_surf:Bool = true;
			
			for (s2 in 0... numMeshBuffer())
			{
				var surf2:MeshBuffer = getMeshBuffer(s2);
				var no_verts2:Int = surf2.CountVertices();
				
				if (Material.CompareMaterial(surf1.material, surf2.material) == true)
				{
					//add vertices
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2 = surf2.AddVertex(vx, vy, vz);
		
					surf2.VertexColor(v2,255,255,255,1);
					surf2.VertexNormal(v2,vnx,vny,vnz);
					surf2.VertexTexCoords(v2,vu0,vv0,0,0);
					surf2.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0)+no_verts2;
					var v1=surf1.TriangleVertex(t,1)+no_verts2;
					var v2=surf1.TriangleVertex(t,2)+no_verts2;

					surf2.AddTriangle(v0,v1,v2);
				}
				surf2.reset_vbo = -1;
				surf2.CreateBoundingBox(Matrix.Identity());
				surf2.UpdateVBO();
				new_surf = false;
				break;
				
				}
				
			}
			if (new_surf == true)
			{
	
				var surf:MeshBuffer = createSurface();
				
				//add vertices
		
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2=surf.AddVertex(vx,vy,vz);
					surf.VertexColor(v2,255,255,255,1);
					surf.VertexNormal(v2,vnx,vny,vnz);
					surf.VertexTexCoords(v2,vu0,vv0,0,0);
					surf.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0);
					var v1=surf1.TriangleVertex(t,1);
					var v2=surf1.TriangleVertex(t,2);

					surf.AddTriangle(v0,v1,v2);
				}
			
				surf.material.clone(surf1.material);
				
				surf.reset_vbo = -1;
				surf.UpdateVBO();
				surf.CreateBoundingBox(Matrix.Identity());
			}
		}
		newList = null;
		var newTotal:Int = numMeshBuffer();
		
		trace("Clean mesh , remove "+ Std.int(total-newTotal)+" mesh buffers"); 
		
	}
	public function CopyMeshTo(mesh2:Mesh):Void
	{
		for (s1 in 0...numMeshBuffer())
		{
			var surf1:MeshBuffer = getMeshBuffer(s1);
			
			if (surf1.CountVertices() == 0 && surf1.CountTriangles() == 0 ) continue;
			
			var new_surf:Bool = true;
			
			for (s2 in 0...mesh2.numMeshBuffer())
			{
				var surf2:MeshBuffer = mesh2.getMeshBuffer(s2);
				var no_verts2:Int = surf2.CountVertices();
				
				if (Material.CompareMaterial(surf1.material, surf2.material) == true)
				{
					//add vertices
					//trace("add vertices surf1");
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2 = surf2.AddVertex(vx, vy, vz);
		
					surf2.VertexColor(v2,255,255,255,1);
					surf2.VertexNormal(v2,vnx,vny,vnz);
					surf2.VertexTexCoords(v2,vu0,vv0,0,0);
					surf2.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0)+no_verts2;
					var v1=surf1.TriangleVertex(t,1)+no_verts2;
					var v2=surf1.TriangleVertex(t,2)+no_verts2;

					surf2.AddTriangle(v0,v1,v2);
				}
				surf2.reset_vbo = -1;
				surf2.CreateBoundingBox(Matrix.Identity());
				surf2.UpdateVBO();
				new_surf = false;
				break;
				
				}
				
			}
			if (new_surf == true)
			{
				var surf:MeshBuffer = mesh2.createSurface();
				//add vertices
		
					for (v in 0...surf1.CountVertices())
					{
					var vx=surf1.VertexX(v);
					var vy=surf1.VertexY(v);
					var vz=surf1.VertexZ(v);
					
					var vnx=surf1.VertexNX(v);
					var vny=surf1.VertexNY(v);
					var vnz=surf1.VertexNZ(v);
					var vu0=surf1.VertexU(v,0);
					var vv0=surf1.VertexV(v,0);
					var vu1=surf1.VertexU(v,1);
					var vv1=surf1.VertexV(v,1);
		

					var v2=surf.AddVertex(vx,vy,vz);
					surf.VertexColor(v2,255,255,255,1);
					surf.VertexNormal(v2,vnx,vny,vnz);
					surf.VertexTexCoords(v2,vu0,vv0,0,0);
					surf.VertexTexCoords(v2,vu1,vv1,0,1);
					}
					
					for (t in 0...surf1.CountTriangles())
				  {
					var v0=surf1.TriangleVertex(t,0);
					var v1=surf1.TriangleVertex(t,1);
					var v2=surf1.TriangleVertex(t,2);

					surf.AddTriangle(v0,v1,v2);
				}
			
				surf.material.clone(surf1.material);
				
				surf.reset_vbo = -1;
				surf.UpdateVBO();
				surf.CreateBoundingBox(Matrix.Identity());
			}
		}
		
	}
	public function UpdateBoundingBox(m:Matrix):Void 
	{
		
		for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			surf.UpdateBoundingBox(m);
		}	
			
	
	}

	
	public function TransformBoundingBox(m:Matrix):Void 
	{
		
		for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			surf.Bounding.update(m);
		}	
			
	
	}
	/* debug the mesh normals*/
	public function showNormals(m:Matrix,lines:Imidiatemode,length:Float)
	{
		
		for (i in 0... surfaces.length)
		{
		var surf = surfaces[i];
			
		for (i in 0... surf.no_verts)
		{
			var v:Vector3 = surf.getVertex(i);
			var n:Vector3 = Vector3.Mult( surf.getNormal(i), length);
			
			v = m.transformVector(v);
			n = m.transformVector(n);
			
			
			lines.line3D(
			v.x, v.y, v.z, 
			v.x + n.x, v.y + n.y, v.z + n.z,
			1, 0, 0);
			
		}

		}

	}

	 public function debug(lines:Imidiatemode):Void 
	{
	  if ( (debugFlags & Gdx.DEBUGSURFOBB) == Gdx.DEBUGSURFOBB) 
	  {
		for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
		  	lines.drawOBBox(surf.Bounding.boundingBox,0,1,1);
		   	
		  
		}
	  }
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
	
	public function rayTrace(ray:Ray):Bool
	{
		var distance = Math.POSITIVE_INFINITY;
		
		for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			if (ray.intersectsBox(surf.Bounding.boundingBox)) 
			{
				
	
		//	SceneManager.lines.drawABBox(surf.Bounding.boundingBox,0,0,1);
				

		 
		  for (index in 0...Std.int(surf.CountTriangles())) 
		 {
 
		
			var p0 = surf.getFace(index,2);
			var p1 = surf.getFace(index,1);
			var p2 = surf.getFace(index, 0);
			ContactPlane.copyFromPoints(p0, p1, p2);
			if ( !ContactPlane.isFrontFacingTo(ray.direction, 0)) continue;
		
		
    		var currentDistance = ray.intersectsTriangle(p0, p1, p2);
			

            if (currentDistance > 0) 
			{
				
                    distance = currentDistance;
					ContactPoint.x = ray.origin.x + (ray.direction.x * distance);
					ContactPoint.y = ray.origin.y + (ray.direction.y * distance);
					ContactPoint.z = ray.origin.z + (ray.direction.z * distance);
					
					ContactNormal.copyFrom(ContactPlane.normal);
					ContactDistance = distance;
						
					return true;
                
            }
			
		
        }
		break;
		}
		}
		return false;
	}
	
	
	
	public  function getMeshBuffer(index:Int):MeshBuffer
	{
		return surfaces[index];
		
	}
	public function scaleTexCoords(  factorX:Float, factorY:Float, coords_set:Int):Void
	{
		for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			
			surf.scaleTexCoords(factorX, factorY, coords_set);
		}
	}
	public  function numMeshBuffer():Int
	{
		return surfaces.length;
		
	}
		


	public function Translate( x:Float,y:Float,z:Float):Void
   {
	   for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			
			surf.translate(x,y, z);
		}
   
   }
   public function Scale( x:Float,y:Float,z:Float):Void
   {
	   for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			
			surf.scale(x, y, z);
		}

   }
   public function ScaleEx( v:Float):Void
   {
	 Scale(v, v, v);
   }
   public function Rotate( y:Float,p:Float,r:Float):Void
   {
	   for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			
			surf.rotate(y,p,r);
		}
   } 
  public function Transform( m:Matrix):Void
  {
	   for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			
			surf.transform(m);
		}
  }

   
  
  
	
  	override public function dispose() 
	{
		for (i in 0... surfaces.length)
		{
			var surf = surfaces[i];
			
			surf.dispose();
		}
		surfaces = null;
		super.dispose();
	}
}