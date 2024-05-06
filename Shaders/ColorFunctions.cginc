float4 Daltonize(float4 lms, int type)
            {
	            // RGB to LMS matrix conversion
	            float L = lms.x;
	            float M = lms.y;
	            float S = lms.z;
    
                float l;
                float m;
                float s;

	            // Simulate color blindness
    
	            if (type == 0){ // Protanope - reds are greatly reduced (1% men)
		            l = 0.0f * L + 2.02344f * M + -2.52581f * S;
		            m = 0.0f * L + 1.0f * M + 0.0f * S;
		            s = 0.0f * L + 0.0f * M + 1.0f * S;
	            }
    
	            if (type == 1){ // Deuteranope - greens are greatly reduced (1% men)
		            l = 1.0f * L + 0.0f * M + 0.0f * S;
		            m = 0.494207f * L + 0.0f * M + 1.24827f * S;
		            s = 0.0f * L + 0.0f * M + 1.0f * S;
	            }
    
	           if (type == 2){ // Tritanope - blues are greatly reduced (0.003% population)
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

float4 LMSconvert(float4 input)
{
				float L = (17.8824f * input.r) + (43.5161f * input.g) + (4.11935f * input.b);
	            float M = (3.45565f * input.r) + (27.1554f * input.g) + (3.86714f * input.b);
	            float S = (0.0299566f * input.r) + (0.184309f * input.g) + (1.46709f * input.b);

				return float4(L,M,S, 1.0);
}

float3 RGBtoLMS(float3 rgb) {
                float3x3 rgbToLms = float3x3(
                    31.3989492, 63.95129383, 4.64975462,
                    15.53714069, 75.78944616, 8.67014186,
                    1.77515606, 10.94420944, 87.25692246
                );
                return mul(rgbToLms, rgb);
}

float3 LMStoRGB(float3 lms) {
                float3x3 lmsToRgb = float3x3(
                    0.0547, -0.0464, 0.0017,
                    -0.0112, 0.0229, -0.0017,
                    0.0002, -0.0019, 0.0116
                );
                return mul(lmsToRgb, lms);
}

float3 lmsColorToTritanopia(float3 lms) {

                float4 e = float4(65.5178, 34.4782, 1.68427, 1); //RGB white in LMS space
                float l = lms.x;
                float m = lms.y;
                float s = lms.z;

                // Determine the anchor
                float2 anchor = (m / l) < (e.y / e.x)
                    ? float2(0.0930085, 0.00730255) // 660nm
                    : float2(0.163952, 0.268063); // 485nm

                // Coefficients for the line equation
                float a = (e.y * anchor.y) - (e.z * anchor.x);
                float b = (e.z * anchor.x) - (e.x * anchor.y);
                float c = (e.x * anchor.y) - (e.y * anchor.x);

                // Compute the new S value
                float newS = -((a * l) + (b * m)) / c;

                return float3(l, m, newS);
}