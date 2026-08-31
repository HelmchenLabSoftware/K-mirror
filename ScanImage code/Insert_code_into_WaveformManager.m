        
        function updateWaveforms(obj,forceOptimizationCheck)
            % function to regenerate command waveforms for scanner control
            % automatically checks waveform cache for optimized waveforms
            % waveforms are stored in hSI.hWaveformManger.scannerAO

            !! Keep the normal ScanImage code here!!
            
            
            if obj.hSI.hFastZ.enableFieldCurveCorr == 1
                
                load('C:\Scanimage\SI-Premium_2023\field_curvature\Piecewise_data.mat','smoothedY');
                
                voltage_command_v1 = smoothedY*0.133;
                voltage_command_v1 = [voltage_command_v1,voltage_command_v1,voltage_command_v1];
                voltage_command_v2 = resample(voltage_command_v1,3*numel(scannerAO_.pathFOV.Z)/obj.hSI.hStackManager.numFramesPerVolume,numel(voltage_command_v1));
                lv = numel(scannerAO_.pathFOV.Z)/obj.hSI.hStackManager.numFramesPerVolume;
                voltage_command_v2 = voltage_command_v2(lv+1:2*lv);
                
                voltage_command_v2 = min(max(voltage_command_v2,0),10);
                voltage_command_v3 = squeeze(repmat(voltage_command_v2,[1 obj.hSI.hStackManager.numFramesPerVolume]))';
                voltage_command_v3 = voltage_command_v3 + scannerAO_.ao_volts.Z;
                voltage_command_v4 = min(max(smooth([voltage_command_v3,voltage_command_v3,voltage_command_v3],1000),0),10);
                voltage_command_v4 = voltage_command_v4((numel(voltage_command_v3)+1):numel(voltage_command_v3)*2);
                
                % figure(14141); plot(scannerAO_.ao_volts.Z,'k'); hold on;
                scannerAO_.pathFOV.Z = voltage_command_v4;
                scannerAO_.ao_volts_raw.Z = voltage_command_v4;
                scannerAO_.ao_volts.Z = voltage_command_v4;
                % figure(14141); plot(scannerAO_.ao_volts.Z,'r'); hold off;
                % box off; set(gca,'TickDir','out');
                % xlabel('Sampling points'); ylabel('Output voltage (V)');
                % title('ETL driving voltage')
                
                load('C:\Scanimage\SI-Premium_2023\field_curvature\Piecewise_data_pockels.mat','smoothedY');
                
                pockels_cell_multiplier = [smoothedY,smoothedY,smoothedY];
                pockels_cell_multiplier2 = resample(pockels_cell_multiplier,3*numel(scannerAO_.ao_volts.B),numel(pockels_cell_multiplier));
                lv = numel(scannerAO_.ao_volts.B);
                pockels_cell_multiplier2 = pockels_cell_multiplier2(lv+1:2*lv);
                
                scannerAO_.ao_volts.B = scannerAO_.ao_volts.B.*pockels_cell_multiplier2';

		% figure(121), plot(scannerAO_.ao_volts_raw.Z,'b'); hold on;
		% plot(scannerAO_.ao_volts.Z+1,'r'); hold off             
		% figure, plot(scannerAO_.ao_volts.Z)

            end
            
            obj.scannerAO = scannerAO_;
        end
        
 