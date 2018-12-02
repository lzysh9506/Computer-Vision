function [hessian_image] = hessian_det(X,threshold)

[m,n] = size(X);
X = double(X);

hessian_x = zeros(m,n);
hessian_y = zeros(m,n);
hessian_xx = zeros(m,n);
hessian_yy = zeros(m,n);
hessian_xy = zeros(m,n);

sobel_filter_x = [-1,0,1;-2,0,2;-1,0,1];
sobel_filter_y = [-1,-2,-1;0,0,0;1,2,1];

for i = 1:(m-2)
    for j = 1:(n-2)
        temp_X = X(i:i+2,j:j+2);
        hessian_x(i,j) = sum(sum(sobel_filter_x .* temp_X));
        hessian_y(i,j) = sum(sum(sobel_filter_y .* temp_X));
    end
end

for i = 1:(m-2)
    for j = 1:(n-2)
        temp_XX = hessian_x(i:i+2,j:j+2);
        temp_YY = hessian_y(i:i+2,j:j+2);
        hessian_xx(i,j) = sum(sum(sobel_filter_x .* temp_XX));
        hessian_yy(i,j) = sum(sum(sobel_filter_y .* temp_YY));
        hessian_xy(i,j) = sum(sum(sobel_filter_y .* temp_XX));
    end
end

hessian_image = hessian_xx.*hessian_yy -hessian_xy.^2;

hessian_image = hessian_image.*(hessian_image > threshold);

end