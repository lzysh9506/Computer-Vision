function grad_mag = grad_mag(X)

[Rmag,Rdir] = imgradient(X(:,:,1));

[Gmag,Gdir] = imgradient(X(:,:,2));

[Bmag,Bdir] = imgradient(X(:,:,3));

grad_mag = sqrt(Rmag.^2 + Gmag.^2 + Bmag.^2);

end