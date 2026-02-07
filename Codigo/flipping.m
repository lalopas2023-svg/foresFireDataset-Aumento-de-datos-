function img_flip = flipping(img_gris, tipo)
% Aplica volteado (flipping) a imagen en escala de grises
% Entrada:
%   img_gris: imagen en escala de grises (matriz MxN)
%   tipo: 'horizontal' o 'vertical'
% Salida:
%   img_flip: imagen volteada

[M, N] = size(img_gris);
img_flip = zeros(M, N, 'uint8');

switch tipo
    case 'horizontal'
        % Volteo horizontal (reflexión vertical)
        for i = 1:M
            for j = 1:N
                j_nuevo = N - j + 1;
                img_flip(i, j_nuevo) = img_gris(i, j);
            end
        end
        
    case 'vertical'
        % Volteo vertical (reflexión horizontal)
        for i = 1:M
            for j = 1:N
                i_nuevo = M - i + 1;
                img_flip(i_nuevo, j) = img_gris(i, j);
            end
        end
        
    otherwise
        error('Tipo de flipping no válido. Usar "horizontal" o "vertical"');
end
end