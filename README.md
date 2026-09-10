[![License](https://img.shields.io/badge/License-GPL--3.0-brightgreen)](https://github.com/HelmchenLabSoftware/K-mirror/blob/master/LICENSE)
[![Size](https://img.shields.io/github/repo-size/HelmchenLabSoftware/K-mirror?style=plastic)](https://img.shields.io/github/repo-size/HelmchenLabSoftware/K-mirror?style=plastic)
[![Language](https://img.shields.io/github/languages/top/HelmchenLabSoftware/K-mirror?style=plastic)](https://github.com/HelmchenLabSoftware/K-mirror)

## Scan field rotation with a K-mirror

Resources for scan field rotation with a K-mirror for fast two-photon imaging along curved planes. All details are described in our [preprint](https://www.biorxiv.org/content/10.1101/2026.XXXXXXXXX). 

### Overview

This repository provides

1. CAD files for a 3D-printed K-mirror holder,
2. Matlab code for within-plane z-scanning in ScanImage, and
3. Python notebooks with geometric optics simulations.


### 1. CAD files for a 3D-printed K-mirror holder

<p align="center"><img src="https://github.com/HelmchenLabSoftware/K-mirror/blob/main/CAD%20files%203D-printed%20K-mirror/Screenshot_CAD_model_transparent.png"  width="40%"></p>

The 3D-printed K-mirror is described with all details in our [preprint](https://www.biorxiv.org/content/10.1101/2026.XXXXXXXXX).

This folder contains the CAD files for the 3D-printed K-mirror holder as `*.STL` and `*.STEP` files, as well as a CAD model of the assembly together with the Thorlabs 2" rotatory adapter as `*.STL` and `*.PDF` files. The PDF file is an interactive file and is best viewed when downloaded. In addition, the repository also contains a file to 3D-print an adapter for the Leica K-mirror.


### 2. Matlab code to control within-plane z-scanning in ScanImage

This folder contains instructions on how to implement z-scanning within an imaging plane in [ScanImage](https://www.mbfbioscience.com/products/scanimage/).

<p align="center"><img src="https://github.com/HelmchenLabSoftware/K-mirror/blob/main/ScanImage%20code/Field_curvature_GUI_screenshot.png"  width="50%"></p>

The **Matlab GUI** to control the z-scanning waveform runs independently of ScanImage (`field_curvature_GUI.m`). With this GUI, the user can **interactively shape the z-scan "waveform"** (see screenshot).

Installation instructions:

1. Copy the file **`field_curvature_GUI.m`** to your ScanImage computer.
2. Adapt the hard-coded path used by `field_curvature_GUI.m` to save the waveform.
3. Use the code provided in `Insert_code_into_WaveformManager.m` and insert it into ScanImage's script `WaveformManager.m`. This script can be found under `+scanimage/+components/WaveformManager.m`. You do not have to delete anything, only add the conditional statement following `if obj.hSI.hFastZ.enableFieldCurveCorr == 1` to the function `updateWaveforms()`.
4. Adapt the hard-coded path in this inserted code snippet to match the path where the waveform was saved (`Piecewise_data.mat`).
5. Run `field_curvature_GUI.m`.
6. Interactively create a within-plane z-scan waveform; save it.
7. Check the box "Control Field Curvature" in ScanImage; this sets the variable `hSI.hFastZ.enableFieldCurveCorr` to `True`.
8. Start scanning with "Focus" or "Grab".
9. You are now adjusting your axial focus within a single plane.

We also provide code for analogous within-plane control of the Pockels cell (`pockels_control_GUI.m`). All code was written by [Peter Rupprecht](https://scholar.google.ch/citations?user=cNQCYjkAAAAJ). The GUIs were written with the help of AI and improved by the user. All code was tested with ScanImage Premium 2023 and 2024. 


### 3. Python notebooks with geometric optics simulations

This folder contains two Jupyter notebooks that model a K-mirror for scan field rotation in a two-photon microscope. The notebooks use geometric raytracing (Optiland) to simulate the beam through the optical path. The main goal is to check how much of the beam is clipped by the K-mirror at different scan angles, mirror positions, and rotation angles. Parameters (lens focal lengths, mirror sizes, distances) can be edited to test your own microscope setup, and interactive widgets let you explore the geometry and clipping live.

- **`Scanning_space_configuration.ipynb`**: K-mirror placed between the scan lens and the tube lens. Computes beam clipping vs. scan angle.
- **`Infinity_space_configuration.ipynb`**: K-mirror placed between the tube lens and the objective. Computes beam clipping vs. scan angle, and in addition pointing error as a function of K-mirror misalignment.

Additional files include videos to illustrate the interactive use of the widgets, and a piece of Matlab code (`Limacon_de_Pascale.m`) to visualize the limacon de Pascal as a function of alignment errors. For details and context, check out the preprint [preprint](https://www.biorxiv.org/content/10.1101/2026.XXXXXXXXX).


### Questions and contact details

Comments and questions are welcome as GitHub issues or via  [email](mailto:p.t.r.rupprecht+kmirror@gmail.com).
