%% load image

white_tower = imread('white-tower.png');
white_tower = double(white_tower);
%% kmean initial
k_num = 10;

wt_matrix = reshape(white_tower(:), [],3);

[kt,p] = kmean(k_num, wt_matrix,10);

%% kmean

q = zeros(length(p),3);

for i = 1:length(p)
    t = p(i);
    q(i,:) = kt(t,:);
end

white_kmean = reshape(q,[720,1280,3]);

imshow(uint8(white_kmen));

pause;

%% SLIC initial
wt_slic = imread('wt_slic.png');
wt_slic = double(wt_slic);

wt_grad_mag = grad_mag(wt_slic);

centroid = [];

for i = 1:50:500
    for j = 1:50:750
        centroid = [centroid;i,j];
    end
end

%% 
max_iter = 3;
iter = 1;
while iter <= max_iter
    slic = zeros(500,750,3);
    cent = [];

    for i = 1: length(centroid)
        Rc = wt_slic(centroid(i,1),centroid(i,2),1);
        Gc = wt_slic(centroid(i,1),centroid(i,2),2);
        Bc = wt_slic(centroid(i,1),centroid(i,2),3);
        cent = [cent;centroid(i,1),centroid(i,2),Rc,Gc,Bc];
    end
    for j = 1:length(cent)
        rangey = max(1,cent(j,1)-49):min(500,cent(j,1)+50);
        rangex = max(1,cent(j,2)-49):min(750,cent(j,2)+50);
        cplist = cent(knnsearch(centroid, centroid(j,:),'K',5),:);
        pi_mag = [];
        for x = rangex
            for y = rangey
                Rp = wt_slic(y,x,1);
                Gp = wt_slic(y,x,2);
                Bp = wt_slic(y,x,3);
                pi_mag = [pi_mag;y,x,Rp,Gp,Bp];
            end
        end
        index = dsearchn(cplist, pi_mag);
        u = find(ismember(cplist,cent(j,:),'rows'));
        cent(j,:) = round(mean(pi_mag(index == u,:)));
        xy = pi_mag(index==u,1:2);
        for e = 1:length(xy)
            slic(xy(e,1),xy(e,2),1) = cent(j,3);
            slic(xy(e,1),xy(e,2),2) = cent(j,4);
            slic(xy(e,1),xy(e,2),3) = cent(j,5);
        end
    end
    iter = iter +1;
end

imshow(uint8(slic));