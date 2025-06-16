function [limit_preevent, preevent_features_cane, preevent_features_empatica, limit_postevent, postevent_features_cane,...
    postevent_features_empatica] = calculateFeaturesM (data_struct, indice)
%INPUTS
%{
    -limit_preevent = matriz de 2 columnas y 6 filas que nos da la hora en datetime del inicio y fin de la ventana de pre-evento
    -preevent_features = matriz con las características para las 6 ventanas de pre-event
    -limit_postevent = matriz de 2 columnas y 6 filas que nos da la hora en datetime del inicio y fin de la ventana de post-evento
    -postevent_features = matriz con las características para las 6 ventanas de post-event
%}
%OUTPUTS
%{
    -data_struct = ej datos.S10
    -indice = nos dice que participante es para incluirlo en la tabla
%}
% PARAMETERS
fs = 4; % Para las GSR son 4Hz
window_size = 5*fs;
vec_events = data_struct.audioEventVector.data;

% ALGORITHM
% 1. Encontrar las posiciones de los eventos
pos = find(vec_events == 1);
pos = [pos, pos - [0; pos(1:end-1)]];
posdif1 = find(pos(:,2) ~= 1);
pos = pos(posdif1);

% 2. Crear las ventanas
limit_preevent = zeros(length(pos), 2);
limit_postevent = zeros(length(pos), 2);

for i = 1:length(pos)
    % Tiempos de evento
    t_event = data_struct.audioEventVector.TimeStampDate(pos(i));
    % Ventana pre-evento
    t_pre_start = t_event - seconds(window_size/fs);
    t_pre_end = t_event;
    % Ventana post-evento
    t_post_start = t_event;
    t_post_end = t_event + seconds(window_size/fs);
    % Índices más cercanos en la señal GSR para pre-evento
    [~, idxInicio_pre] = min(abs(data_struct.caneData.Music.GSR.TimeStampDate - t_pre_start));
    [~, idxFin_pre] = min(abs(data_struct.caneData.Music.GSR.TimeStampDate - t_pre_end));
    limit_preevent(i,:) = [idxInicio_pre, idxFin_pre];
    % Índices más cercanos en la señal GSR para post-evento
    [~, idxInicio_post] = min(abs(data_struct.caneData.Music.GSR.TimeStampDate - t_post_start));
    [~, idxFin_post] = min(abs(data_struct.caneData.Music.GSR.TimeStampDate - t_post_end));
    limit_postevent(i,:) = [idxInicio_post, idxFin_post];
end
% Ventanas de pre-evento y cálculo de características
id = strcat("S", num2str(indice));
% Inicializar tablas acumuladoras
preevent_features_cane = table();
preevent_features_empatica = table();
%Normalización de los datos
%cane
caneGSR = (data_struct.caneData.Music.GSR.data-min(data_struct.caneData.Music.GSR.data))/...
    (max(data_struct.caneData.Music.GSR.data)-min(data_struct.caneData.Music.GSR.data));
caneTONIC = (data_struct.caneData.Music.TONIC.data-min(data_struct.caneData.Music.TONIC.data))/...
    (max(data_struct.caneData.Music.TONIC.data)-min(data_struct.caneData.Music.TONIC.data));
canePHASIC = (data_struct.caneData.Music.PHASIC.data-min(data_struct.caneData.Music.PHASIC.data))/...
    (max(data_struct.caneData.Music.PHASIC.data)-min(data_struct.caneData.Music.PHASIC.data));
%Empatica
empaticaGSR = (data_struct.empaticaData.Music.GSR.data-min(data_struct.empaticaData.Music.GSR.data))/...
    (max(data_struct.empaticaData.Music.GSR.data)-min(data_struct.empaticaData.Music.GSR.data));
empaticaTONIC = (data_struct.empaticaData.Music.TONIC.data-min(data_struct.empaticaData.Music.TONIC.data))/...
    (max(data_struct.empaticaData.Music.TONIC.data)-min(data_struct.empaticaData.Music.TONIC.data));
empaticaPHASIC = (data_struct.empaticaData.Music.PHASIC.data-min(data_struct.empaticaData.Music.PHASIC.data))/...
    (max(data_struct.empaticaData.Music.PHASIC.data)-min(data_struct.empaticaData.Music.PHASIC.data));

for i = 1:length(limit_preevent)
    %Cane
    windows_preevent_caneGSR = caneGSR(limit_preevent(i,1):limit_preevent(i,2));
    windows_preevent_caneTONIC = caneTONIC(limit_preevent(i,1):limit_preevent(i,2));
    windows_preevent_canePHASIC = canePHASIC(limit_preevent(i,1):limit_preevent(i,2));
%Se llama a una función que calcula las características y nos la da en
    %una tabla de columnas número de características y una fila
    tablewindow_cane = calculateWindowFeautre (windows_preevent_caneGSR,windows_preevent_caneTONIC,windows_preevent_canePHASIC);
    tablewindow_cane.("ID participante") = repmat(string(id), height(tablewindow_cane), 1);
    preevent_features_cane = [preevent_features_cane; tablewindow_cane];
    

    %Empatica
    windows_preevent_empaticaGSR = empaticaGSR(limit_preevent(i,1):limit_preevent(i,2));
    windows_preevent_empaticaTONIC = empaticaTONIC(limit_preevent(i,1):limit_preevent(i,2));
    windows_preevent_empaticaPHASIC = empaticaPHASIC(limit_preevent(i,1):limit_preevent(i,2));
    tablewindow_empatica = calculateWindowFeautre (windows_preevent_empaticaGSR,windows_preevent_empaticaTONIC,windows_preevent_empaticaPHASIC);
    tablewindow_empatica.("ID participante") = repmat(string(id), height(tablewindow_empatica), 1);
    preevent_features_empatica = [preevent_features_empatica; tablewindow_empatica];
end
%Ventanas de Post-evento
% Inicializar tablas acumuladoras
postevent_features_cane = table();
postevent_features_empatica = table();

for i = 1:length(limit_postevent)
    %Cane
    windows_postevent_caneGSR = caneGSR(limit_postevent(i,1):limit_postevent(i,2));
    windows_postevent_caneTONIC = caneTONIC(limit_postevent(i,1):limit_postevent(i,2));
    windows_postevent_canePHASIC = canePHASIC(limit_postevent(i,1):limit_postevent(i,2));
%Se llama a una función que calcula las características y nos la da en
    %una tabla de columnas número de características y una fila
    tablewindow_cane = calculateWindowFeautre (windows_postevent_caneGSR,windows_postevent_caneTONIC,windows_postevent_canePHASIC);
    tablewindow_cane.("ID participante") = repmat(string(id), height(tablewindow_cane), 1);
    postevent_features_cane = [postevent_features_cane; tablewindow_cane];
    

    %Empatica
    windows_postevent_empaticaGSR = empaticaGSR(limit_postevent(i,1):limit_postevent(i,2));
    windows_postevent_empaticaTONIC = empaticaTONIC(limit_postevent(i,1):limit_postevent(i,2));
    windows_postevent_empaticaPHASIC = empaticaPHASIC(limit_postevent(i,1):limit_postevent(i,2));
    tablewindow_empatica = calculateWindowFeautre (windows_postevent_empaticaGSR,windows_postevent_empaticaTONIC,windows_postevent_empaticaPHASIC);
    tablewindow_empatica.("ID participante") = repmat(string(id), height(tablewindow_empatica), 1);
    postevent_features_empatica = [postevent_features_empatica; tablewindow_empatica];
end



end