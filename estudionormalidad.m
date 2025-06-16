% Script para test de normalidad Shapiro-Wilk y Q-Q plots sobre diferencias (post - pre)
% con figuras combinadas por característica (cane y empatica)

% Nivel de significación
alpha = 0.05;

% Definición de los grupos
grupos = {
    struct('pre', tablecanepreevent, 'post', tablecanepostevent, 'nombre', 'Cane'), ...
    struct('pre', tableempaticapreevent, 'post', tableempaticapostevent, 'nombre', 'Empatica')
};

% Suponemos que ambas tablas tienen las mismas variables
nombresVar = grupos{1}.pre.Properties.VariableNames;
numVars = numel(nombresVar);
numVarsAnalizar = numVars - 1; % si la última no es característica
caracteristicas = nombresVar(1:numVarsAnalizar)';

% Crear carpeta para guardar las figuras combinadas
carpetaQQ = 'qqplots_diferencias';
if ~exist(carpetaQQ, 'dir')
    mkdir(carpetaQQ);
end

% Inicializar resultados para ambos grupos
pValorDiff = zeros(numVarsAnalizar, 2); % columnas: 1=cane, 2=empatica
normalidadDiff = strings(numVarsAnalizar, 2);

for i = 1:numVarsAnalizar
    nombreVar = nombresVar{i};
    
    % Nueva figura por característica
    f = figure('Name', nombreVar, 'Position', [100, 100, 800, 400]);
    sgtitle(nombreVar, 'Interpreter', 'none'); % Título general de la figura
    
    for g = 1:2
        grupo = grupos{g};
        x = grupo.pre.(nombreVar);
        y = grupo.post.(nombreVar);

        % Diferencia post - pre
        d = y - x;
        d = d(~isnan(d));

        % Subplot: 1=cane, 2=empatica
        subplot(1, 2, g);
        qqplot(d);
        title(grupo.nombre); % Solo "Cane" o "Empatica"

        % Test de Shapiro-Wilk
        if numel(d) >= 3
            [h_diff, p_diff] = swtest(d, alpha);
        else
            p_diff = NaN;
            h_diff = 1; % No se considera normal si hay pocos datos
        end

        pValorDiff(i, g) = p_diff;
        normalidadDiff(i, g) = string(h_diff == 0);
    end

    % Guardar figura
    saveas(f, fullfile(carpetaQQ, ['qqplot_comparado_', nombreVar, '.png']));
    close(f);
end

% Crear y guardar tablas de resultados por grupo
tablaCane = table(caracteristicas, pValorDiff(:,1), normalidadDiff(:,1), ...
    'VariableNames', {'Caracteristica', 'pValorDiferencia', 'EsNormal'});
writetable(tablaCane, 'normalidad_diferencias_cane.csv');

tablaEmpatica = table(caracteristicas, pValorDiff(:,2), normalidadDiff(:,2), ...
    'VariableNames', {'Caracteristica', 'pValorDiferencia', 'EsNormal'});
writetable(tablaEmpatica, 'normalidad_diferencias_empatica.csv');

disp('✅ Figuras combinadas y análisis de normalidad completados.');
