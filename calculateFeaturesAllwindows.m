function [tableempaticapreevent,tableempaticapostevent,tablecanepreevent,tablecanepostevent] = calculateFeaturesAllwindows(data)
%INPUTS
%{  data = datos procesados por la función 'loadAllData.m'
%}
%OUTPUTS
%{
    tableempaticapreevent = tabla de características de la empatica de las ventanas de pre_evento
    tableempaticapostevent = tabla de características de la empatica de las ventanas de post_evento
    tablecanepreevent = tabla de características del bastón de las ventanas de pre_evento
    tablecanepostevent = tabla de características del bastón de las ventanas de post_evento
%}
%INICIALIZACIONES

rechazo = [];
%rechazo = [3 8 10 13 14 15 16 18];
tableempaticapreevent = table();
tableempaticapostevent = table();
tablecanepreevent = table();
tablecanepostevent = table();
participante = fieldnames(data);
for i = 1:length(participante)
    nombre = participante{i};
    % Extraer número del participante
    num_part = str2double(extractAfter(nombre, 'S'));    
    % Verificar si está en la lista de exclusión
    if ismember(num_part, rechazo)
        continue  % Saltar este participante
    end
    % Obtener subestructura de datos
    data_struct = data.(nombre);
    [limit_preevent, preevent_features_cane, preevent_features_empatica, limit_postevent, postevent_features_cane,...
        postevent_features_empatica] = calculateFeaturesM (data_struct, num_part);
    tableempaticapreevent = [tableempaticapreevent;preevent_features_empatica];
    tableempaticapostevent = [tableempaticapostevent;postevent_features_empatica];
    tablecanepreevent = [tablecanepreevent;preevent_features_cane];
    tablecanepostevent = [tablecanepostevent;postevent_features_cane];
    disp([nombre,'Hecho']);
end