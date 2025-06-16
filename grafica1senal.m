function grafica1senal(datos,indice)
substruct = datos.(['S',num2str(indice)]);
%Componente GSR
GSRempatica = (substruct.empaticaData.Music.GSR.data-min(substruct.empaticaData.Music.GSR.data))/(max(substruct.empaticaData.Music.GSR.data)-min(substruct.empaticaData.Music.GSR.data));
GSRbaston = (substruct.caneData.Music.GSR.data-min(substruct.caneData.Music.GSR.data))/(max(substruct.caneData.Music.GSR.data)-min(substruct.caneData.Music.GSR.data));
%Componente tónica
tonicaempatica = (substruct.empaticaData.Music.TONIC.data-min(substruct.empaticaData.Music.TONIC.data))/(max(substruct.empaticaData.Music.TONIC.data)-min(substruct.empaticaData.Music.TONIC.data));
tonicabaston = (substruct.caneData.Music.TONIC.data-min(substruct.caneData.Music.TONIC.data))/(max(substruct.caneData.Music.TONIC.data)-min(substruct.caneData.Music.TONIC.data));
%Componente fásica
fasicaempatica = (substruct.empaticaData.Music.PHASIC.data-min(substruct.empaticaData.Music.PHASIC.data))/(max(substruct.empaticaData.Music.PHASIC.data)-min(substruct.empaticaData.Music.PHASIC.data));
fasicabaston = (substruct.caneData.Music.PHASIC.data-min(substruct.caneData.Music.PHASIC.data))/(max(substruct.caneData.Music.PHASIC.data)-min(substruct.caneData.Music.PHASIC.data));

%Dibujar subplots
figure,
%Gráfico de la GSR
subplot(3,1,1)
plot(substruct.empaticaData.Music.GSR.TimeStampDate,GSRempatica);
hold on
plot(substruct.caneData.Music.GSR.TimeStampDate,GSRbaston);
%Audio de eventos
plot(substruct.audioEventVector.TimeStampDate,substruct.audioEventVector.data);
title(['Componente GSR del participante ',(['S',num2str(indice)])]);
legend('Empatica', 'Bastón','Eventos');
hold off
%Gráfico de la tónica
subplot(3,1,2)
plot(substruct.empaticaData.Music.TONIC.TimeStampDate,tonicaempatica);
hold on
plot(substruct.caneData.Music.TONIC.TimeStampDate,tonicabaston);
%Audio de eventos
plot(substruct.audioEventVector.TimeStampDate,substruct.audioEventVector.data);
title(['Componente Tónica del participante ',(['S',num2str(indice)])]);
legend('Empatica', 'Bastón','Eventos');
hold off
%Gráfico de la fásica
subplot(3,1,3)
plot(substruct.empaticaData.Music.PHASIC.TimeStampDate,fasicaempatica);
hold on
plot(substruct.caneData.Music.PHASIC.TimeStampDate,fasicabaston);
%Audio de eventos
plot(substruct.audioEventVector.TimeStampDate,substruct.audioEventVector.data);
title(['Componente fásica del participante ',(['S',num2str(indice)])]);
legend('Empatica', 'Bastón','Eventos');
hold off
