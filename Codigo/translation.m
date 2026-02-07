function img_trans = translation(img_gris, dx, dy)
% TRASLACIÓN MANUAL DE IMAGEN
% img_gris: imagen en escala de grises (matriz MxN uint8)
% dx: desplazamiento en x (columnas). Positivo: derecha, Negativo: izquierda
% dy: desplazamiento en y (filas). Positivo: abajo, Negativo: arriba
% img_trans: imagen trasladada con relleno negro

% Obtener dimensiones de la imagen
[M, N] = size(img_gris);

% Crear imagen de salida (inicialmente negra)
img_trans = zeros(M, N, 'uint8');

% Recorrer cada píxel de la imagen de salida
for i = 1:M          % Filas
    for j = 1:N      % Columnas
        % Calcular posición correspondiente en imagen original
        % Usamos transformación inversa: (i,j)salida → (i_orig,j_orig)original
        i_orig = i - dy;  % MATLAB: filas = coordenada y
        j_orig = j - dx;  % MATLAB: columnas = coordenada x
        
        % Verificar si está dentro de los límites de la imagen original
        if i_orig >= 1 && i_orig <= M && j_orig >= 1 && j_orig <= N
            % Copiar valor del píxel original
            img_trans(i, j) = img_gris(i_orig, j_orig);
        end
        % Si está fuera de límites, se queda en 0 (negro)
    end
end
end