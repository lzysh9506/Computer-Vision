function X_dup = edged_dup(X,extra_pixel)
%duplicate the edge of image with extra pixel

left_most = X(:,1:extra_pixel);
right_most = X(:,end-extra_pixel:end);
X_dup = [left_most,X,right_most];

top = X_dup(1:extra_pixel,:);
bottom = X_dup(end-extra_pixel:end,:);
X_dup = [top;X_dup;bottom];

end