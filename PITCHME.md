##  

![Logo](dicomImport/matrad_logo.png)
An open source software for radiation treatment planning of intensity-modulated photon, proton, and carbon ion therapy.

---

### matRad provides functionalites for 

- DICOM import
- Ray tracing
- Photon dose calculation
- Proton & Carbon dose calculation
- Inverse planning 
- Multileaf collimator sequencing
- Treatment plan visualization and evaluation

---
### Code

```
stf       = matRad_generateStf(ct,cst,pln);
dij       = matRad_calcParticleDose(ct,stf,pln,cst);
resultGUI = matRad_fluenceOptimization(dij,cst,pln);
matRadGUI
```
@[1]
@[2-4]

---
### Code
---?gist=becker89/d1681e8ff3ba1e22dd26b645ad6b0544

