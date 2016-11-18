
%% Move to the target position
% e.g. move to (12,-14)
target_x=12;
target_y=-14;
x_2=target_x;

target_e=sqrt(target_x^2+target_y^2);
dis=target_e-x_1;
s=dis/5;   % divided into 5 steps

% Rotation
theta_0_e=atand(target_y/target_x);
angle1_e=(1023/300)*theta_0+521;
calllib('dynamixel','dxl_write_word',1,30,angle1_e);%move motor1

%if target_e < x_1
for i=1:1:5
    x_2=x_2+s;
    y_2=-base;
    K_e=(x_2^2+y_2^2-link_1^2-link_2^2)/(2*link_1*link_2);
    theta_2_e = acosd(K_e);
    theta_2_e = -theta_2_e;

    S_theta_1_e=(-x_2*link_2*sind(theta_2_e)+y_2*(link_1+link_2*cosd(theta_2_e)))/(link_1^2+link_2^2+2*link_1*link_2*cosd(theta_2_e));
    C_theta_1_e=(y_2*link_2*sind(theta_2_e)+x_2*(link_1+link_2*cosd(theta_2_e)))/(link_1^2+link_2^2+2*link_1*link_2*cosd(theta_2_e));

    % new_theta_r=atan2(S_theta_1,C_theta_1);
    % theta_1=180*(new_theta_r)/pi;
    theta_1_e=atan2d(S_theta_1_e,C_theta_1_e);


    %calculate angles of joints (revise??)
    angle2_e=(1023/300)*theta_1_e+230;
    angle3_e=-(1023/300)*theta_2_e+500;

    calllib('dynamixel','dxl_write_word',3,30,angle3_e);%move motor3
    %pause(3)
    calllib('dynamixel','dxl_write_word',2,30,angle2_e);%move motor2
end
    
 %% Finish
