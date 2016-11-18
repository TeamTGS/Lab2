clear
clc
load('labelingSession.mat');

imDir = ('C:\Users\Alex\Desktop\Lab2\positive');
addpath(imDir);

negativeFolder = ('C:\Users\Alex\Desktop\Lab2\negative');   
trainCascadeObjectDetector('dominoDetecor.xml',positiveInstances,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);   

detector = vision.CascadeObjectDetector('dominoDetecor.xml');

img = imread('\positive\capture.png');
bbox = step(detector,img);

detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Dominos');   
%%
% Display the detected stop sign.
figure;
imshow(detectedImg);
    
%%
% Remove the image directory from the path.
rmpath(imDir);