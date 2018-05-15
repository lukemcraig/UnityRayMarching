using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractedBody : MonoBehaviour {
    public Rigidbody rb;
    public Transform player;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        if (Input.GetButton("Fire1")) { 
            Vector3 dir = transform.position - player.position;
            float forceClamped = Mathf.Clamp(100.0f / dir.sqrMagnitude,0f,10f);
            rb.AddForce( -dir * forceClamped);
        }
    }
}
