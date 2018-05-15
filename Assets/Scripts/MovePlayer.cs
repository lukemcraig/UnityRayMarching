﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovePlayer : MonoBehaviour {
    public Rigidbody rb;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        rb.AddForce(20.0f * Input.GetAxis("Horizontal") * Vector3.right);



        if (Input.GetButton("Jump") )
        {
            RaycastHit hit;
            if (Physics.Raycast(transform.position, Vector3.down, out hit, .4f))
            {
                Debug.DrawRay(transform.position, Vector3.down * hit.distance, Color.yellow);                
                rb.AddForce(Vector3.up, ForceMode.Impulse);
            }
           
        }
    }
}