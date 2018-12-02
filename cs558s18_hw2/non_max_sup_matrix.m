function nms_image = non_max_sup_matrix(X,halfwid)
%Initialization
[m,n] = size(X);
nms_image = zeros(m,n);
nms_matrix = zeros(halfwid*2+1,halfwid*2+1);
% ============================================

%iterate the non-maxium supression with image
%split to four situation: horizontal, vertical, two diagonals
for i = (halfwid+1):2*halfwid:(m-halfwid)
    for j = (halfwid+1):2*halfwid:(n-halfwid)
      nms_matrix = X((i-halfwid):(i+halfwid),(j-halfwid):(j+halfwid));
      if X(i,j) == max(nms_matrix(:))
          nms_image(i,j) = X(i,j);
      else
          continue
      end
    end
end

end