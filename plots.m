
%***********plot D**********

D_x_Final = mean(D_x_All);
D_x_Error = (std(D_x_All))./(sqrt(z));

D_y_Final = mean(D_y_All);
D_y_Error = (std(D_y_All))./(sqrt(z));

xaxis =(1:length(time)-interval-1);

figure; 
errorbar (xaxis,D_x_Final,D_x_Error,'color',[0.73, 0.83, 0.96]);
hold on
plot(xaxis,D_x_Final , 'b')


hold on
errorbar(xaxis,D_y_Final,D_y_Error,'color',[1, 0.6, 0.78]);
plot(xaxis,D_y_Final , 'r')

set(gca,'xscale','log');
xlabel('Time[s]');
ylabel('D_{(x,y)} [{\mum^2/s}]');

%*****save D*****

saveas(gcf,'D.fig')
%*********plot MSD x y theta***********************

MSD_x_Final = mean(MSD_x_All);
MSD_x_Error = (std(MSD_x_All))./(sqrt(z));

MSD_y_Final = mean(MSD_y_All);
MSD_y_Error = (std(MSD_y_All))./(sqrt(z));

MSD_theta_Final = mean(MSD_theta_All);
MSD_theta_Error = (std(MSD_theta_All))./(sqrt(z));

xaxis =(time);
%***x
figure; 
errorbar (xaxis,MSD_x_Final,MSD_x_Error,'color',[0.73, 0.83, 0.96]);
hold on
plot(xaxis, MSD_x_Final, 'b');
hold on
%***y
hold on
errorbar (xaxis,MSD_y_Final,MSD_y_Error,'color',[1, 0.6, 0.78]);
plot(xaxis, MSD_y_Final ,' r')


set(gca,'xscale','log');
set(gca,'yscale','log');
xlabel('Time[s]');
ylabel('MSD_{(x,y)}[{\mum^2}]');

axes('Position',[.6 .2 .3 .3])

%***theta
hold on
errorbar (xaxis,MSD_theta_Final,MSD_theta_Error,'color', [0.76 , 0.87 , 0.78]);

plot(xaxis, MSD_theta_Final ,'color', [0, 0.5 , 0])

set(gca,'xscale','log');
set(gca,'yscale','log');
xlabel('Time[s]');
ylabel('MSD_{\theta}[{rad^2}]');
%******save MSD x y theta ***************

saveas(gcf,'MSD.fig')


%*****save workspace MSD_theta and time******
%save('MSD_theta.mat','MSD_theta_Final' , 'time')

%save('ellip.mat')