clear all; close all; clc;

%% CONFIGURACIÓN - SOLO CARPETA TRAIN
ruta_base = 'C:\Users\epasc\OneDrive\Documents\Eddy\Maestría\Procesamiento Digital de Imagenes';
carpeta_train = fullfile(ruta_base, 'train\');
carpeta_imagenes = fullfile(carpeta_train, 'images\');

% Verificar que existe la carpeta train/images
if ~exist(carpeta_imagenes, 'dir')
    error('No se encuentra la carpeta train/images/. Verifica la ruta.');
end

% Obtener lista de imágenes
archivos = dir(fullfile(carpeta_imagenes, '*.jpg'));
num_imagenes = length(archivos);

fprintf('Procesando carpeta TRAIN: %d imágenes encontradas\n', num_imagenes);

%% CREAR 7 CARPETAS PARA CADA MÉTODO
carpetas_metodos = {
    'grises\';
    'flipping\';
    'rotation\';
    'translation\';
    'scaling\';
    'random_erase\';
    'cutmix\'};

for i = 1:length(carpetas_metodos)
    carpeta_metodo = fullfile(carpeta_train, carpetas_metodos{i});
    if ~exist(carpeta_metodo, 'dir')
        mkdir(carpeta_metodo);
        fprintf('  Carpeta creada: %s\n', carpetas_metodos{i});
    end
end

%% PROCESAR CADA IMAGEN
for idx = 1:num_imagenes
    % 1. CARGAR IMAGEN ORIGINAL
    nombre_archivo = archivos(idx).name;
    ruta_completa = fullfile(carpeta_imagenes, nombre_archivo);
    img_color = imread(ruta_completa);
    
    % 2. CONVERTIR A GRISES (base para otros métodos)
    img_gris = convertir_a_grises(img_color);
    
    % GUARDAR EN CARPETA 'grises\'
    nombre_base = nombre_archivo(1:end-4);  
    imwrite(img_gris, fullfile(carpeta_train, 'grises\', [nombre_base '_gris.jpg']));
    
    % 3. APLICAR FLIPPING (volteado)
    img_flip_h = flipping(img_gris, 'horizontal');
    img_flip_v = flipping(img_gris, 'vertical');
    
    % Guardar ambos volteados
    imwrite(img_flip_h, fullfile(carpeta_train, 'flipping\', [nombre_base '_flipH.jpg']));
    imwrite(img_flip_v, fullfile(carpeta_train, 'flipping\', [nombre_base '_flipV.jpg']));
    
    % 4. APLICAR ROTACIÓN (ángulos diferentes para variedad)
    angulos = [15, -15, 30, -30, 45];  %5 rotaciones diferentes
    for k = 1:length(angulos)
        img_rot = rotation_bilineal(img_gris, angulos(k));
        imwrite(img_rot, fullfile(carpeta_train, 'rotation\', ...
            [nombre_base '_rot' num2str(angulos(k)) '.jpg']));
    end
    
    % 5. APLICAR TRASLACIÓN
    desplazamientos = [20, -20, 30, -30, 15];  %5 traslaciones diferentes
    for k = 1:length(desplazamientos)
        img_trans = translation(img_gris, desplazamientos(k), desplazamientos(k));
        imwrite(img_trans, fullfile(carpeta_train, 'translation\', ...
            [nombre_base '_trans' num2str(desplazamientos(k)) '.jpg']));
    end
    
    % 6. APLICAR ESCALAMIENTO
    escalas = [0.8, 1.2, 0.9, 1.1, 0.7];  %5 escalamientos diferentes
    for k = 1:length(escalas)
        img_scale = scaling_bilineal(img_gris, escalas(k));
        imwrite(img_scale, fullfile(carpeta_train, 'scaling\', ...
            [nombre_base '_scale' num2str(escalas(k)) '.jpg']));
    end
    
    % 7. APLICAR RANDOM ERASE
    porcentajes = [0.1, 0.2, 0.15, 0.25, 0.3];  % 5 porcentajes diferentes
    for k = 1:length(porcentajes)
        img_erase = random_erase(img_gris, porcentajes(k));
        imwrite(img_erase, fullfile(carpeta_train, 'random_erase\', ...
            [nombre_base '_erase' num2str(porcentajes(k)*100) 'p.jpg']));
    end
    
    % 8. APLICAR CUTMIX (con 3 imágenes diferentes aleatorias)
    if num_imagenes > 1
        % Seleccionar 3 imágenes aleatorias diferentes
        indices_otras = randperm(num_imagenes, 3);
        indices_otras = indices_otras(indices_otras ~= idx);  % No usar la misma
        
        for k = 1:min(3, length(indices_otras))
            idx_otra = indices_otras(k);
            otra_color = imread(fullfile(carpeta_imagenes, archivos(idx_otra).name));
            otra_gris = convertir_a_grises(otra_color);
            
            % Ajustar tamaño si es necesario
            if ~isequal(size(img_gris), size(otra_gris))
                otra_gris = imresize(otra_gris, size(img_gris));
            end
            
            img_cutmix = cutmix(img_gris, otra_gris);
            imwrite(img_cutmix, fullfile(carpeta_train, 'cutmix\', ...
                [nombre_base '_cutmix' num2str(k) '.jpg']));
        end
    end
    
    % Mostrar progreso cada 50 imágenes
    if mod(idx, 50) == 0
        fprintf('  Procesadas %d/%d imágenes\n', idx, num_imagenes);
    end
end

%% ESTADÍSTICAS FINALES
fprintf('\n=== PROCESAMIENTO COMPLETADO ===\n');
fprintf('Carpeta procesada: train/\n');
fprintf('Imágenes originales: %d\n', num_imagenes);
fprintf('Carpetas generadas:\n');

for i = 1:length(carpetas_metodos)
    carpeta_metodo = fullfile(carpeta_train, carpetas_metodos{i});
    archivos_gen = dir(fullfile(carpeta_metodo, '*.jpg'));
    fprintf('  • %-15s: %d imágenes\n', carpetas_metodos{i}(1:end-1), length(archivos_gen));
end

fprintf('\nTotal imágenes generadas: %d\n', ...
    sum(arrayfun(@(x) length(dir(fullfile(carpeta_train, x{1}, '*.jpg'))), carpetas_metodos)));