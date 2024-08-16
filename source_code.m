% Görüntüyü yükleme
image = imread('project_example_image.png');
% image = imread('ornek1.png');
% image = imread('ornek2.png');
% image = imread('ornek3.png');

% Görüntüyü gri tonlamalıya çevirme
gray_image = rgb2gray(image);

%figure;
%imshow(gray_image);
%title('Gri Ölçekli Görüntü');
%figure;
%imhist(gray_image);
%title('Gri Ölçekli Histogram');


% Gürültü gidermek için Gaussian filtresi uygulama
gaussfilt_image = imgaussfilt(gray_image, 0.3);
% ornek1.png için -> gaussfilt_image = imgaussfilt(gray_image, 0.3);
% ornek2.png için -> gaussfilt_image = imgaussfilt(gray_image, 0.1);
% ornek3.png için -> gaussfilt_image = imgaussfilt(gray_image, 0.2);
%figure;
%imshow(smoothed_image);
%title('Gauss filtresi ile filtrelenmiş görüntü');

% Kenar algılama (Canny kenar algılayıcı kullanarak, eşik değerlerini ayarlayarak)
cedges = edge(gaussfilt_image, 'Canny', [0.2 0.4]);
% ornek1.png için -> cedges = edge(smoothed_image, 'Canny', [0.05 0.5]);
% ornek2.png için -> cedges = edge(smoothed_image, 'Canny', [0.12 0.27]);
% ornek3.png için -> cedges = edge(smoothed_image, 'Canny', [0.1 0.5]);
%figure;
%imshow(edges);
%title('Canny kenar algılayıcısı uygulanmış görüntü');

% Morfolojik işlemler (dilation ve closing)                 
se = strel('line', 3, 90);
dilated_image = imdilate(cedges, se);
se = strel('disk', 1);
closed_image = imclose(dilated_image, se);
%figure;
%imshow(closed_image);
%title('Morfolojik işlemler uygulanmış görüntü');

% bounding box filtreleme
filtered_image = bwareaopen(closed_image, 30);

% Binary edgelerin kaydedilmesi
cc = bwconncomp(closed_image);
stats = regionprops(cc, 'BoundingBox');

% Bounding box çizimi
figure;
imshow(image);
title('Çevreleyen kutu ile işaretlenmiş saç kökleri');
hold on;

for idx = 1:numel(stats)
    bounding_box = stats(idx).BoundingBox;
    pos = [bounding_box(1), bounding_box(2), bounding_box(3), bounding_box(4)];
    rectangle('Position', pos, 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;
                                                                                        