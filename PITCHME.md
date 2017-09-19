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
### GUI
![Logo](https://github.com/e0404/matRad/wiki/images/GUI-Guide_optimizedGUIScreenshot.png)
---

### Code Example
+++?gist=becker89/d1681e8ff3ba1e22dd26b645ad6b0544
@[1](import a open source liver patient)
@[3-7](define your treatment plan)
@[9](generate beam and ray geometry)
@[11](dose calculation - pencil beam algorithm)
@[13](inverse planning for IMPT)
@[15](start GUI for visualization of result)

---

![Logo](https://github.com/e0404/matRad/wiki/images/matRadvalidation.png)

---
### Performance 
![Logo](https://github.com/e0404/matRad/wiki/images/matRadPerformanceTable.png)
---
### matRad webinar 
https://www.youtube.com/watch?v=40_n7BIqLdw&t=1s

![Video](https://www.youtube.com/watch?v=40_n7BIqLdw&t=1s)

### Code Example:
Simulate an iso-center shift

'''
NumBeam = 2;
stf(NumBeam).isoCenter(1) = stf(NumBeam).isoCenter(1) + 3;

resultGUI_isoShift = matRad_calcDoseDirect(ct,stf,pln,cst,w);

IsoCenterSlice = round(stf(1,1).isoCenter);

DoseDiff = resultGUI(:,:,IsoCenterSlice) - resultGUI_isoShift(:,:,IsoCenterSlice);

figure,imagesc(DoseDiff); 
'''
@[1-2](Lets simulate a lateral displacement in x of the second beam)
@[4](recalculate dose using previously optimized beamlet weights)
@[6](determine axial iso center slice)
@[8](calculate dose difference)
@[10](plot dose difference slice)