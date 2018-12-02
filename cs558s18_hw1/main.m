%%read image

kangaroo = imread('kangaroo.pgm');
plane = imread('plane.pgm');
red = imread('red.pgm');
%% Gaussian Filter to 'kangaroo.pgm'

%process gaus filter to plane
for i = 1:10
    subplot(2,5,i);
    imshow(gaus_filt(double(kangaroo),i));
    title(['Gaussian filter with sigma' int2str(i)]);
end

%choose sigma = 1 and sigma = 9 to compare
kangaroo_1 = gaus_filt(double(kangaroo),1);
kangaroo_2 = gaus_filt(double(kangaroo),9);

pause;
%% %% Sobel Filter to 'plane.pgm'

%apply sobel filter to kangaroo_1 and kangaroo_2 
%set threshold to be 80 and 40
kangaroo_sobel_1 = sobel_filt(kangaroo_1,80);
kangaroo_sobel_2 = sobel_filt(kangaroo_2,40);

%display the image
subplot(1,2,1);
imshow(kangaroo_sobel_1);
subplot(1,2,2);
imshow(kangaroo_sobel_2);
%choose kangaroo_sobel_2 to do futher process

pause;
%% Non-maxium supression to 'kangaroo.pgm'

%apply Non-maxium supression to kangaroo_1
nms_kangaroo = non_max_sup(kangaroo_2,40);

%display the image
imshow(nms_kangaroo);

pause;
%% Gaussian Filter to 'plane.pgm'

%process gaus filter to plane
for i = 1:10
    subplot(2,5,i);
    imshow(gaus_filt(double(plane),i));
    title(['Gaussian filter with sigma' int2str(i)]);
end

%choose sigma = 1 and sigma = 2 to 
plane_1 = gaus_filt(double(plane),1);
plane_2 = gaus_filt(double(plane),2);

pause;
%% Sobel Filter to 'plane.pgm'

%apply sobel filter to plane_1 and plane_2 
%set threshold to be 100
plane_sobel_1 = sobel_filt(plane_1,100);
plane_sobel_2 = sobel_filt(plane_2,100);

%display the image
subplot(1,2,1);
imshow(plane_sobel_1);
subplot(1,2,2);
imshow(plane_sobel_2);
%choose plane_sobel_1 to do futher process

pause;
%% Non-maxium supression to 'plane.pgm'

%apply Non-maxium supression to plane_1
nms_plane = non_max_sup(plane_1,100);

%display the image
imshow(nms_plane);

pause;
%% Gaussian Filter to 'red.pgm'

%process gaus filter to plane
for i = 1:10
    subplot(2,5,i);
    imshow(gaus_filt(double(red),i));
    title(['Gaussian filter with sigma' int2str(i)]);
end

%choose sigma = 2 and sigma = 4 to compare
red_1 = gaus_filt(double(red),2);
red_2 = gaus_filt(double(red),8);

pause;
%% Sobel Filter to 'red.pgm'

%apply sobel filter to red_1 and red_2 
%set threshold to be 35
red_sobel_1 = sobel_filt(red_1,35);
red_sobel_2 = sobel_filt(red_2,35);

%display the image
subplot(1,2,1);
imshow(red_sobel_1);
subplot(1,2,2);
imshow(red_sobel_2);
%choose red_sobel_1 to do futher process

pause;
%% Non-maxium supression to 'red.pgm'

%apply Non-maxium supression to red_1
nms_red = non_max_sup(red_1,35);

%display the image
imshow(nms_red);
