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
            #include "ColorFunctions.cginc"

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

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col;

                float4 fixedColor1 = LMSconvert(_Color1);
                float4 fixedColor2 = LMSconvert(_Color2);

                if(_isLerp == 0) col = _Color1 * (1.0 + _Percentile);
                if(_isLerp == 1) col = lerp(_Color1, _Color2, _Percentile);

                if (_Type == -1) { clip(-1); }

                col = Daltonize(LMSconvert(col), _Type); 

                return col;
            }
            ENDCG
        }
    }
}
