function dynamixel_move(domino_position)

    loadlibrary('dynamixel','dynamixel.h');
    DEFAULT_PORTNUM = 5; % com5
    DEFAULT_BAUDNUM = 1; % 1mbps
    calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);%open device

    calllib('dynamixel','dxl_write_word',3,32,70);% motor3 speed
    calllib('dynamixel','dxl_write_word',1,32,80);% motor1 speed
    calllib('dynamixel','dxl_write_word',2,32,30);% motor2 speed
       calllib('dynamixel','dxl_write_word',3,30,500);%move motor3
        calllib('dynamixel','dxl_write_word',1,30,521);%move motor1
        calllib('dynamixel','dxl_write_word',2,30,330);%move motor2
    %% Move to the target position
    
  
    base = 18;
    link_1 = 16.5;
    link_2 = 16;
  
        x_w = domino_position(1)-1.5;
        y_w = domino_position(2)-1.5
        theta_0 = atand(y_w/x_w)
        if theta_0 < 0
        theta_0=180+theta_0;
        else 
        end
        x_1=sqrt(x_w^2+y_w^2);
        y_1=-base;
        K=(x_1^2+y_1^2-link_1^2-link_2^2)/(2*link_1*link_2);
        theta_2 = acosd(K);
        theta_2 = -theta_2

        S_theta_1=(-x_1*link_2*sind(theta_2)+y_1*(link_1+link_2*cosd(theta_2)))/(link_1^2+link_2^2+2*link_1*link_2*cosd(theta_2));
        C_theta_1=(y_1*link_2*sind(theta_2)+x_1*(link_1+link_2*cosd(theta_2)))/(link_1^2+link_2^2+2*link_1*link_2*cosd(theta_2));

        theta_1 = atan2d(S_theta_1,C_theta_1)

        %calculate angles of joints
        angle1 = (1023/300)*theta_0+521;
        angle2 = (1023/300)*theta_1+230;
        angle3 = -(1023/300)*theta_2+500;

        %start moving

        calllib('dynamixel','dxl_write_word',1,30,angle1);%move motor1
        calllib('dynamixel','dxl_write_word',3,30,angle3);%move motor3
        calllib('dynamixel','dxl_write_word',2,30,angle2);%move motor2
        pause(3)

        target_x=-17;
        target_y=17;

        target_e=sqrt(target_x^2+target_y^2);
        x_2=x_1;
        dis=target_e-x_1;
        s=dis/50;   % divided into 5 steps

        % Rotation
        theta_0_e=atand(target_y/target_x);
        if theta_0_e < 0
            theta_0_e=180+theta_0_e;
        else 
        end
        angle1_e=(1023/300)*theta_0_e+521;
        calllib('dynamixel','dxl_write_word',1,30,angle1_e);%move motor1
        pause(3)

        for jj=1:1:50
            x_2=x_2+s;
            y_2=-base;
            K_e=(x_2^2+y_2^2-link_1^2-link_2^2)/(2*link_1*link_2);
            theta_2_e = acosd(K_e);
            theta_2_e = -theta_2_e;

            S_theta_1_e=(-x_2*link_2*sind(theta_2_e)+y_2*(link_1+link_2*cosd(theta_2_e)))/(link_1^2+link_2^2+2*link_1*link_2*cosd(theta_2_e));
            C_theta_1_e=(y_2*link_2*sind(theta_2_e)+x_2*(link_1+link_2*cosd(theta_2_e)))/(link_1^2+link_2^2+2*link_1*link_2*cosd(theta_2_e));

            theta_1_e=atan2d(S_theta_1_e,C_theta_1_e);

            %calculate angles of joints (revise??)
            angle2_e=(1023/300)*theta_1_e+230;
            angle3_e=-(1023/300)*theta_2_e+500;
            calllib('dynamixel','dxl_write_word',3,30,angle3_e);%move motor3
          
            calllib('dynamixel','dxl_write_word',2,30,angle2_e);%move motor2

           

        end
        pause(3) %calibration
        calllib('dynamixel','dxl_write_word',3,30,500);%move motor3
        pause(1)
        calllib('dynamixel','dxl_write_word',1,30,521);%move motor1
        calllib('dynamixel','dxl_write_word',2,30,330);%move motor2


   
    calllib('dynamixel','dxl_terminate');%% Finish

end
