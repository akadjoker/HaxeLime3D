package com.gdx.collision;

import com.gdx.math.BoundingBox;
import com.gdx.math.Matrix;
import com.gdx.math.Plane;
import com.gdx.math.Triangle;
import com.gdx.math.Vector3;
import com.gdx.gl.Imidiatemode;
import com.gdx.scene3d.SceneManager;

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
typedef LowestRootResult = {
	root: Float,
	found: Bool
}
class Collider
{

	public var radius:Vector3;
	public var retry:Int;
	public var basePoint:Vector3;
	public var basePointWorld:Vector3;
	public var velocityWorld:Vector3;
	public var normalizedVelocity:Vector3;				// Vector2 or Vector3 or Matrix   ???
	public var velocityWorldLength:Float;
	public var velocity:Vector3;
	public var collisionFound:Bool;
	public var onFloor:Bool;
	public var epsilon:Float;
	public var nearestDistance:Float = 0;
	
	private	 var v1:Vector3 = Vector3.zero;
	private  var v2:Vector3 = Vector3.zero;
	private var v3:Vector3 = Vector3.zero;
	 
	public var intersectionPoint:Vector3;

	
	private var _collisionPoint:Vector3;
	private var _planeIntersectionPoint:Vector3;
	private var _tempVector:Vector3;
	private var _tempVector2:Vector3;
	private var _tempVector3:Vector3;
	private var _tempVector4:Vector3;
	private var _edge:Vector3;
	private var _baseToVertex:Vector3;
	
	public var trianglePlane:Plane;
	public var slidePlaneNormal:Vector3;
	public var destinationPoint:Vector3;
	public var displacementVector:Vector3;
	


	public var Falling:Bool;
	public var triangleHits:Int;
	public var Triangles:Array<Triangle>;

	
	private var _finalPosition:Vector3=Vector3.Zero();
	private var _scaledPosition:Vector3 = Vector3.Zero();
	private var _scaledVelocity:Vector3 = Vector3.Zero();
    private  var _oldPositionForCollisions:Vector3 = new Vector3(0, 0, 0);
    private  var _diffPositionForCollisions:Vector3 = new Vector3(0, 0, 0);
    private  var _newPositionForCollisions:Vector3 = new Vector3(0, 0, 0);
	private  var _previousPosition:Vector3 = Vector3.Zero();
    private  var _collisionVelocity:Vector3 = Vector3.Zero();
    private  var _newPosition:Vector3 = Vector3.Zero();
    private  var collisionsEpsilon:Float = 0.001;

	public function new()
	{
	


		
		
		this.radius = new Vector3(1, 1, 1);
        this.retry = 0;

		this.basePoint = Vector3.Zero();
		this.velocity = Vector3.Zero();
		intersectionPoint = Vector3.Zero();
		
        this.basePointWorld = Vector3.Zero();
        this.velocityWorld = Vector3.Zero();
        this.normalizedVelocity = Vector3.Zero();
        
        // Internals
        this._collisionPoint = Vector3.Zero();
        this._planeIntersectionPoint = Vector3.Zero();
        this._tempVector = Vector3.Zero();
        this._tempVector2 = Vector3.Zero();
        this._tempVector3 = Vector3.Zero();
        this._tempVector4 = Vector3.Zero();
        this._edge = Vector3.Zero();
        this._baseToVertex = Vector3.Zero();
        this.destinationPoint = Vector3.Zero();
        this.slidePlaneNormal = Vector3.Zero();
        this.displacementVector = Vector3.Zero();
		trianglePlane = new Plane(0, 0,0, 0);
	}

	public function collide2(m_pVertices:Array<Vector3>):Void
	{
		
					 
     var v1:Vector3 = Vector3.zero;
	 var v2:Vector3 = Vector3.zero;
	 var v3:Vector3 = Vector3.zero;
	 
    var sMultx:Float = 1.0 / radius.x;
	var sMulty:Float = 1.0 / radius.y;
	var sMultz:Float = 1.0 / radius.z;
	
	for (i in 0 ... Std.int(m_pVertices.length/3))
		

		{
			v1.x = m_pVertices[i * 3 + 0].x * sMultx ;
			v1.y = m_pVertices[i * 3 + 0].y * sMulty ;
			v1.z = m_pVertices[i * 3 + 0].z * sMultz ;
			
		
			v2.x = m_pVertices[i * 3 + 1].x * sMultx ;
			v2.y = m_pVertices[i * 3 + 1].y * sMulty ;
			v2.z = m_pVertices[i * 3 + 1].z * sMultz;
			
			
			v3.x = m_pVertices[i * 3 + 2].x * sMultx; 
			v3.y = m_pVertices[i * 3 + 2].y * sMulty ;
			v3.z = m_pVertices[i * 3 + 2].z * sMultz ;
			
		//	SceneManager.lines.drawFillTriangle(v1,v2,v3, 0, 1, 0, 1);
				
			testTriangle(v1, v2, v3);
		}
	}
	public function collide(Triangles:Array<Triangle>):Void
	{
		
     var v1:Vector3 = Vector3.zero;
	 var v2:Vector3 = Vector3.zero;
	 var v3:Vector3 = Vector3.zero;
	 
    var sMultx:Float = 1.0 / radius.x;
	var sMulty:Float = 1.0 / radius.y;
	var sMultz:Float = 1.0 / radius.z;
	
	
		
		for (i in 0 ... Triangles.length)
		{
			v1.x = Triangles[i].a.x * sMultx;
			v1.y = Triangles[i].a.y * sMulty;
			v1.z = Triangles[i].a.z * sMultz;
		
			v2.x = Triangles[i].b.x * sMultx;
			v2.y = Triangles[i].b.y * sMulty;
			v2.z = Triangles[i].b.z * sMultz;
			
			v3.x = Triangles[i].c.x * sMultx;
			v3.y = Triangles[i].c.y * sMulty;
			v3.z = Triangles[i].c.z * sMultz;
			
		
	
		//	SceneManager.lines.drawTriangle(Vector3.ScaleBy(v1, radius), Vector3.ScaleBy(v2, radius), Vector3.ScaleBy(v3, radius), 0, 1, 0, 1);
			 
			testTriangle(v1, v2, v3);
		}
	}
	public function initialize(source:Vector3, dir:Vector3, e:Float) 
	{
        this.velocity = dir;
        Vector3.NormalizeToRef(dir, this.normalizedVelocity);
        this.basePoint = source;

        source.multiplyToRef(this.radius, this.basePointWorld);
        dir.multiplyToRef(this.radius, this.velocityWorld);

        this.velocityWorldLength = this.velocityWorld.length();

        this.epsilon = e;
        this.collisionFound = false;

	
		
    }
	public function intersectBoxAASphere(boxMin:Vector3, boxMax:Vector3, sphereCenter:Vector3, sphereRadius:Float) {
        if (boxMin.x > sphereCenter.x + sphereRadius)
            return false;

        if (sphereCenter.x - sphereRadius > boxMax.x)
            return false;

        if (boxMin.y > sphereCenter.y + sphereRadius)
            return false;

        if (sphereCenter.y - sphereRadius > boxMax.y)
            return false;

        if (boxMin.z > sphereCenter.z + sphereRadius)
            return false;

        if (sphereCenter.z - sphereRadius > boxMax.z)
            return false;

        return true;
    }
	public function _canDoCollision(sphereCenter:Vector3, sphereRadius:Float, vecMin:Vector3, vecMax:Vector3):Bool {
        var distance:Float = Vector3.Distance(this.basePointWorld, sphereCenter);

        var max:Float = Math.max(this.radius.x, this.radius.y);
        max = Math.max(max, this.radius.z);

        if (distance > this.velocityWorldLength + max + sphereRadius) {
            return false;
        }

        if (!intersectBoxAASphere(vecMin, vecMax, this.basePointWorld, this.velocityWorldLength + max))
            return false;

        return true;
    }
	public function _checkPointInTriangle(point:Vector3, pa:Vector3, pb:Vector3, pc:Vector3, n:Vector3):Bool {
        pa.subtractToRef(point, this._tempVector);
        pb.subtractToRef(point, this._tempVector2);

        Vector3.CrossToRef(this._tempVector, this._tempVector2, this._tempVector4);
        var d:Float = Vector3.Dot(this._tempVector4, n);
        if (d < 0)
            return false;

        pc.subtractToRef(point, this._tempVector3);
        Vector3.CrossToRef(this._tempVector2, this._tempVector3, this._tempVector4);
        d = Vector3.Dot(this._tempVector4, n);
        if (d < 0)
            return false;

        Vector3.CrossToRef(this._tempVector3, this._tempVector, this._tempVector4);
        d = Vector3.Dot(this._tempVector4, n);
        return d >= 0;
    }
	
	
	
	public function getLowestRoot(a:Float, b:Float, c:Float, maxR:Float):LowestRootResult {
        var determinant = b * b - 4.0 * a * c;
        var result:LowestRootResult = { root: 0, found: false };

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
	
	
	public function testTriangle( p1:Vector3, p2:Vector3, p3:Vector3):Bool {
        var t0:Float = 0;
        var embeddedInPlane:Bool = false;
		

		
		//	SceneManager.lines.drawTriangle(Vector3.ScaleBy(p1, radius), Vector3.ScaleBy(p2, radius), Vector3.ScaleBy(p3, radius), 0, 1, 0, 1);
			
		
		//trianglePlane=Plane.FromPoints(p1, p2, p3);
		trianglePlane.copyFromPoints(p1, p2, p3);
      
       if ( !trianglePlane.isFrontFacingTo(this.normalizedVelocity, 0))
		{
	//	trace("back face");	
	     return false;
		}

        var signedDistToTrianglePlane = trianglePlane.signedDistanceTo(this.basePoint);
        var normalDotVelocity = Vector3.Dot(trianglePlane.normal, this.velocity);

        if (normalDotVelocity == 0) {
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

            if (t0 > 1.0 || t1 < 0.0)
			{
		           return false;
			}
            if (t0 < 0)
                t0 = 0;
            if (t0 > 1.0)
                t0 = 1.0;
        }

        this._collisionPoint.copyFromFloats(0, 0, 0);

        var found = false;
        var t = 1.0;

        if (!embeddedInPlane) 
		{
            this.basePoint.subtractToRef(trianglePlane.normal, this._planeIntersectionPoint);
            this.velocity.scaleToRef(t0, this._tempVector);
            this._planeIntersectionPoint.addInPlace(this._tempVector);

            if (this._checkPointInTriangle(this._planeIntersectionPoint, p1, p2, p3, trianglePlane.normal))
			{
                found = true;
                t = t0;
                this._collisionPoint.copyFrom(this._planeIntersectionPoint);
            }
        }

        if (!found) 
		{
            var velocitySquaredLength = this.velocity.lengthSquared();

            var a = velocitySquaredLength;

            this.basePoint.subtractToRef(p1, this._tempVector);
            var b = 2.0 * (Vector3.Dot(this.velocity, this._tempVector));
            var c = this._tempVector.lengthSquared() - 1.0;

            var lowestRoot:LowestRootResult = getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                t = lowestRoot.root;
                found = true;
                this._collisionPoint.copyFrom(p1);
            }

            this.basePoint.subtractToRef(p2, this._tempVector);
            b = 2.0 * (Vector3.Dot(this.velocity, this._tempVector));
            c = this._tempVector.lengthSquared() - 1.0;

            lowestRoot = getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                t = lowestRoot.root;
                found = true;
                this._collisionPoint.copyFrom(p2);
            }

            this.basePoint.subtractToRef(p3, this._tempVector);
            b = 2.0 * (Vector3.Dot(this.velocity, this._tempVector));
            c = this._tempVector.lengthSquared() - 1.0;

            lowestRoot = getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                t = lowestRoot.root;
                found = true;
                this._collisionPoint.copyFrom(p3);
            }

            p2.subtractToRef(p1, this._edge);
            p1.subtractToRef(this.basePoint, this._baseToVertex);
            var edgeSquaredLength = this._edge.lengthSquared();
            var edgeDotVelocity = Vector3.Dot(this._edge, this.velocity);
            var edgeDotBaseToVertex = Vector3.Dot(this._edge, this._baseToVertex);

            a = edgeSquaredLength * (-velocitySquaredLength) + edgeDotVelocity * edgeDotVelocity;
            b = edgeSquaredLength * (2.0 * Vector3.Dot(this.velocity, this._baseToVertex)) - 2.0 * edgeDotVelocity * edgeDotBaseToVertex;
            c = edgeSquaredLength * (1.0 - this._baseToVertex.lengthSquared()) + edgeDotBaseToVertex * edgeDotBaseToVertex;

            lowestRoot = getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                var f = (edgeDotVelocity * lowestRoot.root - edgeDotBaseToVertex) / edgeSquaredLength;

                if (f >= 0.0 && f <= 1.0) {
                    t = lowestRoot.root;
                    found = true;
                    this._edge.scaleInPlace(f);
                    p1.addToRef(this._edge, this._collisionPoint);
                }
            }

            p3.subtractToRef(p2, this._edge);
            p2.subtractToRef(this.basePoint, this._baseToVertex);
            edgeSquaredLength = this._edge.lengthSquared();
            edgeDotVelocity = Vector3.Dot(this._edge, this.velocity);
            edgeDotBaseToVertex = Vector3.Dot(this._edge, this._baseToVertex);

            a = edgeSquaredLength * (-velocitySquaredLength) + edgeDotVelocity * edgeDotVelocity;
            b = edgeSquaredLength * (2.0 * Vector3.Dot(this.velocity, this._baseToVertex)) - 2.0 * edgeDotVelocity * edgeDotBaseToVertex;
            c = edgeSquaredLength * (1.0 - this._baseToVertex.lengthSquared()) + edgeDotBaseToVertex * edgeDotBaseToVertex;
            lowestRoot = getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                var f = (edgeDotVelocity * lowestRoot.root - edgeDotBaseToVertex) / edgeSquaredLength;

                if (f >= 0.0 && f <= 1.0) {
                    t = lowestRoot.root;
                    found = true;
                    this._edge.scaleInPlace(f);
                    p2.addToRef(this._edge, this._collisionPoint);
                }
            }

            p1.subtractToRef(p3, this._edge);
            p3.subtractToRef(this.basePoint, this._baseToVertex);
            edgeSquaredLength = this._edge.lengthSquared();
            edgeDotVelocity = Vector3.Dot(this._edge, this.velocity);
            edgeDotBaseToVertex = Vector3.Dot(this._edge, this._baseToVertex);

            a = edgeSquaredLength * (-velocitySquaredLength) + edgeDotVelocity * edgeDotVelocity;
            b = edgeSquaredLength * (2.0 * Vector3.Dot(this.velocity, this._baseToVertex)) - 2.0 * edgeDotVelocity * edgeDotBaseToVertex;
            c = edgeSquaredLength * (1.0 - this._baseToVertex.lengthSquared()) + edgeDotBaseToVertex * edgeDotBaseToVertex;

            lowestRoot = getLowestRoot(a, b, c, t);
            if (lowestRoot.found) {
                var f = (edgeDotVelocity * lowestRoot.root - edgeDotBaseToVertex) / edgeSquaredLength;

                if (f >= 0.0 && f <= 1.0) {
                    t = lowestRoot.root;
                    found = true;
                    this._edge.scaleInPlace(f);
                    p3.addToRef(this._edge, this._collisionPoint);
                }
            }
        }
         
        if (found)
		{
			
            var distToCollision:Float = t * this.velocity.length();

            if (!this.collisionFound || distToCollision < this.nearestDistance) 
			{
                if (this.intersectionPoint == null) 
				{
                    this.intersectionPoint = this._collisionPoint.clone();
                } else 
				{
                    this.intersectionPoint.copyFrom(this._collisionPoint);
                }
                this.nearestDistance = distToCollision;                
                this.collisionFound = true;
				++triangleHits;
			//	trace("colide:" + trianglePlane.normal.toString());
			//   SceneManager.lines.drawFillTriangle(Vector3.Scale(p1,radius),Vector3.Scale(p2,radius),Vector3.Scale(p3,radius),0,1,0, 1);
				//lines.drawFullTriangle(p1,p2,p3,0,1,0, 1);
				
				
			    return  true;
             
            }
        }
		
		return false;
    }
	
	
	inline private function getResponse(pos:Vector3, vel:Vector3) 
	{
        pos.addToRef(vel, this.destinationPoint);
        vel.scaleInPlace((this.nearestDistance / vel.length()));
		
        this.basePoint.addToRef(vel, pos);
        pos.subtractToRef(this.intersectionPoint, this.slidePlaneNormal);
        this.slidePlaneNormal.normalize();
	    this.slidePlaneNormal.scaleToRef(this.epsilon, this.displacementVector);
        pos.addInPlace(this.displacementVector);
        this.intersectionPoint.addInPlace(this.displacementVector);
        this.slidePlaneNormal.scaleInPlace(Plane.SignedDistanceToPlaneFromPositionAndNormal(this.intersectionPoint, this.slidePlaneNormal, this.destinationPoint));
        this.destinationPoint.subtractInPlace(this.slidePlaneNormal);
	    this.destinationPoint.subtractToRef(this.intersectionPoint, vel);
		
    }
	//********************************************************RESPONSE***************************************************
    inline public function moveAndStop(position:Vector3,ellipsoid:Vector3) :Void
	{
	           radius = ellipsoid;
               position.subtractToRef(this._previousPosition, this._collisionVelocity);
               traceBoxNewPosition(this._previousPosition, this._collisionVelocity,  3, this._newPosition);
                if (!this._newPosition.equalsWithEpsilon( position))
				{
                     position.copyFrom(this._previousPosition);
				}
		
    }
	inline public function moveAndSlide(position:Vector3,velocity:Vector3,ellipsoid:Vector3,ellipsoidOffset:Vector3) 
	{
	       var globalPosition:Vector3 = position;
            globalPosition.subtractFromFloatsToRef(0, 0, 0, this._oldPositionForCollisions);
            this._oldPositionForCollisions.addInPlace(ellipsoidOffset);
            radius.copyFrom(ellipsoid);
            traceBoxNewPosition(this._oldPositionForCollisions, velocity,  3, this._newPositionForCollisions);
            this._newPositionForCollisions.subtractToRef(this._oldPositionForCollisions, this._diffPositionForCollisions);

            if (this._diffPositionForCollisions.length() > collisionsEpsilon)
			{
                position.addInPlace(this._diffPositionForCollisions);
			}
    }
	
	private function traceBoxNewPosition( position:Vector3, velocity:Vector3,  maximumRetry:Int, finalPosition:Vector3 )
	 {
		position.divideToRef(radius, this._scaledPosition);
        velocity.divideToRef(radius, this._scaledVelocity);
        retry = 0;
    	triangleHits = 0;
		Falling = false;
        collideWithWorld(this._scaledPosition, this._scaledVelocity,  maximumRetry, finalPosition);
	    finalPosition.multiplyInPlace(radius);
	    Falling = (triangleHits == 0);
	}
	private function collideWithWorld(position:Vector3, velocity:Vector3,  maximumRetry:Int, finalPosition:Vector3)
	{
		   var closeDistance = collisionsEpsilon * 10.0;
		
		if (retry >= maximumRetry) 
		{
			finalPosition.copyFrom(position);
			return;
		}
		
		initialize(position, velocity, closeDistance);
        collide(Triangles);
		
		
		if (!collisionFound) 
		{
			position.addToRef(velocity, finalPosition);
		
			return;
		}
		
		if (velocity.x != 0 || velocity.y != 0 || velocity.z != 0) {
			getResponse(position, velocity);
		}
		
		if (velocity.length() <= closeDistance) {
			finalPosition.copyFrom(position);
			return;
		}
		
		retry++;
		collideWithWorld(position, velocity,  maximumRetry, finalPosition);
	}
	
}
