function analizar_caracteristicas_no_pareadas(tablecanepreevent, tablecanepostevent, tableempaticapreevent, tableempaticapostevent)

    folder_name = 'caracteristica_no_pareada';
    if ~exist(folder_name, 'dir')
        mkdir(folder_name);
    end

    % Eliminar última columna (si aplica)
    tablecanepreevent(:, end) = [];
    tablecanepostevent(:, end) = [];
    tableempaticapreevent(:, end) = [];
    tableempaticapostevent(:, end) = [];

    feature_names = tablecanepreevent.Properties.VariableNames;

    varTypes = {'string','double','double','string','double','categorical'};
    varNames = {'Caracteristica', 'p_Shapiro_Pre', 'p_Shapiro_Post', ...
                'Test', 'p_Test', 'Significativo'};
    result_cane = table('Size', [numel(feature_names), numel(varNames)], ...
                        'VariableTypes', varTypes, 'VariableNames', varNames);
    result_empatica = result_cane;

    % Función para ampliar ejes con margen
    function lims = ampliar_lim(lim)
        rango = lim(2) - lim(1);
        if rango == 0
            rango = 1; % evitar rango cero
        end
        lims = [lim(1) - 0.1*rango, lim(2) + 0.1*rango];
    end

    for i = 1:numel(feature_names)
        feat = feature_names{i};

        cane_pre = clean_vector(tablecanepreevent.(feat));
        cane_post = clean_vector(tablecanepostevent.(feat));
        empatica_pre = clean_vector(tableempaticapreevent.(feat));
        empatica_post = clean_vector(tableempaticapostevent.(feat));

        % --- Gráficos ---
        f = figure('Visible', 'off', 'Units','normalized','Position',[0.1 0.1 0.8 0.7]);

        t = tiledlayout(2,3, 'Padding','compact', 'TileSpacing','compact');
        sgtitle(['Análisis: ', feat],'FontSize',14,'FontWeight','bold');

        % QQ Cane Pre
        ax1 = nexttile(1);
        qqplot(cane_pre);
        title('QQ Cane Pre');
        xl = ampliar_lim(xlim(ax1));
        yl = ampliar_lim(ylim(ax1));
        xlim(ax1, xl);
        ylim(ax1, yl);

        % QQ Cane Post
        ax2 = nexttile(2);
        qqplot(cane_post);
        title('QQ Cane Post');
        xl = ampliar_lim(xlim(ax2));
        yl = ampliar_lim(ylim(ax2));
        xlim(ax2, xl);
        ylim(ax2, yl);

        % Histograma Cane
        ax3 = nexttile(3);
        histogram(cane_pre, 'FaceAlpha', 0.5); hold on;
        histogram(cane_post, 'FaceAlpha', 0.5);
        legend('Pre', 'Post','Location','best');
        title('Histograma Cane');
        xlabel(feat);
        ylabel('Frecuencia');
        xl = ampliar_lim(xlim(ax3));
        ylim_max = max(ylim(ax3))*1.2; % 20% más alto para espacio
        xlim(ax3, xl);
        ylim(ax3, [0 ylim_max]);

        % QQ Empatica Pre
        ax4 = nexttile(4);
        qqplot(empatica_pre);
        title('QQ Empatica Pre');
        xl = ampliar_lim(xlim(ax4));
        yl = ampliar_lim(ylim(ax4));
        xlim(ax4, xl);
        ylim(ax4, yl);

        % QQ Empatica Post
        ax5 = nexttile(5);
        qqplot(empatica_post);
        title('QQ Empatica Post');
        xl = ampliar_lim(xlim(ax5));
        yl = ampliar_lim(ylim(ax5));
        xlim(ax5, xl);
        ylim(ax5, yl);

        % Histograma Empatica
        ax6 = nexttile(6);
        histogram(empatica_pre, 'FaceAlpha', 0.5); hold on;
        histogram(empatica_post, 'FaceAlpha', 0.5);
        legend('Pre', 'Post','Location','best');
        title('Histograma Empática');
        xlabel(feat);
        ylabel('Frecuencia');
        xl = ampliar_lim(xlim(ax6));
        ylim_max = max(ylim(ax6))*1.2;
        xlim(ax6, xl);
        ylim(ax6, [0 ylim_max]);

        saveas(f, fullfile(folder_name, [feat, '_qq_hist.png']));
        close(f);

        % --- Shapiro-Wilk con validación ---
        p_sw_pre_cane = shapiro_safe(cane_pre);
        p_sw_post_cane = shapiro_safe(cane_post);
        p_sw_pre_emp = shapiro_safe(empatica_pre);
        p_sw_post_emp = shapiro_safe(empatica_post);

        % --- Cane ---
        if p_sw_pre_cane > 0.05 && p_sw_post_cane > 0.05
            [~, p_test_cane] = ttest2(cane_pre, cane_post);
            test_used_cane = "t-Student";
        else
            p_test_cane = ranksum(cane_pre, cane_post); % Mann-Whitney
            test_used_cane = "Mann-Whitney";
        end
        significativo_cane = categorical(p_test_cane < 0.05, [true false], {'Sí','No'});

        result_cane(i,:) = {feat, p_sw_pre_cane, p_sw_post_cane, ...
                            test_used_cane, p_test_cane, significativo_cane};

        % --- Empatica ---
        if p_sw_pre_emp > 0.05 && p_sw_post_emp > 0.05
            [~, p_test_emp] = ttest2(empatica_pre, empatica_post);
            test_used_emp = "t-Student";
        else
            p_test_emp = ranksum(empatica_pre, empatica_post); % Mann-Whitney
            test_used_emp = "Mann-Whitney";
        end
        significativo_emp = categorical(p_test_emp < 0.05, [true false], {'Sí','No'});

        result_empatica(i,:) = {feat, p_sw_pre_emp, p_sw_post_emp, ...
                                test_used_emp, p_test_emp, significativo_emp};
    end

    writetable(result_cane, fullfile(folder_name, 'resultados_cane.csv'));
    writetable(result_empatica, fullfile(folder_name, 'resultados_empatica.csv'));

    disp('Análisis completado. Resultados y gráficos guardados.');
end

function v = clean_vector(v)
    % Elimina NaN, Inf y valores vacíos
    v = v(~isnan(v) & isfinite(v));
end

function p = shapiro_safe(v)
    % Devuelve p-valor del test de Shapiro-Wilk o NaN si no es válido
    if numel(v) >= 3 % El test necesita al menos 3 datos
        try
            [~, p] = swtest(v, 0.05);
        catch
            p = NaN;
        end
    else
        p = NaN;
    end
end
