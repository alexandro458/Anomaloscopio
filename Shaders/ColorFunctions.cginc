
float4 RGBtoLMS(float3 rgb) {
    float4x4 rgbToLms = float4x4(
        17.8824, 43.5161, 4.1193, 0,
        3.4557, 27.1554, 3.8671, 0,
        0.02996, 0.18431, 1.4700, 0,
        0, 0, 0, 1
    );
    return mul(rgbToLms, float4(rgb.xyz, 1.0));
}

float4 LMStoRGB(float3 lms) {
    float4x4 lmsToRgb = float4x4(
            0.0809, -0.1305, 0.1167, 0,
            -0.0102, 0.0540, -0.1136, 0,
            -0.0003, -0.0041, 0.6932, 0,
            0, 0, 0, 1
    );
    return mul(lmsToRgb, float4(lms.xyz, 1.0));
}

float3 lmsColorToProtanopia(float3 lms) {
    float4x4 protanopia = float4x4(
        0, 2.02344, -2.52581, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    );
    return mul(protanopia, float4(lms.xyz, 1.0));
}

float3 lmsColorToDeutanopia(float3 lms) {
    float4x4 deuteranopia = float4x4(
        1, 0, 0, 0,
        0.4942, 0, 1.2483, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    );
    return mul(deuteranopia, float4(lms.xyz, 1.0));
}

float3 lmsColorToTritanopia(float3 lms) {
    float4x4 tritanopia = float4x4(
       1, 0, 0, 0,
      0, 1, 0, 0,
      -0.3959, 0.8011, 0, 0,
      0, 0, 0, 1
    );
    return mul(tritanopia, float4(lms.xyz, 1.0));
}

float3 rgbColorToTritanopia(float3 rgb) {
    float4x4 tritanopia = float4x4(
        1, 0, 0, 0,   
        0, 1, 0, 0,   
        0.2, 0.2, 0.6, 0,
        0, 0, 0, 1
    );
    return mul(tritanopia, float4(rgb.xyz, 1.0));
}

float4 DaltonizeV2(float4 col, int type, float degree)
{
    float4 lmsCol = RGBtoLMS(col.rgb);
    if(type == 0) // Protanope - reds are greatly reduced (1% men)
    {
        lmsCol.xyz = lmsColorToProtanopia(lmsCol);
    }

    if(type == 1) // Deuteranope - greens are greatly reduced (1% men)
    {
        lmsCol.xyz = lmsColorToDeutanopia(lmsCol);
    }

    if(type == 2) // Tritanope - blues are greatly reduced (0.003% population)
    {
        float4 TritanColor = float4(rgbColorToTritanopia(col.xyz).xyz, 1.0);
        return lerp(col, TritanColor, degree);
    }

    lmsCol = LMStoRGB(lmsCol.xyz);

    float4 finalColor = float4( lerp(col.rgb, lmsCol.rgb, degree) , 1.0);

    return finalColor;
    
}