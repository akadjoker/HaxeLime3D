package  com.gdx.collision;

import com.gdx.math.BoundingBox;
import com.gdx.math.Matrix;
import com.gdx.math.Plane;
import com.gdx.math.Triangle;
import com.gdx.math.Vector3;
import com.gdx.gl.Imidiatemode;




typedef LowestResult = {
	root: Float,
	found: Bool
}

typedef LowestRoot = {
	root: Float,
	found: Bool
}

typedef TimeBool = {
	tMax: Float,
	found: Bool
}
typedef TimeBoolNormal = {
	tMax: Float,
	found: Bool,
	normal:Vector3
}
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
/**
 * ...
 * @author Luis Santos AKA DJOKER
 */
class Coldet
{

	public function new() 
	{
		
	}
	
	public static function  getLowestRoot(a:Float, b:Float, c:Float, maxR:Float):LowestResult {
        var determinant = b * b - 4.0 * a * c;
        var result:LowestResult = { root: 0, found: false };

        if (determinant < 0)
            return result;

        var sqrtD = Math.sqrt(determinant);
        var r1 = (-b - sqrtD) / (2.0 * a);
        var r2 = (-b + sqrtD) / (2.0 * a);

        if (r1 > r2) {
            var temp = r2;
            r2 = r1;
            r1 = temp;
        }

        if (r1 > 0 && r1 < maxR) {
            result.root = r1;
            result.found = true;
            return result;
        }

        if (r2 > 0 && r2 < maxR) {
            result.root = r2;
            result.found = true;
            return result;
        }

        return result;
    }

	
	///**************************************************************************************************************************
	public static function collideWithVertices(recursionDepth:Int,colData:CollisionData,selector:Array<Vector3>,position:Vector3,  velocity:Vector3,l:Imidiatemode):Vector3
	{
		
		/*
		/// Set this to match application scale..
        var unitsPerMeter:Float = 100.0;
        var unitScale:Float = unitsPerMeter / 100.0;
        var veryCloseDistance:Float = 0.005 * unitScale;
*/
         var veryCloseDistance:Float =  colData.slidingSpeed;
			   
		if (recursionDepth > 3)
		{
			return position;
		}
		

     

	    colData.velocity=velocity;
		colData.normalizedVelocity = Vector3.Normalize(velocity);
		colData.basePoint = position;
		colData.foundCollision = false;
		colData.nearestDistance = 9999999999999.0;

     var v1:Vector3 = Vector3.zero;
	 var v2:Vector3 = Vector3.zero;
	 var v3:Vector3 = Vector3.zero;
	 
	var sMultx:Float = 1.0 / colData.eRadius.x;
	var sMulty:Float = 1.0 / colData.eRadius.y;
	var sMultz:Float = 1.0 / colData.eRadius.z;
	
	
		
		for (i in 0 ... Std.int(selector.length/3))
		{
	
			v1.x = selector[i*3+0].x * sMultx;
			v1.y = selector[i*3+0].y * sMulty;
			v1.z = selector[i*3+0].z * sMultz;
		
			v2.x = selector[i*3+1].x * sMultx;
			v2.y = selector[i*3+1].y * sMulty;
			v2.z = selector[i*3+1].z * sMultz;
			
			v3.x = selector[i*3+2].x * sMultx;
			v3.y = selector[i*3+2].y * sMulty;
			v3.z = selector[i*3+2].z * sMultz;
			

			
					if (Coldet.testTriangle(colData, v1,v2,v3, l)) 
					{
						
					//	l.drawFillTriangle(Vector3.ScaleBy(v3, colData.eRadius), Vector3.ScaleBy(v2, colData.eRadius), Vector3.ScaleBy(v1, colData.eRadius), 0, 1, 0, 1);
					//	l.drawTriangle(Vector3.ScaleBy(v1, colData.eRadius), Vector3.ScaleBy(v2, colData.eRadius), Vector3.ScaleBy(v3, colData.eRadius), 0, 1, 0, 1);
						
						//break;
					}	
				
		}
		
                
     
                // If no collision we just move along the velocity
                if (!colData.foundCollision)
                {
                    return  Vector3.Add(position, velocity);
                }
     
			     // *** Collision occured ***
                // The original destination point
                var destinationPoint:Vector3 = Vector3.Add(position,velocity);
				var newBasePoint:Vector3  = position;
				
				
     
                // only update if we are not already very close
                // and if so we only move very close to intersection..not
                // to the exact spot.
     
				
                if (colData.nearestDistance >= veryCloseDistance)
                {
                    var  V:Vector3 = velocity;
					
                  //  V.normalize();
				//	V = Vector3.Mult(V, (colData.nearestDistance - veryCloseDistance));
					V.setLength(colData.nearestDistance - veryCloseDistance);
					
                    newBasePoint = Vector3.Add(colData.basePoint, V);
     
                    // Adjust polygon intersection point (so sliding
                    // plane will be unaffected by the fact that we
                    // move slightly less than collision tells us)
                    V.normalize();
                    colData.intersectionPoint.x -= (veryCloseDistance*V.x);
					colData.intersectionPoint.y -= (veryCloseDistance*V.y);
					colData.intersectionPoint.z -= (veryCloseDistance*V.z);
				
                }
     
                // calculate sliding plane
                var slidePlaneOrigin:Vector3 = colData.intersectionPoint;
				
				
                var  slidePlaneNormal:Vector3 = Vector3.Sub(newBasePoint, colData.intersectionPoint);
				slidePlaneNormal.normalize();
				
				
				///trace(slidePlaneNormal.toString());
				
			    var slidingPlane:Plane =Plane.FromPositionAndNormal(slidePlaneOrigin, slidePlaneNormal);
     
        
          	    var newDestinationPoint:Vector3 = Vector3.zero;
				
				var d:Float = slidingPlane.signedDistanceTo(destinationPoint);
				
				newDestinationPoint.x = destinationPoint.x - (slidePlaneNormal.x * d);
				newDestinationPoint.y = destinationPoint.y - (slidePlaneNormal.y * d);				
				newDestinationPoint.z = destinationPoint.z - (slidePlaneNormal.z * d);
				
				
				
     
                // Generate the slide vector, which will become our new velocity vector for the next iteration
                var newVelocityVector:Vector3 = Vector3.Sub(newDestinationPoint, colData.intersectionPoint);
			
	
     
                // Recurse: Don't recurse if the new velocity is very small
                if (newVelocityVector.length() < veryCloseDistance)
                {
                    return newBasePoint;
                }
     
               
		return collideWithVertices(recursionDepth+1,colData,selector,newBasePoint,newVelocityVector,l);
	}
	//*************************************************************************************************************************
	public static function collideWithTriangles(recursionDepth:Int,colData:CollisionData,selector:Array<Triangle>,position:Vector3,  velocity:Vector3,l:Imidiatemode):Vector3
	{
		// Set this to match application scale..
       // var unitsPerMeter:Float = 100.0;
       // var unitScale:Float = unitsPerMeter / 100.0;
       // var veryCloseDistance:Float = 0.005 * unitScale;

         var veryCloseDistance:Float =  colData.slidingSpeed;
			   
		if (recursionDepth > 3)
		{
			return position;
		}
		

     

	    colData.velocity.copyFrom(velocity);
		colData.normalizedVelocity = Vector3.Normalize(velocity);
		colData.basePoint.copyFrom(position);
		colData.foundCollision = false;
		colData.nearestDistance = 9999999999999.0;

     var v1:Vector3 = Vector3.zero;
	 var v2:Vector3 = Vector3.zero;
	 var v3:Vector3 = Vector3.zero;
	 
	var sMultx:Float = 1.0 / colData.eRadius.x;
	var sMulty:Float = 1.0 / colData.eRadius.y;
	var sMultz:Float = 1.0 / colData.eRadius.z;
	
	
		
		for (i in 0 ... selector.length)
		{
	
			v1.x = selector[i].a.x * sMultx;
			v1.y = selector[i].a.y * sMulty;
			v1.z = selector[i].a.z * sMultz;
		
			v2.x = selector[i].b.x * sMultx;
			v2.y = selector[i].b.y * sMulty;
			v2.z = selector[i].b.z * sMultz;
			
			v3.x = selector[i].c.x * sMultx;
			v3.y = selector[i].c.y * sMulty;
			v3.z = selector[i].c.z * sMultz;
			

					if (Coldet.testTriangle(colData, v1,v2,v3, l)) 
					{
						//l.drawFillTriangle(Vector3.ScaleBy(v3, colData.eRadius), Vector3.ScaleBy(v2, colData.eRadius), Vector3.ScaleBy(v1, colData.eRadius), 1, 0, 0, 1);
					}	
				
		}
		
                
     
                // If no collision we just move along the velocity
                if (!colData.foundCollision)
                {
                    return  Vector3.Add(position, velocity);
                }
     
			     // *** Collision occured ***
                // The original destination point
                var destinationPoint:Vector3 = Vector3.Add(position,velocity);
				var newBasePoint:Vector3  = position;
				
				
     
                // only update if we are not already very close
                // and if so we only move very close to intersection..not
                // to the exact spot.
     
				
                if (colData.nearestDistance >= veryCloseDistance)
                {
                    var  V:Vector3 = velocity;
					
                  //  V.normalize();
				//	V = Vector3.Mult(V, (colData.nearestDistance - veryCloseDistance));
					V.setLength(colData.nearestDistance - veryCloseDistance);
					
                    newBasePoint = Vector3.Add(colData.basePoint, V);
     
                    // Adjust polygon intersection point (so sliding
                    // plane will be unaffected by the fact that we
                    // move slightly less than collision tells us)
                    V.normalize();
                    colData.intersectionPoint.x -= (veryCloseDistance*V.x);
					colData.intersectionPoint.y -= (veryCloseDistance*V.y);
					colData.intersectionPoint.z -= (veryCloseDistance*V.z);
				
                }
     
                // calculate sliding plane
                var slidePlaneOrigin:Vector3 = colData.intersectionPoint;
				
				
                var  slidePlaneNormal:Vector3 = Vector3.Sub(newBasePoint, colData.intersectionPoint);
				slidePlaneNormal.normalize();
				
				
				//trace(slidePlaneNormal.toString());
				
			    var slidingPlane:Plane =Plane.FromPositionAndNormal(slidePlaneOrigin, slidePlaneNormal);
     
        
          	    var newDestinationPoint:Vector3 = Vector3.zero;
				
				var d:Float = slidingPlane.signedDistanceTo(destinationPoint);
				
				newDestinationPoint.x = destinationPoint.x - (slidePlaneNormal.x * d);
				newDestinationPoint.y = destinationPoint.y - (slidePlaneNormal.y * d);				
				newDestinationPoint.z = destinationPoint.z - (slidePlaneNormal.z * d);
				
				
				
     
                // Generate the slide vector, which will become our new velocity vector for the next iteration
                var newVelocityVector:Vector3 = Vector3.Sub(newDestinationPoint, colData.intersectionPoint);
			
	
     
                // Recurse: Don't recurse if the new velocity is very small
                if (newVelocityVector.length() < veryCloseDistance)
                {
                    return newBasePoint;
                }
     
               
		return collideWithTriangles(recursionDepth+1,colData,selector,newBasePoint,newVelocityVector,l);
	}
	
	
	
	


	public static function GetPositionOnTriangles(selector:Array<Triangle>,position:Vector3, radius:Vector3, velocity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity=velocity;
	    colData.R3Position = position;
		colData.triangleHits = 0;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	 colData.finalPosition = Coldet.collideWithTriangles(0, colData, selector, eSpacePosition, eSpaceVelocity, l);

	 
	
	colData.finalPosition.x *= colData.eRadius.x;
	colData.finalPosition.y *= colData.eRadius.y;
	colData.finalPosition.z *= colData.eRadius.z;
	colData.hitPosition.set(colData.intersectionPoint.x * colData.eRadius.x, colData.intersectionPoint.y * colData.eRadius.y, colData.intersectionPoint.z * colData.eRadius.z);
	colData.Falling = (colData.triangleHits == 0);
           
		return colData;
	}	
	public static function GetPositionOnVertices(selector:Array<Vector3>,position:Vector3, radius:Vector3, velocity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity=velocity;
	    colData.R3Position = position;
		colData.triangleHits = 0;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	 colData.finalPosition = Coldet.collideWithVertices(0, colData, selector, eSpacePosition, eSpaceVelocity, l);

	 
	
	colData.finalPosition.x *= colData.eRadius.x;
	colData.finalPosition.y *= colData.eRadius.y;
	colData.finalPosition.z *= colData.eRadius.z;
	colData.hitPosition.set(colData.intersectionPoint.x * colData.eRadius.x, colData.intersectionPoint.y * colData.eRadius.y, colData.intersectionPoint.z * colData.eRadius.z);
	colData.Falling = (colData.triangleHits == 0);
           
		return colData;
	}	
		public static function CollideVerticesAndSlide(selector:Array<Vector3>,position:Vector3, radius:Vector3, velocity:Vector3,gravity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity=velocity;
	    colData.R3Position = position;
		colData.triangleHits = 0;
		colData.foundCollision = false;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	 var finalPosition:Vector3 = Coldet.collideWithVertices(0, colData, selector, eSpacePosition, eSpaceVelocity, l);


	 // add gravity
	 
	 if (!gravity.equalsToFloats(0, 0, 0))
	 {
	  
	   colData.R3Position.x =   finalPosition.x * colData.eRadius.x;
	   colData.R3Position.y =   finalPosition.y * colData.eRadius.y;
	   colData.R3Position.z =   finalPosition.z * colData.eRadius.z;
	   colData.R3Velocity = gravity;
	   colData.triangleHits = 0;
	   
	   	eSpaceVelocity.x = gravity.x / colData.eRadius.x;
		eSpaceVelocity.y = gravity.y / colData.eRadius.y;
		eSpaceVelocity.z = gravity.z / colData.eRadius.z;
	   
		finalPosition = Coldet.collideWithVertices(0, colData, selector, finalPosition, eSpaceVelocity, l);
	 }
	
	finalPosition.x *= colData.eRadius.x;
	finalPosition.y *= colData.eRadius.y;
	finalPosition.z *= colData.eRadius.z;
	
	colData.finalPosition = finalPosition;
	colData.hitPosition.set(colData.intersectionPoint.x * colData.eRadius.x, colData.intersectionPoint.y * colData.eRadius.y, colData.intersectionPoint.z * colData.eRadius.z);
    colData.Falling = (colData.triangleHits == 0);
               
		return colData;
	}	
	public static function CollideTrianglesAndSlide(selector:Array<Triangle>,position:Vector3, radius:Vector3, velocity:Vector3,gravity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity=velocity;
	    colData.R3Position = position;
		colData.triangleHits = 0;
		colData.foundCollision = false;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	 var finalPosition:Vector3 = Coldet.collideWithTriangles(0, colData, selector, eSpacePosition, eSpaceVelocity, l);


	 // add gravity
	 
	 if (!gravity.equalsToFloats(0, 0, 0))
	 {
	  
	   colData.R3Position.x =   finalPosition.x * colData.eRadius.x;
	   colData.R3Position.y =   finalPosition.y * colData.eRadius.y;
	   colData.R3Position.z =   finalPosition.z * colData.eRadius.z;
	   colData.R3Velocity = gravity;
	   colData.triangleHits = 0;
	   
	   	eSpaceVelocity.x = gravity.x / colData.eRadius.x;
		eSpaceVelocity.y = gravity.y / colData.eRadius.y;
		eSpaceVelocity.z = gravity.z / colData.eRadius.z;
	   
		finalPosition = Coldet.collideWithTriangles(0, colData, selector, finalPosition, eSpaceVelocity, l);
	 }
	
	finalPosition.x *= colData.eRadius.x;
	finalPosition.y *= colData.eRadius.y;
	finalPosition.z *= colData.eRadius.z;
	
	colData.finalPosition = finalPosition;
	colData.hitPosition.set(colData.intersectionPoint.x * colData.eRadius.x, colData.intersectionPoint.y * colData.eRadius.y, colData.intersectionPoint.z * colData.eRadius.z);
    colData.Falling = (colData.triangleHits == 0);
               
		return colData;
	}	
	

	public static function collideEllipsoidWithTrianglesSimple(selector:Array<Triangle>,position:Vector3, radius:Vector3, velocity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity.copyFrom(velocity);
	    colData.R3Position.copyFrom(position);
		colData.triangleHits = 0;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	colData.finalPosition.copyFrom(Coldet.collideWithTriangles(0, colData, selector, eSpacePosition, eSpaceVelocity, l));
	
	colData.finalPosition.x *= colData.eRadius.x;
	colData.finalPosition.y *= colData.eRadius.y;
	colData.finalPosition.z *= colData.eRadius.z;
	
	
               
		return colData;
	}

	public static function collideEllipsoidWithVerticesSimple(selector:Array<Vector3>,position:Vector3, radius:Vector3, velocity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity.copyFrom(velocity);
	    colData.R3Position.copyFrom(position);
		colData.triangleHits = 0;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	colData.finalPosition.copyFrom(Coldet.collideWithVertices(0, colData, selector, eSpacePosition, eSpaceVelocity, l));
	
	colData.finalPosition.x *= colData.eRadius.x;
	colData.finalPosition.y *= colData.eRadius.y;
	colData.finalPosition.z *= colData.eRadius.z;
	
	
               
		return colData;
	}

	public static function collideEllipsoidWithTriangles(selector:Array<Triangle>,position:Vector3, radius:Vector3, velocity:Vector3,gravity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		
		var  colData:CollisionData = new CollisionData();
        colData.eRadius.copyFrom(radius);
	    colData.R3Velocity.copyFrom(velocity);
	    colData.R3Position.copyFrom(position);
		colData.triangleHits = 0;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	 var finalPosition:Vector3 = Coldet.collideWithTriangles(0, colData, selector, eSpacePosition, eSpaceVelocity, l);

      colData.Falling = false;
	 // add gravity
 
	 if (gravity.y!=0.0)
	 {
	  
	   colData.R3Position.x =   finalPosition.x * colData.eRadius.x;
	   colData.R3Position.y =   finalPosition.y * colData.eRadius.y;
	   colData.R3Position.z =   finalPosition.z * colData.eRadius.z;
	   colData.R3Velocity.copyFrom(gravity);
	   colData.triangleHits = 0;
	   
	   	eSpaceVelocity.x = gravity.x / colData.eRadius.x;
		eSpaceVelocity.y = gravity.y / colData.eRadius.y;
		eSpaceVelocity.z = gravity.z / colData.eRadius.z;
	   
		finalPosition.copyFrom(Coldet.collideWithTriangles(0, colData, selector, finalPosition, eSpaceVelocity, l));
		
		
		colData.Falling = (colData.triangleHits == 0);
	 }
	
	finalPosition.x *= colData.eRadius.x;
	finalPosition.y *= colData.eRadius.y;
	finalPosition.z *= colData.eRadius.z;
	
	colData.finalPosition.copyFrom(finalPosition);
	
	colData.hitPosition.set(colData.intersectionPoint.x * colData.eRadius.x, colData.intersectionPoint.y * colData.eRadius.y, colData.intersectionPoint.z * colData.eRadius.z);
          
		return colData;
	}	

	public static function collideEllipsoidWithVertices(selector:Array<Vector3>,position:Vector3, radius:Vector3, velocity:Vector3,gravity:Vector3,slidingSpeed:Float,l:Imidiatemode):CollisionData
	{
		
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity=velocity;
	    colData.R3Position = position;
		colData.triangleHits = 0;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	 var finalPosition:Vector3 = Coldet.collideWithVertices(0, colData, selector, eSpacePosition, eSpaceVelocity, l);

      colData.Falling = false;
	 // add gravity
	 
	 if (!gravity.equalsToFloats(0, 0, 0))
	 {
	  
	   colData.R3Position.x =   finalPosition.x * colData.eRadius.x;
	   colData.R3Position.y =   finalPosition.y * colData.eRadius.y;
	   colData.R3Position.z =   finalPosition.z * colData.eRadius.z;
	   colData.R3Velocity = gravity;
	   colData.triangleHits = 0;
	   
	   	eSpaceVelocity.x = gravity.x / colData.eRadius.x;
		eSpaceVelocity.y = gravity.y / colData.eRadius.y;
		eSpaceVelocity.z = gravity.z / colData.eRadius.z;
	   
		finalPosition = Coldet.collideWithVertices(0, colData, selector, finalPosition, eSpaceVelocity, l);
		
		
		colData.Falling = (colData.triangleHits == 0);
	 }
	
	finalPosition.x *= colData.eRadius.x;
	finalPosition.y *= colData.eRadius.y;
	finalPosition.z *= colData.eRadius.z;
	
	colData.finalPosition = finalPosition;
	
	colData.hitPosition.set(colData.intersectionPoint.x * colData.eRadius.x, colData.intersectionPoint.y * colData.eRadius.y, colData.intersectionPoint.z * colData.eRadius.z);
          
		return colData;
	}	

	public static function getCollisionResultPosition(selector:Array<Triangle>,position:Vector3, radius:Vector3, velocity:Vector3,slidingSpeed:Float,l:Imidiatemode):Vector3
	{
		
		var  colData:CollisionData = new CollisionData();
        colData.eRadius = radius;
	    colData.R3Velocity=velocity;
	    colData.R3Position = position;
		colData.triangleHits = 0;
		colData.slidingSpeed = slidingSpeed;
		colData.nearestDistance = 9999999999999.0;
		
		var eSpacePosition:Vector3 = Vector3.zero;
		var eSpaceVelocity:Vector3 = Vector3.zero;
		
		eSpacePosition.x = colData.R3Position.x / colData.eRadius.x;
		eSpacePosition.y = colData.R3Position.y / colData.eRadius.y;
		eSpacePosition.z = colData.R3Position.z / colData.eRadius.z;
		
		eSpaceVelocity.x = colData.R3Velocity.x / colData.eRadius.x;
		eSpaceVelocity.y = colData.R3Velocity.y / colData.eRadius.y;
		eSpaceVelocity.z = colData.R3Velocity.z / colData.eRadius.z;
		
	colData.finalPosition = Coldet.collideWithTriangles(0,colData, selector, eSpacePosition, eSpaceVelocity, l);
	
	colData.finalPosition.x *= colData.eRadius.x;
	colData.finalPosition.y *= colData.eRadius.y;
	colData.finalPosition.z *= colData.eRadius.z;
	
	
               
		return colData.finalPosition;
	}
	
	
	public static function  testTriangle(colData:CollisionData, p1:Vector3, p2:Vector3, p3:Vector3, lines:Imidiatemode):Bool 
	{
		
		var a:Float = 0;
		var b:Float = 0;
		var c:Float = 0;
		
        var t0:Float = 0;
        var embeddedInPlane:Bool = false;
		
		var _tempVector:Vector3 = Vector3.zero;

		colData.trianglePlane.copyFromPoints(p1, p2, p3);// = Plane.FromPoints(p1, p2, p3);
		var trianglePlane:Plane = colData.trianglePlane;
      
       if ( !trianglePlane.isFrontFacingTo(colData.normalizedVelocity, 0))
		{
				
		// lines.drawTriangle(Vector3.ScaleBy(p3, colData.eRadius), Vector3.ScaleBy(p2, colData.eRadius), Vector3.ScaleBy(p1, colData.eRadius), 0, 1, 1, 1);
			
	     return false;
		}

        var signedDistToTrianglePlane = trianglePlane.signedDistanceTo(colData.basePoint);
        var normalDotVelocity = Vector3.Dot(trianglePlane.normal, colData.velocity);

        if (normalDotVelocity == 0)
		{
            if (Math.abs(signedDistToTrianglePlane) >= 1.0)
			{
		          return false;
			}
            embeddedInPlane = true;
            t0 = 0;
        }
        else {
            t0 = (-1.0 - signedDistToTrianglePlane) / normalDotVelocity;
            var t1 = (1.0 - signedDistToTrianglePlane) / normalDotVelocity;

            if (t0 > t1) {
                var temp = t1;
                t1 = t0;
                t0 = temp;
            }
 // Check that at least one result is within range:
            if (t0 > 1.0 || t1 < 0.0)
			{
		           return false;// both t values are outside 1 and 0, no collision possible
			}
            if (t0 < 0.0)
                t0 = 0.0;
            if (t0 > 1.0)
                t0 = 1.0;
			if (t1 < 0.0)
                t1 = 0.0;
            if (t1 > 1.0)
                t1 = 1.0;
        }

        var collisionPoint:Vector3 = Vector3.zero;

        var found = false;
        var t = 1.0;

        if (!embeddedInPlane) 
		{
			//var planeIntersectionPoint:Vector3 = Vector3.Mult( Vector3.Sub(colData.basePoint, trianglePlane.normal), t0);
			
			var planeIntersectionPoint:Vector3 = Vector3.zero;// Vector3.Mult( Vector3.Sub(colData.basePoint, trianglePlane.normal), t0);
			
		planeIntersectionPoint.x = (colData.basePoint.x - trianglePlane.normal.x) +  (colData.velocity.x * t0);
		planeIntersectionPoint.y = (colData.basePoint.y - trianglePlane.normal.y) +  (colData.velocity.y * t0);
		planeIntersectionPoint.z = (colData.basePoint.z - trianglePlane.normal.z) +  (colData.velocity.z * t0);
		
		
			
			
			
			
			 //if (Coldet.PointInTriangle(planeIntersectionPoint,p1,p2,p3,trianglePlane.normal))
			 if (Coldet.CheckPointInTriangle(planeIntersectionPoint,p1,p2,p3))
 			{
                found = true;
                t = t0;
	            collisionPoint.copyFrom(planeIntersectionPoint);
           }
        }

        if (!found) 
		{
			var velocity:Vector3 = colData.velocity;
			var base:Vector3 = colData.basePoint;
            var velocitySquaredLength = velocity.lengthSquared();
             a = velocitySquaredLength;
			
			//p1
             b = 2.0 * (Vector3.Dot(velocity,Vector3.Sub(base, p1)));
             c = Vector3.Sub(p1,base).lengthSquared() - 1.0;

            var lowestRoot:LowestResult = Coldet.getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                t = lowestRoot.root;
                found = true;
                collisionPoint.copyFrom(p1);
            }

			
			//p2
             b = 2.0 * (Vector3.Dot(velocity,Vector3.Sub(base, p2)));
             c = Vector3.Sub(p2,base).lengthSquared() - 1.0;
            lowestRoot = Coldet.getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                t = lowestRoot.root;
                found = true;
                collisionPoint.copyFrom(p2);
            }
			//p3

             b = 2.0 * (Vector3.Dot(velocity,Vector3.Sub(base, p3)));
             c = Vector3.Sub(p3,base).lengthSquared() - 1.0;

            lowestRoot = Coldet.getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                t = lowestRoot.root;
                found = true;
                collisionPoint.copyFrom(p3);
            }

			
			// check against edges
			
			//p1 - p2
			var edge:Vector3 = Vector3.Sub(p2, p1);
			var baseToVertex:Vector3 = Vector3.Sub(p1, base);
		
			var edgeSquaredLength = edge.lengthSquared();
            var edgeDotVelocity = Vector3.Dot(edge, velocity);
            var edgeDotBaseToVertex = Vector3.Dot(edge, baseToVertex);

            a = edgeSquaredLength * (-velocitySquaredLength) + edgeDotVelocity * edgeDotVelocity;
            b = edgeSquaredLength * (2.0 * Vector3.Dot(colData.velocity, baseToVertex)) - 2.0 * edgeDotVelocity * edgeDotBaseToVertex;
            c = edgeSquaredLength * (1.0 - baseToVertex.lengthSquared()) + edgeDotBaseToVertex * edgeDotBaseToVertex;

            lowestRoot = Coldet.getLowestRoot(a, b, c, t);
            if (lowestRoot.found) 
			{
                var f = (edgeDotVelocity * lowestRoot.root - edgeDotBaseToVertex) / edgeSquaredLength;

                if (f >= 0.0 && f <= 1.0)
				{
                    found = true;
					t = lowestRoot.root;
                	collisionPoint.x = p1.x + (edge.x * f);
					collisionPoint.y = p1.y + (edge.y * f);
					collisionPoint.z = p1.z + (edge.z * f);

                }
            }

			//p2 - p3
           	 edge = Vector3.Sub(p3, p2);
			 baseToVertex = Vector3.Sub(p2, base);
			
            edgeSquaredLength = edge.lengthSquared();
            edgeDotVelocity = Vector3.Dot(edge, velocity);
            edgeDotBaseToVertex = Vector3.Dot(edge, baseToVertex);

            a = edgeSquaredLength * (-velocitySquaredLength) + edgeDotVelocity * edgeDotVelocity;
            b = edgeSquaredLength * (2.0 * Vector3.Dot(colData.velocity, baseToVertex)) - 2.0 * edgeDotVelocity * edgeDotBaseToVertex;
            c = edgeSquaredLength * (1.0 - baseToVertex.lengthSquared()) + edgeDotBaseToVertex * edgeDotBaseToVertex;
            lowestRoot = Coldet.getLowestRoot(a, b, c, t);
            if (lowestRoot.found) 
			{
                var f = (edgeDotVelocity * lowestRoot.root - edgeDotBaseToVertex) / edgeSquaredLength;

                if (f >= 0.0 && f <= 1.0) 
				{
                     found = true;
					t = lowestRoot.root;
                	collisionPoint.x = p2.x + (edge.x * f);
					collisionPoint.y = p2.y + (edge.y * f);
					collisionPoint.z = p2.z + (edge.z * f);
                }
            }

			//p3 -p1
           	 edge = Vector3.Sub(p1, p3);
			 baseToVertex = Vector3.Sub(p3, base);
		
            edgeSquaredLength = edge.lengthSquared();
            edgeDotVelocity = Vector3.Dot(edge, velocity);
            edgeDotBaseToVertex = Vector3.Dot(edge, baseToVertex);

            a = edgeSquaredLength * (-velocitySquaredLength) + edgeDotVelocity * edgeDotVelocity;
            b = edgeSquaredLength * (2.0 * Vector3.Dot(colData.velocity, baseToVertex)) - 2.0 * edgeDotVelocity * edgeDotBaseToVertex;
            c = edgeSquaredLength * (1.0 - baseToVertex.lengthSquared()) + edgeDotBaseToVertex * edgeDotBaseToVertex;

            lowestRoot = Coldet.getLowestRoot(a, b, c, t);
            if (lowestRoot.found) 
			{
                var f = (edgeDotVelocity * lowestRoot.root - edgeDotBaseToVertex) / edgeSquaredLength;

                if (f >= 0.0 && f <= 1.0) {
                    t = lowestRoot.root;
                    found = true;
                    collisionPoint.x = p3.x + (edge.x * f);
					collisionPoint.y = p3.y + (edge.y * f);
					collisionPoint.z = p3.z + (edge.z * f);
                }
            }
        }

        if (found)
		{
			// distance to collision is t
            var distToCollision:Float = t * colData.velocity.length();

            if (!colData.foundCollision || distToCollision < colData.nearestDistance) 
			{
           
				// does this triangle qualify for closest hit?
                colData.intersectionPoint.copyFrom(collisionPoint);
                colData.nearestDistance = distToCollision;                
                colData.foundCollision = true;
				++colData.triangleHits;
		        return  true;
             
            }
        }
		
		return false;
    }
	
//game institute

public static function CheckPointInTriangle(point:Vector3, a:Vector3, b:Vector3, c:Vector3):Bool
{
	// using barycentric method - this is supposedly the fastest method there is for this.
	// from http://www.blackpawn.com/texts/pointinpoly/default.html
	// Compute vectors
	
	var v0:Vector3 = Vector3.Sub(c, a);
	var v1:Vector3 = Vector3.Sub(b, a);
	var v2:Vector3 = Vector3.Sub(point, a);
	
	var  dot00:Float = Vector3.Dot(v0, v0);
	var  dot01:Float = Vector3.Dot(v0, v1);
	var  dot02:Float = Vector3.Dot(v0, v2);
	var  dot11:Float = Vector3.Dot(v1, v1);
	var  dot12:Float = Vector3.Dot(v1, v2);
	
   // Compute barycentric coordinates
	var invDenom:Float = 1 / (dot00 * dot11 - dot01 * dot01);
	var u:Float = (dot11 * dot02 - dot01 * dot12) * invDenom;
	var v:Float = (dot00 * dot12 - dot01 * dot02) * invDenom;

	// Check if point is in triangle
	return (u > 0) && (v > 0) && (u + v < 1);
	
	
}

public static function PointInTriangle(Point:Vector3, v1:Vector3, v2:Vector3, v3:Vector3, TriNormal:Vector3):Bool
{
	 var Edge:Vector3      = Vector3.zero;
	var Direction:Vector3  = Vector3.zero;
	var EdgeNormal:Vector3 = Vector3.zero;


	 Edge      = Vector3.Sub(v2 , v1);
	 Direction  = Vector3.Sub(v1 , Point);
	 EdgeNormal = Vector3.Cross(Edge, TriNormal);
	 if ( Vector3.Dot(Direction, EdgeNormal) < 0.0) return false;
	
	
	  
	
	 // Second edge
	 
     Edge      = Vector3.Sub(v3 , v2);
	 Direction = Vector3.Sub(v2 , Point);
	 EdgeNormal = Vector3.Cross(Edge, TriNormal);
	if ( Vector3.Dot(Direction, EdgeNormal) < 0.0) return false;

	
    
   // Third edge
     Edge      = Vector3.Sub(v1 , v3);
	 Direction = Vector3.Sub(v3 , Point);
	 EdgeNormal = Vector3.Cross(Edge, TriNormal);
     if ( Vector3.Dot(Direction, EdgeNormal) < 0.0) return false;

return true;

}

public static function SolveCollision(a:Float,b:Float,c:Float,t:Float ):LowestRoot
{
    var d, one_over_two_a, t0, t1, temp:Float = 0;
	  var result:LowestRoot = { root: 0, found: false };
		

    // Basic equation solving
    d = b*b - 4*a*c;

    // No root if d < 0
    if (d < 0.0) return result;

    // Setup for calculation
    d = Math.sqrt( d );
    one_over_two_a = 1.0 / (2.0 * a);

    // Calculate the two possible roots
    t0 = (-b - d) * one_over_two_a;
    t1 = (-b + d) * one_over_two_a;

    // Order the results
    if (t1 < t0) 
	{ 
		temp = t0; 
		t0 = t1; 
		t1 = temp; 
	}

    // Fail if both results are negative
    if (t1 < 0.0) return result;

    // Return the first positive root
    if (t0 < 0.0) 
	{
	t = t1; 
	}
	else 
	{
	t = t0;
	}
	
	result.root = t;
	result.found = true;

    // Solution found
    return result;

}

}