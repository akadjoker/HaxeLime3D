package com.gdx.math;

import com.gdx.scene3d.cameras.Camera;
import com.gdx.math.Rectangle;
import lime.utils.Float32Array;
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

 class Matrix {
	static var tmp = new Matrix();
	private static var _tempQuaternion:Quaternion = new Quaternion();
	private static var _xAxis:Vector3 = Vector3.Zero();
	private static var _yAxis:Vector3 = Vector3.Zero();
	private static var _zAxis:Vector3 = Vector3.Zero();

	public var m11 : Float;//0
	public var m12 : Float;//1
	public var m13 : Float;//2
	public var m14 : Float;//3
	public var m21 : Float;//4
	public var m22 : Float;//5
	public var m23 : Float;//6
	public var m24 : Float;//7
	public var m31 : Float;//8
	public var m32 : Float;//9
	public var m33 : Float;//10
	public var m34 : Float;//11
	public var m41 : Float;//12
	public var m42 : Float;//13
	public var m43 : Float;//14
	public var m44 : Float;//15

		
	
	
	public function new() {
		
	
	
	}
	inline public  function set(m11:Float, m12:Float, m13:Float, m14:Float,
		m21:Float, m22:Float, m23:Float, m24:Float,
		m31:Float, m32:Float, m33:Float, m34:Float,
		m41:Float, m42:Float, m43:Float, m44:Float) {
			
		

        this.m11 = m11;
        this.m12 = m12;
        this.m13 = m13;
        this.m14 = m14;
		
        this.m21 = m21;
        this.m22 = m22;
        this.m23 = m23;
        this.m24 = m24;
		
        this.m31 = m31;
        this.m32 = m32;
        this.m33 = m33;
        this.m34 = m34;
		
        this.m41 = m41;
        this.m42 = m42;
        this.m43 = m43;
        this.m44 = m44;
	
	}
	
	public function Forward():Vector3
	{
		return new Vector3(-this.m31, -this.m32, -this.m33);
	}
	
	public function Down():Vector3
	{
		return new Vector3(-this.m21, -this.m22, -this.m23);
	}
	public function Backward():Vector3
	{
		return new Vector3(this.m31, this.m32, this.m33);
	}
	public function initRotateX( a : Float ) {
		var cos = Math.cos(a);
		var sin = Math.sin(a);
		m11 = 1.0; m12 = 0.0; m13 = 0.0; m14 = 0.0;
		m21 = 0.0; m22 = cos; m23 = sin; m24 = 0.0;
		m31 = 0.0; m32 = -sin; m33 = cos; m34 = 0.0;
		m41 = 0.0; m42 = 0.0; m43 = 0.0; m44 = 1.0;
	}

	public function initRotateY( a : Float ) {
		var cos = Math.cos(a);
		var sin = Math.sin(a);
		m11 = cos; m12 = 0.0; m13 = -sin; m14 = 0.0;
		m21 = 0.0; m22 = 1.0; m23 = 0.0; m24 = 0.0;
		m31 = sin; m32 = 0.0; m33 = cos; m34 = 0.0;
		m41 = 0.0; m42 = 0.0; m43 = 0.0; m44 = 1.0;
	}

	public function initRotateZ( a : Float ) {
		var cos = Math.cos(a);
		var sin = Math.sin(a);
		m11 = cos; m12 = sin; m13 = 0.0; m14 = 0.0;
		m21 = -sin; m22 = cos; m23 = 0.0; m24 = 0.0;
		m31 = 0.0; m32 = 0.0; m33 = 1.0; m34 = 0.0;
		m41 = 0.0; m42 = 0.0; m43 = 0.0; m44 = 1.0;
	}

	public function initTranslate( x = 0., y = 0., z = 0. ) {
		m11 = 1.0; m12 = 0.0; m13 = 0.0; m14 = 0.0;
		m21 = 0.0; m22 = 1.0; m23 = 0.0; m24 = 0.0;
		m31 = 0.0; m32 = 0.0; m33 = 1.0; m34 = 0.0;
		m41 = x; m42 = y; m43 = z; m44 = 1.0;
	}

	public function initScale( x = 1., y = 1., z = 1. ) {
		m11 = x; m12 = 0.0; m13 = 0.0; m14 = 0.0;
		m21 = 0.0; m22 = y; m23 = 0.0; m24 = 0.0;
		m31 = 0.0; m32 = 0.0; m33 = z; m34 = 0.0;
		m41 = 0.0; m42 = 0.0; m43 = 0.0; m44 = 1.0;
	}

	public function initRotateAxis( axis : Vector3, angle : Float ) {
		var cos = Math.cos(angle), sin = Math.sin(angle);
		var cos1 = 1 - cos;
		var x = -axis.x, y = -axis.y, z = -axis.z;
		var xx = x * x, yy = y * y, zz = z * z;
		var len = Math.invSqrt(xx + yy + zz);
		x *= len;
		y *= len;
		z *= len;
		var xcos1 = x * cos1, zcos1 = z * cos1;
		m11 = cos + x * xcos1;
		m12 = y * xcos1 - z * sin;
		m13 = x * zcos1 + y * sin;
		m14 = 0.;
		m21 = y * xcos1 + z * sin;
		m22 = cos + y * y * cos1;
		m23 = y * zcos1 - x * sin;
		m24 = 0.;
		m31 = x * zcos1 - y * sin;
		m32 = y * zcos1 + x * sin;
		m33 = cos + z * zcos1;
		m34 = 0.;
		m41 = 0.; m42 = 0.; m43 = 0.; m44 = 1.;
	}

	public function initRotate( x : Float, y : Float, z : Float ) {
		var cx = Math.cos(x);
		var sx = Math.sin(x);
		var cy = Math.cos(y);
		var sy = Math.sin(y);
		var cz = Math.cos(z);
		var sz = Math.sin(z);
		var cxsy = cx * sy;
		var sxsy = sx * sy;
		m11 = cy * cz;
		m12 = cy * sz;
		m13 = -sy;
		m14 = 0;
		m21 = sxsy * cz - cx * sz;
		m22 = sxsy * sz + cx * cz;
		m23 = sx * cy;
		m24 = 0;
		m31 = cxsy * cz + sx * sz;
		m32 = cxsy * sz - sx * cz;
		m33 = cx * cy;
		m34 = 0;
		m41 = 0;
		m42 = 0;
		m43 = 0;
		m44 = 1;
	}

	
public function prependTranslate( x = 0., y = 0., z = 0. ) {
		var vx = m11 * x + m21 * y + m31 * z + m41;
		var vy = m12 * x + m22 * y + m32 * z + m42;
		var vz = m13 * x + m23 * y + m33 * z + m43;
		var vw = m14 * x + m24 * y + m34 * z + m44;
		m41 = vx;
		m42 = vy;
		m43 = vz;
		m44 = vw;
	}

	public function prependRotate( x, y, z ) {
		var tmp = tmp;
		tmp.initRotate(x,y,z);
		multiplyBy2(tmp, this);
	}

	public function prependRotateAxis( axis, angle ) {
		var tmp = tmp;
		tmp.initRotateAxis(axis, angle);
		multiplyBy2(tmp, this);
	}

	public function prependScale( sx = 1., sy = 1., sz = 1. ) {
		var tmp = tmp;
		tmp.initScale(sx,sy,sz);
		multiplyBy2(tmp, this);
	}
	
	public function multiply3x4( a : Matrix, b : Matrix ) {
		multiply3x4inline(a, b);
	}

	public inline function getScale():Vector3 {
		var v = new Vector3();
		v.x = Math.sqrt(m11 * m11 + m12 * m12 + m13 * m13);
		v.y = Math.sqrt(m21 * m21 + m22 * m22 + m23 * m23);
		v.z = Math.sqrt(m31 * m31 + m32 * m32 + m33 * m33);
		if( determinant() < 0 ) {
			v.x *= -1;
			v.y *= -1;
			v.z *= -1;
		}
		return v;
	}
	public inline function getPosition():Vector3 
	{
		var v = new Vector3();
		v.x = this.m14;
		v.y = this.m24;
		v.z = this.m34; 
		
		return v;
	}
	public inline function multiply3x4inline( a : Matrix, b : Matrix ) {
		var m11 = a.m11; var m12 = a.m12; var m13 = a.m13;
		var m21 = a.m21; var m22 = a.m22; var m23 = a.m23;
		var a31 = a.m31; var a32 = a.m32; var a33 = a.m33;
		var a41 = a.m41; var a42 = a.m42; var a43 = a.m43;
		var b11 = b.m11; var b12 = b.m12; var b13 = b.m13;
		var b21 = b.m21; var b22 = b.m22; var b23 = b.m23;
		var b31 = b.m31; var b32 = b.m32; var b33 = b.m33;
		var b41 = b.m41; var b42 = b.m42; var b43 = b.m43;

		m11 = m11 * b11 + m12 * b21 + m13 * b31;
		m12 = m11 * b12 + m12 * b22 + m13 * b32;
		m13 = m11 * b13 + m12 * b23 + m13 * b33;
		m14 = 0;

		m21 = m21 * b11 + m22 * b21 + m23 * b31;
		m22 = m21 * b12 + m22 * b22 + m23 * b32;
		m23 = m21 * b13 + m22 * b23 + m23 * b33;
		m24 = 0;

		m31 = a31 * b11 + a32 * b21 + a33 * b31;
		m32 = a31 * b12 + a32 * b22 + a33 * b32;
		m33 = a31 * b13 + a32 * b23 + a33 * b33;
		m34 = 0;

		m41 = a41 * b11 + a42 * b21 + a43 * b31 + b41;
		m42 = a41 * b12 + a42 * b22 + a43 * b32 + b42;
		m43 = a41 * b13 + a42 * b23 + a43 * b33 + b43;
		m44 = 1;
	}

	public inline function multiplyBy2( a : Matrix, b : Matrix ) 
	{
		
		var a11 = a.m11; var a12 = a.m12; var a13 = a.m13; var a14 = a.m14;
		var a21 = a.m21; var a22 = a.m22; var a23 = a.m23; var a24 = a.m24;
		var a31 = a.m31; var a32 = a.m32; var a33 = a.m33; var a34 = a.m34;
		var a41 = a.m41; var a42 = a.m42; var a43 = a.m43; var a44 = a.m44;
		var b11 = b.m11; var b12 = b.m12; var b13 = b.m13; var b14 = b.m14;
		var b21 = b.m21; var b22 = b.m22; var b23 = b.m23; var b24 = b.m24;
		var b31 = b.m31; var b32 = b.m32; var b33 = b.m33; var b34 = b.m34;
		var b41 = b.m41; var b42 = b.m42; var b43 = b.m43; var b44 = b.m44;

		m11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
		m12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
		m13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
		m14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

		m21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
		m22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
		m23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
		m24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

		m31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
		m32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
		m33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
		m34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

		m41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
		m42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
		m43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
		m44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;
	}

	public function multiplyValue( v : Float ) {
		m11 *= v;
		m12 *= v;
		m13 *= v;
		m14 *= v;
		m21 *= v;
		m22 *= v;
		m23 *= v;
		m24 *= v;
		m31 *= v;
		m32 *= v;
		m33 *= v;
		m34 *= v;
		m41 *= v;
		m42 *= v;
		m43 *= v;
		m44 *= v;
	}

	public function getRotationDegrees():Vector3
{
	var Y = -Math.asin(this.m13);
	var C = Math.cos(Y);
	Y *= Util.Rad2Deg;

	var rotx;
	var roty;
	var X;
	var Z;

	if (Math.abs(C)> 0.00000001)
	{
		var invC = (1.0/C);
		rotx = this.m33 * invC;
		roty = this.m23 * invC;
		X = Math.atan2( roty, rotx ) * Util.Rad2Deg;
		rotx = this.m11 * invC;
		roty = this.m12 * invC;
		Z = Math.atan2( roty, rotx ) *  Util.Rad2Deg;
	}
	else
	{
		X = 0.0;
		rotx = this.m22;
		roty = -this.m21;
		Z = Math.atan2( roty, rotx ) *  Util.Rad2Deg;
	}

	// fix values that get below zero
	// before it would set (!) values to 360
	// that where above 360:
	if (X < 0.0) X += 360.0;
	if (Y < 0.0) Y += 360.0;
	if (Z < 0.0) Z += 360.0;

	return new Vector3(X,Y,Z);
}

	
	public function getFloats() {
		return [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44];
	}

	public function toString() {
		return "MAT=[\n" +
			"  [ " + Math.fmt(m11) + ", " + Math.fmt(m12) + ", " + Math.fmt(m13) + ", " + Math.fmt(m14) + " ]\n" +
			"  [ " + Math.fmt(m21) + ", " + Math.fmt(m22) + ", " + Math.fmt(m23) + ", " + Math.fmt(m24) + " ]\n" +
			"  [ " + Math.fmt(m31) + ", " + Math.fmt(m32) + ", " + Math.fmt(m33) + ", " + Math.fmt(m34) + " ]\n" +
			"  [ " + Math.fmt(m41) + ", " + Math.fmt(m42) + ", " + Math.fmt(m43) + ", " + Math.fmt(m44) + " ]\n" +
		"]";
	}

	// Properties
	public function isIdentity():Bool {
		if (this.m11 != 1.0 || this.m22 != 1.0 || this.m33 != 1.0 || this.m44 != 1.0)
			return false;
			
		if (this.m12 != 0.0 || this.m13 != 0.0 || this.m14 != 0.0 ||
			this.m21 != 0.0 || this.m23 != 0.0 || this.m24 != 0.0 ||
			this.m31 != 0.0 || this.m32 != 0.0 || this.m34 != 0.0 ||
			this.m41 != 0.0 || this.m42 != 0.0 || this.m43 != 0.0)
			return false;
			
		return true;
	}

	inline public function determinant():Float {
		var temp1 = (this.m33 * this.m44) - (this.m34 * this.m43);
		var temp2 = (this.m32 * this.m44) - (this.m34 * this.m42);
		var temp3 = (this.m32 * this.m43) - (this.m33 * this.m42);
		var temp4 = (this.m31 * this.m44) - (this.m34 * this.m41);
		var temp5 = (this.m31 * this.m43) - (this.m33 * this.m41);
		var temp6 = (this.m31 * this.m42) - (this.m32 * this.m41);
		
		return ((((this.m11 * (((this.m22 * temp1) - (this.m23 * temp2)) + (this.m24 * temp3))) - (this.m12 * (((this.m21 * temp1) -
			(this.m23 * temp4)) + (this.m24 * temp5)))) + (this.m13 * (((this.m21 * temp2) - (this.m22 * temp4)) + (this.m24 * temp6)))) -
			(this.m14 * (((this.m21 * temp3) - (this.m22 * temp5)) + (this.m23 * temp6))));
	}

	// Methods
	public function toArray():  Float32Array  
	{
		return new Float32Array(getFloats());
	}

	public function asArray():  Float32Array
	{
		return this.toArray();
	}

	public function invert():Matrix 
	{
		this.invertToRef(this);
		return this;
	}

	inline public function invertToRef(other:Matrix) {
		var l1 = this.m11;
		var l2 = this.m12;
		var l3 = this.m13;
		var l4 = this.m14;
		var l5 = this.m21;
		var l6 = this.m22;
		var l7 = this.m23;
		var l8 = this.m24;
		var l9 = this.m31;
		var l10 = this.m32;
		var l11 = this.m33;
		var l12 = this.m34;
		var l13 = this.m41;
		var l14 = this.m42;
		var l15 = this.m43;
		var l16 = this.m44;
		var l17 = (l11 * l16) - (l12 * l15);
		var l18 = (l10 * l16) - (l12 * l14);
		var l19 = (l10 * l15) - (l11 * l14);
		var l20 = (l9 * l16) - (l12 * l13);
		var l21 = (l9 * l15) - (l11 * l13);
		var l22 = (l9 * l14) - (l10 * l13);
		var l23 = ((l6 * l17) - (l7 * l18)) + (l8 * l19);
		var l24 = -(((l5 * l17) - (l7 * l20)) + (l8 * l21));
		var l25 = ((l5 * l18) - (l6 * l20)) + (l8 * l22);
		var l26 = -(((l5 * l19) - (l6 * l21)) + (l7 * l22));
		var l27 = 1.0 / ((((l1 * l23) + (l2 * l24)) + (l3 * l25)) + (l4 * l26));
		var l28 = (l7 * l16) - (l8 * l15);
		var l29 = (l6 * l16) - (l8 * l14);
		var l30 = (l6 * l15) - (l7 * l14);
		var l31 = (l5 * l16) - (l8 * l13);
		var l32 = (l5 * l15) - (l7 * l13);
		var l33 = (l5 * l14) - (l6 * l13);
		var l34 = (l7 * l12) - (l8 * l11);
		var l35 = (l6 * l12) - (l8 * l10);
		var l36 = (l6 * l11) - (l7 * l10);
		var l37 = (l5 * l12) - (l8 * l9);
		var l38 = (l5 * l11) - (l7 * l9);
		var l39 = (l5 * l10) - (l6 * l9);
		
		other.m11 = l23 * l27;
		other.m21 = l24 * l27;
		other.m31 = l25 * l27;
		other.m41 = l26 * l27;
		other.m12 = -(((l2 * l17) - (l3 * l18)) + (l4 * l19)) * l27;
		other.m22 = (((l1 * l17) - (l3 * l20)) + (l4 * l21)) * l27;
		other.m32 = -(((l1 * l18) - (l2 * l20)) + (l4 * l22)) * l27;
		other.m42 = (((l1 * l19) - (l2 * l21)) + (l3 * l22)) * l27;
		other.m13 = (((l2 * l28) - (l3 * l29)) + (l4 * l30)) * l27;
		other.m23 = -(((l1 * l28) - (l3 * l31)) + (l4 * l32)) * l27;
		other.m33 = (((l1 * l29) - (l2 * l31)) + (l4 * l33)) * l27;
		other.m43 = -(((l1 * l30) - (l2 * l32)) + (l3 * l33)) * l27;
		other.m14 = -(((l2 * l34) - (l3 * l35)) + (l4 * l36)) * l27;
		other.m24 = (((l1 * l34) - (l3 * l37)) + (l4 * l38)) * l27;
		other.m34 = -(((l1 * l35) - (l2 * l37)) + (l4 * l39)) * l27;
		other.m44 = (((l1 * l36) - (l2 * l38)) + (l3 * l39)) * l27;
	}

	inline public function setTranslation(vector3:Vector3) {
		this.m41 = vector3.x;
		this.m42 = vector3.y;
		this.m43 = vector3.z;
	}

	
	inline public function multiply(other:Matrix):Matrix
	{
		var result = new Matrix();

	
		result.m11 = this.m11 * other.m11 + this.m12 * other.m21 + this.m13 * other.m31 + this.m14 * other.m41;
		result.m12 = this.m11 * other.m12 + this.m12 * other.m22 + this.m13 * other.m32 + this.m14 * other.m42;
		result.m13 = this.m11 * other.m13 + this.m12 * other.m23 + this.m13 * other.m33 + this.m14 * other.m43;
		result.m14 = this.m11 * other.m14 + this.m12 * other.m24 + this.m13 * other.m34 + this.m14 * other.m44;
		
		result.m21 = this.m21 * other.m11 + this.m22 * other.m21 + this.m23 * other.m31 + this.m24 * other.m41;
		result.m22 = this.m21 * other.m12 + this.m22 * other.m22 + this.m23 * other.m32 + this.m24 * other.m42;
		result.m23 = this.m21 * other.m13 + this.m22 * other.m23 + this.m23 * other.m33 + this.m24 * other.m43;
		result.m24 = this.m21 * other.m14 + this.m22 * other.m24 + this.m23 * other.m34 + this.m24 * other.m44;
		
		result.m31 = this.m31 * other.m11 + this.m32 * other.m21 + this.m33 * other.m31 + this.m34 * other.m41;
		result.m32 = this.m31 * other.m12 + this.m32 * other.m22 + this.m33 * other.m32 + this.m34 * other.m42;
		result.m33 = this.m31 * other.m13 + this.m32 * other.m23 + this.m33 * other.m33 + this.m34 * other.m43;
		result.m34 = this.m31 * other.m14 + this.m32 * other.m24 + this.m33 * other.m34 + this.m34 * other.m44;
		
		result.m41 = this.m41 * other.m11 + this.m42 * other.m21 + this.m43 * other.m31 + this.m44 * other.m41;
		result.m42 = this.m41 * other.m12 + this.m42 * other.m22 + this.m43 * other.m32 + this.m44 * other.m42;
		result.m43= this.m41 * other.m13 + this.m42 * other.m23 + this.m43 * other.m33 + this.m44 * other.m43;
		result.m44 = this.m41 * other.m14 + this.m42 * other.m24 + this.m43 * other.m34 + this.m44 * other.m44;

		
		return result;
	}

	inline public function copyFrom(m:Matrix) 
	{
		m11 = m.m11; m12 = m.m12; m13 = m.m13; m14 = m.m14;
		m21 = m.m21; m22 = m.m22; m23 = m.m23; m24 = m.m24;
		m31 = m.m31; m32 = m.m32; m33 = m.m33; m34 = m.m34;
		m41 = m.m41; m42 = m.m42; m43 = m.m43; m44 = m.m44;
	}

	inline public function copyToArray(array:  Array<Float> ) 
	{
		array[0] = m11;
		array[1] = m12;
		array[2] = m13;
		array[3] = m14;
				
array[4] = m21;
array[5] = m22;
array[6] = m23;
array[7] = m24;
		
array[8] = m31;
array[9] = m32;
array[10] = m33;
array[11] = m34;

array[12] = m41;
array[13] = m42;
array[14] = m43;
array[15] = m44;
	
	}

	public function multiplyToRef(other:Matrix, result:Matrix)
	{
		result.m11 = this.m11 * other.m11 + this.m12 * other.m21 + this.m13 * other.m31 + this.m14 * other.m41;
		result.m12 = this.m11 * other.m12 + this.m12 * other.m22 + this.m13 * other.m32 + this.m14 * other.m42;
		result.m13 = this.m11 * other.m13 + this.m12 * other.m23 + this.m13 * other.m33 + this.m14 * other.m43;
		result.m14 = this.m11 * other.m14 + this.m12 * other.m24 + this.m13 * other.m34 + this.m14 * other.m44;
		
		result.m21 = this.m21 * other.m11 + this.m22 * other.m21 + this.m23 * other.m31 + this.m24 * other.m41;
		result.m22 = this.m21 * other.m12 + this.m22 * other.m22 + this.m23 * other.m32 + this.m24 * other.m42;
		result.m23 = this.m21 * other.m13 + this.m22 * other.m23 + this.m23 * other.m33 + this.m24 * other.m43;
		result.m24 = this.m21 * other.m14 + this.m22 * other.m24 + this.m23 * other.m34 + this.m24 * other.m44;
		
		result.m31 = this.m31 * other.m11 + this.m32 * other.m21 + this.m33 * other.m31 + this.m34 * other.m41;
		result.m32 = this.m31 * other.m12 + this.m32 * other.m22 + this.m33 * other.m32 + this.m34 * other.m42;
		result.m33 = this.m31 * other.m13 + this.m32 * other.m23 + this.m33 * other.m33 + this.m34 * other.m43;
		result.m34 = this.m31 * other.m14 + this.m32 * other.m24 + this.m33 * other.m34 + this.m34 * other.m44;
		
		result.m41 = this.m41 * other.m11 + this.m42 * other.m21 + this.m43 * other.m31 + this.m44 * other.m41;
		result.m42 = this.m41 * other.m12 + this.m42 * other.m22 + this.m43 * other.m32 + this.m44 * other.m42;
		result.m43= this.m41 * other.m13 + this.m42 * other.m23 + this.m43 * other.m33 + this.m44 * other.m43;
		result.m44 = this.m41 * other.m14 + this.m42 * other.m24 + this.m43 * other.m34 + this.m44 * other.m44;

	}

	inline public function multiplyToArray(other:Matrix, result:  Float32Array, offset:Int) 
	{		
		result[offset] = this.m11 * other.m11 + this.m12 * other.m21 + this.m13 * other.m31 + this.m14 * other.m41;
		result[offset + 1] = this.m11 * other.m12 + this.m12 * other.m22 + this.m13 * other.m32 + this.m14 * other.m42;
		result[offset + 2] = this.m11 * other.m13 + this.m12 * other.m23 + this.m13 * other.m33 + this.m14 * other.m43;
		result[offset + 3] = this.m11 * other.m14 + this.m12 * other.m24 + this.m13 * other.m34 + this.m14 * other.m44;
		
		result[offset + 4] = this.m21 * other.m11 + this.m22 * other.m21 + this.m23 * other.m31 + this.m24 * other.m41;
		result[offset + 5] = this.m21 * other.m12 + this.m22 * other.m22 + this.m23 * other.m32 + this.m24 * other.m42;
		result[offset + 6] = this.m21 * other.m13 + this.m22 * other.m23 + this.m23 * other.m33 + this.m24 * other.m43;
		result[offset + 7] = this.m21 * other.m14 + this.m22 * other.m24 + this.m23 * other.m34 + this.m24 * other.m44;
		
		result[offset + 8] = this.m31 * other.m11 + this.m32 * other.m21 + this.m33 * other.m31 + this.m34 * other.m41;
		result[offset + 9] = this.m31 * other.m12 + this.m32 * other.m22 + this.m33 * other.m32 + this.m34 * other.m42;
		result[offset + 10] = this.m31 * other.m13 + this.m32 * other.m23 + this.m33 * other.m33 + this.m34 * other.m43;
		result[offset + 11] = this.m31 * other.m14 + this.m32 * other.m24 + this.m33 * other.m34 + this.m34 * other.m44;
		
		result[offset + 12] = this.m41 * other.m11 + this.m42 * other.m21 + this.m43 * other.m31 + this.m44 * other.m41;
		result[offset + 13] = this.m41 * other.m12 + this.m42 * other.m22 + this.m43 * other.m32 + this.m44 * other.m42;
		result[offset + 14] = this.m41 * other.m13 + this.m42 * other.m23 + this.m43 * other.m33 + this.m44 * other.m43;
		result[offset + 15] = this.m41 * other.m14 + this.m42 * other.m24 + this.m43 * other.m34 + this.m44 * other.m44;
	}
	

	inline public function equals(value:Matrix):Bool {
		return value != null &&
			(this.m11 == value.m11 && this.m12 == value.m12 && this.m13 == value.m13 && this.m14 == value.m14 &&
			this.m21 == value.m21 && this.m22 == value.m22 && this.m23 == value.m23 && this.m24 == value.m24 &&
			this.m31 == value.m31 && this.m32 == value.m32 && this.m33 == value.m33 && this.m34 == value.m34 &&
			this.m41 == value.m41 && this.m42 == value.m42 && this.m43 == value.m43 && this.m44 == value.m44);
	}

	inline public function clone():Matrix {
		return Matrix.FromValues(this.m11, this.m12, this.m13, this.m14,
			this.m21, this.m22, this.m23, this.m24,
			this.m31, this.m32, this.m33, this.m34,
			this.m41, this.m42, this.m43, this.m44);
	}
	
	public function decompose(scale:Vector3, rotation:Quaternion, translation:Vector3):Bool {
		translation.x = this.m41;
		translation.y = this.m42;
		translation.z = this.m43;
		
		var xs = Util.Sign(this.m11 * this.m12 * this.m13 * this.m14) < 0 ? -1 : 1;
		var ys = Util.Sign(this.m21 * this.m22 * this.m23 * this.m24) < 0 ? -1 : 1;
		var zs = Util.Sign(this.m31 * this.m32 * this.m33 * this.m34) < 0 ? -1 : 1;
		
		scale.x = xs * Math.sqrt(this.m11 * this.m11 + this.m12 * this.m12 + this.m13 * this.m13);
		scale.y = ys * Math.sqrt(this.m21 * this.m21 + this.m22 * this.m22 + this.m23 * this.m23);
		scale.z = zs * Math.sqrt(this.m31 * this.m31 + this.m32 * this.m32 + this.m33 * this.m33);
		
		if (scale.x == 0 || scale.y == 0 || scale.z == 0) {
			rotation.x = 0;
			rotation.y = 0;
			rotation.z = 0;
			rotation.w = 1;
			return false;
		}
		
		var rotationMatrix = Matrix.FromValues(
			this.m11 / scale.x, this.m12 / scale.x, this.m13 / scale.x, 0,
			this.m21 / scale.y, this.m22 / scale.y, this.m23 / scale.y, 0,
			this.m31 / scale.z, this.m32 / scale.z, this.m33 / scale.z, 0,
			0, 0, 0, 1);
			
		rotation.fromRotationMatrix(rotationMatrix);
		
		return true;
	}
	inline public  function setLookAtLH(eye:Vector3, target:Vector3, up:Vector3):Void
	{
	
		
		// Z axis
        target.subtractToRef(eye,Matrix._zAxis);
        Matrix._zAxis.normalize();

        // X axis
        Vector3.CrossToRef(up, Matrix._zAxis, Matrix._xAxis);
        Matrix._xAxis.normalize();

        // Y axis
        Vector3.CrossToRef(Matrix._zAxis, Matrix._xAxis, Matrix._yAxis);
        Matrix._yAxis.normalize();

        // Eye angles
        var ex = -Vector3.Dot(Matrix._xAxis, eye);
        var ey = -Vector3.Dot(Matrix._yAxis, eye);
        var ez = -Vector3.Dot(Matrix._zAxis, eye);

       set(Matrix._xAxis.x, Matrix._yAxis.x, Matrix._zAxis.x, 0,
            Matrix._xAxis.y, Matrix._yAxis.y, Matrix._zAxis.y, 0,
            Matrix._xAxis.z, Matrix._yAxis.z, Matrix._zAxis.z, 0,
            ex, ey, ez, 1);
	}

	// Statics
	inline public static function FromArray(array:Array<Float>, offset:Int = 0):Matrix {
		var result = new Matrix();
		Matrix.FromArrayToRef(array, offset, result);
		return result;
	}

	inline public static function FromArrayToRef(array:Array<Float>, offset:Int, result:Matrix) {
		
			result.m11 = array[offset];
			result.m12 = array[offset +1];
			result.m13 = array[offset +2];
			result.m14 = array[offset +3];
			
     		result.m21 = array[offset +4];
			result.m22 = array[offset +5];
			result.m23 = array[offset +6];
			result.m24 = array[offset +7];
			
			result.m31 = array[offset +8];
			result.m32 = array[offset +9];
			result.m33 = array[offset +10];
			result.m34 = array[offset +11];
			
			result.m41 = array[offset +12];
			result.m42 = array[offset +13];
			result.m43 = array[offset +14];
			result.m44 = array[offset +15];
			
			
			
	}

	public static function FromValuesToRef(initialM11:Float, initialM12:Float, initialM13:Float, initialM14:Float,
		initialM21:Float, initialM22:Float, initialM23:Float, initialM24:Float,
		initialM31:Float, initialM32:Float, initialM33:Float, initialM34:Float,
		initialM41:Float, initialM42:Float, initialM43:Float, initialM44:Float, result:Matrix) {
			
		result.m11 = initialM11;
		result.m12 = initialM12;
		result.m13 = initialM13;
		result.m14 = initialM14;
		result.m21 = initialM21;
		result.m22 = initialM22;
		result.m23 = initialM23;
		result.m24 = initialM24;
		result.m31 = initialM31;
		result.m32 = initialM32;
		result.m33 = initialM33;
		result.m34 = initialM34;
		result.m41 = initialM41;
		result.m42 = initialM42;
		result.m43 = initialM43;
		result.m44 = initialM44;
	}

	inline public static function FromValues(initialM11:Float, initialM12:Float, initialM13:Float, initialM14:Float,
		initialM21:Float, initialM22:Float, initialM23:Float, initialM24:Float,
		initialM31:Float, initialM32:Float, initialM33:Float, initialM34:Float,
		initialM41:Float, initialM42:Float, initialM43:Float, initialM44:Float):Matrix {
			
		var result = new Matrix();
		
		result.m11 = initialM11;
		result.m12 = initialM12;
		result.m13 = initialM13;
		result.m14 = initialM14;
		result.m21 = initialM21;
		result.m22 = initialM22;
		result.m23 = initialM23;
		result.m24 = initialM24;
		result.m31 = initialM31;
		result.m32 = initialM32;
		result.m33 = initialM33;
		result.m34 = initialM34;
		result.m41 = initialM41;
		result.m42 = initialM42;
		result.m43 = initialM43;
		result.m44 = initialM44;
		
		return result;
	}
	
	public static inline function Compose(scale:Vector3, rotation:Quaternion, translation:Vector3):Matrix {
		var result = Matrix.FromValues(scale.x, 0, 0, 0,
			0, scale.y, 0, 0,
			0, 0, scale.z, 0,
			0, 0, 0, 1);
			
		var rotationMatrix = Matrix.Identity();
		rotation.toRotationMatrix(rotationMatrix);
		result = result.multiply(rotationMatrix);
		
		result.setTranslation(translation);
		
		return result;
	}

	
	public inline static function multiplyWith(a:Matrix, b:Matrix):Matrix
{
	var out:Matrix = Matrix.Identity();
	
	var a11 = a.m11; var a12 = a.m12; var a13 = a.m13; var a14 = a.m14;
		var a21 = a.m21; var a22 = a.m22; var a23 = a.m23; var a24 = a.m24;
		var a31 = a.m31; var a32 = a.m32; var a33 = a.m33; var a34 = a.m34;
		var a41 = a.m41; var a42 = a.m42; var a43 = a.m43; var a44 = a.m44;
		var b11 = b.m11; var b12 = b.m12; var b13 = b.m13; var b14 = b.m14;
		var b21 = b.m21; var b22 = b.m22; var b23 = b.m23; var b24 = b.m24;
		var b31 = b.m31; var b32 = b.m32; var b33 = b.m33; var b34 = b.m34;
		var b41 = b.m41; var b42 = b.m42; var b43 = b.m43; var b44 = b.m44;

		out.m11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
		out.m12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
		out.m13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
		out.m14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

		out.m21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
		out.m22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
		out.m23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
		out.m24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

		out.m31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
		out.m32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
		out.m33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
		out.m34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

		out.m41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
		out.m42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
		out.m43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
		out.m44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;
		
	return out;
	
}

 public inline static function multiply2x(out:Matrix,a:Matrix, b:Matrix):Matrix
{
	
	
	var a11 = a.m11; var a12 = a.m12; var a13 = a.m13; var a14 = a.m14;
		var a21 = a.m21; var a22 = a.m22; var a23 = a.m23; var a24 = a.m24;
		var a31 = a.m31; var a32 = a.m32; var a33 = a.m33; var a34 = a.m34;
		var a41 = a.m41; var a42 = a.m42; var a43 = a.m43; var a44 = a.m44;
		var b11 = b.m11; var b12 = b.m12; var b13 = b.m13; var b14 = b.m14;
		var b21 = b.m21; var b22 = b.m22; var b23 = b.m23; var b24 = b.m24;
		var b31 = b.m31; var b32 = b.m32; var b33 = b.m33; var b34 = b.m34;
		var b41 = b.m41; var b42 = b.m42; var b43 = b.m43; var b44 = b.m44;

		out.m11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
		out.m12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
		out.m13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
		out.m14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

		out.m21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
		out.m22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
		out.m23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
		out.m24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

		out.m31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
		out.m32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
		out.m33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
		out.m34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

		out.m41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
		out.m42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
		out.m43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
		out.m44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;
		
	return out;
	
}


	inline public function append (lhs:Matrix):Void 
	{
		
		var m111:Float = this.m11, m121:Float = this.m21, m131:Float = this.m31, m141:Float = this.m41,
			m112:Float = this.m12, m122:Float = this.m22, m132:Float = this.m32, m142:Float = this.m42,
			m113:Float = this.m13, m123:Float = this.m23, m133:Float = this.m33, m143:Float = this.m43,
			m114:Float = this.m14, m124:Float = this.m24, m134:Float = this.m34, m144:Float = this.m44,
			m211:Float = lhs.m11, m221:Float = lhs.m21, m231:Float = lhs.m31, m241:Float = lhs.m41,
			m212:Float = lhs.m12, m222:Float = lhs.m22, m232:Float = lhs.m32, m242:Float = lhs.m42,
			m213:Float = lhs.m13, m223:Float = lhs.m23, m233:Float = lhs.m33, m243:Float = lhs.m43,
			m214:Float = lhs.m14, m224:Float = lhs.m24, m234:Float = lhs.m34, m244:Float = lhs.m44;
		
		this.m11 = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
		this.m12 = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
		this.m13 = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
		this.m14 = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
		
		this.m21 = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
		this.m22 = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
		this.m23 = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
		this.m24 = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
		
		this.m31 = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
		this.m32 = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
		this.m33 = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
		this.m34 = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
		
		this.m41 = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
		this.m42 = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
		this.m43 = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
		this.m44 = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
		
	}
	
	inline public  function setRotationDegrees( rotation:Vector3 ):Matrix
	{
		var cr:Float=Math.cos( rotation.x*Util.Deg2Rad);
		var sr:Float=Math.sin( rotation.x*Util.Deg2Rad );
		var cp:Float=Math.cos( rotation.y*Util.Deg2Rad );
		var sp:Float=Math.sin( rotation.y*Util.Deg2Rad );
		var cy:Float=Math.cos( rotation.z*Util.Deg2Rad );
		var sy:Float=Math.sin( rotation.z*Util.Deg2Rad );

		m11 = ( cp*cy );
		m12 = ( cp*sy );
		m13 = ( -sp );

		var srsp:Float = sr*sp;
		var crsp:Float = cr*sp;

		m21 = ( srsp*cy-cr*sy );
		m22 = ( srsp*sy+cr*cy );
		m23 = ( sr*cp );

		m31 = ( crsp*cy+sr*sy );
		m32 = ( crsp*sy-sr*cy );
		m33 = ( cr*cp );
		
		return this;
	}
	
	 inline public  function setIdentity():Void 
	{
		this.set(
			1.0, 0, 0, 0,
            0, 1.0, 0, 0,
            0, 0, 1.0, 0,
            0, 0, 0, 1.0
		);
	}
	inline public static function Identity():Matrix {
		return Matrix.FromValues(1.0, 0, 0, 0,
			0, 1.0, 0, 0,
			0, 0, 1.0, 0,
			0, 0, 0, 1.0);
	}

	inline public static function IdentityToRef(result:Matrix) {
		Matrix.FromValuesToRef(1.0, 0, 0, 0,
			0, 1.0, 0, 0,
			0, 0, 1.0, 0,
			0, 0, 0, 1.0, result);
	}

	inline public static function Zero():Matrix {
		return Matrix.FromValues(0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0);
	}

	inline public static function Rotation(forward:Vector3, up:Vector3):Matrix 
	{
		var f:Vector3 = forward.normalize();
		var r:Vector3 = up.normalize();
		r = r.cross(f);
		var u:Vector3 = f.cross(r);
		return Matrix.InitRotation(r, u, r);
	}
	inline public static function InitRotation( forward:Vector3,  up:Vector3, right:Vector3):Matrix
	{
		var f:Vector3 = forward;
		var r:Vector3 = right;
		var u:Vector3 = up;

		var m:Matrix = Matrix.Zero();
		m.m11 = r.x;	m.m12 = r.y;	m.m13 = r.z;	m.m14 = 0;
		m.m21 = u.x;	m.m22 = u.y;	m.m23 = u.z;	m.m24 = 0;
		m.m31 = f.x;	m.m32 = f.y;	m.m33 = f.z;	m.m34 = 0;
		m.m41 = 0;	m.m42 = 0;	m.m43 = 0;	m.m44 = 1;

		return m;
	}
	
	inline public static function RotationX(angle:Float):Matrix {
		var result = new Matrix();
		Matrix.RotationXToRef(angle, result);
		return result;
	}
	
	inline public static function Invert(source:Matrix):Matrix {
		var result = new Matrix();
		source.invertToRef(result);
		return result;
	}

	inline public static function RotationXToRef(angle:Float, result:Matrix) {
		var s = Math.sin(angle);
		var c = Math.cos(angle);
		
		result.m11 = 1.0;
		result.m44 = 1.0;
		
		result.m22 = c;
		result.m33 = c;
		result.m32 = -s;
		result.m23 = s;
		
		result.m12 = 0;
		result.m13 = 0;
		result.m14 = 0;
		result.m21 = 0;
		result.m24 = 0;
		result.m31 = 0;
		result.m34 = 0;
		result.m41 = 0;
		result.m42 = 0;
		result.m43 = 0;
	}

	inline public static function RotationY(angle:Float):Matrix {
		var result = new Matrix();
		Matrix.RotationYToRef(angle, result);
		return result;
	}

	inline public static function RotationYToRef(angle:Float, result:Matrix) {
		var s = Math.sin(angle);
		var c = Math.cos(angle);
		
		result.m22 = 1.0;
		result.m44 = 1.0;
		
		result.m11 = c;
		result.m13 = -s;
		result.m31 = s;
		result.m33 = c;
		
		result.m12 = 0;
		result.m14 = 0;
		result.m21 = 0;
		result.m23 = 0;
		result.m24 = 0;
		result.m32 = 0;
		result.m34 = 0;
		result.m41 = 0;
		result.m42 = 0;
		result.m43 = 0;
	}

	inline public static function RotationZ(angle:Float):Matrix {
		var result = new Matrix();
		Matrix.RotationZToRef(angle, result);
		return result;
	}

	inline public static function RotationZToRef(angle:Float, result:Matrix) {
		var s = Math.sin(angle);
		var c = Math.cos(angle);
		
		result.m33 = 1.0;
		result.m44 = 1.0;
		
		result.m11 = c;
		result.m12 = s;
		result.m21 = -s;
		result.m22 = c;
		
		result.m13 = 0;
		result.m14 = 0;
		result.m23 = 0;
		result.m24 = 0;
		result.m31 = 0;
		result.m32 = 0;
		result.m34 = 0;
		result.m41 = 0;
		result.m42 = 0;
		result.m43 = 0;
	}

	inline public static function RotationAxis(axis:Vector3, angle:Float):Matrix {
		var s = Math.sin(-angle);
		var c = Math.cos(-angle);
		var c1 = 1 - c;
		
		axis.normalize();
		var result = Matrix.Zero();
		
		result.m11 = (axis.x * axis.x) * c1 + c;
		result.m12 = (axis.x * axis.y) * c1 - (axis.z * s);
		result.m13 = (axis.x * axis.z) * c1 + (axis.y * s);
		result.m14 = 0.0;
		
		result.m21 = (axis.y * axis.x) * c1 + (axis.z * s);
		result.m22 = (axis.y * axis.y) * c1 + c;
		result.m23 = (axis.y * axis.z) * c1 - (axis.x * s);
		result.m24 = 0.0;
		
		result.m31 = (axis.z * axis.x) * c1 - (axis.y * s);
		result.m32 = (axis.z * axis.y) * c1 + (axis.x * s);
		result.m33 = (axis.z * axis.z) * c1 + c;
		result.m34 = 0.0;
		
		result.m44 = 1.0;
		
		return result;
	}

	inline public static function RotationYawPitchRoll(yaw:Float, pitch:Float, roll:Float):Matrix {
		var result = new Matrix();
		Matrix.RotationYawPitchRollToRef(yaw, pitch, roll, result);
		return result;
	}

	inline public static function RotationYawPitchRollToRef(yaw:Float, pitch:Float, roll:Float, result:Matrix) {
		Quaternion.RotationYawPitchRollToRef(yaw, pitch, roll, Matrix._tempQuaternion);
		Matrix._tempQuaternion.toRotationMatrix(result);
	}

	inline public static function Scaling(x:Float, y:Float, z:Float):Matrix {
		var result = Matrix.Zero();
		Matrix.ScalingToRef(x, y, z, result);
		return result;
	}

	inline public static function ScalingToRef(x:Float, y:Float, z:Float, result:Matrix) {
		result.m11 = x;
		result.m12 = 0;
		result.m13 = 0;
		result.m14 = 0;
		result.m21 = 0;
		result.m22 = y;
		result.m23 = 0;
		result.m24 = 0;
		result.m31 = 0;
		result.m32 = 0;
		result.m33 = z;
		result.m34 = 0;
		result.m41 = 0;
		result.m42 = 0;
		result.m43 = 0;
		result.m44 = 1.0;
	}

	inline public static function Translation(x:Float, y:Float, z:Float):Matrix {
		var result = Matrix.Identity();
		Matrix.TranslationToRef(x, y, z, result);
		return result;
	}

	public static function TranslationToRef(x:Float, y:Float, z:Float, result:Matrix) {
		Matrix.FromValuesToRef(1.0, 0, 0, 0,
			0, 1.0, 0, 0,
			0, 0, 1.0, 0,
			x, y, z, 1.0, result);
	}

	inline public static function LookAtLH(eye:Vector3, target:Vector3, up:Vector3):Matrix {
		var result = Matrix.Zero();
		Matrix.LookAtLHToRef(eye, target, up, result);
		return result;
	}

	public static function LookAtLHToRef(eye:Vector3, target:Vector3, up:Vector3, result:Matrix)
	{
		
		
		
		// Z axis
		target.subtractToRef(eye, Matrix._zAxis);
		Matrix._zAxis.normalize();
		
		// X axis
		Vector3.CrossToRef(up, Matrix._zAxis, Matrix._xAxis);
		Matrix._xAxis.normalize();
		
		// Y axis
		Vector3.CrossToRef(Matrix._zAxis, Matrix._xAxis, Matrix._yAxis);
		Matrix._yAxis.normalize();
		
		// Eye angles
		var ex = -Vector3.Dot(Matrix._xAxis, eye);
		var ey = -Vector3.Dot(Matrix._yAxis, eye);
		var ez = -Vector3.Dot(Matrix._zAxis, eye);
		
		return Matrix.FromValuesToRef(Matrix._xAxis.x, Matrix._yAxis.x, Matrix._zAxis.x, 0,
			Matrix._xAxis.y, Matrix._yAxis.y, Matrix._zAxis.y, 0,
			Matrix._xAxis.z, Matrix._yAxis.z, Matrix._zAxis.z, 0,
			ex, ey, ez, 1, result);
			
	}

	
	inline public static function OrthoLH(width:Float, height:Float, znear:Float, zfar:Float):Matrix {
		var hw = 2.0 / width;
		var hh = 2.0 / height;
		var id = 1.0 / (zfar - znear);
		var nid = znear / (znear - zfar);
		
		return Matrix.FromValues(hw, 0, 0, 0,
			0, hh, 0, 0,
			0, 0, id, 0,
			0, 0, nid, 1);
	}
	
	inline public static function OrthoLHRef(width:Float, height:Float, znear:Float, zfar:Float,result:Matrix):Matrix {
		var hw = 2.0 / width;
		var hh = 2.0 / height;
		var id = 1.0 / (zfar - znear);
		var nid = znear / (znear - zfar);
		
		result.set(hw, 0, 0, 0,
			0, hh, 0, 0,
			0, 0, id, 0,
			0, 0, nid, 1);
			
			return result;
	}

	inline public static function OrthoOffCenterLH(left:Float, right:Float, bottom:Float, top:Float, znear:Float, zfar:Float):Matrix {
		var matrix = Matrix.Zero();
		Matrix.OrthoOffCenterLHToRef(left, right, bottom, top, znear, zfar, matrix);
		return matrix;
	}

	public static function OrthoOffCenterLHToRef(left:Float, right:Float, bottom:Float, top:Float, znear:Float, zfar:Float, result:Matrix) {
		result.m11 = 2.0 / (right - left);
		result.m12 = result.m13 = result.m14 = 0;
		result.m22 = 2.0 / (top - bottom);
		result.m21 = result.m23 = result.m24 = 0;
		result.m33 = -1.0 / (znear - zfar);
		result.m31 = result.m32 = result.m34 = 0;
		result.m41 = (left + right) / (left - right);
		result.m42 = (top + bottom) / (bottom - top);
		result.m43 = znear / (znear - zfar);
		result.m44 = 1.0;
	}

	inline public static function PerspectiveLH(width:Float, height:Float, znear:Float, zfar:Float):Matrix {
		var matrix = Matrix.Zero();
		
		matrix.m11 = (2.0 * znear) / width;
		matrix.m12 = matrix.m13 = matrix.m14 = 0.0;
		matrix.m22 = (2.0 * znear) / height;
		matrix.m21 = matrix.m23 = matrix.m24 = 0.0;
		matrix.m33 = -zfar / (znear - zfar);
		matrix.m31 = matrix.m32 = 0.0;
		matrix.m34 = 1.0;
		matrix.m41 = matrix.m42 = matrix.m44 = 0.0;
		matrix.m43 = (znear * zfar) / (znear - zfar);
		
		return matrix;
	}

	inline public static function PerspectiveFovLH(fov:Float, aspect:Float, znear:Float, zfar:Float):Matrix {
		var matrix = Matrix.Zero();
		Matrix.PerspectiveFovLHToRef(fov, aspect, znear, zfar, matrix);
		return matrix;
	}

	public static function PerspectiveFovLHToRef(fov:Float, aspect:Float, znear:Float, zfar:Float, result:Matrix, ?fovMode:Int) {
		var tan = 1.0 / (Math.tan(fov * 0.5));
		
		var v_fixed:Bool = fovMode == null || (fovMode == Camera.FOVMODE_VERTICAL_FIXED);
		var h_fixed:Bool = (fovMode == Camera.FOVMODE_HORIZONTAL_FIXED);
		
		if (v_fixed) {
			result.m11 = tan / aspect;
		} else if (h_fixed) {
			result.m11 = tan;
		}
		
		result.m12 = result.m13 = result.m14 = 0.0;
		
		if (v_fixed) { 
			result.m22 = tan; 
		} else if (h_fixed) { 
			result.m22 = tan * aspect; 
		}
			
		result.m21 = result.m23 = result.m24 = 0.0;
		result.m31 = result.m32 = 0.0;
		result.m33 = -zfar / (znear - zfar);
		result.m34 = 1.0;
		result.m41 = result.m42 = result.m44 = 0.0;
		result.m43 = (znear * zfar) / (znear - zfar);
	}



	inline public static function Transpose(matrix:Matrix):Matrix {
		var result = new Matrix();
		
		result.m11 = matrix.m11;
		result.m12 = matrix.m21;
		result.m13 = matrix.m31;
		result.m14 = matrix.m41;
		
		result.m21 = matrix.m12;
		result.m22 = matrix.m22;
		result.m23 = matrix.m32;
		result.m24 = matrix.m42;
		
		result.m31 = matrix.m13;
		result.m32 = matrix.m23;
		result.m33 = matrix.m33;
		result.m34 = matrix.m43;
		
		result.m41 = matrix.m14;
		result.m42 = matrix.m24;
		result.m43 = matrix.m34;
		result.m44 = matrix.m44;
		
		return result;
	}

	inline public static function Reflection(plane:Plane):Matrix {
		var matrix = new Matrix();
		Matrix.ReflectionToRef(plane, matrix);
		return matrix;
	}

	public static function ReflectionToRef(plane:Plane, result:Matrix) {
		plane.normalize();
		var x = plane.normal.x;
		var y = plane.normal.y;
		var z = plane.normal.z;
		var temp = -2 * x;
		var temp2 = -2 * y;
		var temp3 = -2 * z;
		result.m11 = (temp * x) + 1;
		result.m12 = temp2 * x;
		result.m13 = temp3 * x;
		result.m14 = 0.0;
		result.m21 = temp * y;
		result.m22 = (temp2 * y) + 1;
		result.m23 = temp3 * y;
		result.m24 = 0.0;
		result.m31 = temp * z;
		result.m32 = temp2 * z;
		result.m33 = (temp3 * z) + 1;
		result.m34 = 0.0;
		result.m41 = temp * plane.d;
		result.m42 = temp2 * plane.d;
		result.m43 = temp3 * plane.d;
		result.m44 = 1.0;
	}
	/**
	 * BLITZ3d Function
	 */
	inline public function TransformVecToRef(v:Vector3,result:Vector3, addTranslation:Int = 0 ):Void
	{

		var  w = 1.0/ ( m14 + m24 + m34 + m44 );
		var  ix = v.x;
		var  iy = v.y;
		var  iz = v.z;

		addTranslation = addTranslation & 1;

		result.x =  ( ( m11*ix ) + ( m21*iy ) + ( m31*iz ) + m41 * addTranslation ) * w;
		result.y =  ( ( m12*ix ) + ( m22*iy ) + ( m32*iz ) + m42 * addTranslation ) * w;
		result.z =  ( ( m13*ix ) + ( m23*iy ) + ( m33*iz ) + m43 * addTranslation ) * w;

	}
	
	inline public function transformVector(r:Vector3):Vector3
		{

	
		var  ix = r.x;
		var  iy = r.y;
		var  iz = r.z;

		var result:Vector3 = Vector3.zero;
		result.x =  ( ( m11 * ix ) + ( m21 * iy ) + ( m31 * iz ) + m41 ) ;
		result.y =  ( ( m12  *ix ) + ( m22 * iy ) + ( m32 * iz ) + m42  ) ;
		result.z =  ( ( m13 * ix ) + ( m23 * iy ) + ( m33 * iz ) + m43  ) ;
		
		
		
		
		return result; 
		

	}
	inline public function transformVectorRef(r:Vector3):Vector3
		{

	
		var  ix = r.x;
		var  iy = r.y;
		var  iz = r.z;

		
		r.x =  ( ( m11 * ix ) + ( m21 * iy ) + ( m31 * iz ) + m41 ) ;
		r.y =  ( ( m12  *ix ) + ( m22 * iy ) + ( m32 * iz ) + m42  ) ;
		r.z =  ( ( m13 * ix ) + ( m23 * iy ) + ( m33 * iz ) + m43  ) ;
		
		
		
		
		return r; 
		

	}
	inline public function rotateVect(r:Vector3 ):Vector3
		{
		var result:Vector3 = Vector3.zero;
		var  ix = r.x;
		var  iy = r.y;
		var  iz = r.z;
		
		result.x =  ( ( m11 * ix ) + ( m21 * iy ) + ( m31  * iz ) );
		result.y =  ( ( m12 * ix ) + ( m22 * iy ) + ( m32  * iz) ) ;
		result.z =  ( ( m13 * ix ) + ( m23 * iy ) + ( m33 * iz ) ) ;
		
		return result; 
		}
		
		
		
}
