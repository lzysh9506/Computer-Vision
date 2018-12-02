%% read image

road = imread('road.png');
%% Pre-processing

%smooting, hessian detector, and non maximum supression
road_smooth = gaus_filt(double(road),5);

[road_1d,road_ori] = sobel_filt(road_smooth,0);

hessian_image = hessian_det(road_smooth, 400);

nms_image = non_max_sup_matrix(hessian_image, 1);

nms_image = binarize(nms_image);

[c,r] = find(nms_image);

interest_point = [r,c];

%eliminate the interest point on trees and ground
a = find(0.73*interest_point(:,1)+interest_point(:,2)<189|interest_point(:,2)>280);

interest_point1 = setdiff(interest_point, interest_point(a,:),'rows');

imshow(road);

hold on;

plot(interest_point1(:,1),interest_point1(:,2),'r*');

pause;

%% RANSAC

%line1

[ransac_line_coe1, inlier1] = ransacline(interest_point1,50,0.8);

x = linspace(0,548,400);

y1 = ransac_line_coe1(1)+ransac_line_coe1(2)*x;

%line2
interest_point2 = setdiff(interest_point1, inlier1,'rows');

[ransac_line_coe2, inlier2] = ransacline(interest_point2,30,0.9);

y2 = ransac_line_coe2(1)+ransac_line_coe2(2)*x;

%line3
interest_point3 = setdiff(interest_point2, inlier2,'rows');

[ransac_line_coe3, inlier3] = ransacline(interest_point3,20,0.95);

y3 = ransac_line_coe3(1)+ransac_line_coe3(2)*x;

%line4
interest_point4 = setdiff(interest_point3, inlier3,'rows');

[ransac_line_coe4, inlier4] = ransacline(interest_point4,20,0.95);

y4 = ransac_line_coe4(1)+ransac_line_coe4(2)*x;

inlier_all = [inlier1;inlier2;inlier3;inlier4];

imshow(road);

hold on;

plot(x,y1,x,y2,x,y3,x,y4, 'LineWidth',1.5);

plot(inlier_all(:,1),inlier_all(:,2),'y*');

pause;

%% Hough

H = hough_trans(407,548,interest_point1);

%get the local maximum interest point
hough_max = sort(H(:),'descend');

hough_max = hough_max(1:20);

[r1,c1] = find(H==18);

y5 = hough_inver(r1,c1);

[r2,c2] = find(H==16);

y6 = hough_inver(r2(1),c2(1));

[r3,c3] = find(H==14);

y7 = hough_inver(r3(3),c3(3));

[r4,c4] = find(H==13);

y8 = hough_inver(r4(4),c4(4));

imshow(road);

hold on;

plot(x,y5,x,y6,x,y7,x,y8,'LineWidth',1.5);

