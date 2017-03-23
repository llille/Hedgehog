function [newBordo]=ordonnebary(oldB,newB)  %� revoir pb m�me point
%La fonction prend 2 matrices de barycentres en entr�es et retourne la
%matrice des 4 barycentres (de la "nouvelle" image) ordonn�s
     
     %Cr�ation d'une matrice de 0 pour contenir les barycentres
     newBordo=zeros(2,4);
    
     %Ordonnement
     compteur=0;

     while (isempty(distance)==0) %tant que le tableau distance n'est pas vide (0=false)
         %Recherche des coordonn�es de la plus petite distance du tableau
         dmin=distance(1,1);
         dminX=1;
         dminY=1;
         dminXdistance=1;
         dminYdistance=1;
         for i=1:nbBnew-compteur
             for j=1:nbBold-compteur                
                 if (distance(i,j)<dmin)
                     dmin=distance(i,j);
                     %on garde les deux valeurs de x et de y 
                     %car on en aura besoin pour troncaturer la matrice
                     %distance
                     dminXdistance=i;
                     dminYdistance=j;
                 end
             end
         end
         %On va retrouver dmin dans la matrice baseDist
         for i=1:nbBnew
             for j=1:nbBold   
                 if (baseDist(i,j)==dmin)
                     dminX=i;
                     dminY=j;
                 end
             end
         end
     
         %Ajout du barycentre � la matrice newBordo
         newBordo(1,dminY)=newB(1,dminX)
         newBordo(2,dminY)=newB(2,dminX)
     
         %on enregistre les valeurs de dminX et dminY pour la prochaine
         %it�ration
         
         %Plus petite distance trouv�e, on supprime les lignes/colonnes pour obtenir un sous-tableau
         % la fin, on a une matrice 1,1, donc on s'assure d'enlever la
         % premi�re ligne
         [L,l]=size(distance);
         if (L==l==1)
             distance=[];
         elseif(L>=dminXdistance)
            distance(dminXdistance,:)=[];
         elseif(l>=dminYdistance)
            distance(:,dminYdistance)=[];
        end
         compteur=compteur+1;
     end
     
     %V�rification de newBordo (cas o� la "nouvelle" image a moins de 4 barycentres
     for c=1:4 
         if (newBordo(1,c)==0) %�a suffit de regarder o� sont les 0 avec les abscisses
             %On va mettre le barycentre de l'ancienne image � la place
              newBordo(1,c)=oldB(1,c);
              newBordo(2,c)=oldB(2,c);
         end       
     end 
    
end