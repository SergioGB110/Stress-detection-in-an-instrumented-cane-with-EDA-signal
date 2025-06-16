function dataStruct = loadAllData(basePath)
    % Inicializa el struct de salida
    dataStruct = struct();

    % Obtener carpetas que empiezan con 'S' y contienen números
    dirInfo = dir(fullfile(basePath, 'S*'));
    dirInfo = dirInfo([dirInfo.isdir]);  % Solo carpetas

    for k = 1:length(dirInfo)
        folderName = dirInfo(k).name;

        % Extraer número de participante
        tokens = regexp(folderName, '^S(\d+)$', 'tokens');
        if isempty(tokens)
            continue;
        end
        participantID = tokens{1}{1};
        structField = ['S', participantID];

        % Rutas
        signalFolder = fullfile(basePath, folderName, 'filt_signal');
        caneFile = fullfile(signalFolder, sprintf('S%s_caneDataExperiment.mat', participantID));
        empaticaFile = fullfile(signalFolder, sprintf('S%s_empaticaDataExperiment.mat', participantID));
        audioFile = fullfile(basePath, folderName, sprintf('S%s_audioEventVector.mat', participantID));

        % Inicializa subestructura
        substruct = struct();

        % Cargar caneData
        if isfile(caneFile)
            temp = load(caneFile);
            fn = fieldnames(temp);
            substruct.caneData = temp.(fn{1});
        end

        % Cargar empaticaData
        if isfile(empaticaFile)
            temp = load(empaticaFile);
            fn = fieldnames(temp);
            substruct.empaticaData = temp.(fn{1});
        end

        % Cargar audioEventVector
        if isfile(audioFile)
            temp = load(audioFile);
            fn = fieldnames(temp);
            substruct.audioEventVector = temp.(fn{1});
        end

        % Asignar al struct principal
        dataStruct.(structField) = substruct;
    end
end
