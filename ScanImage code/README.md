# Matlab code to control within-plane z-scanning in ScanImage

These are instructions on how to implement z-scanning within an imaging plane in [ScanImage](https://www.mbfbioscience.com/products/scanimage/).

The main idea is to create a new Matlab GUI that runs independently of ScanImage (`field_curvature_GUI.m`). With this GUI, the user can interactively shape the z-scan "waveform" (see below for a screenshot). This waveform is saved to disk to a hard-coded path. Then, ScanImage reads the saved waveform from this hard-coded path and applies it to the z-scanning device (e.g., electrically tunable lens, piezo, voice coil motor).

<p align="center"><img src="https://github.com/HelmchenLabSoftware/K-mirror/blob/main/ScanImage%20code/Field_curvature_GUI_screenshot.png"  width="60%"></p>

To use the code, please follow these instructions:

1. Copy the file `field_curvature_GUI.m` to your computer.
2. Adapted the hard-coded path used by `field_curvature_GUI.m` to save the waveform.
3. Use the code in `Insert_code_into_WaveformManager.m` and insert it into ScanImage's script `WaveformManager.m`. This script can be found under `+scanimage/+components/WaveformManager.m`. You do not have to delete anything, only to add the condition `if obj.hSI.hFastZ.enableFieldCurveCorr == 1` to the function `updateWaveforms()`.
4. Adapt the hard-coded path in this script where the saved waveform (`Piecewise_data.mat`) is loaded.
5. Run `field_curvature_GUI.m` and create a within-plane z-scan waveform; save it.
6. Check the box "Control Field Curvature"; this sets the variable `hSI.hFastZ.enableFieldCurveCorr` to `True`.
7. Start scanning with "Focus" or "Grab".
8. Enjoy.

We also provide code for analogous within-plane control of the Pockels cell (`pockels_control_GUI.m`). The GUIs were written with the help of AI (Gemini) and improved by the user. All code was tested with ScanImage Premium 2023 and 2024. For questions, please reach out via [email](mailto:p.t.r.rupprecht+kmirror@gmail.com).

