%% start

clear
close all
picture_ok = false;

while picture_ok == false
    output = realbboxcenters();
    [dominoNumber,~] = size(output);
    domino_val = output(:,3);
    realbboxcenter(:,1) = output(:,1);
    realbboxcenter(:,2) = output(:,2);
    %% do you want this picture?
    prompt = ('Use this picture? Y/N [N]: ');
    picture_ok = input(prompt,'s');
    if isempty(picture_ok)
        picture_ok = 'N';
    end
    
    if picture_ok == 'N'
        picture_ok = false;
        clf(1);
    end

    if picture_ok == 'Y'
        break;
    end
end


%%
disp('pick two reference points');
% pick two points from figure
% color scale has to be 1, otherwise the scale is not
% 1920x1080
[x,y] = ginput(2);
dominos_position = zeros(dominoNumber,2,'double');
for i = 1:dominoNumber    
    % feed the world_position2()
    % syntax [X_d,Y_d] = world_position2(x,y,x_d,y_d)
    % x and y from userinput
    % x_d and y_d from realbboxcenter

    [dominos_position(i,1), dominos_position(i,2)] = world_position2(round(x),round(y),realbboxcenter(i,1),realbboxcenter(i,2));
    disp('Domino position calculated');
end

% sort



%% move accrodingly
i = 1;
while (i <= dominoNumber)

    prompt = 'Do you want to move? Y/N [N]: ';
    motor_go = input(prompt,'s');
    if isempty(motor_go)
        motor_go = 'N';
    end

    if motor_go == 'Y'
        dynamixel_move(dominos_position(i,:));
        i = i + 1;
    end
end
disp('All done');

pause(0.02)


%% Close kinect object
