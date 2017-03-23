function [barycentres] = bary(L,nbrzone) %Image seuillée
%prend le nombre de zone et l'image labellisée et renvoie les barycentres
%des zones labellisées

barycentres=ones(2,nbrzone); %On crée un tableau vide pour rentrer la valeur des barycentres

    for i=1:nbrzone
        [lig,col]=find(L==i);
        coord_y=mean(lig); % en repère géométrique la coordonées en y est en repère matricielle la coordonnée de lignes
        coord_x=mean(col); % le x géométrique correspond aux colonnes
        barycentres(1,i)=(coord_x); 
        barycentres(2,i)=(coord_y);
    end
end
