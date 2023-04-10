clc;
clear;
close all;

%% Basically Seperating the green
rgb1=imread("plant001.png");
rgb2=imread("plant002.png");
rgb3=imread("plant003.png");
ImageProcessing(rgb3);
figure();
ImageProcessing(rgb1);
figure();
ImageProcessing(rgb2);



%%
function ImageProcessing(rgb)
imshow(rgb)
title("Rgb Img")


grayScale=rgb2gray(rgb);
% imshow(grayScale)
% title("Gray scale Img")

redChannel=(rgb(:,:,1));
imshow(redChannel)
redChannel=imsharpen((rgb(:,:,1)));
imshow(redChannel)
greenChannel=rgb(:,:,2);
imsharpen(greenChannel)
greenChannel=imsharpen(rgb(:,:,2));
imshow(greenChannel)
imshow(redChannel)
blueChannel=rgb(:,:,3);

imshow(greenChannel)
title("green scale")

% greenChannel=imsharpen(rgb(:,:,2))
% imshow(greenChannel)
% title("green scale sharpen")

greeness2=imsubtract(greenChannel,grayScale);
imshow(greeness2);
title("Greeness 2");



% rgb=imsharpen(rgb);
% imshow(greenChannel)
% title("greenChannel")
% greenness = (greenChannel-(blueChannel+redChannel)/2);
% b = greenness(greenness>0)
% imshow(greenness)
% title("Greeness")





%%binarize image


thresh = mean(greeness2(greeness2>0));
binaryImg = greeness2 > thresh;
imshow(binaryImg)
title("binaryImg")

binaryImg2 = imbinarize(greeness2);
imshow(binaryImg2)
title("binaryImg2")

%%filtering

J= medfilt2(binaryImg) %Median filetring to remove salt and peper 
imshow(J)
title("Median Filter De Salt peper")

extractedPlant = bwareafilt(J,1) %extracts all connected components 
imshow(extractedPlant)
title("Extracted Plant")

%erosion
SE=strel('disk',1);
erodedPlant=imopen(extractedPlant,SE)
imshow(erodedPlant)
title("erodedplant")

% imshow(erodedPlant1)
% title("erodedplant1")
% erodedPlant1=imopen(imerode(extractedPlant,SE),SE)

bw2 = ~bwareaopen(~erodedPlant, 10);
imshow(bw2)
%adding color back

red_processed=redChannel.*uint8(bw2);
green_processed=greenChannel.*uint8(bw2);
blue_processed=blueChannel.*uint8(bw2);
img=cat(3,red_processed,green_processed,bw2);
imshow(img)

%%watershed

D = bwdist(~bw2);
imshow(D)
D=-D
imshow(D,[])
title("bwdist")

Ld = watershed(D);
imshow(label2rgb(Ld))
title("LD")
bw2 = erodedPlant;
bw2(Ld == 0) = 0;
imshow(bw2)
title("bw2")


mask = imextendedmin(D,1);
imshow(mask)
imshow(erodedPlant)
imshowpair(erodedPlant,mask,'blend')

D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = erodedPlant;
bw3(Ld2 == 0) = 0;
imshow(bw3)

% Create 10 data series
XY = rand(100,50)
% Build colormap and shuffle
cmap = colormap(jet(size(XY,2)));
cmap = cmap(randperm(length(cmap)),:)

Ld2(~bw3) = 0;
rgb = label2rgb(imfill(Ld2), cmap ,[0 0 0],'noshuffle');
imshow(rgb)
title('Watershed Transform')
end