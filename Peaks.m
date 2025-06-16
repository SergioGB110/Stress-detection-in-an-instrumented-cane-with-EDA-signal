function [StrongPeak, NumPeaks,RiseTime,HalfRecoveryTime,PeakEnergy, MaxPeak, MeanWindow, TamSignal,state, DataTonset, DataTpeak] = Peaks(WindowSignal,...
    winOverlapTime, fs, WinMeanB, TamB, Max,TonsetData,TpeakData,j,state)
%Características de salida
    StrongPeak = 0;
    NumPeaks = 0;
    RiseTime = 0;
    HalfRecoveryTime = 0;
    PeakEnergy = 0;
%Variables de salida que se usan a modo de realimentación con la siguiente llamada
    MaxPeak = Max;
    MeanWindow = 0;
    DataTonset = TonsetData;
    DataTpeak = TpeakData;
%Matrices de características podría darse que haya más de un pico por lo
%que se guarda en matrices y las características de salida son la media de
%estas matrices
    HalfRecoveryTimeMatrix = 0;
    StrongPeakMatrix = 0;
    RiseTimeMatrix = 0;
    PeakEnergyMatrix = 0;
%---------------------------------------------
%Algoritmo en sí
%Calculate the new threshold
    tamwindow = length(WindowSignal);
    if (winOverlapTime<0.1)
        %La primera ventana no tiene solape
        Signal = WindowSignal;
    else
        %Para las demás ventanas. Tengo que revisarlo bien pero creo que
        %con esta parte no cojo solape
        Signal = WindowSignal(tamwindow-winOverlapTime*fs:end);
    end
    MaxSignal = max(Signal);
    if (MaxSignal > Max)
        MaxPeak = MaxSignal;
    end
    TamSignal = length(Signal);
    MeanWindow = (WinMeanB*TamB+sum(Signal))/(TamB+TamSignal);
    threshold = 1/4*(MeanWindow + MaxPeak);
    cpeak = 0;
    ctonset = 0;
    derivada(1) = 0;
    vantd = 0;
    cuentatonset = 0;
%Suavizo la señal para eliminar ruido
    SmoothSignal = smooth(Signal,3);
    for cont = 2:length(SmoothSignal)-1
        derivada(cont) = fs*(SmoothSignal(cont+1) - SmoothSignal(cont-1))/2;
        if state == 1
            %Estado 1 es no hay tiempo de onset y de pico anterior, entonces
            %buscamos tiempo de onset
            if (vantd<0 && derivada(cont)>0)% -+
                ctonset = ctonset + 1;
                if (winOverlapTime>0.1)
                    TimeOnset(ctonset,1) = cont + (tamwindow-winOverlapTime*fs);
                else
                    TimeOnset(ctonset,1) = cont;
                end
                TimeOnset(ctonset,2) = SmoothSignal(cont);
                DataTonset = [(j+TimeOnset(ctonset,1))/fs,TimeOnset(ctonset,2)];
                state = 2;
            end
        elseif (state == 2)
            %Aquí volvemos al estado 1 si hay más de 20 veces que la
            %derivada da 0 o es positiva, se puede configurar. Esto evita
            %un falso tiempo de onset
            if (derivada(cont) <= 0)
                cuentatonset = cuentatonset + 1;
                if(cuentatonset > 20)
                    %Volvemos al estado 1 y dejamos preparado ctonset para
                    %modificarlo en el estado 1
                    cuentatonset = 0;
                    ctonset = ctonset - 1;
                    state = 1;
                    DataTonset = [0,0];
                end
            else
                cuentatonset = 0;
            end
            %Buscamos picos
            if (vantd>=0 && derivada(cont)<0 && SmoothSignal(cont-1)>threshold)
                cpeak = cpeak+1;
                if (winOverlapTime>0.1)
                    pico(cpeak,1) = cont-1+tamwindow-winOverlapTime*fs;
                else
                    pico(cpeak,1) = cont-1;
                end
                pico(cpeak,2) = SmoothSignal(cont-1);
                state = 3;
                DataTpeak = [(j+pico(cpeak,1))/fs,pico(cpeak,2)];
                StrongPeakMatrix = [StrongPeakMatrix;DataTpeak(2)-DataTonset(2)];
                RiseTimeMatrix = [RiseTimeMatrix;DataTpeak(1)-DataTonset(1)];
                PeakEnergyMatrix = [PeakEnergyMatrix;0.5*RiseTimeMatrix(end)*StrongPeakMatrix(end)];
            end

        else
            %State = 3, esperamos a tener la mitad de la amplitud de pico
            %para el Half recovery time
            cpeak =1;
            if (SmoothSignal(cont)<=DataTpeak(2)/2)
                if (winOverlapTime>0.1)
                    HRtime = cont+tamwindow-winOverlapTime*fs;
                else
                    HRtime = cont;
                end
                StrongPeakMatrix = [StrongPeakMatrix;DataTpeak(2)-DataTonset(2)];
                RiseTimeMatrix = [RiseTimeMatrix;DataTpeak(1)-DataTonset(1)];
                HalfRecoveryTimeMatrix = [HalfRecoveryTimeMatrix;(HRtime+j)/fs-DataTpeak(1)];
                
                state = 1;
                DataTonset = [0,0];
                DataTpeak = [0,0];
            end
        end
        vantd = derivada(cont);        
    end


%---------------------------------------------

    %---------------------------------------------
    %Calculate characteristics
    if (length(StrongPeakMatrix)>1)
        StrongPeak = mean(StrongPeakMatrix(2:end));
    end
    if (length(RiseTimeMatrix)>1)
        RiseTime = mean(RiseTimeMatrix(2:end));
    end
    if (length(HalfRecoveryTimeMatrix)>1)
        HalfRecoveryTime = mean(HalfRecoveryTimeMatrix(2:end));
    end
    if (length(PeakEnergyMatrix)>1)
        PeakEnergy = mean(PeakEnergyMatrix(2:end));
    end
    NumPeaks = cpeak;

end