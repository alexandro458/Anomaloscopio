Shader "Unlit/BrightnessAdjusted"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle] _isLerp("is Lerp?", Float) = 0
        _Color1 ("Color1 ", Color) = (0,0,0,0)
        _Color2 ("Color2 ", Color) = (0,0,0,0)
        _Percentile("Percentile", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _Color1;
            float4 _Color2;

            float _Percentile;

            int _Type;
            float _isLerp;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 Daltonize( float4 input)
            {
	            // RGB to LMS matrix conversion
	            float L = (17.8824f * input.r) + (43.5161f * input.g) + (4.11935f * input.b);
	            float M = (3.45565f * input.r) + (27.1554f * input.g) + (3.86714f * input.b);
	            float S = (0.0299566f * input.r) + (0.184309f * input.g) + (1.46709f * input.b);
    
                float l;
                float m;
                float s;

	            // Simulate color blindness
    
	            if (_Type == 0){ // Protanope - reds are greatly reduced (1% men)
		            l = 0.0f * L + 2.02344f * M + -2.52581f * S;
		            m = 0.0f * L + 1.0f * M + 0.0f * S;
		            s = 0.0f * L + 0.0f * M + 1.0f * S;
	            }
    
	            if (_Type == 1){ // Deuteranope - greens are greatly reduced (1% men)
		            l = 1.0f * L + 0.0f * M + 0.0f * S;
		            m = 0.494207f * L + 0.0f * M + 1.24827f * S;
		            s = 0.0f * L + 0.0f * M + 1.0f * S;
	            }
    
	           if (_Type == 2){ // Tritanope - blues are greatly reduced (0.003% population)
		            l = 1.0f * L + 0.0f * M + 0.0f * S;
		            m = 0.0f * L + 1.0f * M + 0.0f * S;
		            s = -0.395913f * L + 0.801109f * M + 0.0f * S;
	            }
    
	            float4 error;
	            error.r = (0.0809444479f * l) + (-0.130504409f * m) + (0.116721066f * s);
	            error.g = (-0.0102485335f * l) + (0.0540193266f * m) + (-0.113614708f * s);
	            error.b = (-0.000365296938f * l) + (-0.00412161469f * m) + (0.693511405f * s);
	            error.a = 1;

	            return error.rgba;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col;

                if(_isLerp == 0) col = _Color1 * (1.0 + _Percentile);
                if(_isLerp == 1) col = lerp(_Color1, _Color2, _Percentile);

                if (_Type == -1) { clip(-1); }

                col.xyz = Daltonize(col); 

                return col;
            }
            ENDCG
        }
    }
}
