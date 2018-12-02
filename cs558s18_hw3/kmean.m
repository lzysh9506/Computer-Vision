function [kt,p] = kmean(k, X_matrix, threshold)

s = RandStream('mlfg6331_64'); 

kt = datasample(s,X_matrix,k,'Replace',false);

k0 = zeros(size(kt));

dist = det((kt-k0)'*(kt-k0));

while dist > threshold
    k0 = kt;
    p = dsearchn(kt, X_matrix);
    for i = 1:k
        q = X_matrix.*(p==i);
        q = q(any(q,2),:);
        kt(i,:) = mean(q);
    end
    dist = det((kt-k0)'*(kt-k0));
end
p = dsearchn(kt, X_matrix);
end