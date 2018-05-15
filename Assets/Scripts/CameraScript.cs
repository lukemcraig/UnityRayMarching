using UnityEngine;
[RequireComponent(typeof(Camera))]
public class CameraScript : MonoBehaviour
{ 
    public Shader myShader;
    public Material myMaterial;

    [ImageEffectOpaque]
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        myMaterial.SetVector("_CamForward", transform.forward);
        myMaterial.SetVector("_CamRight", transform.right);
        myMaterial.SetVector("_CamUp", transform.up);        
        myMaterial.SetFloat("_Fov", (Camera.main.fieldOfView * Mathf.Deg2Rad) / 2.0f);

        Graphics.Blit(source, destination, myMaterial, 0);
    }
    
}
