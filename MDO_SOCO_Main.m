clc
clear
rand('seed',1)
tic
%initial parameters
maxgene=20;
%% structure
Sub_A_Out=zeros(9,maxgene);
Sub_B_Out=zeros(9,maxgene);
Sys_T=zeros(5,maxgene);


%% initial values

% Sys_T(:,1)=[-2.8014,0.0757,0.1021,8,0.1292];%(x1,x2,x3,y1,y2) local minima
% Sys_T(:,1)=[3.0284,0,0,8,5.8569];%(x1,x2,x3,y1,y2)
%   Sys_T(:,1)=[10,5,10,108.9128,30.4361];%(x1,x2,x3,y1,y2)
 Sys_T(:,1)=[1,0,5,2.3814,25.0932];%(x1,x2,x3,y1,y2)
%  Sys_T(:,1)=[1,0,5,5.2586,3.7068];%(x1,x2,x3,y1,y2)
 
%main loop
for jj=1:maxgene
    
    [Sub_A]=myfun_MDO_SOCO_Sub_A(Sys_T(:,jj));
    val_A=Sub_A; %(x1,x2,x3,v1,v2,v3,v4,y1,y2,gb)
    Sub_A_Out(:,jj)=val_A;
    [Sub_B]=myfun_MDO_SOCO_Sub_B(Sys_T(:,jj));
    val_B=Sub_B;
    Sub_B_Out(:,jj)=val_B; %(x1,x2,x3,v1,v2,v3,v4,y1,y2,gb)
    
    Sys_T(1,jj+1) = 1/2.*(Sub_A_Out(1,jj)+Sub_B_Out(1,jj));
    Sys_T(2,jj+1) = 1/2.*(Sub_A_Out(2,jj)+Sub_B_Out(2,jj));
    Sys_T(3,jj+1) = 1/2.*(Sub_A_Out(3,jj)+Sub_B_Out(3,jj));
    Sys_T(4,jj+1) = Sub_A_Out(7,jj);
    Sys_T(5,jj+1) = Sub_B_Out(8,jj);
    
    fprintf('times: %d \n',jj);
end


   figure (1)
   plot(1:maxgene,Sub_A_Out(9,:),'r-');
   hold on 
   plot(1:maxgene,Sub_B_Out(9,:),'b-');
   hold on 
   xlabel('generation');
   ylabel('global best');
    
   
   figure (2)
   plot3(Sys_T(1,1),Sys_T(2,1),Sys_T(3,1),'*g');
   hold on 
   plot3(Sys_T(1,end),Sys_T(2,end),Sys_T(3,end),'or','markerfacecolor','r');
   xlabel('x1');
   ylabel('x2');
   zlabel('x3');
   globalbest_Position=Sys_T(:,end)
   
  plot3(Sys_T(1,:),Sys_T(2,:),Sys_T(3,:),'-b');
  hold on
    
  figure (3)
 
    plot(1:maxgene,Sub_A_Out(1,:),'-.g','LineWidth',2);
    hold on
    plot(1:maxgene,Sub_A_Out(2,:),'-.g','LineWidth',2);
    hold on
    plot(1:maxgene,Sub_A_Out(3,:),'-.g','LineWidth',2);
    hold on
    plot(1:maxgene,Sub_B_Out(1,:),'-.b','LineWidth',2);
    hold on
    plot(1:maxgene,Sub_B_Out(2,:),'-.b','LineWidth',2);
    hold on
    plot(1:maxgene,Sub_B_Out(3,:),'-.b','LineWidth',2);
    
    hold on
    plot(1:maxgene,Sys_T(1,1:maxgene),'-r','LineWidth',2);
    hold on
    plot(1:maxgene,Sys_T(2,1:maxgene),'-r','LineWidth',2);
    hold on
    plot(1:maxgene,Sys_T(3,1:maxgene),'-r','LineWidth',2);
    hold on
   xlabel('generation');
   ylabel('design variables');
  
toc