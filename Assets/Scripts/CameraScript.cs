﻿using System;
using UnityEngine;
[RequireComponent(typeof(Camera))]
public class CameraScript : MonoBehaviour
{ 
    public Shader myShader;
    public Material myMaterial;
    Light[] lights;
    //Texture2D lightInfo;
    ComputeBuffer lightInfo;
    float[] lightPositions;

    private void Start()
    {
       
    }

    [ImageEffectOpaque]
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        myMaterial.SetVector("_CamForward", transform.forward);
        myMaterial.SetVector("_CamRight", transform.right);
        myMaterial.SetVector("_CamUp", transform.up);        
        myMaterial.SetFloat("_Fov", (Camera.main.fieldOfView * Mathf.Deg2Rad) / 2.0f);

        lights = FindObjectsOfType(typeof(Light)) as Light[];
        //lightInfo = new Texture2D(1, lights.Length);
        lightInfo = new ComputeBuffer(4 * lights.Length, 4);
        lightPositions = new float[4 * lights.Length];
        myMaterial.SetBuffer("_LightInfo", lightInfo);

        for (int i = 0; i < lights.Length; i++)
        {
            Vector3 lp = lights[i].transform.position;
           
            lightPositions[(i * 4)+0] = lp.x;
            lightPositions[(i * 4)+1] = lp.y;
            lightPositions[(i * 4)+2] = lp.z;
            lightPositions[(i * 4)+3] = 1.0f;
        }
        lightInfo.SetData(lightPositions);       


        Graphics.Blit(source, destination, myMaterial, 0);
    }
    
}
