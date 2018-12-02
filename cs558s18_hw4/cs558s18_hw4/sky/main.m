%% Load training image
sky_train = double(imread('sky.jpg'));
ground_train = double(imread('ground.jpg'));
sky_test1 = double(imread('sky_test1.jpg'));
sky_test2 = double(imread('sky_test2.jpg'));
sky_test3 = double(imread('sky_test3.jpg'));
sky_test4 = double(imread('sky_test4.jpg'));

%% k-mean
k = 10;

sky_train_kmean = reshape(sky_train, [256*256,3]);

ground_train_kmean = reshape(ground_train, [256*256,3]);

[id_sky,sky_cent] = kmeans(sky_train_kmean, k, 'EmptyAction', 'singleton');

[id_ground, ground_cent] = kmeans(ground_train_kmean, k, 'EmptyAction', 'singleton');
%% test

[sky1, ground1] = split_sky_ground(sky_test1,sky_cent,ground_cent);
[sky2, ground2] = split_sky_ground(sky_test2,sky_cent,ground_cent);
[sky3, ground3] = split_sky_ground(sky_test3,sky_cent,ground_cent);
[sky4, ground4] = split_sky_ground(sky_test4,sky_cent,ground_cent);
%% Show the picture

subplot(1,4,1);
imshow(uint8(ground1));
subplot(1,4,2);
imshow(uint8(ground2));
subplot(1,4,3);
imshow(uint8(ground3));
subplot(1,4,4);
imshow(uint8(ground4));