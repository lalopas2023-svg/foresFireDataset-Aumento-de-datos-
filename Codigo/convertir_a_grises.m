function img_gris = convertir_a_grises(img_color)
[M, N, ~] = size(img_color);
img_gris = zeros(M, N, 'uint8');

for i = 1:M
    for j = 1:N
        R = double(img_color(i, j, 1));
        G = double(img_color(i, j, 2));
        B = double(img_color(i, j, 3));
        
        valor = round((R + G + B) / 3);
        img_gris(i, j) = valor;
    end
end
end