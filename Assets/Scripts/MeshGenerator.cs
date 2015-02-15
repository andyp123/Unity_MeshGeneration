using UnityEngine;
using System.Collections;

[RequireComponent (typeof(MeshRenderer))]
public class MeshGenerator : MonoBehaviour
{
	public int quadsX = 8;
	public int quadsZ = 16;
	public float lengthX = 5.0f;
	public float lengthZ = 10.0f;
	public float scaleY = 1.0f;
	public bool preview = true;

	public AudioSource audioInput;
	public float updateDelay = 0.2f;
	float _nextUpdate = 0.0f;

	Vector3[] _verts;
	Color32[] _colors;
	Vector2[] _uvs;
	Vector3[] _normals;

	MeshFilter meshFilter;

	void Awake()
	{
		if (quadsX < 1) quadsX = 1;
		if (quadsZ < 1) quadsZ = 1;
		meshFilter = gameObject.AddComponent<MeshFilter>();
	}

	void Start()
	{
		InitMesh();
	}

	void Update()
	{
		if (audioInput.time > _nextUpdate && audioInput.isPlaying)
		{
			_nextUpdate += updateDelay;

			PushVerts();

			AudioClip clip = audioInput.clip;
			float[] data = new float[quadsX + 1];
			clip.GetData(data, audioInput.timeSamples);

			float stepX = 1.0f / quadsX;
			for (int i = 0; i < quadsX + 1; ++i)
			{
				float t = stepX * i * 2 * Mathf.PI;
				float cx = Mathf.Sin(t); 
				float cy = Mathf.Cos(t);

				float sum = data[i];
				int div = 1;
				if (i > 0) { sum += data[i - 1]; div += 1; }
				if (i < quadsX) { sum += data[i + 1]; div += 1; }
				float y = sum / div * scaleY;
				_verts[i].Set(cy * lengthX, cx * lengthX, _verts[i].z);
				_verts[i] += _normals[i] * y;

				float fa = Mathf.Clamp01(y);
				byte alpha = (byte)(255 * fa);
				_colors[i] = new Color32(255, 255, 255, alpha);
			}

			StichEdges();

			Mesh mesh = meshFilter.mesh;

			mesh.vertices = _verts;
			mesh.colors32 = _colors;

			mesh.Optimize();			
		}
	}

	void PushVerts()
	{
		int vertsX = quadsX + 1;
		int vertsZ = quadsZ + 1;

		for (int z = vertsZ - 1; z > 0; --z)
		{
			for (int x = 0; x < vertsX; ++x)
			{
				int i = x + z * vertsX;
				float px = _verts[i - vertsX].x;
				float py = _verts[i - vertsX].y;
				float pz = _verts[i].z;
				_verts[i].Set(px, py, pz);

				_colors[i] = _colors[i - vertsX];
			}
		}
	}

	void StichEdges()
	{
		int vertsX = quadsX + 1;
		// int vertsZ = quadsZ + 1;

		// just realised only one vertex needs stitching per update :D
		// for (int z = vertsZ - 1; z > 0; --z)
		for (int z = 0; z < 1; ++z)
		{
			Vector3 merged = (_verts[z * vertsX] + _verts[z * vertsX + vertsX - 1]) * 0.5f;
			_verts[z * vertsX] = merged;
			_verts[z * vertsX + vertsX - 1] = merged;

			Color32 mergedColor = Color32.Lerp(_colors[z + vertsX], _colors[z * vertsX + vertsX - 1], 0.5f);
			_colors[z * vertsX] = mergedColor;
			_colors[z * vertsX + vertsX - 1] = mergedColor;
		}		
	}

	void InitMesh()
	{
		int vertsX = quadsX + 1;
		int vertsZ = quadsZ + 1;

		// initialize arrays and objects
		int numVerts = vertsX * vertsZ;
		_verts = new Vector3[numVerts];
		_normals = new Vector3[numVerts];
		_colors = new Color32[numVerts];
		_uvs = new Vector2[numVerts];

		for (int i = 0; i < numVerts; ++i)
		{
			_verts[i] = new Vector3();
			_normals[i] = Vector3.up;
			_colors[i] = Color.white;
			_uvs[i] = new Vector2();
		}

		// set vertex positions into a grid
		float stepX = 1.0f / quadsX;
		float stepZ = 1.0f / quadsZ;

		for (int z = 0; z < vertsZ; ++z)
		{
			for (int x = 0; x < vertsX; ++x)
			{
				int i = x + z * vertsX;
				float t = stepX * x * 2 * Mathf.PI;
				float cx = Mathf.Sin(t); 
				float cy = Mathf.Cos(t);
				_verts[i].Set(cy * lengthX, cx * lengthX, z * stepZ * lengthZ); // cy, cx to flip normal
				_uvs[i].Set(x * stepX, z * stepZ);
			}
		}

		// set up triangles
		int numQuads = quadsX * quadsZ;
		int[] tris = new int[numQuads * 6]; // 3 verts per triangle, 2 triangles per quad

		for (int z = 0; z < quadsZ; ++z)
		{
			for (int x = 0; x < quadsX; ++x)
			{
				// anti-clockwise winding
				int ti = (x + z * quadsX) * 6;
				int vi = x + z * vertsX;
				tris[ti]     = vi;
				tris[ti + 1] = vi + vertsX;
				tris[ti + 2] = vi + 1;
				tris[ti + 3] = vi + 1;
				tris[ti + 4] = vi + vertsX;
				tris[ti + 5] = vi + vertsX + 1;
			}
		}

		// assign to mesh
		Mesh mesh = meshFilter.mesh;
		mesh.Clear();

		mesh.vertices = _verts;
		mesh.uv = _uvs;
		mesh.colors32 = _colors;
		mesh.triangles = tris;

		mesh.Optimize();
		mesh.RecalculateNormals();
		_normals = mesh.normals;
	}

	void OnDrawGizmos()
	{
		if (!preview) return;

		Gizmos.matrix = transform.localToWorldMatrix;
		Gizmos.color = Color.yellow;

		for (int x = 0; x < quadsX + 1; ++x)
		{
			float px = (float)x / (float)quadsX * lengthX;
			Gizmos.DrawLine(new Vector3(px, 0.0f, 0.0f), new Vector3(px, 0.0f, lengthZ));
		}

		for (int z = 0; z < quadsZ + 1; ++z)
		{
			float pz = (float)z / (float)quadsZ * lengthZ;
			Gizmos.DrawLine(new Vector3(0.0f, 0.0f, pz), new Vector3(lengthX, 0.0f, pz));
		}

	}
}
