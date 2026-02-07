function img_cutmix = cutmix(img_A, img_B)
[M, N] = size(img_A);
img_cutmix = img_A;

ancho_reg = round(N * 0.3);
alto_reg = round(M * 0.3);

pos_x = randi([1, N - ancho_reg + 1]);
pos_y = randi([1, M - alto_reg + 1]);

for i = pos_y:pos_y + alto_reg - 1
    for j = pos_x:pos_x + ancho_reg - 1
        img_cutmix(i, j) = img_B(i, j);
    end
end
end