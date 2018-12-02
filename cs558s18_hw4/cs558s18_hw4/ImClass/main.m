maindir = 'E:\SIT\CS558\cs558s18_hw4\cs558s18_hw4\ImClass';

subdir  = dir( maindir );

for i = 1 : length( subdir )
    subdirpath = fullfile( maindir, subdir( i ).name, '*.jpg' );
    dat = dir( subdirpath ) ;             

    for j = 1 : length( dat )
        datpath = fullfile( maindir, subdir( i ).name, dat( j ).name);
        image{j} = double(imread(datpath));
    end
end
%% 

bin = 8;

image_rep = rep_image(image,bin);

train = image_rep([5:8,13:16,21:24],:);
y = [1;1;1;1;2;2;2;2;3;3;3;3];  %1 is coast, 2 is forest, 3 is incidecity

test = image_rep([1:4,9:12,17:20],:);
test_y = [1;1;1;1;2;2;2;2;3;3;3;3];
%% 
wrong = 0;

test_size = size(test,1);

for i = 1: test_size
    k = dsearchn(train, test(i,:));
    fprintf('\nTest image %d of class %d has been assigned to class %d.\n', i, test_y(i),y(k));
    if test_y(i)~=y(k)
        wrong = wrong + 1;
    end
end

accuracy = (test_size-wrong)/test_size;
fprintf('\nAccuracy is %.2f', accuracy);

pause;
%% 
bin = 1:64;

accuracy = zeros(length(bin),2);
accuracy(:,1) = bin;

for i = 1:length(bin)
    
    image_rep = rep_image(image,bin(i));

    train = image_rep([5:8,13:16,21:24],:);

    test = image_rep([1:4,9:12,17:20],:);
    
    accuracy(i,2) = cal_accuracy(train,test);
    
end

plot(accuracy(:,1),accuracy(:,2));
ylim([0.5,1]);

pause;
%% 