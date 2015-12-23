package com.gdx;

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
 
import com.gdx.Screen;
import com.gdx.App;
import com.gdx.util.Util;
import com.gdx.util.ArrayIterator;
import com.gdx.util.Clip;
import com.gdx.util.HeightMap;
import com.gdx.util.PosKeyFrame;
import com.gdx.util.RotKeyFrame;
import com.gdx.util.SpriteSheet;
import com.gdx.util.Strings;
import com.gdx.util.TextParser;

import com.gdx.collision.BspTree;
import com.gdx.collision.Coldet;
import com.gdx.collision.Collider;
import com.gdx.collision.CollisionData;
import com.gdx.collision.OctSelector;
import com.gdx.collision.Octree;
import com.gdx.collision.QuadSelector;
import com.gdx.collision.QuadTree;

import com.gdx.color.Color3;
import com.gdx.color.Color4;

import com.gdx.gl.material.Material;

import com.gdx.gl.shaders.ColorShader;
import com.gdx.gl.shaders.Shader;
import com.gdx.gl.shaders.ShaderDefault;
import com.gdx.gl.shaders.ShaderGrass;
import com.gdx.gl.shaders.ShaderSkin;
import com.gdx.gl.shaders.ShaderSkyBox;
import com.gdx.gl.shaders.ShaderTexture;
import com.gdx.gl.shaders.TextureShaderDetailFog;

import com.gdx.gl.BlendMode;
import com.gdx.gl.Imidiatemode;
import com.gdx.gl.MeshBuffer;
import com.gdx.gl.PackVertexBuffer;
import com.gdx.gl.Texture;
import com.gdx.gl.VertexBone;
import com.gdx.gl.VertexBuffer;

import com.gdx.math.BoundingBox;
import com.gdx.math.BoundingInfo;
import com.gdx.math.BoundingSphere;
import com.gdx.math.Face;
import com.gdx.math.Frustum;
import com.gdx.math.IntersectionInfo;
import com.gdx.math.Math;
import com.gdx.math.Matrix;
import com.gdx.math.Matrix2D;
import com.gdx.math.Perlin;
import com.gdx.math.Plane;
import com.gdx.math.Quaternion;
import com.gdx.math.Rand;
import com.gdx.math.Ray;
import com.gdx.math.Rectangle;
import com.gdx.math.Triangle;
import com.gdx.math.Vector2;
import com.gdx.math.Vector3;
import com.gdx.math.Vector4;

import com.gdx.scene2d.Graphic;
import com.gdx.scene2d.Image;
import com.gdx.scene2d.render.BatchPrimitives;
import com.gdx.scene2d.render.SpriteAtlas;
import com.gdx.scene2d.render.SpriteBatch;
import com.gdx.scene2d.render.SpriteCloud;
import com.gdx.scene2d.ui.AngelFont;
import com.gdx.scene2d.ui.BitmapFont;
import com.gdx.scene2d.ui.Font;
import com.gdx.scene2d.ui.ImageFont;

import com.gdx.scene3d.AnimatedMesh;
import com.gdx.scene3d.AnimatedSceneNode;
import com.gdx.scene3d.GeoTerrain;
import com.gdx.scene3d.Mesh;
import com.gdx.scene3d.MeshAnimated;
import com.gdx.scene3d.MeshB3D;
import com.gdx.scene3d.MeshCreator;
import com.gdx.scene3d.MeshGroundHeighMap;
import com.gdx.scene3d.MeshH3D;
import com.gdx.scene3d.MeshLargeLandScape;
import com.gdx.scene3d.MeshMD2;
import com.gdx.scene3d.MeshMD3;
import com.gdx.scene3d.MeshBSP;
import com.gdx.scene3d.MeshSkyBox;
import com.gdx.scene3d.Node;
import com.gdx.scene3d.partition.NodeMeshOctree;
import com.gdx.scene3d.partition.NodeOctree;

import com.gdx.scene3d.SceneManager;
import com.gdx.scene3d.SceneNode;
import com.gdx.scene3d.animators.Animator;
import com.gdx.scene3d.animators.DeleteAnimator;
import com.gdx.scene3d.animators.FlyStraight;
import com.gdx.scene3d.animators.KeyFrameAnimation;
import com.gdx.scene3d.animators.Montion;
import com.gdx.scene3d.animators.MoveAnimator;
import com.gdx.scene3d.animators.PosKeyFrame;
import com.gdx.scene3d.animators.RotKeyFrame;

import com.gdx.scene3d.bolt.BilboardNode;

import com.gdx.scene3d.cameras.ArcBallCamera;
import com.gdx.scene3d.cameras.Camera;
import com.gdx.scene3d.cameras.Camera2D;
import com.gdx.scene3d.cameras.FreeCamera;
import com.gdx.scene3d.cameras.OrbitCamera;
import com.gdx.scene3d.cameras.OrthoCamera;
import com.gdx.scene3d.cameras.TargetCamera;

import com.gdx.scene3d.lensflare.LensFlare;
import com.gdx.scene3d.lensflare.LensFlareSystem;

import com.gdx.scene3d.particles.affectors.BounceAffect;
import com.gdx.scene3d.particles.affectors.ColorMorphAffect;
import com.gdx.scene3d.particles.affectors.GravityAffect;
import com.gdx.scene3d.particles.affectors.ParticleAffect;
import com.gdx.scene3d.particles.affectors.RotateAffect;
import com.gdx.scene3d.particles.BilboardBatch;
import com.gdx.scene3d.particles.BilboardStaticBatch;
import com.gdx.scene3d.particles.BoxEmitter;
import com.gdx.scene3d.particles.CylinderEmitter;
import com.gdx.scene3d.particles.ParticleSystem;
import com.gdx.scene3d.particles.RingEmitter;
import com.gdx.scene3d.particles.SphereEmitter;


import com.gdx.scene3d.bolt.DecaleNode;







/**
 * ...
 * @author ...
 */
class Importer
{

	public function new() 
	{
		
	}
	
}