function img_erase = random_erase(img_gris, porcentaje)
[M, N] = size(img_gris);
img_erase = img_gris;

area_total = M * N;
area_borrar = round(area_total * porcentaje);

lado = round(sqrt(area_borrar));
if lado > min(M, N)
    lado = min(M, N);
end

pos_i = randi([1, M - lado + 1]);
pos_j = randi([1, N - lado + 1]);

for i = pos_i:pos_i + lado - 1
    for j = pos_j:pos_j + lado - 1
        img_erase(i, j) = 0;
    end
end
end