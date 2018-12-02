function  gaus_image = gaus_filt(X, sigma)
%Initialization

[m,n] = size(X);

gaus_image = zeros(m,n);

%set the gaus filter to be a 7*7 matrix, so the half width is 3
halfwid = 3; 

%initialize gaus filter
gaus_filter = zeros(2*halfwid + 1);

% ============================================

%creat gaus filter with sigma
[xx,yy] = meshgrid(-halfwid:halfwid,-halfwid:halfwid); 

gaus_filter = exp(-1/(2*sigma^2) * (xx.^2 + yy.^2));
gaus_filter = gaus_filter/sum(sum(gaus_filter));

%duplicate the edge of image with half width of filter
X_dup = edged_dup(X,halfwid); 

%mutiple the gaus filter with each 7*7 matrix of the original image
for i = 1:m
    for j = 1:n
        temp_X = X_dup(i:i+2*halfwid,j:j+2*halfwid);
        gaus_image(i,j) = sum(sum(gaus_filter .* double(temp_X)));
    end
end

gaus_image = uint8(gaus_image);

end