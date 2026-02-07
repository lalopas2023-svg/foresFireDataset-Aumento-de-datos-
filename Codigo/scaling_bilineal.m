function img_scale = scaling_bilineal(img_gris, factor)
% Escala imagen usando interpolación bilineal
% Entrada:
%   img_gris: imagen en escala de grises
%   factor: factor de escala (ej: 0.8 para reducir 80%, 1.2 para aumentar 20%)
% Salida:
%   img_scale: imagen escalada

[M_orig, N_orig] = size(img_gris);

% Nuevas dimensiones (usar factor para ambos ejes)
M_nueva = round(M_orig * factor);
N_nueva = round(N_orig * factor);

% Crear imagen de salida
img_scale = zeros(M_nueva, N_nueva, class(img_gris));

% Factores inversos
inv_s = 1 / factor;

% Para cada píxel de la imagen de salida
for fila_nueva = 1:M_nueva
    for col_nueva = 1:N_nueva
        % Calcular coordenadas en imagen original
        fila_orig = (fila_nueva - 0.5) * inv_s + 0.5;
        col_orig = (col_nueva - 0.5) * inv_s + 0.5;
        
        % Verificar límites
        if fila_orig >= 1 && fila_orig <= M_orig && col_orig >= 1 && col_orig <= N_orig
            
            % Coordenadas enteras para interpolación
            x1 = floor(col_orig);
            x2 = ceil(col_orig);
            y1 = floor(fila_orig);
            y2 = ceil(fila_orig);
            
            % Asegurar límites
            x1 = max(1, min(x1, N_orig));
            x2 = max(1, min(x2, N_orig));
            y1 = max(1, min(y1, M_orig));
            y2 = max(1, min(y2, M_orig));
            
            % Si las coordenadas son enteras
            if x1 == x2 && y1 == y2
                valor = double(img_gris(y1, x1));
            else
                % Diferencias fraccionales
                dx = col_orig - x1;
                dy = fila_orig - y1;
                
                % Si x1 == x2 (misma columna)
                if x1 == x2
                    valor = (1-dy)*double(img_gris(y1, x1)) + dy*double(img_gris(y2, x1));
                % Si y1 == y2 (misma fila)
                elseif y1 == y2
                    valor = (1-dx)*double(img_gris(y1, x1)) + dx*double(img_gris(y1, x2));
                % Interpolación bilineal completa
                else
                    Q11 = double(img_gris(y1, x1));
                    Q21 = double(img_gris(y1, x2));
                    Q12 = double(img_gris(y2, x1));
                    Q22 = double(img_gris(y2, x2));
                    
                    valor = (1-dx)*(1-dy)*Q11 + dx*(1-dy)*Q21 + ...
                            (1-dx)*dy*Q12 + dx*dy*Q22;
                end
            end
            
            % Asignar valor interpolado
            img_scale(fila_nueva, col_nueva) = cast(valor, class(img_gris));
        else
            % Fuera de límites - negro
            img_scale(fila_nueva, col_nueva) = 0;
        end
    end
end
end