Shader "Raymarching/MyShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			uniform float3 _CamForward;
			uniform float3 _CamRight;
			uniform float3 _CamUp;
			uniform float  _Fov;

			static const int MAX_MARCHING_STEPS = 256;
			static const float EPSILON = 0.00001;
			static const float PI = 3.141592653589793238462643383279502884197169399375105820974;
			static const float PI_HALF = 1.570796326794896619231321691639751442098584699687552910487;
			#include "Raymarching.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{				
				float4 vertex : SV_POSITION;	
				float2 uv : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{ 
				fixed4 col = tex2D(_MainTex, i.uv);

				float3 rayOrigin = _WorldSpaceCameraPos;
				float2 myUv = i.uv;
				
				float fov = tan(_Fov);
				// _ScreenParams.x/ _ScreenParams.y = aspect
				myUv.x = (2.0*i.uv.x - 1.0) * (_ScreenParams.x/ _ScreenParams.y) * fov;
				myUv.y = (1.0 - 2.0*i.uv.y) * fov;
				float3 rayDirection = normalize(1.0*_CamForward + _CamRight*myUv.x + _CamUp* myUv.y);
				
				// do the marching    
				//_ProjectionParams.y = near clip
				//_ProjectionParams.z = far clip	
				float t = rayMarching(rayOrigin, rayDirection, _ProjectionParams.y, _ProjectionParams.z);
				
				if (t < _ProjectionParams.z) {
					float3 color = float3(0.0, 0.0, 0.0);
					// TODO get ambient light from unity
					//color = float3(0.05,0.05,0.05);
					float3 p = rayOrigin + (t * rayDirection);
					float3 normal = estimateNormal(p);
					float3 viewVec = normalize(rayOrigin - p);
					color = calculateLight(color, p, viewVec, normal, float3(0.0,-3.0,0.0), 1.0);
					color = clamp(color, 0.0, 1.0);

					col.rgb = color;
				}		

				return col;
			}
			ENDCG
		}
	}
}
