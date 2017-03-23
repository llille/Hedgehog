%CREATION DU MODELE DU DOITGH
clear all
close all

% Transfert video à image
video = VideoReader ('vid_in.mp4'); % lire la vidéo
n = 44;
I = double(read (video, n)); % récupére la n image de la vidéo
imshow(uint8(I)) % affiche l'image


% Selection zone
zoom on; % active le zoom
pause(); % enleve le zoom des qu'une touche est appuyée
nb_points = 2;
[x,y] = ginput (nb_points); % permet de trouver les abscisses et ordonnées des 2 points cliqués


selection = [x(1),y(1),x(2)-x(1),y(2)-y(1)]; % correspond à x0 y0 (point bas gauche) longueur largeur
rectangle('Position', selection )%tracer le rectangle
IS = double(imcrop (I,selection)); % extraction de la sélection
figure(2), imshow(uint8(IS)) % affiche la zone selectionnée

% Calcul modele
    % calcul de la moyenne mu
    ISR = IS(:,:,1); % matrice de la composante rouge de IS
    R = ISR(:); % ISR sous forme de vecteur colonne
    muR = mean(R); % moyenne de la composante rouge de IS
    ISV = IS(:,:,2); % matrice de la composante verte de IS
    V = ISV(:);
    muV = mean(V);
    ISB = IS(:,:,3); % matrice de la composante bleue de IS
    B = ISB(:);
    muB = mean(B);
    
    mu = [muR muV muB];
   
    % calcul de la matrice de covariance Sigma
    S11 = sum((R-muR).*(R-muR)); % R - muR correspond à un vecteur colonne contenant (xiR - muR)²
    S12 = sum((R-muR).*(V-muV));
    S13 = sum((R-muR).*(B-muB));
    S21 = S12; % car les termes antidiagonaux sont égaux
    S22 = sum((V-muV).*(V-muV));
    S23 = sum((V-muV).*(B-muB));
    S31 = S13;
    S32 = S23;
    S33 = sum((B-muB).*(B-muB));
    
    S = [S11 S12 S13; S21 S22 S23;  S31 S32 S33];


M = [mu;S]; % le modele M


%Calcul de la distance de Mahalanobis
DmalaI=mahalanobis(I,mu,S); %On appelle la fonction exterieure dmala

%Determination du seuil
Vseuil=0.06;

[l,c,a]=size(I);
I2=ones(l,c,a);%Création d'une image vide
for i=1:l
        for j=1:c
            if (DmalaI(i,j)<Vseuil)
                I2(i,j,1)=255;
                I2(i,j,2)=0;
                I2(i,j,3)=0;
            else
                I2(i,j,1)=0;
                I2(i,j,2)=0;
                I2(i,j,3)=255;
            end
        end
end
imshow(uint8(I2));

%Sauvegarde le modèle dans le fichier destination
save('modeleDoigt.mat', 'mu', 'S');
    