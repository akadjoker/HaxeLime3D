package com.gdx.scene3d;


import com.gdx.gl.Imidiatemode;
import com.gdx.gl.material.Material;
import com.gdx.gl.shaders.Shader;
import com.gdx.math.BoundingBox;
import com.gdx.math.Math;
import com.gdx.math.Matrix;
import com.gdx.math.Quaternion;
import com.gdx.math.Vector3;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.util.ArrayIterator;
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
class Node extends Buffer {

	private var _enableLighting:Bool;
	
   public var debugFlags:Int;	

	public var active:Bool;
	public var visible:Bool;
	
	public var Bounding:BoundingBox;
	
	public var localinv_tform:Matrix;
	public var worldinv_tform:Matrix;
	
	public var local_rotTform:Matrix;
	
	public var local_tform:Matrix;
	public var local_rot:Quaternion;
	public var local_pos:Vector3;
	public var local_scl:Vector3;
	
	
	public var world_tform:Matrix;
	public var world_rot:Quaternion;
	public var world_pos:Vector3;
	public var world_scl:Vector3;
	
	public var posChanged:Bool;
	public var boundChanged:Bool;
	


	private	var rotationMatrix = Matrix.Identity();

	public var childs : Array<Node>;
	public var parent : Node;
	public var numChildren(get, never) : Int;

	private var Id:Int;
	public var name : String;
	


	public var onUpdate:Void->Void;

	
	
    public var ID(get,set) : Int;
	inline function set_ID(v) 
	{
		Id = v;
		return v;
	}
   inline function get_ID() { return Id;}
		
		public var UseLights(get, set) : Bool;
	inline function set_UseLights(v:Bool):Bool 
	{
		_enableLighting = v;
		return v;
	}
	inline function get_UseLights():Bool 
	{return _enableLighting; }
	
    public var defaultTransform(default, set) : Matrix;
	inline function set_defaultTransform(v) 
	{
		defaultTransform = v;
		posChanged = true;
		return v;
	}



	public var Position(get, set):Vector3;
	private function get_Position():Vector3 { return local_pos; }
	private function set_Position(value:Vector3):Vector3 
	{ 
		local_pos = value;
		return value;
	}

	public var Scaling(get, set):Vector3;
	private function get_Scaling():Vector3 { return local_scl; }
	private function set_Scaling(value:Vector3):Vector3 
	{ 
		local_scl = value;
		return value;
	}

	
	public function new( ?p : Node, ?Name:String = "Node", ?id:Int = -1 ) 
	{
	 super();

	 debugFlags=Gdx.DEBUGNONE;	
	// debugFlags=Gdx.DEBUGNODEOBB | Gdx.DEBUGSURFOBB;	
	_enableLighting=false;

	  var min = new Vector3(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
         var max = new Vector3(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
		 Bounding = new BoundingBox(min, max);
		 
	 
	     active = true;
		 visible = true;

		
	 localinv_tform = Matrix.Identity();
	 worldinv_tform = Matrix.Identity();
	 local_rotTform = Matrix.Identity();
	
	 local_tform= Matrix.Identity();
	 local_rot = Quaternion.Identity();
	 local_pos=Vector3.Zero();
	 local_scl = new Vector3(1, 1, 1);
	
	
	 world_tform= Matrix.Identity();
	 world_rot= Quaternion.Identity();
	 world_pos = Vector3.Zero();
	 world_scl= new Vector3(1, 1, 1);
	
		
		this.parent = p;

		name = Name;
		Id = id;
		boundChanged = true;
		
		
		childs = [];
		if ( parent != null )
		{
			parent.addChild(this);
		}
			onUpdate = null;
	}

	public function setDebug(flags:Int):Void 
	{
	 debugFlags = flags;	
	}




	public function getObjectsCount() {
		var k = 0;
		for( c in childs )
			k += c.getObjectsCount() + 1;
		return k;
	}



	

	public function getObjectByName( name : String ) {
		if( this.name == name )
			return this;
		for( c in childs ) {
			var o = c.getObjectByName(name);
			if( o != null ) return o;
		}
		return null;
	}

	
	public function getMaterial(index:Int):Material
	{
		return null;
	}
	

	public function addChild( o : Node )
	{
		addChildAt(o, childs.length);
	}

	public function addChildAt( o : Node, pos : Int ) {
		if( pos < 0 ) pos = 0;
		if( pos > childs.length ) pos = childs.length;
		var p = this;
		while( p != null ) {
			if( p == o ) throw "Recursive addChild";
			p = p.parent;
		}
		if( o.parent != null )
			o.parent.removeChild(o);
		childs.insert(pos,o);
	//	o.parent = this;
		o.posChanged = true;
	}

	public function removeChild( o : Node ) {
		if( childs.remove(o) )
			o.parent = null;
	}

	


	public inline function remove() {
		if( this != null && parent != null ) parent.removeChild(this);
	}


		



	
	public function setLocalPosition(v:Vector3):Void 
	{
		local_pos.copyFrom(v);
		posChanged = true;
	}
	public inline function setLocalScale(v:Vector3 ) :Void
	{
		local_scl.copyFrom(v);
		posChanged = true;
	}
	public inline function setLocalRotation(q:Quaternion ) :Void
	{
		local_rot.copyFrom(q);
		
		posChanged = true;
	}
	
	public function setWorldPosition(v:Vector3):Void 
	{
		if (parent != null)
		{
			parent.getInvWorldtform().TransformVecToRef(v, local_pos, 1);
		}else
		{
		setLocalPosition(v);	
		}
		
     posChanged = true;
	}
	public inline function setWorldScale(v:Vector3 ) :Void
	{
		if (parent != null)
		{
			var ps:Vector3 = parent.getWorldScale();
			var tmp:Vector3 = new Vector3(v.x / ps.x, v.y / ps.y, v.z / ps.z);
			setLocalScale(tmp);
			
		}else
		{
		setLocalScale(v);
		}
	posChanged = true;
	}
	public inline function setWorldRotation(q:Quaternion ) :Void
	{
		if (parent != null)
		{
			var inverse =Quaternion.Inverse( parent.getWorldRotation());	
			local_rot = Quaternion.Multiply(inverse,q);
		} else
		{
			setLocalRotation(q);
		}
		posChanged = true;
	}
	
	public inline function getWorldScale():Vector3
	{
		if (parent != null)
		{

			 var ps:Vector3 = parent.getWorldScale();
			world_scl.x = ps.x * local_scl.x;
			world_scl.y = ps.y * local_scl.y;
			world_scl.z = ps.z * local_scl.z;
			return world_scl;
		} else
		{
			world_scl.copyFrom(local_scl);
			return world_scl;
		}
	}

	
	public inline function getWorldPosition():Vector3
	{
		return new Vector3(getWorldTform().m41, getWorldTform().m42, getWorldTform().m43);
		
	}
	
	
	
	public function getWorldTform():Matrix
	{
	    if (this.parent != null)
		{
			getLocalTform().multiplyToRef(parent.getWorldTform(), world_tform);
		}	else
		{
			world_tform.copyFrom(getLocalTform());
		}
		Bounding.update(world_tform);
		return world_tform;
	}
	public function GetTransformedRot():Quaternion
	{
		var parentRotation:Quaternion = new Quaternion(0, 0, 0, 1);
		if (parent != null)
		{
			
			parentRotation = parent.GetTransformedRot();
		
		}
		 return parentRotation.Mul(local_rot);
	}
	
	public function LookTo( point:Vector3,  up:Vector3):Void
	{
		local_rot = GetLookAtRotation(point, up);
		posChanged = true;
	}
	
	public function GetLookAtRotation(point:Vector3, up:Vector3):Quaternion
	{
		var mat:Matrix = Matrix.Rotation(point.subtract(local_pos).normalize(), up);
	
		
		return  Quaternion.FromMatrix(mat);
	
	}
	
	public function getLocalTform():Matrix
	{
		if (posChanged)
		{
		boundChanged = true;
		local_rot.toRotationMatrix(local_rotTform);
		local_rot.toRotationMatrix(local_tform);
		local_tform.m11 *= local_scl.x;
		local_tform.m12 *= local_scl.x;
		local_tform.m13 *= local_scl.x;
		
		local_tform.m21 *= local_scl.y;
		local_tform.m22 *= local_scl.y;
		local_tform.m23 *= local_scl.y;
		
		local_tform.m31 *= local_scl.z;
		local_tform.m32 *= local_scl.z;
		local_tform.m33 *= local_scl.z;
		
		local_tform.m41 = local_pos.x;
		local_tform.m42 = local_pos.y;
		local_tform.m43 = local_pos.z;
		
		
		
		for( c in childs )
			c.posChanged = true;
		
		
		posChanged = false;
		
	
		}
		
		
			return local_tform;
		
		
	}
	
	public inline function getWorldRotation():Quaternion
	{
		if (parent != null)
		{
			//parent.getWorldRotation().multiplyToRef(local_rot, world_rot);
			local_rot.multiplyToRef(parent.getWorldRotation(), world_rot);
		    
		}else
		{   world_rot.copyFrom(local_rot);
			
		}
		
		return world_rot;
		
	}
	public inline function setPos( x : Float, y : Float, z : Float ) {
		local_pos.set(x, y, z);
		posChanged = true;
	}
    public inline function setScale( x : Float, y : Float, z : Float ) {
		local_scl.set(x, y, z);
		posChanged = true;
	}
	public inline function Scale( v:Vector3 , global:Bool = false) 
	{
		if (global)
		{
		setWorldScale(v);
		} else
		{
		setLocalScale(v);
		}

	}

 /*
 * Moves an entity relative to its current position and orientation. 
 */
  public function Move( mx : Float, my : Float, mz : Float):Void
  {
	  var v=Vector3.TransformCoordinates(new Vector3(mx,my,mz), local_rotTform);
	 local_pos.x += v.x;
	 local_pos.y += v.y;
	 local_pos.z += v.z;
		posChanged = true;
	}
    

	/*
	 * Translates an entity relative to its current position and not its orientation. 
	 */
	public function Translate(x:Float,y:Float,z:Float,global:Bool=false):Void
	{
	
	 if (global)
	 {
		 var p:Vector3 = getWorldPosition();
		 var add:Vector3 = new Vector3(p.x + x, p.y + y, p.z + z);
		 setWorldPosition(add);
	 } else
	 {
		 var add:Vector3 = new Vector3(local_pos.x + x, local_pos.y + y, local_pos.z + z);
		 setLocalPosition(add);
	 }
	 posChanged = true;
	}

	/*
	 * Rotates an entity so that it is at an absolute orientation. 
	 */
	public function Rotate( p : Float, y : Float, r : Float,global:Bool=false )
	{
		var r =  Quaternion.RotationYawPitchRoll(y*Util.dtor, p*Util.dtor, r*Util.dtor);

		if (global)
		{
			
			setWorldRotation(r);
		}else
		{
			
			setLocalRotation(r);
		}
		posChanged = true;
	}
	/*
	 *Turns an entity relative to its current orientation. 
	 */
	public function Turn( pitch : Float, yaw : Float, roll : Float,global:Bool=false )
	{
		var qTemp =  Quaternion.RotationYawPitchRoll(yaw*Util.dtor, pitch*Util.dtor, roll*Util.dtor);
		
		if (global)
		{
			var r=Quaternion.Multiply(getWorldRotation(),qTemp);
			setWorldRotation(r);
		}else
		{
			qTemp.multLeft(local_rot);
			setLocalRotation(qTemp);
		}
		
		posChanged = true;
	}
	
	/*
    axis - axis of entity that will be aligned to vector 
1: x-axis 
2: y-axis 
3: z-axis 
rate# (optional) - rate at which entity is aligned from current orientation to vector orientation. Should be in the range 0 to 1, 0 for smooth transition and 1 for 'snap' transition. Defaults to 1. 

	    */
	public function AlignToVector( x:Float, y:Float, z:Float,axis:Int = 3,rate:Float=1 )
	{
			var ax:Vector3 = new Vector3(x, y, -z);

		var dd:Float = ax.length();
	    if (dd < Math.EPSILON) return;
		
		
		ax.x /= dd;
		ax.y /= dd;
		ax.z /= dd;
		
		var q:Quaternion = getWorldRotation();	
	
		var tv:Vector3 = (axis==1) ? q.axisX() : (axis==2 ? q.axisY() : q.axisZ());
		
		
		
		var dp:Float = ax.dot(tv);
		if (dp >= 1 - Math.EPSILON) return;
		
		if (dp <= - 1 + Math.EPSILON) 
		{
			var an:Float = Math.PI * rate / 2;
			var cp:Vector3= (axis==1) ? q.axisY() : (axis==2 ? q.axisZ() : q.axisX());
    		var qa:Quaternion = new Quaternion(cp.x * Math.sin(an), cp.y * Math.sin(an), cp.z * Math.sin(an), Math.cos(an));
		
	   	    setWorldRotation(Quaternion.Multiply(local_rot,qa));
			
			return;
		}
		
		
		
		var an:Float = Math.acos(dp) * rate / 2;
		var cp:Vector3 = ax.cross(tv).normalize();
		
		var qa:Quaternion = new Quaternion(cp.x * Math.sin(an),cp.y * Math.sin(an),cp.z * Math.sin(an), Math.cos(an));
	
		setWorldRotation(Quaternion.Multiply(local_rot,qa));
		posChanged = true;	
	}
	
	
		/*
	    *Points one entity at another. 
        *The optional roll parameter allows you to specify a roll angle as pointing an entity only sets pitch and yaw angles. 
	    */
	
	public function Point( target:Node, roll : Float=0 )
	{
		var x:Float = target.nodeX(true);
		var y:Float = target.nodeY(true);
		var z:Float = target.nodeZ(true);
		var xdiff:Float = nodeX(true) - x;
		var ydiff:Float = -(nodeY(true) - y);
		var zdiff:Float = nodeZ(true) - z;
		var dist22:Float = Math.sqrt( (xdiff * xdiff) + (zdiff * zdiff));
		var pitch:Float = Util.atan2deg(ydiff, dist22);
		var yaw:Float = Util.atan2deg(xdiff, zdiff);
		Rotate(pitch, yaw, roll, true);
	}
	public function PointLerp( target:Node, ratio:Float,roll : Float=0 )
	{
		var x:Float = target.nodeX(true);
		var y:Float = target.nodeY(true);
		var z:Float = target.nodeZ(true);
		var xdiff:Float = nodeX(true) - x;
		var ydiff:Float = -(nodeY(true) - y);
		var zdiff:Float = nodeZ(true) - z;
		var dist22:Float = Math.sqrt( (xdiff * xdiff) + (zdiff * zdiff));
		var pitch:Float = Util.atan2deg(ydiff, dist22);
		var yaw:Float = Util.atan2deg(xdiff, zdiff);
		var qTemp =  Quaternion.RotationYawPitchRoll(yaw * Util.dtor, pitch * Util.dtor, roll * Util.dtor);
		setWorldRotation(Quaternion.Slerp(local_rot, qTemp, ratio));
	}
	
	public function nodeX(global:Bool = false):Float
	{
		if (global)
		{
			return world_tform.m41;
			
		} else
		{
			return local_pos.x;
		}
		
		
	}
	public function nodeY(global:Bool = false):Float
	{
		if (global)
		{
			return world_tform.m42;
			
		} else
		{
			return local_pos.y;
		}
		
		
	}
	public function nodeZ(global:Bool = false):Float
	{
		if (global)
		{
			return world_tform.m43;
			
		} else
		{
			return local_pos.z;
		}
		
		
	}
	
	
	public function setRotate( pitch : Float,yaw : Float, roll : Float )
	{
		local_rot.RotationYawPitchRollTo(yaw, pitch, roll);
		posChanged = true;		
	}

	public function setRotateAxis( ax : Float, ay : Float, az : Float, angle : Float ) 
	{

		local_rot.initRotateAxis(ax, ay, az, angle);
		posChanged = true;
	}

	public function appendRotateAxis( ax : Float, ay : Float, az : Float, angle : Float ) 
	{
		var tmp = Quaternion.Identity();
		tmp.initRotateAxis(ax, ay, az, angle);
		//Matrix.multiply2x(tmp, local_rot);
		local_rot=Quaternion.Multiply(local_rot,tmp);
		posChanged = true;
	}
	

	public function setRotationQuat(q)
	{
		local_rot.copyFrom(q);
		posChanged = true;
	}

	public inline function scale( v : Float ) 
	{
		local_scl.x *= v;
	    local_scl.y *= v;
		local_scl.z *= v;
		posChanged = true;
	}




	public function toString() {
		return Type.getClassName(Type.getClass(this)).split(".").pop() + (name == null ? "" : "(" + name + ")");
	}

	public inline function getChildAt( n )
	{
		return childs[n];
	}

	public inline function getChild( name:String ):Node
	{
		for (c in childs)
		{
			if (name.toUpperCase() == c.name.toUpperCase())
			{
			 return c;	
			}
		}
		return null;
	}
	inline function get_numChildren()
	{
		return childs.length;
	}

	public inline function iterator() :ArrayIterator<Node> 
	{
		return new ArrayIterator(childs);
	}

	
	

	
	function syncRec( )
	{
		
		
	
		var p = 0, len = childs.length;
		while( p < len ) {
			var c = childs[p];
			if( c == null )
				break;
			
	
				c.syncRec();
			
	
			if( childs[p] != c ) {
				p = 0;
				len = childs.length;
			} else
				p++;
		}
		
	}

	
	public function localToGlobal( ?pt : Vector3 ) 
	{
		//getAbsoluteTransformation();
	
		return pt;
	}
    public function globalToLocal( pt : Vector3 ) 
	{
		//getAbsoluteTransformation();
		////pt.transform3x4(getInvPos());
		return pt;
	}

	function getInvLocaltform()
	{
		getLocalTform().invertToRef(localinv_tform);
		return localinv_tform;
	}
	function getInvWorldtform()
	{
        getWorldTform().invertToRef(worldinv_tform);
		return worldinv_tform;
	}
	public function onAnimate():Void 
	{
		
	}
	public function getTransformBox():BoundingBox
	{
			Bounding.update(getWorldTform());
			return Bounding;
	}
	public function update():Void 
	{
		 		
		if (onUpdate!=null)
		{
			onUpdate();
		}
	
		syncRec();
		

		
		for( c in childs )
			c.update();
			
		
		
		
	}
	
	public function renderTo(newShader:Shader,cam:Camera,setMaterial:Bool):Void
	{
		//use or no???? :(
	
		for ( c in childs )
		{
			c.renderTo(newShader,cam,setMaterial);
			
		}

	}
	
	public function render(cam:Camera):Void
	{
	
		for ( c in childs )
		{
			c.render(cam);
			
		}

	}
	public function debug(lines:Imidiatemode):Void
	{
		if (debugFlags == Gdx.DEBUGNONE) return;

		if ((debugFlags & Gdx.DEBUGSKELETON)==Gdx.DEBUGSKELETON)
		{
		
		 var vector:Vector3 = Vector3.zero;
		 var parentvector:Vector3 = Vector3.zero;
		 
		
		 vector=world_tform.transformVector(vector);
		 
		 if (parent != null)
		 {
			parentvector = parent.world_tform.transformVector(parentvector);
			lines.lineVector(vector, parentvector, 1, 1, 1, 1);
			
		 } else
		 {
			 lines.lineVector(vector, vector, 1, 1, 1, 1);
		 }
		 
	    }
		 
		 for (b in childs)
		 {
			 b.debug(lines);
		 }
	}
	override public function dispose() 
	{
		super.dispose();
		for( c in childs )
			c.dispose();
	}

	
	inline public static function TFormPoint(v:Vector3,result:Vector3,src_ent:Node,dest_ent:Node):Void
	{

		
		if (src_ent != null)
		{
			src_ent.getWorldTform().TransformVecToRef(v, result, 1);
		}

		if (dest_ent != null)
		{
			dest_ent.getInvWorldtform().TransformVecToRef(v, result, 1);
		}
	}
	inline public static function TFormVector(v:Vector3,result:Vector3,src_ent:Node,dest_ent:Node):Void
	{
		
     
		
		
		if (src_ent != null)
		{
			var mat:Matrix = Matrix.Identity();
		 mat.copyFrom(src_ent.getWorldTform());
		 mat.m41 = 0;
		 mat.m42 = 0;
		 mat.m43 = 0;
		 mat.TransformVecToRef(v, result, 1);
		}
		
		if (dest_ent != null)
		{
		 var mat:Matrix = Matrix.Identity();
		 mat.copyFrom(dest_ent.getInvWorldtform());
		 mat.m41 = 0;
		 mat.m42 = 0;
		 mat.m43 = 0;
		 mat.TransformVecToRef(v, result, 1);
		}

	}
	inline public static function TFormNormal(v:Vector3,result:Vector3,src_ent:Node,dest_ent:Node):Void
	{
		var normal:Vector3 = Vector3.Zero();
        TFormVector(v, normal, src_ent, dest_ent);
		var uv:Float = Math.sqrt( (normal.x * normal.x) + (normal.y * normal.y) + (normal.z * normal.z));
		
		result.x /= uv;
		result.y /= uv;
		result.z /= uv;
	 

	}
}
