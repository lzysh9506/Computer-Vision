function  accuracy= cal_accuracy(train,test)

wrong = 0;

test_size = size(test,1);

y = [1;1;1;1;2;2;2;2;3;3;3;3]; 
test_y = [1;1;1;1;2;2;2;2;3;3;3;3];

for j = 1: test_size
    k = dsearchn(train, test(j,:));
    if test_y(j)~=y(k)
        wrong = wrong + 1;
    end
end

accuracy = (test_size-wrong)/test_size;

end