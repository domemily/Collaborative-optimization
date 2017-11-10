clc
clear
rand('seed',1)
tic
%initial parameters
maxgene=1000;
%% structure
Sub_A_Out=zeros(9,maxgene);
Sub_B_Out=zeros(9,maxgene);
Sys_T=zeros(5,maxgene);
Optimum=zeros(maxgene,1);

%% initial values

% Sys_T(:,1)=[-2.8014,0.0757,0.1021,8,0.1292];%(x1,x2,x3,y1,y2) local minima
% Sys_T(:,1)=[3.0284,0,0,8,5.8569];%(x1,x2,x3,y1,y2)
%   Sys_T(:,1)=[10,5,10,108.9128,30.4361];%(x1,x2,x3,y1,y2)
 Sys_T(:,1)=[1,0,5,4.3814,8.0932];%(x1,x2,x3,y1,y2)
%  Sys_T(:,1)=[1,0,5,5.2586,3.7068];%(x1,x2,x3,y1,y2)
 
%main loop
for jj=1:maxgene
    
    [Sub_A]=myfun_MDO_CO_Sub_A(Sys_T(:,jj));
    val_A=Sub_A; %(x1,x2,x3,y2,v1,v2,v3,v4,y1)
    Sub_A_Out(:,jj)=val_A;
    [Sub_B]=myfun_MDO_CO_Sub_B(Sys_T(:,jj));
    val_B=Sub_B;
    Sub_B_Out(:,jj)=val_B; %(x1,x2,x3,y1,v1,v2,v3,v4,y2)
    [f,Sub_Sys]=myfun_MDO_CO_Sub_Sys(Sub_A_Out(:,jj),Sub_B_Out(:,jj));
    val_Sys=Sub_Sys;
    val_f=f;
    Sys_T(:,jj+1)=val_Sys;  %(x1,x2,x3,y1,y2)
    Optimum(jj)=val_f;
    fprintf('times: %d \n',jj);
end


   figure (1)
   plot(1:maxgene,Optimum(:,1),'r-');
   xlabel('generation');
   ylabel('global best');
    Optimum=Optimum(end,1)
   
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

  
toc