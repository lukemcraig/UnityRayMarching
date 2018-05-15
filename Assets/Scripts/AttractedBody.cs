using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttractedBody : MonoBehaviour {
    public Rigidbody rb;
    public Transform player;
    public Rigidbody playerRb;
    public FixedJoint fj;
    public float distance;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        Vector3 dir = transform.position - player.position;
        distance = dir.sqrMagnitude;
        if (Input.GetButton("Fire1") && distance <= 0.682) {

            //float forceClamped = Mathf.Clamp(100.0f / dir.sqrMagnitude,0f,10f);
            //rb.AddForce( -dir * forceClamped);    
            fj = gameObject.GetComponent<FixedJoint>();
            if (fj == null)
            {
                fj = gameObject.AddComponent<FixedJoint>();
                fj.connectedBody = playerRb;
            }
        }
        else
        {            
            //fj.connectedBody = null;
            fj = gameObject.GetComponent<FixedJoint>();
            if (fj != null)
            {
                Destroy(fj);
            }
        }
    }
}
