close all;
clear;clc;

% ============================= 1.1 机械量 ============================= %

    l_1=0.1785;
    l_2=0.2125;
    l_3=0.2125;
    l_4=0.1785;
    l_5=0.0;

    B_L = 0.554;            % 机体长度（x方向）
    % B_L = 0.554 + 0.240;  % 机体长度（x方向 加云台） 
    B_W = 0.200;            % 机体宽度（y方向） 
    B_H = 0.167;            % 机体高度（z方向） 

    phi_1=135/180*pi;
    phi_4=45/180*pi;
    
    R = 0.06;

% ============================= VMC正解算 ============================= %

    % 1. 计算 B, D 点坐标
    xB = l_1 * cos(phi_1);
    yB = l_1 * sin(phi_1);
    xD = l_5 + l_4 * cos(phi_4);
    yD = l_4 * sin(phi_4);
    
    % 2. 计算 lBD^2
    lBD2 = (xD - xB)^2 + (yD - yB)^2;
    
    % 3. 计算 phi2
    A0 = 2 * l_2 * (xD - xB);
    B0 = 2 * l_2 * (yD - yB);
    C0 = l_2^2 + lBD2 - l_3^2;
    phi_2 = 2 * atan((B0 + sqrt(A0^2 + B0^2 - C0^2)) / (A0 + C0));
    
    % 4. 计算 C 点坐标
    xC = xB + l_2 * cos(phi_2);
    yC = yB + l_2 * sin(phi_2);
    
    % 5. 计算 phi3
    phi_3 = atan2(yC - yD, xC - xD);
    
    % 6. 计算 L0 和 phi0
    L0 = sqrt((xC - l_5/2)^2 + yC^2);
    phi0 = atan2(yC, xC - l_5/2);

% ============================= VMC正动力学 ============================= %

    F = 20;
    Tp = 0;

    J11 = (l_1 * cos(phi0 - phi_3) * sin(phi_1 - phi_2)) / (L0 * sin(phi_3 - phi_2));
    J12 = (l_1 * sin(phi0 - phi_3) * sin(phi_1 - phi_2)) / sin(phi_3 - phi_2);
    
    J21 = (l_4 * cos(phi0 - phi_2) * sin(phi_3 - phi_4)) / (L0 * sin(phi_3 - phi_2));
    J22 = (l_4 * sin(phi0 - phi_2) * sin(phi_3 - phi_4)) / sin(phi_3 - phi_2);
    
    T1 = J11*Tp + J12*F;
    T4 = J21*Tp + J22*F;

    fprintf('运行结束，当前时间：%s\n', datetime("now"));