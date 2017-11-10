function [f,Sub_Sys]=myfun_MDO_CO_Sub_Sys(Sub_A_Out,Sub_B_Out)
% parameters
maxgene = 200;
sizepop = 50;
Vmax = 1;
Vmin = -1;
inertia_weight = 0.8;
cognitive_weight = 1;
social_weight = 1;
r=zeros(maxgene,1);
epsi = 0.0001;
r(1)=2;
c=1.5;

% structure
Sub_Sys = zeros(sizepop,10,maxgene);  %(x1,x2,x3,y1,y2,v1,v2,v3,v4,v5)
fitness = zeros(sizepop,maxgene);
sbest = zeros(sizepop,10,maxgene);
gbest= zeros(maxgene,10);
globalbest_state=zeros(maxgene,11);
selfbest_state=zeros(sizepop,11,maxgene);




penalty_Sub_A=zeros(sizepop,maxgene);
penalty_Sub_B=zeros(sizepop,maxgene);
penalty_x1=zeros(sizepop,maxgene);
penalty_x2=zeros(sizepop,maxgene);
penalty_x3=zeros(sizepop,maxgene);

%initial values



location = 10*rand(sizepop,5);
velocity = zeros(sizepop,5);
popini = [location,velocity];
Sub_Sys(:,:,1) = popini;



% initial fitness
for k=1:sizepop
    penalty_Sub_A(k,1)=max((Sub_Sys(k,1,1)-Sub_A_Out(1))^2+...
        (Sub_Sys(k,2,1)-Sub_A_Out(2))^2+(Sub_Sys(k,3,1)-Sub_A_Out(3))^2+...
        (Sub_Sys(k,4,1)-Sub_A_Out(9))^2+(Sub_Sys(k,5,1)-Sub_A_Out(4))^2-epsi,0)^2;
    
        penalty_Sub_B(k,1)=max((Sub_Sys(k,1,1)-Sub_B_Out(1))^2+...
        (Sub_Sys(k,2,1)-Sub_B_Out(2))^2+(Sub_Sys(k,3,1)-Sub_B_Out(3))^2+...
        (Sub_Sys(k,4,1)-Sub_B_Out(4))^2+(Sub_Sys(k,5,1)-Sub_B_Out(9))^2-epsi,0)^2;
    
end

fitness(:,1) = Sub_Sys(:,2,1).^2+Sub_Sys(:,3,1)+Sub_Sys(:,4,1)+exp(-Sub_Sys(:,5,1))+...
     r(1).*(penalty_Sub_A(:,1)+penalty_Sub_B(:,1));

[globalbest_state(1,11), bestindex] = min(fitness(:,1)); 


globalbest_state(1,1:10) = Sub_Sys(bestindex,1:10,1); %
selfbest_state(:,11,1) = fitness(:,1); 
selfbest_state(:,1:10,1) = Sub_Sys(:,:,1); %
gbest(1,:) = globalbest_state(1,1:10); %
sbest(:,:,1) = selfbest_state(:,1:10,1);%

% main loop
for jj = 2:1:maxgene
    r(jj)=r(jj-1)*c;
   for ii = 1:1:sizepop
%% velocity update

 
       
       Sub_Sys(ii,6,jj) = inertia_weight*Sub_Sys(ii,6,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,1,jj-1)-Sub_Sys(ii,1,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,1)-Sub_Sys(ii,1,jj-1));
       
       Sub_Sys(ii,7,jj) = inertia_weight*Sub_Sys(ii,7,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,2,jj-1)-Sub_Sys(ii,2,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,2)-Sub_Sys(ii,2,jj-1));  
       
       Sub_Sys(ii,8,jj) = inertia_weight*Sub_Sys(ii,8,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,3,jj-1)-Sub_Sys(ii,3,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,3)-Sub_Sys(ii,3,jj-1));
       
       Sub_Sys(ii,9,jj) = inertia_weight*Sub_Sys(ii,9,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,4,jj-1)-Sub_Sys(ii,4,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,4)-Sub_Sys(ii,4,jj-1));
       
       Sub_Sys(ii,10,jj) = inertia_weight*Sub_Sys(ii,10,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,5,jj-1)-Sub_Sys(ii,5,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,5)-Sub_Sys(ii,5,jj-1));  %



   % limited speed   

      if Sub_Sys(ii,6,jj) > Vmax
           Sub_Sys(ii,6,jj) = Vmax;
       elseif Sub_Sys(ii,6,jj) < Vmin
               Sub_Sys(ii,6,jj) = Vmin;
      end
       if Sub_Sys(ii,7,jj) > Vmax
           Sub_Sys(ii,7,jj) = Vmax;
       elseif Sub_Sys(ii,7,jj) < Vmin
               Sub_Sys(ii,7,jj) = Vmin;
       end
        if Sub_Sys(ii,8,jj) > Vmax
           Sub_Sys(ii,8,jj) = Vmax;
       elseif Sub_Sys(ii,8,jj) < Vmin
               Sub_Sys(ii,8,jj) = Vmin;
        end
      if Sub_Sys(ii,9,jj) > Vmax
           Sub_Sys(ii,9,jj) = Vmax;
       elseif Sub_Sys(ii,9,jj) < Vmin
              Sub_Sys(ii,9,jj) = Vmin;
      end
      if Sub_Sys(ii,10,jj) > Vmax
           Sub_Sys(ii,10,jj) = Vmax;
       elseif Sub_Sys(ii,10,jj) < Vmin
              Sub_Sys(ii,10,jj) = Vmin;
      end
       %% position update
       Sub_Sys(ii,1,jj) = Sub_Sys(ii,1,jj-1)+Sub_Sys(ii,6,jj);
       Sub_Sys(ii,2,jj) = Sub_Sys(ii,2,jj-1)+Sub_Sys(ii,7,jj);
       Sub_Sys(ii,3,jj) = Sub_Sys(ii,3,jj-1)+Sub_Sys(ii,8,jj);
       Sub_Sys(ii,4,jj) = Sub_Sys(ii,4,jj-1)+Sub_Sys(ii,9,jj);
       Sub_Sys(ii,5,jj) = Sub_Sys(ii,5,jj-1)+Sub_Sys(ii,10,jj);
 %Only external penalty function
   
   
        penalty_Sub_A(ii,jj)=max((Sub_Sys(ii,1,jj)-Sub_A_Out(1))^2+...
        (Sub_Sys(ii,2,jj)-Sub_A_Out(2))^2+(Sub_Sys(ii,3,jj)-Sub_A_Out(3))^2+...
        (Sub_Sys(ii,4,jj)-Sub_A_Out(9))^2+(Sub_Sys(ii,5,jj)-Sub_A_Out(4))^2-epsi,0)^2;
    
        penalty_Sub_B(ii,jj)=max((Sub_Sys(ii,1,jj)-Sub_B_Out(1))^2+...
        (Sub_Sys(ii,2,jj)-Sub_B_Out(2))^2+(Sub_Sys(ii,3,jj)-Sub_B_Out(3))^2+...
        (Sub_Sys(ii,4,jj)-Sub_B_Out(4))^2+(Sub_Sys(ii,5,jj)-Sub_B_Out(9))^2-epsi,0)^2;
    

    
    % fitness update
    fitness(ii,jj) = Sub_Sys(ii,2,jj).^2+Sub_Sys(ii,3,jj)+Sub_Sys(ii,4,jj)+exp(-Sub_Sys(ii,5,jj))+...
     r(jj).*(penalty_Sub_A(ii,jj)+penalty_Sub_B(ii,jj));

     %% find global best
      [globalbest_state(jj,11), bestindex] = min(fitness(:,jj)); 
      globalbest_state(jj,1:10) = Sub_Sys(bestindex,1:10,jj); 
     
       if globalbest_state(jj,11) <= globalbest_state(jj-1,11)
           
           globalbest_state(jj,11) = globalbest_state(jj,11);
           gbest(jj,:) = globalbest_state(jj,1:10);
           
       else
           globalbest_state(jj,11) = globalbest_state(jj-1,11);
           gbest(jj,:) = globalbest_state(jj-1,1:10);
       end
      
       
       %% find self best
       selfbest_state(:,11,jj) = fitness(:,jj);  %
       
       if fitness(ii,jj) <= selfbest_state(ii,11,jj-1)
           selfbest_state(ii,11,jj) = fitness(ii,jj);
           selfbest_state(ii,1:10,jj) = Sub_Sys(ii,:,jj);
           sbest(ii,:,jj) = selfbest_state(ii,1:10,jj);
       else 
           selfbest_state(ii,:,jj) = selfbest_state(ii,:,jj-1);
           sbest(ii,:,jj) = selfbest_state(ii,1:10,jj-1);
       end   
   end
   
end

Sub_Sys=gbest(end,1:5);
 f=globalbest_state(end,11);
 

              
