function [sobel_image, sobel_ori] = sobel_filt(X,threshold)
%Initialization
[m,n] = size(X);

sobel_image_x = zeros(m,n);
sobel_image_y = zeros(m,n);

%set the sobel filter with x and y direction 
sobel_filter_x = [-1,0,1;-2,0,2;-1,0,1];
sobel_filter_y = [-1,-2,-1;0,0,0;1,2,1];

%duplicate the edge
X_dup = edged_dup(X,1);

% ============================================

%iterate the sobel filter with image
for i = 1:m
    for j = 1:n
        temp_X = X_dup(i:i+2,j:j+2);
        sobel_image_x(i,j) = sum(sum(sobel_filter_x .* double(temp_X)));
        sobel_image_y(i,j) = sum(sum(sobel_filter_y .* double(temp_X)));
    end
end

%calculate gradient magnitude
sobel_image = sqrt(sobel_image_x.^2 + sobel_image_y.^2);

%calculate the gradient direction
sobel_ori = atan((sobel_image .* sobel_image_y)./(sobel_image .* sobel_image_x));
sobel_ori(isnan(sobel_ori))=0;

%apply threshold to filted image
sobel_image = sobel_image.*(sobel_image > threshold);

sobel_image = uint8(sobel_image);

end