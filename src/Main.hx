package;
import com.gdx.input.Keys;
import lime.ui.KeyModifier;



import com.gdx.App;
import com.gdx.Screen;
import lime.ui.KeyCode;
import lime.ui.Window;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */

class Main extends App
{
	

	var demos:Array<Screen>;
	var demoIndex:Int;
	
	public function new () 
	{
		
		super ();
		
	}
	override function OnStart():Void 
	{
		
		
		demos = new Array<Screen>();
		
		
	demos.push(new DemoPrimitives());
    demos.push(new DemoH3DMeshStatic());
 	demos.push(new DemoBS3DMeshStatic());
    demos.push(new DemoScreen_Decals());
	demos.push(new DemoTransform());
	demos.push(new DemoWaterFall());
	demos.push(new DemoB3DMesh());
	demos.push(new DemoH3DMesh());
	demos.push(new DemoScreen_LargeLanscape());
	demos.push(new DemoScreen_LargeLanscapeColide());
	demos.push(new DemoScreen_Terrain());
	demos.push(new DemoScreen_TerrainOctree());
	demos.push(new DemoScreen_MeshOctree());
	demos.push(new DemoScreen_TerrainGrass());
	demos.push(new DemoBsp1());
	demos.push(new DemoMD3());
	demos.push(new DemoMD2Mesh());
	demos.push(new DemoGeoTerrain());
	
	demos.push(new DemoBS3DMeshStatic3());
	demos.push(new DemoBS3DMeshStatic4());
	
	//demoIndex = demos.length-1;
	demoIndex = 0;
	
	
	gdx.setScreen(demos[demoIndex]);
	}
	
	override public function onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		
		//trace (keyCode);
		
		if (keyCode == 110)
		{
			demoIndex -= 1;
			if (demoIndex <= 0) demoIndex = 0;
			gdx.setScreen(demos[demoIndex]);
		} else
		if (keyCode == 109)
		{
			demoIndex += 1;
			if (demoIndex >= demos.length-1) demoIndex = demos.length-1;
			gdx.setScreen(demos[demoIndex]);
		}
		super.onKeyUp(window, keyCode, modifier);
	}
	
	
}
