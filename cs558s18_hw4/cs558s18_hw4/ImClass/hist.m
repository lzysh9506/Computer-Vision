function RGB_vector = hist(X, bin)

RGB_vector = zeros(3*bin,1);

for i = 1:3
    RGB_vector((i-1)*bin+1:i*bin,:) = histcounts(X(:,:,i),bin);
end

end