function img_out = clahe(img, clipLimit, tileSize)
    % clahe - Aplica CLAHE (Contrast Limited Adaptive Histogram Equalization)

    % Valores por defecto
    if nargin < 2
        clipLimit = 0.02;
    end
    if nargin < 3
        tileSize = [8 8];
    end

    % Verificar que la imagen sea uint8 (opcional, pero recomendado)
    if ~isa(img, 'uint8')
        error('La imagen de entrada debe ser de tipo uint8.');
    end

    % Aplicar CLAHE usando la función de MATLAB
    img_out = adapthisteq(img, 'ClipLimit', clipLimit, 'NumTiles', tileSize);
end