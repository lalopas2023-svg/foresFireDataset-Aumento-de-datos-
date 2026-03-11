function img_out = gradiente_laplaciano(img)
    % gradiente_laplaciano - Aplica filtrado Gradiente-Laplaciano
  
    % Convertir a double para operaciones
    J = double(img);
    
    % Máscaras de Sobel para el gradiente
    MaskX = [-1,-2,-1; 0,0,0; 1,2,1];
    MaskY = [-1,0,1; -2,0,2; -1,0,1];
    
    % Calcular gradientes
    GradX = imfilter(J, MaskX, 'replicate', 'conv');
    GradY = imfilter(J, MaskY, 'replicate', 'conv');
    
    % Magnitud del gradiente
    Magnitud = sqrt(GradX.^2 + GradY.^2);
    
    % Suavizar la magnitud con filtro promedio 3×3
    w = ones(3,3) / 9;
    MagnitudSuav = imfilter(Magnitud, w, 'replicate', 'conv');
    
    % Máscara Laplaciana (centro positivo)
    MaskL = [0,-1,0; -1,4,-1; 0,-1,0];
    Lapla = imfilter(J, MaskL, 'replicate', 'conv');
    
    % Imagen realzada con Laplaciano (c = 1)
    imgR = J + Lapla;
    
    % Máscara del filtrado Gradiente-Laplaciano (producto elemento a elemento)
    MaskGL = imgR .* MagnitudSuav;
    
    % Imagen final: original + máscara
    ImgGL = J + MaskGL;
    ImgGL = max(0, min(255, ImgGL));
    img_out = uint8(ImgGL);
end