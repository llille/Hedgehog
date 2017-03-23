function [bary] = TrouveBary(distance,newB)
    [nbligne,nbcolonne]=size(distance);
    min=distance(1,1);
    Xmin=1;
    Ymin=1;
    coordonnee=zeros(2,4);
    for n=1:4
        
        for i=1:nbligne
            for j=1:nbcolonne    
                 if(min==-2)
                     min=1000000;
                 end
                 if(distance(i,j)~=-1)
                     if (distance(i,j)<min)
                         min=distance(i,j);
                         Xmin=i;
                         Ymin=j;
                     end

                 end
            end 
        end
        coordonnee(1,Ymin)=newB(1,Xmin);
        coordonnee(2,Ymin)=newB(2,Xmin);
        for i=1:nbligne
            distance(i,Ymin)=-1; 
        end

        for j=1:nbcolonne
            distance(Xmin,j)=-1; 
        end
        min=-2;
    end
    bary=coordonnee;
end