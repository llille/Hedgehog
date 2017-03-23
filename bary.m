function [barycentres] = bary(L,nbrzone) %Image seuill�e
%prend le nombre de zone et l'image labellis�e et renvoie les barycentres
%des zones labellis�es

barycentres=ones(2,nbrzone); %On cr�e un tableau vide pour rentrer la valeur des barycentres

    for i=1:nbrzone
        [lig,col]=find(L==i);
        coord_y=mean(lig); % en rep�re g�om�trique la coordon�es en y est en rep�re matricielle la coordonn�e de lignes
        coord_x=mean(col); % le x g�om�trique correspond aux colonnes
        barycentres(1,i)=(coord_x); 
        barycentres(2,i)=(coord_y);
    end
end
