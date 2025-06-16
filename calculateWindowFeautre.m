function tabla = calculateWindowFeautre (windows_GSR,windows_TONIC,windows_PHASIC)   
            %GSR
            %maximum
            gsrMaxValue = max(windows_GSR);
            %minimum
            gsrMinValue = min(windows_GSR);
            %Range
            gsrRangeValue = gsrMaxValue-gsrMinValue;
            %mean
            gsrMeanValue = mean(windows_GSR);
            %std
            gsrStdValue = std(windows_GSR);
            %Median
            gsrMedianValue = median(windows_GSR);
            %mode
            gsrModeValue = mode(windows_GSR);          
        %TONIC
            %maximum
            tonicMaxValue = max(windows_TONIC);
            %minimum 
            tonicMinValue = min(windows_TONIC);
            %Range
            tonicRangeValue = tonicMaxValue-tonicMinValue;
            %mean
            tonicMeanValue = mean(windows_TONIC);
            %std
            tonicStdValue = std(windows_TONIC);
            %Quartile 25
            tonicQuartile25Value = quantile(windows_TONIC,0.25);
            %Quartile 75
            tonicQuartile75Value = quantile(windows_TONIC,0.75);

        %PHASIC
            %minimum
            phasicMinValue = min(windows_PHASIC);
            %maximum
            phasicMaxValue = max(windows_PHASIC);
            %Range
            phasicRangeValue = phasicMaxValue-phasicMinValue;
            %mean
            phasicMeanValue = mean(windows_PHASIC);
            %std
            phasicStdValue = std(windows_PHASIC);
            %energy
            phasicEnergyValue = sum(windows_PHASIC.^2)/4;%fs = 4
            %Median
            phasicMedianValue = median(windows_PHASIC);
            %Mode
            phasicModeValue = mode(windows_PHASIC);
            %RMS Root Mean Square
            phasicRMSValue = sqrt(sum(windows_PHASIC.^2)/5*4);
            %Quartile 25
            phasicQuartile25Value = quantile(windows_PHASIC,0.25);
            %Quartile 75
            phasicQuartile75Value = quantile(windows_PHASIC,0.75);
            %peaks 5 characteristics
            [phasicStrongPeakValue, phasicNumPeaksValue,phasicRiseTimeValue,phasicHalfRecoveryTimeValue,phasicPeakEnergyValue, MaxPeak,...
                MeanWindow,TamSignal,state,DataTonset, DataTpeak] = Peaks(windows_PHASIC, 0, 4, 0, 0, 0,[0,0],[0,0],0,1);
            
%Construcción de la tabla
tabla = table( ...
        gsrMaxValue, gsrMinValue,gsrRangeValue,gsrMeanValue, gsrStdValue, gsrMedianValue, gsrModeValue, ...
        tonicMaxValue, tonicMinValue, tonicRangeValue, tonicMeanValue, tonicStdValue, ...
        tonicQuartile25Value, tonicQuartile75Value, ...
        phasicMinValue, phasicMaxValue, phasicRangeValue, phasicMeanValue, ...
        phasicEnergyValue, phasicStdValue, ...
        phasicStrongPeakValue, phasicNumPeaksValue, phasicRiseTimeValue, ...
        phasicHalfRecoveryTimeValue, phasicPeakEnergyValue, ...
        phasicMedianValue,phasicModeValue, phasicRMSValue, ...
        phasicQuartile25Value, phasicQuartile75Value ...
    );
end