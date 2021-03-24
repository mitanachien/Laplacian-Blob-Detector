img=rgb2gray(imread('images/fishes.jpg'));

tic;

img=im2double(img);
[img_r,img_l]=size(img);
n=1;
scale_space=zeros(img_r,img_l,n);
k=1.28;
sigma=2;
LoG_scales=zeros(1,15);

%Calculating sigma for different scale space by multiplying sigma with k
for i=1 : 15
    LoG_scales(1,i) = sigma;
    sigma=k*sigma;
end

%Creating filter and applying it on image and creating scale space 
for scale = LoG_scales
    filt_size = 2*ceil(scale*3)+1;
    %LoG = fspecial('log', filt_size, sigma);
    norm_LoG = (scale.^2) * fspecial('log', filt_size, scale);  % Scale Normalize Laplacian
    img_LoG = myconv2(img, norm_LoG);
    %img_LoG = myconv(img, norm_LoG);
    img_LoG = img_LoG.*img_LoG;  % Square of Laplacian Response

    if n==1
        scale_space = img_LoG;
    else
        scale_space = cat(3,scale_space,img_LoG);
    end
    n=n+1;
end

%Performing Non Maximum Supression on each 2D layer of the Scale Space
for i=1:15
    layer = scale_space(:,:,i);
    img_max = mymax(layer,ones(3,3));   %Getting the maximas for the layer
    
    if i==1
        img_max_set = img_max;
    else
        img_max_set = cat(3,img_max_set,img_max);
    end
end

%Finding Maximum values in the 3D Scale Space 
img_max_3d = max(img_max_set,[],3);
img_max_3d = (img_max_3d==img_max_set).*img_max_set;

%Replacing all non maximum values with zeros 
%Finding coordinates of the maximas and drawing circles for that maxima.
for i=1: 15
    radius = 1.414 * LoG_scales(i);  %Calculating Radius
    th = 0.007;                 %Setting threshold
    layer = scale_space(:,:,i);
    layer = (layer==img_max_3d(:,:,i))&(layer>th);
    [row,col] = find(layer);
    if i==1
        row2 = row;
        col2 = col;     
        rad = repmat(radius,size(row,1),1);
    else
        rad2 = repmat(radius,size(row,1),1);
        rad = cat(1,rad,rad2);
        row2 = cat(1,row2,row);
        col2 = cat(1,col2,col);
    end
end

toc;  % Displaying Elapsed Time
show_circles(img, col2, row2, rad, 'r', 1.5); 

% %g = conv2(img,w,'same');
% g = myconv(img, LoG);
% imshow(g); pause;
% g(g < 1.1) = 0;
% imshow(g); pause;
% gd = imdilate(g,strel('disk',2));
% imshow(gd); pause;
% P = (g == gd) .* g;
% figure(1);
% imshow(P);


% figure(2);
% imshow(g2); pause;
% g2 = g2.*g2;
% imshow(g2); pause;
% g2(g2 < 5) = 0;
% imshow(g2); pause;
% gd2 = imdilate(g2,strel('disk',2));
% imshow(gd2); pause;
% P2 = (g2 == gd2) .* g2;
% imshow(P2);

% loc = find(P > 0);
% fprintf('There are %d blobs\n',numel(loc));



