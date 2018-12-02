function bi_image = binarize(X)

X(X~=0) = 255;

bi_image = X;

end