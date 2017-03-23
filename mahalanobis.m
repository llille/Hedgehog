function [maha]=mahalanobis(image, moyenne, covariences)
    [h,l,a]=size(image);
    nbp=h*l;% calcule le nombre de pixels 
    covariences_inv=(covariences^(-1));% calcule la transposée de la matrice de covariance
    image2=double(image);% passe l'image en double
    image2=reshape(image2,[],3,1)-repmat(moyenne,nbp,1);
    image2=sum((covariences_inv*image2').*image2',1);% application de la formule de mahalanobis
    maha=reshape(image2,h,l);
end