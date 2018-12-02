function H = hough_trans(m,n,interest_point)

H = zeros(m,n);

for i = 1 : length(interest_point)
    for j = 1:n
        theta = j*pi/n;
        p = interest_point(i,1)*cos(theta) + interest_point(i,2)*sin(theta);
        
        if p > m | p <= 0
            continue
        else
            p = floor(p);
            y = m-p;
            H(y,j) = H(y,j) +1;
        end
    end
end