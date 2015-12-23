package com.gdx.scene3d;

import com.gdx.Gdx;
import com.gdx.gl.material.Material;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.VertexBone;
import com.gdx.math.Matrix;
import com.gdx.math.Quaternion;
import com.gdx.math.Vector3;
import com.gdx.scene3d.Node;
import haxe.io.Path;
import lime.Assets;
import com.gdx.util.ByteArray;
import com.gdx.util.Util;




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
class MeshH3D extends AnimatedMesh

{
	
private var  file:ByteArray;

public var Joints:Array<H3DJoint>;
private var Bones:Array<H3DBone>;
private var haveBones:Bool;
private var isSkinning:Bool = true;	

	
	public function new() 
	{
		super();
		 Joints = [];
		Bones = [];
		haveBones = false;
		
		 
	}
	
	public function load(f:String,path:String):Void
	{
		
		var textures:Array<String> = [];
		var  materials:Array<Material> = [];
	
	 	

		var file:ByteArray =	Util.getBytes(f);
	    	file.endian = "littleEndian";
        if (file.bytesAvailable <= 0) return;
	    file.position = 0;
		
		var  hSize:Int = file.readInt();
		var header:String = file.readUTFBytes(hSize);
		var id:Int = file.readInt();
		
		var numMaterials:Int = file.readInt();
		
		var brushes:Map<Int,Material> = new Map<Int,Material>();
		
		trace("size:" + hSize+" , id:"+id+" , Header:" + header + " , Num materials :" + numMaterials);
		
		for (i in 0 ... numMaterials)
		{
			
			var  flags:Int = file.readInt();//
			var brush:Material = new Material();
			
			var r = file.readFloat();
			var g = file.readFloat();
			var b = file.readFloat();
			var alpha = file.readFloat();
			brush.DiffuseColor.set(r, g, b);
			brush.alpha = alpha;
			brush.materialId = i;
		//	trace('Color :' + brush.DiffuseColor.toString()+' alpha:'+alpha);
			
			var  nameSize:Int = file.readInt();
			if (nameSize >= 255) 
			{
				trace("ERROR:file dont match -"+nameSize+" color texture");
				return null;
			}
			var filename:String = file.readUTFBytes(nameSize);
			
			var  texture:String = Path.withoutDirectory(filename);
			if (Path.extension(texture) == 'bmp')
			{
				texture = Path.withoutExtension(texture);
				texture+= '.jpg';
			}else
			if (Path.extension(texture) == 'tga')
			{
				texture = Path.withoutExtension(texture);
				texture+= '.png';
			}
			
			
			
			
			if (Assets.exists(path  + texture))
			{
				
		    brush.setTexture( Gdx.Instance().getTexture(path  + texture, true));
			} else
			{
				trace("ERROR : dont find "+path  + texture+" color texture");
				
			}
			
			//****************
			
			
		//	pipline = new ShaderSkin();
			
			//detail texture
			var  useDetail:Int = file.readInt();
			if (useDetail >= 1)
			{
			  var  nameSize:Int = file.readInt();
		  	var filename:String=file.readUTFBytes(nameSize);
			var  texture:String = Path.withoutDirectory(filename);
		    if (Path.extension(texture) == 'bmp')
			{
				texture = Path.withoutExtension(texture);
				texture+= '.jpg';
			}else
			if (Path.extension(texture) == 'tga')
			{
				texture = Path.withoutExtension(texture);
				texture+= '.png';
			}
			
				  
		     if (Assets.exists(path  + texture))
			{
		     brush.setTexture( Gdx.Instance().getTexture(path  + texture),1);
			} else
			{
				trace("ERROR : dont find"+path  + texture+" detail texture");
				
			}
			}
			
		
			brushes.set(i, brush);
	    }
		
	
		
		       
				
				
		var  countMeshs:Int = file.readInt();
		trace("INFO:numsub surfaces:"+countMeshs);

	    for (i in 0 ... countMeshs)
		{

			var  nameSize:Int = file.readInt();//
			var name:String = file.readUTFBytes(nameSize);
			var  flags:Int = file.readInt();//
			var surf:MeshBuffer = createSurface();
			surf.materialIndex = file.readInt();
			var numVertices:Int=file.readInt();
			var numFaces:Int=file.readInt();
			var numUVCoords:Int = file.readInt();
	
		
			
			
			surf.material.clone(brushes.get(surf.materialIndex));
		
			 
			//
//trace("Mesh ["+i+"] , num Vertices["+numVertices+"],  num Faces["+numFaces+"],  num UVCoords["+numUVCoords+"], Material:["+surf.materialIndex+']' );
		
             var bone:H3DBone = new H3DBone();
			
			for (x in 0...numVertices)
			{
			
				var vertex:VertexBone = new VertexBone();	
				
				
				vertex.Pos.x = file.readFloat();
				vertex.Pos.y = file.readFloat();
				vertex.Pos.z = file.readFloat();
				
				
				
				
			
				
				
				vertex.Normal.x = file.readFloat();
				vertex.Normal.y = file.readFloat();
				vertex.Normal.z = file.readFloat();
				
				
				vertex.TCoords0.x = file.readFloat();
				vertex.TCoords0.y =1*- file.readFloat();
			if (numUVCoords == 2)
			{
					vertex.TCoords1.x = file.readFloat();
				    vertex.TCoords1.y =1*- file.readFloat();
					surf.AddFullVertex(vertex.Pos.x, vertex.Pos.y, vertex.Pos.z, vertex.Normal.x,  vertex.Normal.y,  vertex.Normal.z,  vertex.TCoords0.x, vertex.TCoords0.y, vertex.TCoords1.x, vertex.TCoords1.y);

			} else
			{
			surf.AddFullVertex(vertex.Pos.x, vertex.Pos.y, vertex.Pos.z, vertex.Normal.x,  vertex.Normal.y,  vertex.Normal.z,  vertex.TCoords0.x, vertex.TCoords0.y, vertex.TCoords0.x, vertex.TCoords0.y);
			}
			
			
		 bone.vertex.push(vertex);
		}
		
		Bones.push(bone);
		
			
			for (x in 0...numFaces)
			{
				var v0:Int = file.readInt();
				var v1:Int = file.readInt();
				var v2:Int = file.readInt();
	    		surf.AddTriangle(v0, v1, v2);
			}
	
		
		 surf.CreateBoundingBox(Matrix.Identity());	
	     surf.UpdateVBO();
		}
		
		var numBones:Int = file.readInt();
		trace("Num of bones:"+numBones);
		

		
		if (numBones !=0)
		{
			 isAnimated = true;
			  framesPerSecond = file.readFloat();
			 duration = file.readFloat();
			if (framesPerSecond <= 1)
			{
				framesPerSecond = 25.0;
			}
			
			trace("Fps:" + framesPerSecond + " num frames:" + duration);

			NumFrames = Std.int(duration-1);

		  // addAnimation("all", 0, Std.int(duration - 1), Std.int(framesPerSecond));
		  // setAnimation(0);
	
	
		   
		   
		   var pos:Vector3 = Vector3.Zero();
		   var rot:Quaternion =  Quaternion.Zero();
	   
			for (i in 0...numBones)
			{
			
			var  nameSize:Int = file.readInt();//
			var bname:String = file.readUTFBytes(nameSize);
			
	//	trace(nameSize+ " " + bname);
			
			var  parentnameSize:Int = file.readInt();//
			var parentname:String = file.readUTFBytes(parentnameSize);
			var Joint= new H3DJoint( null,  bname,parentname,i);
			var numKeys:Int = file.readInt();
			
	
				
			pos.x = file.readFloat();
			pos.y = file.readFloat();
			pos.z = file.readFloat();
			
			rot.x = file.readFloat();
			rot.y = file.readFloat();
			rot.z = file.readFloat();
			rot.w = file.readFloat();
			
		
			Joint.setLocalPosition(pos);
			Joint.setRotationQuat(rot);
		
			
			
		
			Joint.numKeys = numKeys;
			
			
		

				for (i in 0...Joints.length)
			    {
					if ( Joints[i].name == parentname)
					{
						Joint.parent = Joints[i];
						Joint.initialize();
						break;
					}
		     	}
	

			
			for (x in 0...numKeys)
			{
				
			var Pos:Vector3 = Vector3.Zero();
			var Rot:Quaternion =  new Quaternion();
			var time:Float=file.readFloat();
			Pos.x = file.readFloat();
			Pos.y = file.readFloat();
			Pos.z = file.readFloat();
			Rot.x = file.readFloat();
			Rot.y = file.readFloat();
			Rot.z = file.readFloat();
			Rot.w = file.readFloat();
		    Joint.Frames.push(new H3DKeyFrame(time,Pos, Rot));
			}
		 Joints.push(Joint);
		}
			
			
			
			for (buffer_id in 0... numMeshBuffer())
			{
			  var  numJoints:Int = file.readInt();//
			  for (x in 0...numJoints)
			 {
				 haveBones = true;
				 			var  nameSize:Int = file.readInt();//
		         	        var  name:String = file.readUTFBytes(nameSize);
							var  NumWeights:Int = file.readInt();//
							var jointId:Int = getJointIndex(name);
								
		     for (j in 0...NumWeights)
			 {
				 var vertex_id:Int = file.readInt();//
				 var strength:Float = file.readFloat();//
				 
				 
				 if (strength > Bones[buffer_id].vertex[vertex_id].bones[0].Wight)
				{
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId = Bones[buffer_id].vertex[vertex_id].bones[2].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = Bones[buffer_id].vertex[vertex_id].bones[2].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[1].boneId = Bones[buffer_id].vertex[vertex_id].bones[0].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[1].Wight = Bones[buffer_id].vertex[vertex_id].bones[0].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[0].boneId = jointId;
					Bones[buffer_id].vertex[vertex_id].bones[0].Wight = strength;
					Bones[buffer_id].vertex[vertex_id].numBones = 1;
					
				} else
				
				if (strength > Bones[buffer_id].vertex[vertex_id].bones[1].Wight)
				{
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId = Bones[buffer_id].vertex[vertex_id].bones[2].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = Bones[buffer_id].vertex[vertex_id].bones[2].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[2].boneId = Bones[buffer_id].vertex[vertex_id].bones[1].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[2].Wight = Bones[buffer_id].vertex[vertex_id].bones[1].Wight;
					
					Bones[buffer_id].vertex[vertex_id].bones[1].boneId =jointId;
					Bones[buffer_id].vertex[vertex_id].bones[1].Wight = strength;
					Bones[buffer_id].vertex[vertex_id].numBones = 2;
					
				} else
					if (strength > Bones[buffer_id].vertex[vertex_id].bones[2].Wight)
				{
					
					
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId = Bones[buffer_id].vertex[vertex_id].bones[2].boneId;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = Bones[buffer_id].vertex[vertex_id].bones[2].Wight;
					Bones[buffer_id].vertex[vertex_id].bones[2].boneId = jointId;
					Bones[buffer_id].vertex[vertex_id].bones[2].Wight = strength;
					Bones[buffer_id].vertex[vertex_id].numBones = 3;
					
					
				} else
				if (strength > Bones[buffer_id].vertex[vertex_id].bones[3].Wight)
				{
					Bones[buffer_id].vertex[vertex_id].bones[3].boneId =jointId;
					Bones[buffer_id].vertex[vertex_id].bones[3].Wight = strength;
					Bones[buffer_id].vertex[vertex_id].numBones = 4;
				}
				 
			
				 
			 }			
			}		
			}//
		}
			
	
if (isAnimated && haveBones && isSkinning)
{
	trace("USE SHADER SKIN");
	setShader(Gdx.SHADERTEXTURESKIN);
	//setShader(Gdx.SHADERSKINPARALLAXMAP);
	//setShader(Gdx.SHADERSKINNORMALMAP);
}


		for (s in 0... numMeshBuffer())
		{
		
			var surf:MeshBuffer = surfaces[s];
			surf.bones = [];
			surf.wights = [];
			
			
			
	
		for (i in 0... Bones[s].vertex.length)
		{
		   var vertex:VertexBone = Bones[s].vertex[i];
		//     trace("surface:"+s + ", num bones" + vertex.numBones);
		   
		   surf.bones.push(vertex.bones[0].boneId);
		   surf.bones.push(vertex.bones[1].boneId);
		   surf.bones.push(vertex.bones[2].boneId);
		   surf.bones.push(vertex.bones[3].boneId);
		   surf.wights.push(vertex.bones[0].Wight);
		   surf.wights.push(vertex.bones[1].Wight);
		   surf.wights.push(vertex.bones[2].Wight);
		   surf.wights.push(vertex.bones[3].Wight);
		 }
		 surf.reset_vbo = surf.reset_vbo | 24;
	     surf.UpdateVBO();
	
		 
		 surf.bones = null;
		 surf.wights = null;
			
			}
	
		
		sortMaterial();

		if (isSkinning)
		{
		Bones = null;
		}
		brushes = null;
		file = null;
        textures=null;
		
		trace("Read OK..");
	
}
	
  

override public function getJoint(name:String):H3DJoint
{
	for (i in 0...Joints.length)
	{
		if (Joints[i].name == name)
		{
			return Joints[i];
		}
	}
	return null;
}
override public function getJointIndex(name:String):Int
{
	for (i in 0...Joints.length)
	{
		if (Joints[i].name == name)
		{
			return i;
		}
	}
	return -1;
}
override public function numJoints():Int
{
	return Joints.length;
}


	
	override public function animate(currentFrame:Int,nextFrame:Int,poll:Float):Void 
	{
	
	
		

		if(!isAnimated) return;


	   
	   

		if (isSkinning)
		{
			
		 pipline.Use();
	     for (i in 0... Joints.length)
		 {
			var Joint:H3DJoint = Joints[i];
			Joint.animateJoints(currentFrame);
			pipline.setBoneMatrix(i, Joint.tform_mat);
		 }
		pipline.unBind();

	} else
	
	{	
		
	//render by soft
	
	  for (i in 0... Joints.length)
		 {
			var Joint:H3DJoint = Joints[i];
			Joint.animateJoints(currentFrame);
		 }
		

		for ( s in 0...surfaces.length)
		{
		
		var surf:MeshBuffer = surfaces[s];
		var Bone = Bones[s];
		
		
		
		for (i in 0...Bone.vertex.length)
		{
			
			
		var vertex:VertexBone = Bone.vertex[i];
		   
		var x:Float = 0;
		var y:Float = 0;
		var z:Float = 0;
		var ovx:Float = 0;
		var ovy:Float = 0;
		var ovz:Float = 0;
		
		  if (vertex.bones[0].boneId != -1)
		   {
			  var pos:Vector3 = vertex.Pos;
	
	
			  var tform_mat:Matrix=  Joints[vertex.bones[0].boneId].tform_mat;
			  
			  
			  var w:Float = vertex.bones[0].Wight;
		
		      
			  ovx=pos.x;
              ovy=pos.y;
              ovz=pos.z;
            
			   x = ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y = ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z = ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
			   
			   
			
		
			   
			  if (vertex.bones[1].boneId != -1)
		      {
			
			   var tform_mat:Matrix=  Joints[vertex.bones[1].boneId].tform_mat;
			
			   var w:Float = vertex.bones[1].Wight;
		       x =x+ ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y =y+ ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z =z+ ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
		
			   
			  if (vertex.bones[2].boneId != -1)
		      {
		
		    	var tform_mat:Matrix  =Joints[vertex.bones[2].boneId].tform_mat;
			
			    var w:Float = vertex.bones[2].Wight;
		       x =x+ ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y =y+ ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z =z+ ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
		
			   
			   if (vertex.bones[3].boneId != -1)
		      {
			
		   	   var tform_mat:Matrix=  Joints[vertex.bones[3].boneId].tform_mat;
			   var w:Float = vertex.bones[3].Wight;
		       x =x+ ( tform_mat.m11 * ovx + tform_mat.m21 * ovy + tform_mat.m31 * ovz  + tform_mat.m41 ) * w;
			   y =y+ ( tform_mat.m12 * ovx + tform_mat.m22 * ovy + tform_mat.m32 * ovz  + tform_mat.m42 ) * w;
		 	   z =z+ ( tform_mat.m13 * ovx + tform_mat.m23 * ovy + tform_mat.m33 * ovz + tform_mat.m43 ) * w;
		
		      }
			  
		      }
			 
		     }
			
		    }
			
	
				

		surf.VertexCoords(i, x, y, z);
		}
		surf.UpdateVBO();
		}
    }
	}
}

class H3DKeyFrame
{
public var Pos:Vector3;
public var Rot:Quaternion;
public var time:Float;
public function new(t:Float,v:Vector3,r:Quaternion)
{
	Pos = v;
	time = t;
	Rot = r;
}
}





class H3DBone
{
  public var vertex:Array<VertexBone>;
  public function new() 
	{
		vertex=[];
	}
}


class H3DJoint extends Node
{
	  
     	public var Frames:Array<H3DKeyFrame>;
		
	    public  var offMatrix:Matrix;
		public var tform_mat:Matrix;

		public var numKeys:Int;
		public var parentName:String;
		

		
		


		public function new(Parent:Node,name:String,pName:String,id:Int)
	    {
		 super( Parent, name,id);
		 parentName = pName;
		 Frames = [];
	     offMatrix = Matrix.Identity();
	     tform_mat = Matrix.Identity();
	
	
		}
		private function updatePose():Void
		{
		
		local_rot.toRotationMatrix(local_tform);
	    local_tform.m41 = local_pos.x;
		local_tform.m42 = local_pos.y;
		local_tform.m43 = local_pos.z;
		if (this.parent != null)
		{
			if (Std.is(this.parent, H3DJoint))
			{
				var p:H3DJoint = cast(parent, H3DJoint);
		        local_tform.append(p.local_tform);
			} 
		
		} 	
		
		Bounding.update(local_tform);
		Matrix.multiply2x(tform_mat, offMatrix, local_tform);
		}
		public function initialize():Void
		{
		updatePose();
		
		local_tform.invertToRef(offMatrix);
		}
		
	private function FindKey(time:Float):Int
	{
		for (i in 0...Frames.length-1)
		{
			if (time < Frames[i + 1].time)
			{
				return i;
			}
		}
		return 0;
	}


	
	

	public function animateMatrix(movetime:Float):Void
	{
	        var currentIndex:Int = FindKey(movetime);
            var nextIndex:Int = (currentIndex + 1);
			
			if (nextIndex > Frames.length)
			{
				return;
			}  
				
			 var DeltaTime :Float= (Frames[nextIndex].time -Frames[currentIndex].time);
             var Factor = (movetime - Frames[currentIndex].time) / DeltaTime;
			 setLocalPosition(Vector3.Lerp(Frames[currentIndex].Pos, Frames[nextIndex].Pos, Factor));
			 setRotationQuat(Quaternion.Slerp(Frames[currentIndex].Rot, Frames[nextIndex].Rot, Factor));
				 
		
	}
	
	
		public function animateJoints(movetime:Float):Void
		{
			animateMatrix(movetime);
		    updatePose();
			
		}
}
