function nms_image = non_max_sup(X,threshold)
%Initialization
[m,n] = size(X);
nms_image = zeros(m,n);

[X_image, X_ori] = sobel_filt(X, threshold);

%convert non-nomorlized sobel image
X_sobel = double(X) .* double(X_image/255);

% ============================================

%iterate the non-maxium supression with image
%split to four situation: horizontal, vertical, two diagonals
for i = 2:(m-1)
    for j = 2:(n-1)
        if X_ori(i,j)==0
            continue
        elseif X_ori(i,j) >= (-3/8 *pi) & X_ori(i,j) < (-1/8 *pi)
            nms_image(i,j) = X_sobel(i,j)*(max([X_sobel(i,j),X_sobel(i-1,j+1), X_sobel(i+1,j-1)])==X_sobel(i,j));
        elseif X_ori(i,j) >= (-1/8*pi) & X_ori(i,j) < (1/8*pi)
            nms_image(i,j) = X_sobel(i,j)*(max([X_sobel(i,j),X_sobel(i-1,j), X_sobel(i+1,j)])==X_sobel(i,j));
        elseif X_ori(i,j) >= (1/8 *pi) & X_ori(i,j) < (3/8 *pi)
            nms_image(i,j) = X_sobel(i,j)*(max([X_sobel(i,j),X_sobel(i+1,j+1), X_sobel(i-1,j-1)])==X_sobel(i,j));
        else
            nms_image(i,j) = X_sobel(i,j)*(max([X_sobel(i,j),X_sobel(i,j-1), X_sobel(i,j+1)])==X_sobel(i,j));
        end
       
    end
end

nms_image = nms_image./nms_image *255;
nms_image(isnan(nms_image)) = 0;

nms_image = uint8(nms_image);

end