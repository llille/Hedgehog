function [dist] = distance(oldB,newB) 
     
    %Cr�ation tableau de distance entre les barycentres
     [a,b] = size(oldB);
     nbBold=b; %nombre de barycentres de l'image pr�c�dente
     [c,d] = size(newB);
     nbBnew=d;
     dist=ones(nbBnew,nbBold); %cr�ation tableau avec le nombre de barycentres de l'image actuelle en abscisses 
                            %et le nombre de barycentres de l'ancienne image en ordonn�es   
     for i=1:nbBnew
         for j=1:nbBold
             dist(i,j)=sqrt((newB(1,i)-oldB(1,j)).^2+(newB(2,i)-oldB(2,j)).^2);
         end             
     end  
     
     dist=TrouveBary(dist,newB);
end