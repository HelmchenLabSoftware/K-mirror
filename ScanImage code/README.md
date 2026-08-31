## Matlab code to control within-plane z-scanning in ScanImage

### Overview

These are instructions on how to implement z-scanning within an imaging plane in [ScanImage](https://www.mbfbioscience.com/products/scanimage/).

<p align="center"><img src="https://github.com/HelmchenLabSoftware/K-mirror/blob/main/ScanImage%20code/Field_curvature_GUI_screenshot.png"  width="60%"></p>

The **Matlab GUI** to control the z-scanning waveform runs independently of ScanImage (`field_curvature_GUI.m`). With this GUI, the user can **interactively shape the z-scan "waveform"** (see screenshot).

### Installation instructions

1. Copy the file `field_curvature_GUI.m` to your ScanImage computer.
2. Adapted the hard-coded path which is used by `field_curvature_GUI.m` to save the waveform.
3. Use the code provided in `Insert_code_into_WaveformManager.m` and insert it into ScanImage's script `WaveformManager.m`. This script can be found under `+scanimage/+components/WaveformManager.m`. You do not have to delete anything, only add the conditional statement following `if obj.hSI.hFastZ.enableFieldCurveCorr == 1` to the function `updateWaveforms()`.
4. Adapt the hard-coded path in this inserted code snipped to match the path where the waveform was saved (`Piecewise_data.mat`).
5. Run `field_curvature_GUI.m`.
6. Interactively create a within-plane z-scan waveform; save it.
7. Check the box "Control Field Curvature" in ScanImage; this sets the variable `hSI.hFastZ.enableFieldCurveCorr` to `True`.
8. Start scanning with "Focus" or "Grab".
9. You are now adjusting your axial focus within a single plane.

### Further details and contact

We also provide code for analogous within-plane control of the Pockels cell (`pockels_control_GUI.m`). All code was writter by [Peter Rupprecht](https://scholar.google.ch/citations?user=cNQCYjkAAAAJ). The GUIs were written with the help of AI and improved by the user. All code was tested with ScanImage Premium 2023 and 2024. For questions, please reach out via [email](mailto:p.t.r.rupprecht+kmirror@gmail.com).

