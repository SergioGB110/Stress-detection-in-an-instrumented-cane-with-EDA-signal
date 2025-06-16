function [vec_time,vec_secuencia]=playAudio(audio,secuencia,fs)
% Se reproduce
sound(audio,fs)
% Pintamos la secuencia
figure, plot((1:length(audio))/fs,secuencia,'b')
t_inicial = tic;  % Iniciar temporizador
vec_time = [];
vec_secuencia = [];
for cursor = 1:10000:length(audio)
    vec_time = [vec_time,datetime('now', 'TimeZone', 'Europe/Madrid', 'Format', 'dd-MM-yyyy HH:mm:ss.SSSSSS')];
    vec_secuencia = [vec_secuencia, secuencia(cursor)];
    plot((1:length(audio))/fs,secuencia,'b')
    hold on
    plot((1:cursor)/fs,secuencia(1:cursor),'r-*');
    hold off

    % Calcular el tiempo transcurrido y ajustar la pausa
    t_esperado = cursor/fs;
    t_transcurrido = toc(t_inicial);
    t_restante = t_esperado - t_transcurrido;
    
    if t_restante > 0
        pause(t_restante);
    end
end
end