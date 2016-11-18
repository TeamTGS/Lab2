%function total_bbox_number = getValueV2(colorImage)
%% Code referred from: 
%   http://au.mathworks.com/help/vision/examples/automatically-detect-and-recognize-text-in-natural-images.html
%   read image
colorImage = imread('\positive\KinectScreenshot-Color-06-06-01.png');
%I = histeq(imadjust(colorImage(:,:,3)));
I = imadjust(colorImage(:,:,3));
%I = rgb2gray(colorImage);

% Detect MSER regions.
[mserRegions, mserConnComp] = detectMSERFeatures(I, ...
    'RegionAreaRange',[200 8000],'ThresholdDelta',4);

% figure
% imshow(I)
% hold on
% plot(mserRegions, 'showPixelList', true,'showEllipses',false)
% title('MSER regions')
% hold off

% Use regionprops to measure MSER properties
mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');

% Compute the aspect ratio using bounding box data.
bbox = vertcat(mserStats.BoundingBox);

w = bbox(:,3);
h = bbox(:,4);
aspectRatio = w./h;


% % Threshold the data to determine which regions to remove. These thresholds
% % may need to be tuned for other images.
% filterIdx = aspectRatio' > 3;
% filterIdx = filterIdx | [mserStats.Eccentricity] > .995 ;
% filterIdx = filterIdx | [mserStats.Solidity] < .3;
% filterIdx = filterIdx | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.9;
% filterIdx = filterIdx | [mserStats.EulerNumber] < -4;
% 
% % Remove regions
% mserStats(filterIdx) = [];
% mserRegions(filterIdx) = [];

% % Show remaining regions
% figure
% imshow(I)
% hold on
% plot(mserRegions, 'showPixelList', true,'showEllipses',false)
% title('After Removing Non-Text Regions Based On Geometric Properties')
% hold off


% % Get a binary image of the a region, and pad it to avoid boundary effects
% % during the stroke width computation.
% regionImage = mserStats(6).Image;
% regionImage = padarray(regionImage, [1 1]);
% 
% % Compute the stroke width image.
% distanceImage = bwdist(~regionImage);
% skeletonImage = bwmorph(regionImage, 'thin', inf);
% 
% strokeWidthImage = distanceImage;
% strokeWidthImage(~skeletonImage) = 0;
% 
% % Show the region image alongside the stroke width image.
% figure
% subplot(1,2,1)
% imagesc(regionImage)
% title('Region Image')
% 
% subplot(1,2,2)
% imagesc(strokeWidthImage)
% title('Stroke Width Image')
% 
% Get bounding boxes for all the regions


% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience.
xmin = bbox(:,1);
ymin = bbox(:,2);
xmax = xmin + bbox(:,3) - 1;
ymax = ymin + bbox(:,4) - 1;

% Expand the bounding boxes by a small amount.
expansionAmount = 0.02;
xmin = (1-expansionAmount) * xmin;
ymin = (1-expansionAmount) * ymin;
xmax = (1+expansionAmount) * xmax;
ymax = (1+expansionAmount) * ymax;

% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1);
ymin = max(ymin, 1);
xmax = min(xmax, size(I,2));
ymax = min(ymax, size(I,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
%IExpandedBBoxes = insertShape(colorImage,'Rectangle',expandedBBoxes,'LineWidth',3);

% figure
% imshow(IExpandedBBoxes)
% title('Expanded Bounding Boxes Text')

%% Delete repeat bbox (by W.Dong)
%  This method calculates the overlap ratio of each bbox area. If the
%  overlap ratio is larger than a specific value (currently assume 60%), then it means
%  the program counts same dominoes' dot. Therefore, it reqiures to delete
%  the repeat bbox.

%   computing bbox overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);

n = size(overlapRatio,1);
% count=1;
j=1;
while j~=n
for i=j:1:n
    ratio_value = bboxOverlapRatio (expandedBBoxes (j,:),expandedBBoxes (i,:));
    
    %   Set overlap ratio range (currently use 60%~99.99999%)
    if ratio_value >0.6 & ratio_value <1
        expandedBBoxes(i,:)=[0,1,2,3];
    end
%     count=count+1;  
end
j=j+1;
end

bbox_no = size(expandedBBoxes,1);
for i = 1:bbox_no
   
    if expandedBBoxes(i,3)/expandedBBoxes(i,4) < 0.7 || (expandedBBoxes(i,3)/expandedBBoxes(i,4) > 1.3)
        expandedBBoxes(i,:) = [0,1,2,3];
    end
    
end

%   Create new bbox matrix
id=expandedBBoxes(:,1)<=0 & expandedBBoxes(:,1)>=0;
expandedBBoxes(id,:)=[];



IExpandedBBoxes = insertShape(colorImage,'Rectangle',expandedBBoxes,'LineWidth',3);
figure
imshow(IExpandedBBoxes)

title(num2str(size(expandedBBoxes,1)));


%   Find total bbox number (need to deduct middle bar) 
%   need to deduct the total number of dominoes. The reason is this code will count middle bar
total_bbox_number = size(expandedBBoxes,1);

%end

