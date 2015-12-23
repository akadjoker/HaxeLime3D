package com.gdx.util;


import flash.display.Stage;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.events.Event;
import flash.system.System;
import flash.system.Capabilities;

/**
 * ...
 * @author djoker
 */

class FPS extends TextField
{
  
	    var dpi:Float;
   var screenResolutionX:Float;
   var screenResolutionY:Float;
 
    public var 	    avgFPS :Int;
    public var     bestFPS :Int;
    public var     lastFPS :Int;
    public var     worstFPS :Int;
    public var     triangleCount :Int;
    public var     bestFrameTime :Int;
    public var     worstFrameTime :Int;
    public var     mLastTime :Int;
    public var     mLastSecond :Int;
    public var     mFrameCount :Int;
		
   public function new(inX:Float=10.0, inY:Float=10.0, inCol:Int = 0x000000)
   {
      super();
      x = inX;

      y = inY;
      selectable = false;
      defaultTextFormat = new TextFormat("_sans", 20, 0, true);
      text = "FPS:";
      textColor = 0xff00ffff;
	  backgroundColor = 0xFFFFFFFF;
      width = 200;
    
	  
	  dpi = Capabilities.screenDPI;
	  screenResolutionX = Capabilities.screenResolutionX;
	  screenResolutionY = Capabilities.screenResolutionY;
      addEventListener(Event.ENTER_FRAME, onEnter);

	  
	    avgFPS = 0;
        bestFPS = 0;
        lastFPS = 0;
        worstFPS = 999;
        triangleCount = 0;
        bestFrameTime = 999999;
        worstFrameTime = 0;
        mLastTime = Lib.getTimer ();
        mLastSecond = mLastTime;
        mFrameCount = 0;
   }

   public function onEnter(Env:Event)
   {
	   ++mFrameCount;
        var thisTime:Int =  Lib.getTimer ();
        var frameTime:Int = thisTime - mLastTime ;
        mLastTime = thisTime ;

        bestFrameTime = Std.int(Math.min(bestFrameTime, frameTime));
        worstFrameTime = Std.int(Math.max(worstFrameTime, frameTime));
		
		   // check if new second (update only once per second)
        if (thisTime - mLastSecond > 1000) 
        { 
            // new second - not 100% precise
            lastFPS = Std.int(mFrameCount / (thisTime - mLastSecond) * 1000);

            if (avgFPS == 0)
                avgFPS = lastFPS;
            else
                avgFPS = Std.int((avgFPS + lastFPS) / 2); // not strictly correct, but good enough

            bestFPS = Std.int(Math.max(bestFPS, lastFPS));
			
            worstFPS = Std.int(Math.min(worstFPS, lastFPS));

            mLastSecond = thisTime ;
            mFrameCount  = 0;

        }

		// text = "FPS:" + Std.string(lastFPS).substr(0, 5) + ",Best:" + Std.string(bestFPS).substr(0, 5) + ",Worst:"+Std.string(worstFPS).substr(0, 5);
		 text = "FPS:" +lastFPS + 
		 "\nBest:" + bestFPS + 
		 "\nWorst:" + worstFPS ;
		 ///"\nTextures:" + Gdx.Instance().numTextures;
    
   }

}