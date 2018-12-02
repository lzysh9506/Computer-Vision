function [sky,ground] = split_sky_ground(X,sky_cent, ground_cent)

[m,n,k] = size(X);

sky = zeros(size(X));

ground = zeros(size(X));

for i = 1: m
    for j = 1:n
    p = reshape(X(i,j,:),[1,3]);
    d_sky = mean(sqrt(sum((p - sky_cent).^2,2)));
    d_ground = mean(sqrt(sum((p - ground_cent).^2,2)));
    if d_sky < d_ground
        sky(i,j,:) = X(i,j,:);
    else
        ground(i,j,:) = X(i,j,:);
    end
    end
end

end