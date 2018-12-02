function [ransac_line_coe, inlier_max] = ransacline(interest_point, threshold,p)

N = 1;

sample_count = 0;

s = RandStream('mlfg6331_64'); 

e_min = 1;

count = 0;

while N > sample_count
    sample = datasample(s,interest_point,2,'Replace',false);
    inlier_num = 0;
    inlier = [];
    for i = 1 : size(interest_point,1)
        P = interest_point(i,:)';
        d = abs(det([sample(1,:)'-sample(2,:)',P-sample(1,:)']))/norm(sample(1,:)'-sample(2,:)');
        if d <= threshold
            inlier_num = inlier_num + 1;
            inlier = [inlier;P'];
        end
    end
    e = 1 - inlier_num/size(interest_point,1);
    if e <= e_min
        e_min = e;
        inlier_max = inlier;
        N = round(log(1-p)/log(1-(1-e_min)^2));
        sample_count = sample_count+ 1;
    end
    count = count +1;
end

X = [ones(length(inlier_max),1),inlier_max(:,1)];
Y = inlier_max(:,2);
ransac_line_coe = regress(Y,X);

end