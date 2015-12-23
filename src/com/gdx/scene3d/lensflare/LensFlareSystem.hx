package com.gdx.scene3d.lensflare;


import com.gdx.collision.OctSelector;
import com.gdx.color.Color3;
import com.gdx.gl.BlendMode;
import com.gdx.math.Matrix;
import com.gdx.math.Ray;
import com.gdx.math.Rectangle;
import com.gdx.math.Vector3;
import com.gdx.scene2d.Graphic;
import com.gdx.scene2d.render.SpriteBatch;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.util.SpriteSheet;
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
class LensFlareSystem extends Graphic
{

	
	public var borderLimit:Float;
	public var lensFlares:Array<LensFlare>;

	
	private var camera:Camera;
	
	public var _positionX:Float;
	public var _positionY:Float;
	public var collider:OctSelector;
    
	private var pos:Vector3;
	private var z:Float;
	private var spriteSheet:SpriteSheet;

	public function new(c:Camera,spriteSheet:SpriteSheet,x:Float,y:Float,z:Float) 
	{
		super();
		this.camera = c;
		this.lensFlares = [];
		this.spriteSheet = spriteSheet;
		borderLimit = 100;
		pos = new  Vector3(x, y, z);
		collider = null;
		
	}
	
		
	public function addFlare(frame:Int,size:Float, position:Float, ?color:Color3):Void
	{
		var flare:LensFlare = new LensFlare(size, position, frame,color, this);
	
	}
	public function computeEffectivePosition():Bool 
	{
		var position = getEmitterPosition();
		var globalViewport:Rectangle = camera.viewPort;

        position = Vector3.Project(position, Matrix.Identity(), camera.getProjViewMatrix(), globalViewport);
		
		

        this._positionX = position.x;
        this._positionY = position.y;
	
       z = position.z;

        if (z > 0) 
		{
            if ((this._positionX > globalViewport.x) && (this._positionX < globalViewport.x + globalViewport.width)) {
                if ((this._positionY > globalViewport.y) && (this._positionY < globalViewport.y + globalViewport.height))
                    return true;
            }
        }

        return false;
	}
	public function getEmitterPosition():Vector3 
	{
		return pos;
	}
	
	public function isVisible():Bool 
	{
		if (lensFlares.length <= 0) return false;
		var emitterPosition:Vector3 = this.getEmitterPosition();
		
		

	   
	   
	   
	     var direction:Vector3 = emitterPosition.subtract(camera.local_pos);
         var distance:Float = direction.length();
          direction.normalize();
		  

		
		var angle = Util.rad2deg(Util.AngleBetweenVectors(camera.rotation, emitterPosition));
		if (angle > 90) return false;
		
		
		if (collider != null)
		{
			var ray:Ray = new Ray(camera.local_pos, direction);
			if (collider.RayTrace(ray))
			{
				return false;
			}
		}
		
		
      
		 return true;
		
	}
	
	override public function render(batch:SpriteBatch):Void 
	{
	    if (lensFlares.length <= 0) return ;
        var globalViewport:Rectangle = camera.viewPort;
        
        // Position
        if (!this.computeEffectivePosition())
		{
            return ;
        }
        
        // Visibility
        if (!this.isVisible()) 
		{
            return ;
        }

        // Intensity
        var awayX:Float = 0;
        var awayY:Float = 0;

        if (this._positionX < this.borderLimit + globalViewport.x)
		{
            awayX = this.borderLimit + globalViewport.x - this._positionX;
        } else if (this._positionX > globalViewport.x + globalViewport.width - this.borderLimit) {
            awayX = this._positionX - globalViewport.x - globalViewport.width + this.borderLimit;
        } else {
            awayX = 0;
        }

        if (this._positionY < this.borderLimit + globalViewport.y) {
            awayY = this.borderLimit + globalViewport.y - this._positionY;
        } else if (this._positionY > globalViewport.y + globalViewport.height - this.borderLimit) {
            awayY = this._positionY - globalViewport.y - globalViewport.height + this.borderLimit;
        } else {
            awayY = 0;
        }

        var away:Float = (awayX > awayY) ? awayX : awayY;
        if (away > this.borderLimit)
		{
            away = this.borderLimit;
        }

        var intensity:Float = 1.0 - (away / this.borderLimit);
        if (intensity < 0) 
		{
            return ;
        }
        
        if (intensity > 1.0) 
		{
            intensity = 1.0;
        }

		
        // Position
        var centerX:Float = globalViewport.x + globalViewport.width / 2;
        var centerY:Float = globalViewport.y + globalViewport.height / 2;
        var distX:Float = centerX - this._positionX;
        var distY:Float = centerY - this._positionY;
		
	 var flare:LensFlare = this.lensFlares[0];	
	var skw:Float = 0; //Math.sin(Gdx.Instance().getTimer() / 10) * 0.01; 
    batch.RenderScaleRotateClipColorAlpha(spriteSheet.image, _positionX, _positionY, flare.size, flare.size, skw, spriteSheet.getClip(flare.frame),  flare.color.r, flare.color.g, flare.color.b, flare.alpha, BlendMode.ADD);
        

        // Flares
        for (index in 1...this.lensFlares.length) 
		{
            var flare:LensFlare = this.lensFlares[index];

            var x = centerX - (distX * flare.index);
            var y = centerY - (distY * flare.index);
		    var cw = flare.size;
            var ch = flare.size* Gdx.Instance().getAspectRatio();
	
       		batch.RenderScaleRotateClipColorAlpha(spriteSheet.image, x, y, cw, ch, 0, spriteSheet.getClip(flare.frame),  flare.color.r, flare.color.g, flare.color.b, intensity, BlendMode.ADD);
			
									
		 }
    
	}
	
	override public function dispose() 
	{
		super.dispose();
		

        while (this.lensFlares.length > 0)
		{
            this.lensFlares[0].dispose();
        }

        
	}
	
}
