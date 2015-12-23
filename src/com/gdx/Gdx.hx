package com.gdx;




import com.gdx.color.Color3;
import com.gdx.gl.material.Material;
import com.gdx.gl.shaders.ShaderCastShadow;
import com.gdx.gl.shaders.ShaderLight;
import com.gdx.gl.shaders.ShaderPointLight;
import com.gdx.gl.shaders.ShaderSpotLight;
import com.gdx.Importer;
import com.gdx.gl.BlendMode;
import com.gdx.gl.shaders.ColorShader;
import com.gdx.gl.shaders.Shader;
import com.gdx.gl.shaders.ShaderDefault;
import com.gdx.gl.shaders.ShaderGrass;
import com.gdx.gl.shaders.ShaderSkin;
import com.gdx.gl.shaders.ShaderTexture;
import lime.ui.Window;

import com.gdx.gl.Texture;
import com.gdx.gl.TextureCube;
import com.gdx.math.Rectangle;
import com.gdx.util.Util;
import haxe.Timer;
import lime.Assets;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.opengl.GL;
import lime.system.System;


















/**
 * ...
 * @author djoker
 */
class Gdx 
{

	public static inline var MAXTEXTURES = 4;
	 
    public static inline var DEBUGNONE = 0;
	public static inline var DEBUGNODEOBB = 101;
	public static inline var DEBUGSURFOBB = 110;
	public static inline var DEBUGSURFNORMALS = 111;
	public static inline var DEBUGSKELETON = 200;
	
public static inline var MaterialSolid  =0;
public static inline var MaterialSolid2Layer = 1;
public static inline var MaterialLightMap = 2;
public static inline var MaterialDetailMap = 3;
public static inline var MaterialReflection2Layer = 4;
public static inline var MaterialTransparentAlphaChannel = 5;
public static inline var MaterialTransparentAlphaChannelRef = 6;
public static inline var MaterialTransparentVertexAlpha = 7;
public static inline var MaterialTransparentReflection2Layer = 8;

	


	  
	   public static inline var SHADERCOLOR          = 0; 
	   public static inline var SHADERDEFAULT        = 1;
	   public static inline var SHADERSHADOW        = 2;
	   public static inline var SHADERTEXTURE        = 3;
	   public static inline var SHADERTEXTURESKIN    = 4;
	   public static inline var SHADERGRASS = 5;
	   public static inline var SHADERLIGHT = 6;
	   public static inline var SHADERPOINTLIGHT = 7;
	   public static inline var SHADERSPOTLIGHT = 8;
	   
	   
	 
	   
	public static inline var GLPOINTS = 0x0000;
	public static inline var GLLINES = 0x0001;
	public static inline var GLLINE_LOOP = 0x0002;
	public static inline var GLLINE_STRIP = 0x0003;
	public static inline var GLTRIANGLES = 0x0004;
	public static inline var GLTRIANGLE_STRIP = 0x0005;
	public static inline var GLTRIANGLE_FAN = 0x0006;
	

		private var  BlendSource:Int;
		private var  BlendDestination:Int;
		private var  Blend:Bool;
		private var  Blendtype:Int;

		private var CullFaceMode:Int;
		private var CullFace:Bool;

		private var  DepthFunc:Int;
		private var DepthMask:Bool;
		private var DepthTest:Bool;
		
	private var ASPECT_RATIO:Float;
	public var deltaTime:Float;
	public var fixedTime:Float;
	public var  timecount:Float;
	
	public var currentBaseTextures:Array<Texture>;
	public var currentMaterial:Material;

	public var numTextures:Int;
	public var numVertex:Int;
	public var numTris:Int;
	public var numBuffers:Int;
	public var numSurfaces:Int;
	public var numMesh:Int;
	public var numBrush:Int;
	public var status:String;
	public var dummyTexture:Texture;
	public var viewPort:Rectangle;
	private var keys:Array<Int>;
	private var maxMem:Int = 0;
	
	
	public  var fogColor:Color3=new Color3(0.2, 0.2, 0.3);
	public  var fogMode:Float;
	public  var fogStart:Float;
	public  var fogEnd:Float;
	public  var fogDensity:Float;
	
	public var materials:Array<Shader>;
	
	
	private static var __startTime:Float = Timer.stamp ();

		

	public static var gdx:Gdx = null;
    public  var width:Int = 0;
    public  var height:Int = 0;
	private var startWidth:Int;
	private var startHeight:Int;
	

	private var isPause:Bool;
	
    private var screen:Screen;
    public var textures:Map<String,Texture>;

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
	//private var txtfps:TextField;
     private var pt:Int = 0;
     private var fps:Float = -1.0;
     private var timeStamp:Int = 0;

	 private var mainWindow:Window;
	

	 private var _r:Float;
	 private var _g:Float;
	 private var _b:Float;
	 
	public function new() 
	{
	 status = "";
	}

	
	   public function init(win:Window,w:Int, h:Int)
	   {
		 	this.mainWindow = win;
		   viewPort = new Rectangle(0, 0, w, h);
	

	currentBaseTextures = [];
	 for (i in 0...Gdx.MAXTEXTURES)
	 {
	 currentBaseTextures.push(null);
	 }

	numTextures = 0;
	numVertex=0;
	numTris = 0;
	numSurfaces = 0;
	numMesh = 0;
	numBrush = 0;
	numBuffers = 0;
	
	keys = [];
	for (i in 0...256)
	{
		keys[i] = 0;
	}
	
		for (i in 0...20)
		{
			TouchX[i] =- 1;
			TouchY[i] =- 1;
		}

        timecount = 0;
		width  = w;
        height = h;
		ASPECT_RATIO =(width /  height);
	
		setViewPort(0, 0, width, height);

		startWidth = width;
	    startHeight = height;
	
		
	    avgFPS = 0;
        bestFPS = 0;
        lastFPS = 0;
        worstFPS = 999;
        triangleCount = 0;
        bestFrameTime = 999999;
        worstFrameTime = 0;
        mLastTime = getTimer();
        mLastSecond = mLastTime;
        mFrameCount = 0;
		fixedTime = 0;
		deltaTime = 0;
		
		isPause = false;

		
		 BlendSource = -1;
		 BlendDestination = -1;
		 DepthFunc = -1;
		 Blend=true;

		 CullFaceMode=GL.BACK;
		 CullFace=false;
		 DepthFunc=GL.LESS;
		 DepthMask=false;
		 DepthTest=false;
	
		 
	

	     
		
    clearColor(0, 0, 0.4);
	
	

	
       setDepthMask(true);
	   setDepthTest(true);
	   setCullFace(true);
	   setBlend(false); 
	   setDepthFunc(GL.LESS);
	   
	   
	   
	   
	GL.pixelStorei(GL.PACK_ALIGNMENT,1);
	//GL.hint(GL.GENERATE_MIPMAP_HINT, GL.FASTEST);
	GL.hint(GL.GENERATE_MIPMAP_HINT, GL.NICEST);
	GL.clearDepth(1.0);
	GL.colorMask(true, true, true, true);
	 
	GL.depthRange(0.0, 1.0);
	GL.frontFace(GL.CCW);
	GL.clearStencil(0);
	GL.stencilMask(0xFFFFFFFF);
	GL.cullFace(GL.BACK);

	
	
	
	textures = new  Map<String,Texture>();
	
	
	dummyTexture = new Texture();
	
	var bmp:Image = new Image(null, 0, 0, 128, 128);
	
	for (x in 0...64)
	{
		for (y in 0...64)
		{
			bmp.setPixel32(x, y,       Util.getColorARGB(255,0,0,0));
			bmp.setPixel32(x+64, y,    Util.getColorARGB(255,255,255,255));
			bmp.setPixel32(x, y + 64,  Util.getColorARGB(255,255,255,255));
			bmp.setPixel32(x+64, y+64, Util.getColorARGB(255,0,0,0));
		}
	}
	

	dummyTexture.loadBitmap(bmp, false);
	textures.set("dummy", dummyTexture);
	
//	Util.saveImageToFile(bmp, "dummy.png");
	
	
	materials = [];
	materials.push(new ColorShader());
	materials.push(new ShaderDefault());
	materials.push(new ShaderCastShadow());
	materials.push(new ShaderTexture());
	materials.push(new ShaderSkin());
	materials.push(new ShaderGrass());
    materials.push(new ShaderLight());
//	materials.push(new ShaderPointLight());
//	materials.push(new ShaderSpotLight());


	
	currentMaterial = new Material();

	
		
 //this.fogColor = new Color3(0.2, 0.2, 0.3);

 

 
	
setFogMode(2, 20.0, 60.0, 0.009);
	
		
		
		 pt = getTimer();
		
	   }

    public function getWindow():Window
	{
		   return mainWindow;
	}
	public function setTitle(caption:String):Void
	{
		mainWindow.title = caption;
	}
	public function setFogColor(c:Color3):Void
	{
	  fogColor.copyFrom(c);
	}
	/*
	 *   FOGMODE_NONE - default one, fog is deactivated.
     *   FOGMODE_EXP - the fog density is following an exponential function.
     *   FOGMODE_EXP2 - same that above but faster.
     *   FOGMODE_LINEAR - the fog density is following a linear function.
	 */
	  
	public function setFogMode(mode:Float, fogStar:Float,fogEnd:Float,fogDensity:Float ):Void
	{
	this.fogMode = mode;
	this.fogStart = fogStar;
	this.fogEnd = fogEnd;
	this.fogDensity = fogDensity;
	}
	   
	public function onKeyDown (keyCode:Int):Void 
	{
	if (keyCode <= 256) keys[keyCode] = 1;
	if (screen != null) screen.KeyDown(keyCode);

   }
	public function onKeyUp (keyCode:Int):Void
	{
	if (keyCode <= 256) keys[keyCode] = 0;
	  if (screen != null) screen.KeyUp(keyCode);
	}
	
	public function keyPress(keyCode:Int):Bool
    {
	    return  (keys[keyCode]) != 0 ;
	}	
	public function getTextureCubemap(url:String ):TextureCube 
   {
	if (textures.exists(url))
	{
		return cast (textures.get(url), TextureCube);
	} else
	{	
	var tex = new TextureCube(url);
	#if debug
	//trace("INFO: Load ("+url+") Bitmap to Texture");
	#end
	
	textures.set(url,tex);
	return tex;
	}
   }
	public function getTexture(url:String, Linear:Bool = true, Repeat:Bool = true, mipmap:Bool = false ):Texture 
   {
	if (textures.exists(url))
	{
		return textures.get(url);
	} else
	{	
	var tex = new Texture();
	tex.loadBitmap(Assets.getImage(url), Linear,Repeat,mipmap );
	#if debug
	trace("INFO: Load ("+url+") Bitmap to Texture");
	#end
	
	textures.set(url,tex);
	return tex;
	}
   }
   public function getTextureEx(img:Image, mipmap:Bool = false ):Texture 
   {
	
	var tex = new Texture();
	tex.loadBitmap(img, mipmap );
	return tex;
	
   }
    public function setTextureFilter(linear:Bool)
	{
		if (linear)
		{
				 GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
	             GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
			
		}else
		{
				 GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
	             GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
			
		}
		
	}
   	public function setTextureWrap(mode:Int)
	{
		switch (mode)
		{
		case 0:
			{
				 GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
                 GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);			
			}
			case 1:
				{
		        GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
                GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);			
				}
				case 2:
					{
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.MIRRORED_REPEAT);
                    GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.MIRRORED_REPEAT);			
					}
		
		}
	}
	
	
	

	public function getWidth():Int
	{
	 return width;
	}
	public function getHeight():Int
	{
		return height;
		
	}
	
	
	public function clearColor(red:Float = 0, green:Float = 0, blue:Float = 0)
   {
	 _r = red;
	 _g = green;
	 _b = blue;
	  GL.clearColor(_r,_g,_b, 1);
   }
   
   public function resetStatus()
   {
	    avgFPS = 0;
        bestFPS = 0;
        lastFPS = 0;
        worstFPS = 999;
        triangleCount = 0;
        bestFrameTime = 999999;
        worstFrameTime = 0;
   }
   private function updateStates():Void
   {
	   ++mFrameCount;
        var thisTime:Int =  getTimer ();
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
	
		
		var mem = Std.int(get_totalMemory() / 1024 / 1024);
		if (mem > maxMem) maxMem = mem;
		

       status = "FPS:" +lastFPS + 
		 "/Best:" + bestFPS + 
		 "\nTris:"+this.numTris+"/Vtx:"+this.numVertex+"/Surf:"+numSurfaces+"/Mesh:"+numMesh+
		 "\nTextures:" + numTextures +"/Mat:" + numBrush;
		 //"\nmem : " + mem + " / " + maxMem + "\n";
		 
	    
   }
   
	 public function get_totalMemory ():Int {
		
		#if neko
		return neko.vm.Gc.stats().heap;
		#elseif cpp
		return untyped __global__.__hxcpp_gc_used_bytes ();
		#elseif (js && html5)
		return untyped __js__ ("window.performance.memory");
		#end
		
	}
	
   public function clear():Void
   {
	   GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
   }


		
   	public function setViewPort(x:Float,y:Float,w:Float,h:Float):Void
	{
		GL.viewport(Std.int(x) , Std.int(y), Std.int(w), Std.int(h));
		viewPort.setTo(x, y, w, h);
	}
	public function Update(dt:Float)
	{
		 fixedTime = Math.min(1 / 40, 1 / 200 + timeStamp * 1e-5 * 30);
		 deltaTime = dt;
		if (screen != null) screen.update(dt);
	}
	
	 public function render( ):Void 
	{

		// if (isPause) return;
		 

	  currentBaseTextures[0] = null;
	  currentBaseTextures[1] = null;
	  currentBaseTextures[2] = null;
	  currentBaseTextures[3] = null;
	  currentMaterial = null;
	  
	 

	numTextures = 0;
	numVertex=0;
	numTris = 0;
	numSurfaces = 0;
	numMesh = 0;
	numBrush = 0;
	
	
	
	
	
        setDepthMask(true);
		setDepthTest(true);
		setCullFace(true);
		setBlend(true);
		BlendMode.setBlend(BlendMode.NORMAL);
		//setBlendFunc(GL.SRC_ALPHA, GL.DST_ALPHA);
		
		GL.clearColor(_r,_g,_b, 1);
        clear();
	 
	 
	
	  if (screen != null) screen.render();	
      timeStamp++;

	  
	
	
	
	
		 
		
	  
	
	  GL.useProgram(null);
	  GL.bindBuffer(GL.ARRAY_BUFFER, null);
	  GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
	  GL.activeTexture(GL.TEXTURE0);
      //GL.enable(GL.TEXTURE_2D);

 
	  updateStates();
	  
	 
	}

   
	public function onShow():Void
	{
     if (screen != null) screen.resume();	
	 isPause = false;
	}
	public function onHide():Void
	{
	if (screen != null) screen.pause();
	isPause = true;
	}
	public function onClose():Void
	{
	 dispose();
	}
	public function onresize(Width:Int, Height:Int):Void
	{
	    this.width  = Width;
		this.height = Height;
		if (screen != null) screen.resize(width, height);
		ASPECT_RATIO =(width /  height);
	
		

		//txtfps.y = height - 80;
		
		fullScaleX = (startWidth / width);
		fullScaleY = (startHeight / height);
      // trace(viewWidth+","+viewHeight+","+Width+","+Height+","+fullScaleX + "," + fullScaleY);
	}


	public function setScreen ( screen:Screen):Void 
	{
		if (this.screen != null) this.screen.hide();
		this.screen = screen;
		if (this.screen != null) 
		{
			this.screen.show();
			this.screen.resize(getWidth(),getHeight());
		}
	}
	public function getScreen () :Screen
	{
		return screen;
	}
	public function dispose()
	{
	  GL.useProgram(null);
      GL.bindBuffer(GL.ARRAY_BUFFER, null);
      GL.blendFunc(GL.SRC_ALPHA, GL.DST_ALPHA );	
	  
		#if !js
		if (screen != null) screen.dipose();
			for (tex in this.textures)
		{
			tex.dispose();
		}
		textures = null;
		#end
	}
	public function mouseDown(x:Float, y:Float, button:Int):Void
	{
	    TouchX[button] =x;
		TouchY[button] =y;
	    ++TouchID ;
		TouchDown = true;
		if (screen != null) screen.TouchDown(x,y,button);
	}

	
	public function mouseUp(x:Float, y:Float, button:Int):Void
	{
		
	    TouchX[button] =x;
		TouchY[button] =y;
	    --TouchID ;
		TouchDown = false;
		if (screen != null) screen.TouchUp(x,y,button);
	}

	
	public function mouseMove(x:Float, y:Float, button:Int):Void
	{
	     TouchX[button] =x;
		 TouchY[button] = y;
    
	
		
	   if (screen != null) screen.TouchMove(x,y,button);
	}
	public  function onTouchBegin(x:Float, y:Float, id:Int)
	{
		TouchX[id] = x;
		TouchY[id] = y;
	    ++TouchID ;
		TouchDown = true;
		if (screen != null) screen.TouchDown(x,y,id);
	}

	public  function onTouchMove(x:Float, y:Float, id:Int)
	{
		
		
		TouchX[id] = x;
		TouchY[id] = y;
		if (screen != null) screen.TouchMove(x,y,id);
	}

	public  function onTouchEnd(x:Float, y:Float, id:Int)
	{
		TouchX[id] = -1;
		TouchY[id] = -1;
		--TouchID ;
		TouchDown = false;
		if (screen != null) screen.TouchUp(x,y,id);
		
	}
	
	
	 public function getAspectRatio():Float
	  {
		   
		     var vw:Float =width;
		     var vh:Float =height;
		     return (vw/ vh);
	       
    }
	
	public function getTimer():Int
	{
		return Std.int ((Timer.stamp () - __startTime) * 1000);
	}
	public function getTicks():Int
	{
		return Std.int (Timer.stamp ()); 
	}
	
	public function computeSpeed(speed:Float):Float 
	{
		return speed * ((deltaTime / (lastFPS * 10.0)));
	}
	
	public static function Instance() : Gdx 
	{
		if (Gdx.gdx == null)
		{
			Gdx.gdx = new Gdx();
		}
		return Gdx.gdx;
		
	}
	
	public function setDepthTest( enable:Bool)
	{
		if (DepthTest != enable)
		{
			if (enable)
				GL.enable(GL.DEPTH_TEST);
			else
				GL.disable(GL.DEPTH_TEST);

			DepthTest = enable;
		}
		

	}
	public function setDepthMask(enable:Bool)
	{
		if (DepthMask != enable)
		{
			if (enable)
				GL.depthMask(true);
			else
				GL.depthMask(false);

			DepthMask = enable;
		}
	
	}
	public function setDepthFunc( mode:Int)
	{
		if (DepthFunc != mode)
		{
			GL.depthFunc(mode);

			DepthFunc = mode;
		}
	}
	public function setCullFace( enable:Bool)
	{
		if (CullFace != enable)
		{
			if (enable)
				GL.enable(GL.CULL_FACE);
			else
				GL.disable(GL.CULL_FACE);

			CullFace = enable;
	    }

	}
	public function setCullFaceFunc( mode:Int)
	{
		if (CullFaceMode != mode)
		{
			GL.cullFace(mode);

			CullFaceMode = mode;
		}
	}
	public function setBlend( enable:Bool)
	{
		if (Blend != enable)
		{
			if (enable)
				GL.enable(GL.BLEND);
			else
				GL.disable(GL.BLEND);

			Blend = enable;
		}
		
	}
	public function setBlendFunc( source:Int, destination:Int)
	{
		if (BlendSource != source || BlendDestination != destination)
		{
			GL.blendFunc(source, destination);

			BlendSource = source;
			BlendDestination = destination;
		}
	}

	public function setBlendType( type:Int)
	{
		if (Blendtype != type )
		{
			
			switch (type)
			{
			 case 0:setBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);//alpha
			 case 1:setBlendFunc(GL.DST_COLOR, GL.ZERO);//multiply
			 case 2:setBlendFunc(GL.SRC_ALPHA, GL.ONE);//additive and alpha
			 case 3:setBlendFunc(GL.ONE, GL.ONE);//blend after texture
			
				
		}
		
		//BlendMode.setBlend(type);	 

			Blendtype = type;
		}
	}
	public var fullScaleX(default, null):Float = 1;
	public var fullScaleY(default, null):Float = 1;
	public  var multiTouchSupported(default, null):Bool = false;
	public  var TouchDown:Bool = false;
	public  var TouchX:Array<Float> = new Array<Float>();
	public  var TouchY:Array<Float> = new Array<Float>();
	public  var TouchID:Int = 0;
}