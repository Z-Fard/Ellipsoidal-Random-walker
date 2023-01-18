clear
%hold on
clc
% for larg number of ensembles turn off waitbar
%hw = waitbar(0,'Please Wait ...'); % turn off waitbar


%% Pre Allocations
ns = 400; % Number of Steps
ne = 1000; % Number of Ensembles
interval = 50;
R = 200;
D_x_All = zeros(R,ns-interval-1);
D_y_All = zeros(R,ns-interval-1);

h = waitbar(0,'Please wait ...');
for Repeat = 1:R
    x = zeros(ne,ns);
    y = zeros(ne,ns);
    theta = zeros(ne,ns);

    delta_t = 0.04;
    
    % Calculation length step in each jump :
    delta_x=0.1; % change order of diffusion coeffficient
    delta_y=0.1 ;
    delta_theta = pi/40;%   in pi/10 is good aproximate %(pi/180)*0.1; %sqrt(D_rotational.*delta_t);
    %***********************************************************
    % Ellipsoidal Particles Coefficients: Perrin:
    eta = 0.001;
    a =5.9;
    b = 1.3;
    s = 2./(sqrt(a.^2-b.^2)).*log((a+sqrt(a.^2-b.^2))./b);
    gama_par = 16.*pi.*eta.*(a.^2-b.^2)./((2.*a.^2-b.^2).*s-(2.*a));
    gama_per = 32.*pi.*eta.*(a.^2-b.^2)./((2.*a.^2-3.*b.^2).*s+(2.*a));
    gama_rotational_per= 32.*pi.*eta.*((a.^2-b.^2).*b.^2)./(3.*(2.*a.^2-(b.^2).*s));
    KT=1.38.*(19+273);
    
    D = [KT./gama_par 0; 0 KT./gama_per];  
    
    %Diffusion Coefficients:
    %Rotational Diffusion
    D_theta= 1./gama_rotational_per;
    %Translational Diffusion: Parallel and Perpendicular
    D_par= (KT./gama_par).*(10.^(-5));
    D_per = (KT./gama_per).*(10.^(-5));
    
    %% Main 
    for e=1:ne
        for i=1:ns-1
            r1 = rand(1);
            theta(e,i+1) = theta(e,i) + delta_theta.*sign(r1-0.5);
            
            r2 = rand(1);
            p_x= (D_par )./(D_par+D_per);
            
            if (r2 < p_x)
                y(e,i+1) = 0;
                
                r3 = rand(1);
                x(e,i+1) = delta_x.*sign(r3-0.5);              
            else
                x(e,i+1) = 0;
                
                r4 = rand(1);
                y(e,i+1) = delta_y.*sign(r4-0.5);           
            end          
        end     
    end  
    
    %Rotation Matrix to convert from paticle fram to labratory framwork
    %R=[cos(theta(e,i)) sin(theta(e,i)); -sin(theta(e,i)) cos(theta(e,i))]; 
    x_new = x .* cos(theta) - y .* sin(theta);
    x_f= cumsum(x_new,2);
    
    y_new = x .* sin(theta) + y .* cos(theta);
    y_f= cumsum(y_new,2);
    
    % Mean Square Displacements:
    % Calculating MSD theta
    theta2 = theta.^2;
    MSD_theta = mean(theta2) - (mean(theta)).^2;
    time = 0:0.04:(ns-1).*0.04;
    
    %Calculating MSD x
    x2 = x_f.^2;
    MSD_x = mean(x2) - (mean(x_f)).^2;
    
    % %Calculating MSD y
    y2 = y_f.^2;
    MSD_y = mean(y2) - (mean(y_f)).^2;
    
    %*************************************** 
    for i=1:length(time)-interval-1
        start = i;
        stop = i+interval;
        p_1 = polyfit(time(start:stop),MSD_x(start:stop),1);
        D_new_x(i)=p_1(1)./2;
        p_2 = polyfit(time(start:stop),MSD_y(start:stop),1);
        D_new_y(i)=p_2(1)./2;
    end
    
    MSD_x_All(Repeat,:) = MSD_x;
    MSD_y_All(Repeat,:) = MSD_y;
    MSD_theta_All(Repeat,:) = MSD_theta;
    
    D_x_All(Repeat,:) = D_new_x;
    D_y_All(Repeat,:) = D_new_y;
   
    waitbar(Repeat/R);
end
close(h);
z=R;
