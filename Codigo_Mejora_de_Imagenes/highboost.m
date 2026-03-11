function img_out = highboost(img, k, tam_filtro)
    % highboost - Aplica filtrado Highboost a una imagen en escala de grises

    % Valores por defecto
    if nargin < 2
        k = 1.5;
    end
    if nargin < 3
        tam_filtro = 3;
    end

    % Convertir a double para operaciones
    J = double(img);

    % Crear máscara de filtro promedio (todos unos)
    w = ones(tam_filtro, tam_filtro);

    % 1. Suavizar la imagen usando convolusion
    ImgS = imfilter(J, w, 'replicate', 'conv') * (1 / (tam_filtro^2));

    % 2. Calcular la máscara Highboost
    MaskFH = J - ImgS;

    % 3. Sumar la máscara ponderada a la imagen original
    ImgFH = J + k * MaskFH;

    % 4. Recortar valores al rango [0, 255] y convertir a uint8
    ImgFH = max(0, min(255, ImgFH));
    img_out = uint8(ImgFH);
end