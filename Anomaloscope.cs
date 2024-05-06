using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

[ExecuteInEditMode]
public class Anomaloscope : MonoBehaviour
{
    public Material colorLerp;
    public Material brightnessLerp;
    public Material lerpAdjusted;
    public Material brightnessAdjusted;

    public Slider colorLerpSlider;
    public Slider brightnessLerpSlider;
    public Slider BlindDegreeSlider;
    public TMP_Text blindDegree;

    public bool hideReference = false;

    public Type type;

    public List<ColorData> colorList;

    private void Start()
    {
        SetColorLerp();
        SetBrightnessLerp();
        SetBlindDegree();
    }

    public void SetColorLerp()
    {
        colorLerp.SetFloat("_Percentile", colorLerpSlider.value);
        lerpAdjusted.SetFloat("_Percentile", colorLerpSlider.value);
    }

    public void SetBrightnessLerp()
    {
        brightnessLerp.SetFloat("_Percentile", brightnessLerpSlider.value);
        brightnessAdjusted.SetFloat("_Percentile", brightnessLerpSlider.value);
    }

    public void SetBlindDegree()
    {
        lerpAdjusted.SetFloat("_BlindDegree", BlindDegreeSlider.value);
        brightnessAdjusted.SetFloat("_BlindDegree", BlindDegreeSlider.value);
        blindDegree.text = BlindDegreeSlider.value.ToString("F1");
    }

    private void Update()
    {
        int index = FindTypeIndex(type);
        colorLerp.SetColor("_Color1", colorList[index].color1);
        colorLerp.SetColor("_Color2", colorList[index].color2);
        lerpAdjusted.SetColor("_Color1", colorList[index].color1);
        lerpAdjusted.SetColor("_Color2", colorList[index].color2);

        brightnessLerp.SetColor("_Color1", colorList[index].yellowColor);
        brightnessAdjusted.SetColor("_Color1", colorList[index].yellowColor);

        int typeValue = (int)type;
        if (hideReference) typeValue = -1;

        brightnessAdjusted.SetInt("_Type", typeValue);
        lerpAdjusted.SetInt("_Type", typeValue);
    }

    private int FindTypeIndex(Type type)
    {
        for(int i = 0; i < colorList.Count; i++)
        {
            if(colorList[i].type == type)
            {
                return i;
            }
        }
        return -1;
    }
}

public enum Type
{
    Protan,
    Deutan,
    Tritan
}

[System.Serializable]
public class ColorData
{
    public Color color1;
    public Color color2;
    public Color yellowColor;

    public Type type;
}
