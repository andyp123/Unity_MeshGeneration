using UnityEngine;
using System.Collections;

public class CameraWobble : MonoBehaviour
{
	public AudioSource audioInput;
	public float wobbleAmount = 1.0f;
	public float wobbleSpeed = 1.0f;

	float[] _samples;

	void Awake()
	{
		_samples = new float[8];
	}

	void Update()
	{
		float signal = 0.0f;
		if (audioInput != null && audioInput.isPlaying)
		{
			audioInput.clip.GetData(_samples, audioInput.timeSamples);
			for (int i = 0; i < _samples.Length; ++i)
			{
				signal += Mathf.Abs(_samples[i]);
			}
			signal /= _samples.Length;
			signal *= signal;
		}

		float t = (Time.time / wobbleSpeed) % (2 * Mathf.PI);
		float cx = Mathf.Sin(t);
		float cy = Mathf.Cos(t);
		transform.position = new Vector3(cx * wobbleAmount * signal, cy * wobbleAmount * signal, transform.position.z);
	}
}
