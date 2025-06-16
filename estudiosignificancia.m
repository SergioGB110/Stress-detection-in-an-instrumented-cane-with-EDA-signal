% Script para aplicar t-test pareado o Wilcoxon signed rank dependiendo de normalidad de las diferencias

% REQUIERE: tablecanepreevent, tablecanepostevent, 
%           tableempaticapreevent, tableempaticapostevent

% Crear estructura de grupos


%Guarda como "comparacion"

grupos = {
    struct('pre', tablecanepreevent, 'post', tablecanepostevent, 'nombre', 'cane'), ...
    struct('pre', tableempaticapreevent, 'post', tableempaticapostevent, 'nombre', 'empatica')
};

alpha = 0.05;

for g = 1:length(grupos)
    grupo = grupos{g};
    pre = grupo.pre;
    post = grupo.post;
    nombre = grupo.nombre;

    nombresVar = pre.Properties.VariableNames;
    numVars = numel(nombresVar);

    resultados = [];

    for i = 1:numVars-1  % Asumimos que la última columna no es característica
        x = pre.(nombresVar{i});
        y = post.(nombresVar{i});

        % Calcular diferencias y eliminar NaNs
        d = y - x;
        d = d(~isnan(d));
        x = x(~isnan(d));
        y = y(~isnan(d));

        % Evaluar normalidad de la diferencia
        if numel(d) >= 3
            [h_diff, p_diff] = swtest(d, alpha);
        else
            p_diff = NaN;
            h_diff = 1; % Asumir no normal si hay pocos datos
        end

        % Elegir test según normalidad de las diferencias
        if h_diff == 0  % Normal
            testUsado = "t-test";
            [~, pValor] = ttest(x, y);
            normalidad = "Normal";
        else  % No normal
            testUsado = "Wilcoxon";
            pValor = signrank(x, y);
            normalidad = "No normal";
        end

        % Interpretación
        significativa = pValor < alpha;

        resultados = [resultados; {nombresVar{i}, p_diff, normalidad, testUsado, pValor, significativa}];
    end

    % Crear tabla final
    tablaFinal = cell2table(resultados, ...
        'VariableNames', {'Caracteristica', 'pValorDiferencia', 'Normalidad', 'TestUsado', 'pValor', 'Significativa'});

    % Mostrar y guardar
    disp(['Resultados para grupo: ', nombre]);
    disp(tablaFinal);

    writetable(tablaFinal, ['comparacion_', nombre, '.csv']);
end

disp('✅ Comparaciones completadas y resultados guardados.');
