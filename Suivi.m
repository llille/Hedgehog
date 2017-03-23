clear all
close all

% Transfert video à image
video = VideoReader ('vid_in.mp4'); % lire la vidéo
load('modele.mat'); % chargement des paramètres
load('modeleDoigt.mat'); % chargement des paramètres
mu=M(1,:);
S=M(2:4,:);
N = video.NumberOfFrames; % nombre d'image dans la vidéo

%Motif à incorporer
Imotif=imread('herisson.jpg');

%Initialisation de la vidéo de sortie
aviobj=VideoWriter('video.avi','Uncompressed AVI');
open(aviobj)


for n=1:N % parcourt la vidéo image par image
    n
    % Segmentation à l'aide du modèle
    I = double(read (video, n));
    DmalaI=mahalanobis(I,mu,S);  % calcul de la distance au modèle M pour chaque pixel de l'image
    
    % Seuillage de l'image à l'aide de Vseuil (compris entre 0 et 1)
    IMax = max(max(DmalaI)); % on trouve la valeur max de l'image 
    IGris = DmalaI./IMax;  %on divise tout les point par cette valeur max --> permet d'attribuer à chaque pixel une valeur entre 0 et 1 
                            %on obtient donc une image en niveaux de gris  
                            
                            
                            
    ISeuillee = zeros(size(IGris)); %on crée une matrice vide de zéro (correspond à des pixels blancs)
    ISeuillee(IGris < Vseuil) = 1;% si la valeur du pixel < Vseuil, pixel mis en noir
    
    ISeuilleeDoigt = zeros(size(IGris));
    ISeuilleeDoigt(IGris > 0.55) = 1;

    % oprétateur morphologique
    se = strel('arbitrary',50);
    ISeuillee = imerode(ISeuillee,se);
    ISeuillee = imdilate(ISeuillee,se);
    
    % Labellisation 
    [imageLabellisee,nbrzone] = bwlabel(ISeuillee);
    
    %Calcul des barycentres des différentes zone de l'image labellisée     
    barycentres=bary(imageLabellisee,nbrzone);
    
%     %test : affiche les 4 barycentres
%     imshow(uint8(I));
%     hold on;
%     plot(barycentres(1,1),barycentres(2,1),'ro');
%     plot(barycentres(1,2),barycentres(2,2),'ro');
%     plot(barycentres(1,3),barycentres(2,3),'ro');
%     plot(barycentres(1,4),barycentres(2,4),'ro');
    
    %Comparaison pour sortir une matrice de barycentres ordonnées           
   if (n==1)
        %On s'est assuré par notre modèle d'avoir uniquement 4 zones lors
        %du traitement de la première image
        
        %Ordonner les barycentres de la 1ère image
        newBaryOrdonnes=zeros(2,4); %on cree la matrice de barycentres ordonnés
        cpt=0;
        for i=1:4 %On fait une boucle qui trouvera les 4 xMin
            xMin=min(barycentres(1,:)); % on trouve le xMin
            for j=1:(4-cpt) % On parcourt la matrice
                if (barycentres(1,j)==xMin) %On place le xMin a la bonne place dans BaryOrdonne 
                    newBaryOrdonnes(1,i)=barycentres(1,j);
                    newBaryOrdonnes(2,i)=barycentres(2,j);
                    col=j;   
                end
            end
            barycentres(:,col)=[];
            cpt=cpt+1;
        end
        
        if (newBaryOrdonnes(2,1)>newBaryOrdonnes(2,2))
            ValInter=newBaryOrdonnes(:,1);%on place la colonne dans une variable intermédiaire
            newBaryOrdonnes(:,1)=newBaryOrdonnes(:,2);
            newBaryOrdonnes(:,2)=ValInter;
        end
        
        if (newBaryOrdonnes(2,3)<newBaryOrdonnes(2,4))
            ValInter=newBaryOrdonnes(:,3);%on place la colonne dans une variable intermédiaire
            newBaryOrdonnes(:,3)=newBaryOrdonnes(:,4);
            newBaryOrdonnes(:,4)=ValInter;
        end
     % l'image sort dans le mauvais sens 
     % on change l'ordre des barycentres
        
        saveNewBarryOrdonnes = newBaryOrdonnes;
        newBaryOrdonnes(:,2) = saveNewBarryOrdonnes(:,4);
        newBaryOrdonnes(:,4) = saveNewBarryOrdonnes(:,2);
                             
                
    else %on ne peut pas comparer la 1ère image
      %Comparaison de deux images 

      [newBaryOrdonnes]=distance(oldB,barycentres);
      
    end  
   
    %Incrustation
    Ivideo = read (video, n); 

    x=zeros(1,4);
    y=zeros(1,4);
    for k=1:4
        x(1,k)=newBaryOrdonnes(1,k) ;
        y(1,k)=newBaryOrdonnes(2,k);
    end
    
    scale=0.80;
 
    mask=zeros(size(Ivideo));
     %imshow(Ivideo);
     if (i == 1)
                videoR = uint8(zeros(size(frame, 1),size(frame, 2), 3, N));
     end
     
    frame = motif2frame(Imotif,Ivideo,x,y,scale,ISeuilleeDoigt);
    writeVideo(aviobj, frame);
    oldB=newBaryOrdonnes; %on enregistre le barycentre de l'image qui va devenir l'"image précédente"
    
end

close(aviobj);

