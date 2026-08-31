# Code to control within-plane z-scanning in ScanImage

These are instructions on how to implement z-scanning within a single imaging plane in ScanImage. The main idea is to create a new Matlab GUI that runs independently of ScanImage (`field_curvature_GUI.m`). With this GUI, the user can interactively shape the z-scan "waveform". This waveform is then saved to disk. Then, ScanImage reads the saved waveform from disk (hard-coded path) and applies it if the "Field curvature" checkbox in the main ScanImage GUI window is checked (controlled by the variable `hSI.hFastZ.enableFieldCurveCorr`).

<p align="center"><img src="https://github.com/HelmchenLabSoftware/K-mirror/blob/main/ScanImage%20code/Field_curvature_GUI_screenshot.png"  width="60%"></p>


To use the code, please follow these instructions (tested in ScanImage Premium 2023 and 2024):

1. Copy the file `field_curvature_GUI.m` to your computer.
2. Adapted the hard-coded path used by `field_curvature_GUI.m` to save the waveform.
3. Use the code in `Insert_code_into_WaveformManager.m` and insert it into ScanImage's script `WaveformManager.m`. This script can be found under `+scanimage/+components/WaveformManager.m`. You do not have to delete anything, only to add the condition `if obj.hSI.hFastZ.enableFieldCurveCorr == 1` to the function `updateWaveforms()`.
4. Adapt the hard-coded path in this script where the saved waveform (`Piecewise_data.mat`) is loaded.
5. Run `field_curvature_GUI.m` and create a within-plane z-scan waveform; save it.
6. Check the box "Control Field Curvature".
7. Start scanning with "Focus" or "Grab"

