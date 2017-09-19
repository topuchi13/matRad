##  
![Logo](dicomImport/matrad_logo.png)

A radiation treatment planning software for intensity-modulated <span style="color:rgb(0,107,182): font-size: 4em;">photon</span>, <span style="color:rgb(0,107,182)">proton</span>, and <span style="color:rgb(0,107,182)">carbon ion</span> therapy.

https://e0404.github.io/matRad/
---
## Free Software for reasearch and education
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
@[11](dose calculation - obtain dose influence matrix)
@[13](inverse planning for IMPT)
@[15](start GUI for visualization of result)
---
![Logo](https://github.com/e0404/matRad/wiki/images/matRadvalidation.png)
---
### Performance 
![Logo](https://github.com/e0404/matRad/wiki/images/matRadPerformanceTable.png)
---
### matRad webinar 
![Video](https://www.youtube.com/embed/40_n7BIqLdw)
---
## Get in touch
### https://e0404.github.io/matRad/
### matRad@dkfz.de

---
### Code Example
+++?gist=becker89/fc6031d7c87dd4f2e16d7a72598a5556
@[1-2](Lets simulate a lateral displacement in x of the second beam)
@[4](recalculate dose using previously optimized beamlet weights)
@[6](determine axial iso center slice)
@[8](calculate dose difference)
@[10](plot dose difference slice)
---
### Code Example

```matlab
%% dose calculation
if strcmp(pln.radiationMode,'photons')
    dij = matRad_calcPhotonDose(ct,stf,pln,cst);
    %dij = matRad_calcPhotonDoseVmc(ct,stf,pln,cst);
elseif strcmp(pln.radiationMode,'protons') || strcmp(pln.radiationMode,'carbon')
    dij = matRad_calcParticleDose(ct,stf,pln,cst);
end
```