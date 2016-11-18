function [X_d,Y_d] = world_position2(x,y,x_d,y_d)

% % Create a set of calibration images.
% images = imageSet(fullfile('c:\','Users','dell','Desktop','callibration'));
% 
% % Detect the checkerboard corners in the images.
% [imagePoints, boardSize] = detectCheckerboardPoints(images.ImageLocation);
% 
% % Generate the world coordinates of the checkerboard corners in the
% % pattern-centric coordinate system, with the upper-left corner at (0,0).
% squareSize = 24; % in millimeters
% worldPoints = generateCheckerboardPoints(boardSize, squareSize);
% 
% % Calibrate the camera.
% cameraParams = estimateCameraParameters(imagePoints, worldPoints);
% 
% % Load image at new location.
% imOrig = imread(fullfile('c:\','Users','dell','Desktop','callibration','21.jpg'));
% figure; imshow(imOrig);
% title('Input Image');
% 
% % Undistort image.
% im = undistortImage(imOrig, cameraParams);

%1.find the unit pixel and its corresponding real length

%x1=821;
%y1=245;
%x2=1081;
%y2=227;
point1 = [x(1),y(1)];
point2 = [x(2),y(2)];
pos = [point1;point2];
d = pdist(pos,'euclidean'); %pixel length between two points
D = 15; %real length between two points 
ratio = D/d;
x_o = (x(1)+x(2))/2;
y_o = (y(1)+y(2))/2;
%orig=[x_o,y_o];
%2.return domino's coordinate 
%x_d= input('x_d\n');
%y_d=input('y_d\n');
%domino=[x_d,y_d]; %pixel coordinate
X_d = ratio*(double(x_d) - x_o);
Y_d = ratio*(double(y_d) - y_o);
%Domino=[X_d,Y_d]; % real world coordinate

end
