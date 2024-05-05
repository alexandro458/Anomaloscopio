using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;

public class ToggleTypeManager : MonoBehaviour
{
    public List<Toggles> toggles;  // Array de todos los toggles en el grupo

    public Toggle adaptedReferencesToggle;
    public GameObject[] itemsToHide;

    private Anomaloscope appManager;

    void Start()
    {
        appManager = GetComponent<Anomaloscope>();
        foreach (Toggles obj in toggles)
        {
            obj.toggle.onValueChanged.AddListener(delegate { ToggleValueChanged(obj.toggle); });
        }
        adaptedReferencesToggle.onValueChanged.AddListener(delegate { HideReferences(adaptedReferencesToggle.isOn); });
    }

    void ToggleValueChanged(Toggle changedToggle)
    {
        if (changedToggle.isOn)
        {
            foreach (Toggles obj in toggles)
            {
                if (obj.toggle != changedToggle)
                {
                    obj.toggle.isOn = false;
                }
                else
                {
                    appManager.type = obj.type;
                }
            }
        }
    }

    void HideReferences(bool isActive)
    {
        foreach (GameObject obj in itemsToHide)
        {
            obj.SetActive(isActive);
        }
    }
}

[System.Serializable]
public class Toggles
{
    public Toggle toggle;
    public Type type;
}
