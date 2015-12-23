package;
import com.gdx.color.Color3;
import com.gdx.Gdx;
import com.gdx.math.Ray;
import com.gdx.math.Vector3;
import com.gdx.scene3d.lights.PointLight;
import com.gdx.scene3d.lights.SpotLight;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Bolt
{ 
	
	public var light:PointLight;
	public var live:Float;
	public var maxLive:Float;
	public var position:Vector3;

private var start:Vector3;
private var end:Vector3;
private var path:Vector3;
	
	public var alive:Bool;
	var mesh:Mesh;
	var n:SceneNode;

	public function new(s:SceneManager) 
	{
		     var p:Vector3 = Vector3.zero;
             var col:Color3 = new Color3(1, 1, 1);
             light = cast( s.addLight(new PointLight(col, 10, p, 1, 1)), PointLight);
			 light.visible = false;
			 live = -1;
			 maxLive = 4;
			 position = Vector3.zero;
			start = Vector3.zero;
		    end = Vector3.zero;
			path= Vector3.zero;
			 alive = false;
			 
mesh= MeshCreator.createCube();
mesh.ScaleEx(0.020);
mesh.setColor(Std.int(col.r*255), Std.int(col.g*255), Std.int(col.b*255));
n = s.addSceneNode(mesh);
n.setPos(p.x, p.y, p.z);
n.setShader(Gdx.SHADERCOLOR);

	}
	
	public function shot(startPoint:Vector3,endPoint:Vector3)
	{
	
		position.copyFrom(startPoint);
		start.copyFrom(startPoint);
		end.copyFrom(endPoint);
		path = Vector3.Sub(end, start);
		live = maxLive;
		alive = true;
	}
	public function update(dt:Float):Void
	{
	    if(alive)	live -= (1 * dt);
		
		
		
		if (live > 0)
		{
			n.visible = true;
			light.visible = true;
		}else
		{
			n.visible = false;
			alive = false;
			light.visible = false;
		}
		if (alive)
		{
		//	trace(live+ "," + alive);
			
		position.x +=  path.x * (dt * 0.1);
		position.y +=  path.y * (dt * 0.1);
		position.z +=  path.z * (dt * 0.1);
		light.local_pos.copyFrom(position);
		n.setLocalPosition(position);
		}
	}
}