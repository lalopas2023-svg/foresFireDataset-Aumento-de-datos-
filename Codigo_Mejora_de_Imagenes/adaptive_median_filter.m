function img_out = adaptive_median_filter(img, tam_inicial, tam_maximo)
    % adaptive_median_filter - Filtro adaptativo de mediana para reducción de ruido impulsivo

    % Valores por defecto
    if nargin < 2
        tam_inicial = 3;
    end
    if nargin < 3
        tam_maximo = 7;
    end

    % Validaciones básicas
    if mod(tam_inicial, 2) == 0 || mod(tam_maximo, 2) == 0
        error('Los tamaños de ventana deben ser impares.');
    end
    if tam_inicial > tam_maximo
        error('tam_inicial no puede ser mayor que tam_maximo.');
    end

    % Guardar tipo original y convertir a double para operaciones
    esUint8 = isa(img, 'uint8');
    img = double(img);
    [M, N] = size(img);
    img_out = zeros(M, N);

    % Relleno necesario para el tamaño máximo
    relleno_max = floor(tam_maximo / 2);
    img_padded = padarray(img, [relleno_max relleno_max], 'replicate');

    % Recorrer cada píxel
    for i = 1:M
        for j = 1:N
            % Coordenadas del centro en la imagen con relleno
            fila_centro = i + relleno_max;
            col_centro = j + relleno_max;
            tam_actual = tam_inicial;

            while tam_actual <= tam_maximo
                relleno_actual = floor(tam_actual / 2);
                % Extraer vecindad
                vecindad = img_padded(fila_centro-relleno_actual:fila_centro+relleno_actual, ...
                                      col_centro-relleno_actual:col_centro+relleno_actual);
                vecindad = vecindad(:); % vectorizar

                % Calcular estadísticos
                zmin = min(vecindad);
                zmax = max(vecindad);
                zmed = median(vecindad);
                zxy = img_padded(fila_centro, col_centro);

                % Nivel A
                if zmin < zmed && zmed < zmax
                    % Nivel B
                    if zmin < zxy && zxy < zmax
                        img_out(i, j) = zxy;  % píxel no es ruido
                    else
                        img_out(i, j) = zmed; % píxel es ruido
                    end
                    break; % salir del while
                else
                    % Aumentar tamaño de ventana
                    tam_actual = tam_actual + 2;
                end
            end

            % Si se alcanzó el tamaño máximo sin cumplir condición A
            if tam_actual > tam_maximo
                % Usar mediana de la ventana máxima
                relleno_actual = floor(tam_maximo / 2);
                vecindad = img_padded(fila_centro-relleno_actual:fila_centro+relleno_actual, ...
                                      col_centro-relleno_actual:col_centro+relleno_actual);
                img_out(i, j) = median(vecindad(:));
            end
        end
    end

    % Convertir a uint8 si la imagen original lo era
    if esUint8
        img_out = uint8(img_out);
    end
end