function img_rot = rotation_bilineal(img_gris, angulo)
% ROTACIÓN CON INTERPOLACIÓN BILINEAL
% img_gris: imagen en escala de grises (matriz MxN)
% angulo: ángulo de rotación en grados (positivo: antihorario)
% img_rot: imagen rotada con interpolación bilineal

% Obtener dimensiones de la imagen original
[nfils, ncols] = size(img_gris);

% Calcular centro de la imagen
centx = nfils / 2;
centy = ncols / 2;

% Convertir ángulo a radianes
teta = angulo * pi / 180;

% Matrices de transformación
matrizTras = [1 0 centx; 0 1 centy; 0 0 1];
matrizRotacion = [cos(teta) -sin(teta) 0; sin(teta) cos(teta) 0; 0 0 1];
matrizInvTras = [1 0 -centx; 0 1 -centy; 0 0 1];

% Matriz de transformación completa (centrar, rotar, descentrar)
matrizTF = matrizTras * matrizRotacion * matrizInvTras;

% Matriz inversa (para mapear coordenadas de salida a entrada)
matrizTF_inv = inv(matrizTF);

% Inicializar imagen de salida
img_rot = zeros(nfils, ncols);

% Recorrer todos los píxeles de la imagen de salida
for i = 1:nfils
    for j = 1:ncols
        % Obtener coordenadas en imagen original
        nuevasCoords = matrizTF_inv * [i; j; 1];
        
        iaster = floor(nuevasCoords(1));  % Parte entera de x
        jaster = floor(nuevasCoords(2));  % Parte entera de y
        
        % Distancias para interpolación
        distX = nuevasCoords(1) - iaster;
        distY = nuevasCoords(2) - jaster;
        
        % Coeficientes de interpolación
        Bv = 1 - distX;
        Bh = 1 - distY;
        av = distX;
        ah = distY;
        
        % Verificar que los 4 píxeles vecinos estén dentro de la imagen
        if (iaster > 0 && iaster < nfils && jaster > 0 && jaster < ncols && ...
            iaster+1 <= nfils && jaster+1 <= ncols)
            
            % Interpolación bilineal
            img_rot(i, j) = (Bh * Bv) * img_gris(iaster, jaster) + ...
                            (ah * Bv) * img_gris(iaster, jaster+1) + ...
                            (Bh * av) * img_gris(iaster+1, jaster) + ...
                            (ah * av) * img_gris(iaster+1, jaster+1);
        end
    end
end

% Convertir a uint8
img_rot = uint8(img_rot);
end