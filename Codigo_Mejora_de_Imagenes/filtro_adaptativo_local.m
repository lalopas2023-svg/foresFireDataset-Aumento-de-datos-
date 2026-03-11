function img_out = filtro_adaptativo_local(img, var_ruido, tam_ventana)
    % filtro_adaptativo_local - Filtro adaptativo de reducción de ruido (ec. 5-32)

    if nargin < 2
        error('Debe proporcionar la varianza del ruido.');
    end
    if nargin < 3
        tam_ventana = 3;
    end

    % Convertir a double para operaciones
    img = double(img);

    % Calcular media local usando filtro promedio
    h = ones(tam_ventana) / tam_ventana^2;
    media_local = imfilter(img, h, 'replicate');

    % Calcular varianza local usando stdfilt (desviación estándar) y elevando al cuadrado
    desv_local = stdfilt(img, ones(tam_ventana));
    var_local = desv_local.^2;

    % Calcular el ratio (σ_ruido² / σ_local²) limitado a 1
    % Evitar división por cero añadiendo eps
    ratio = var_ruido ./ max(var_local, eps);
    ratio = min(ratio, 1);   % Limitar a 1 según la teoría

    % Aplicar la fórmula: f_hat = g - ratio * (g - media_local)
    img_filt = img - ratio .* (img - media_local);

    % Recortar al rango [0, 255] y convertir a uint8
    img_filt = max(0, min(255, img_filt));
    img_out = uint8(img_filt);
end