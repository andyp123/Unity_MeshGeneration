using UnityEngine;
using System.Collections;

public class Rotator : MonoBehaviour
{
	public float rotateSpeed = 45.0f; // degrees per second

	void Update()
	{
		transform.Rotate(Vector3.forward * Time.deltaTime * rotateSpeed);
	}
}
