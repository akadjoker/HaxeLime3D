package com.gdx.scene3d.lights;
import com.gdx.math.Vector3;

/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class DirectionalLight extends Light
{
	public function GetDirection():Vector3
	{
		return this.GetTransformedRot().GetForward();
	}
	
}