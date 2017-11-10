
function [Sub_B]=myfun_MDO_CO_Sub_B(Sys_T)
% parameters
maxgene = 100;
sizepop = 50;
Vmax = 1;
Vmin = -1;
inertia_weight = 0.8;
cognitive_weight = 1;
social_weight = 1;


% structure
Sub_B = zeros(sizepop,9,maxgene);  %(x1,x2,x3,y1,v1,v2,v3,v4,y2)
fitness = zeros(sizepop,maxgene);
sbest = zeros(sizepop,9,maxgene);
gbest= zeros(maxgene,9);
globalbest_state=zeros(maxgene,10);
selfbest_state=zeros(sizepop,10,maxgene);
r=zeros(maxgene,1);



penalty_y1=zeros(sizepop,maxgene);
penalty_y2=zeros(sizepop,maxgene);
penalty_x1=zeros(sizepop,maxgene);
penalty_x2=zeros(sizepop,maxgene);
penalty_x3=zeros(sizepop,maxgene);

%initial values
r(1)=2;
c=4;
location = 10*rand(sizepop,4);
velocity = zeros(sizepop,4);
popini = [location,velocity];
Sub_B(:,1:8,1) = popini;
val(:)=Sub_B(:,1,1)+Sub_B(:,3,1)+sqrt(Sub_B(:,4,1));
Sub_B(:,9,1)=val(:);


% initial fitness
for k=1:sizepop
    
    if Sub_B(k,1,1)<=-10
        penalty_x1(k,1)=(Sub_B(k,1,1)+10)^2;
    elseif Sub_B(k,1,1)>=10
        penalty_x1(k,1)=(Sub_B(k,1,1)-10)^2;
    else
        penalty_x1(k,1)=0;
    end
    
    if Sub_B(k,2,1)<=0
        penalty_x2(k,1)=(Sub_B(k,2,1))^2;
    elseif Sub_B(k,2,1)>=10
        penalty_x2(k,1)=(Sub_B(k,2,1)-10)^2;
    else
        penalty_x2(k,1)=0;
    end
    
    if Sub_B(k,3,1)<=0
        penalty_x3(k,1)=(Sub_B(k,3,1))^2;
    elseif Sub_B(k,3,1)>=10
        penalty_x3(k,1)=(Sub_B(k,3,1)-10)^2;
    else
        penalty_x3(k,1)=0;
    end
        
    if Sub_B(k,9,1)>=24
    penalty_y2(k,1)=(Sub_B(k,9,1)-24)^2;
    else 
     penalty_y2(k,1) = 0;
    end
end

fitness(:,1) = (Sub_B(:,1,1)-Sys_T(1)).^2+(Sub_B(:,2,1)-Sys_T(2)).^2+(Sub_B(:,3,1)-Sys_T(3)).^2+...
               +(Sub_B(:,4,1)-Sys_T(4)).^2+(Sub_B(:,9,1)-Sys_T(5)).^2+...
               + r(1).*(penalty_x1(:,1)+penalty_x2(:,1)+penalty_x3(:,1)+...
                 penalty_y1(:,1)+penalty_y2(:,1));
    

   

[globalbest_state(1,10), bestindex] = min(fitness(:,1)); 


globalbest_state(1,1:9) = Sub_B(bestindex,1:9,1); %
selfbest_state(:,10,1) = fitness(:,1); 
selfbest_state(:,1:9,1) = Sub_B(:,1:9,1); %
gbest(1,:) = globalbest_state(1,1:9); %
sbest(:,:,1) = selfbest_state(:,1:9,1);%

% main loop
for jj = 2:1:maxgene
    r(jj)=r(jj-1)*c;
   for ii = 1:1:sizepop
%% velocity update

       Sub_B(ii,5,jj) = inertia_weight*Sub_B(ii,5,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,1,jj-1)-Sub_B(ii,1,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,1)-Sub_B(ii,1,jj-1));  %
       
       Sub_B(ii,6,jj) = inertia_weight*Sub_B(ii,6,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,2,jj-1)-Sub_B(ii,2,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,2)-Sub_B(ii,2,jj-1));
       
       Sub_B(ii,7,jj) = inertia_weight*Sub_B(ii,7,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,3,jj-1)-Sub_B(ii,3,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,3)-Sub_B(ii,3,jj-1));
       
       Sub_B(ii,8,jj) = inertia_weight*Sub_B(ii,8,jj-1)...           %
           + cognitive_weight*rand()*(sbest(ii,4,jj-1)-Sub_B(ii,4,jj-1))...%
           + social_weight*rand()*(gbest(jj-1,4)-Sub_B(ii,4,jj-1));
       


   % limited speed   
      if Sub_B(ii,5,jj) > Vmax
           Sub_B(ii,5,jj) = Vmax;
       elseif Sub_B(ii,5,jj) < Vmin
              Sub_B(ii,5,jj) = Vmin;
      end
      if Sub_B(ii,6,jj) > Vmax
           Sub_B(ii,6,jj) = Vmax;
       elseif Sub_B(ii,6,jj) < Vmin
               Sub_B(ii,6,jj) = Vmin;
      end
       if Sub_B(ii,7,jj) > Vmax
           Sub_B(ii,7,jj) = Vmax;
       elseif Sub_B(ii,7,jj) < Vmin
               Sub_B(ii,7,jj) = Vmin;
       end
        if Sub_B(ii,8,jj) > Vmax
           Sub_B(ii,8,jj) = Vmax;
       elseif Sub_B(ii,8,jj) < Vmin
               Sub_B(ii,8,jj) = Vmin;
       end
       %% position update
       Sub_B(ii,1,jj) = Sub_B(ii,1,jj-1)+Sub_B(ii,5,jj);
       Sub_B(ii,2,jj) = Sub_B(ii,2,jj-1)+Sub_B(ii,6,jj);
       Sub_B(ii,3,jj) = Sub_B(ii,3,jj-1)+Sub_B(ii,7,jj);
       Sub_B(ii,4,jj) = Sub_B(ii,4,jj-1)+Sub_B(ii,8,jj);
       
       val=Sub_B(ii,1,jj)+Sub_B(ii,3,jj)+sqrt(Sub_B(ii,4,jj));
       Sub_B(ii,9,jj)=val;


 %Only external penalty function
   
    if Sub_B(ii,1,jj)<=-10
        penalty_x1(ii,jj)=(Sub_B(ii,1,jj)+10)^2;
    elseif Sub_B(ii,1,jj)>=10
        penalty_x1(ii,jj)=(Sub_B(ii,1,jj)-10)^2;
    else
        penalty_x1(ii,jj)=0;
    end
    
    if Sub_B(ii,2,jj)<=0
        penalty_x2(ii,jj)=(Sub_B(ii,2,jj))^2;
    elseif Sub_B(ii,2,jj)>=10
        penalty_x2(ii,jj)=(Sub_B(ii,2,jj)-10)^2;
    else
        penalty_x2(ii,jj)=0;
    end
    
    if Sub_B(ii,3,jj)<=0
        penalty_x3(ii,jj)=(Sub_B(ii,3,jj))^2;
    elseif Sub_B(ii,3,jj)>=10
        penalty_x3(ii,jj)=(Sub_B(ii,3,jj)-10)^2;
    else
        penalty_x3(ii,jj)=0;
    end
        
   if Sub_B(ii,9,jj)>=24
    penalty_y2(ii,jj)=(Sub_B(ii,9,jj)-24)^2;
    else 
     penalty_y2(ii,jj) = 0;
    end
    
    % fitness update
   fitness(ii,jj) = (Sub_B(ii,1,jj)-Sys_T(1)).^2+(Sub_B(ii,2,jj)-Sys_T(2)).^2+(Sub_B(ii,3,jj)-Sys_T(3)).^2+...
               +(Sub_B(ii,4,jj)-Sys_T(4)).^2+(Sub_B(ii,9,jj)-Sys_T(5)).^2+...
               + r(jj).*(penalty_x1(ii,jj)+penalty_x2(ii,jj)+penalty_x3(ii,jj)+...
                 penalty_y1(ii,jj)+penalty_y2(ii,jj));
    
     %% find global best
      [globalbest_state(jj,10), bestindex] = min(fitness(:,jj)); 
      globalbest_state(jj,1:9) = Sub_B(bestindex,1:9,jj); 
     
       if globalbest_state(jj,10) <= globalbest_state(jj-1,10)
           
           globalbest_state(jj,10) = globalbest_state(jj,10);
           gbest(jj,:) = globalbest_state(jj,1:9);
           
       else
           globalbest_state(jj,10) = globalbest_state(jj-1,10);
           gbest(jj,:) = globalbest_state(jj-1,1:9);
       end
      
       
       %% find self best
       selfbest_state(:,10,jj) = fitness(:,jj);  %
       
       if fitness(ii,jj) <= selfbest_state(ii,10,jj-1)
           selfbest_state(ii,10,jj) = fitness(ii,jj);
           selfbest_state(ii,1:9,jj) = Sub_B(ii,:,jj);
           sbest(ii,:,jj) = selfbest_state(ii,1:9,jj);
       else 
           selfbest_state(ii,:,jj) = selfbest_state(ii,:,jj-1);
           sbest(ii,:,jj) = selfbest_state(ii,1:9,jj-1);
       end   
   end
   
end


  
   
 Sub_B = gbest(end,:);




