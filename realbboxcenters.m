%function output = realbboxcenters()
% Citation:
% Terven J. Cordova D.M., "Kin2. A Kinect 2 Toolbox for MATLAB", Science of
% Computer Programming.
% https://github.com/jrterven/Kin2, 2016.

%% clean up
close all
addpath('kinect interface\Mex');
load('cameraParam.mat');
%% initialize

% initialize Kin2 with color and depth sensor
k2 = Kin2('color','depth');
pause(2)
% size of color source
color_width = 1920; color_height = 1080;

% size of depth source
%d_width = 512; d_height = 424; outOfRange = 4000;

% rescale for higher performance
colorScale = 1;

% fill matrix with zeros
color = zeros(color_height*colorScale,color_width*colorScale,3,'uint8');
%depth = zeros(d_height,d_width,'uint16');

% draw figure with color size
figure(1), h2 = imshow(color,[]);

% title of figure
title('Color Source');

% use the object detector trained beforex
detector = vision.CascadeObjectDetector('dominoDetector1978_0.2_10.xml');

%% start

% Before processing the data, we need to make sure that a valid
% frame was acquired.
    
    validData = k2.updateData;
    pause(2)
    if validData
        % Copy data to Matlab matrices
        % use this if connect to kinect
        color = k2.getColor;
        %depth = k2.getDepth;

        %% update color figure
        color = undistortImage(imresize(color,colorScale),cameraParams);
        bbox = step(detector,color);

        %% count total domino numbers
        [dominoNumber,~] = size(bbox);

        %% if domino exist
        if dominoNumber ~= 0

            bboxcenter = zeros(dominoNumber,2,'uint16');
            realbboxcenter = zeros(dominoNumber,2,'uint16');
            %depthCoords = zeros(dominoNumber,2,'uint16');
            %depthValue = zeros(dominoNumber,1,'uint16');
            %realLocation = zeros(dominoNumber,2,'int64');
            %pixelX = zeros(dominoNumber,1,'double');
            %pixelY = zeros(dominoNumber,1,'double');
            %bboxx = zeros(dominoNumber);
            %bboxy = zeros(dominoNumber);
            domino_val = zeros(dominoNumber,1);
            newbbox = zeros(dominoNumber,4);


           newbbox(:,1) = bbox(:,1) - 10;
           newbbox(:,2) = bbox(:,2) - 10;
           newbbox(:,3) = bbox(:,3) + 20;
           newbbox(:,4) = bbox(:,4) + 20;

            
            for i = 1:dominoNumber
                bboxcenter(i,:) = [floor(bbox(i,1) + (bbox(i,3)/2)),floor(bbox(i,2) + (bbox(i,4)/2))];
                domino_val(i) = getValueV2(imresize(imcrop(color,newbbox(i,:)),2));
            end

            % real pixel on real picture
            for i = 1:dominoNumber
                realbboxcenter(i,:) = ([bboxcenter(i,1)/colorScale bboxcenter(i,2)/colorScale]);
            end
            tempoutput = cat(2,domino_val,realbboxcenter);
            output = sortrows(tempoutput);
        end
        label_str = cell(dominoNumber,1);
        for ii=1:dominoNumber
                label_str{ii} = ['Domino:' num2str(ii) ' , x: ' num2str(realbboxcenter(ii,1)) ', y:' num2str(realbboxcenter(ii,2)) ', value:' num2str(domino_val(ii)-1)];
        end
        detectedImg = insertObjectAnnotation(color,'rectangle',newbbox,label_str);
        color = insertMarker(detectedImg,bboxcenter,'x','color','red','size',5);
        set(h2,'CData',color);
    end
    k2.delete;
%end
