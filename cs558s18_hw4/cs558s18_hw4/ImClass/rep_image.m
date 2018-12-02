function image_rep = rep_image(X,bin)

image_rep = [];

for i = 1:length(X)
    p = cell2mat(X(i));
    RGB_V = hist(p,bin);
    image_rep(i,:) = RGB_V';
end

end