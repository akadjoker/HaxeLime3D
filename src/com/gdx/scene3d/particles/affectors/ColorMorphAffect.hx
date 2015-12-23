package com.gdx.scene3d.particles.affectors;

import com.gdx.color.Color3;
import com.gdx.math.Vector3;
import com.gdx.scene3d.particles.Particle;

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
class ColorMorphAffect extends ParticleAffect
{

	private var ColorList:Array<Color3>;
	private var TimeList:Array<Int>;
	private var MaxIndex:Int;
	private var Smooth:Bool;
	
	
	public function new(ColorList:Array<Color3>,TimeList:Array<Int>,?smooth:Bool=true) 
	{
		super();
		
		Smooth = smooth;
		MaxIndex = 0;
		this.ColorList = ColorList;
		this.TimeList = TimeList;
		
	}
	override public function affect(now:Int,p:Particle):Void
	{
		
	
	var dt:Float = Gdx.Instance().deltaTime;		
		
	if (ColorList.length <= 0) return;
	
		
		
	
		MaxIndex = ColorList.length-1;

		

		
		var FinalColor:Color3;
		
	    var Age:Float = (now-p.startTime);

			if(Age > TimeList[MaxIndex])
			{
				p.color = ColorList[MaxIndex];
				return;
			}

			var index:Int = GetCurrentTimeSlice(Std.int(Age));
			var LifeTime:Float = TimeList[index+1] - TimeList[index];
			if (LifeTime == 0)		LifeTime = 1;
			
			   var lerp:Float = (p.startlife - p.life) / p.startlife * dt;
			   

			var percent:Float = 1.0 - Math.abs((Age-TimeList[index])/LifeTime);


			if(index < MaxIndex)
			{
				if(Smooth)
				{
					FinalColor = Color3.Lerp( ColorList[index + 1],ColorList[index], lerp);
					
				}
				else
				{
					FinalColor = ColorList[index];
				}

				p.color = FinalColor;
			}
			else
			{
				p.color = ColorList[MaxIndex];
			}
	
	}	
		
	
	private function GetCurrentTimeSlice(particleTime:Int):Int
   {
 
	   var x:Int = 0;
	   
	for(x in 0...MaxIndex)
	{
		if(particleTime < TimeList[x])
		{
			return x;
		}
	}
	return x;
  }
 
}