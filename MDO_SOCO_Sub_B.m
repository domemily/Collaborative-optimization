
clc
clear


 Sys_T=[1,0,5,8.3814,8.0932];%(x1,x2,x3,y1,y2)

% parameters
maxgene = 100;
sizepop = 50;
Vmax = 1;
Vmin = -1;
inertia_weight = 0.8;
cognitive_weight = 1;
social_weight = 1;
r=zeros(maxgene,1);
r(1)=2;
c=4;
lamda = 0.1; %compatibility penalty parameter
% structure
Sub_B = zeros(sizepop,8,maxgene);  %(x1,x2,x3,v1,v2,v3,y1,y2)
fitness = zeros(sizepop,maxgene);
globalbest_state=zeros(maxgene,9);
selfbest_state=zeros(sizepop,9,maxgene);




penalty_y1=zeros(sizepop,maxgene);
penalty_y2=zeros(sizepop,maxgene);
penalty_x1=zeros(sizepop,maxgene);
penalty_x2=zeros(sizepop,maxgene);
penalty_x3=zeros(sizepop,maxgene);

%initial values
location = 10*rand(sizepop,3);
velocity = zeros(sizepop,3);
popini = [location,velocity];
Sub_B(:,1:6,1) = popini;
Sub_B(:,7,1)=Sys_T(4);
val(:)=sqrt(Sys_T(4))+Sub_B(:,1,1)+Sub_B(:,3,1);
Sub_B(:,8,1)=val(:);


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
        
     if Sub_B(k,8,1)>=24
    penalty_y2(k,1)=(Sub_B(k,8,1)-24)^2;
    else 
     penalty_y2(k,1) = 0;
    end
end

   
fitness(:,1) = Sub_B(:,2,1).^2+Sub_B(:,3,1)+Sub_B(:,7,1)+exp(-Sub_B(:,8,1))+...
    lamda.*((Sub_B(:,1,1)-Sys_T(1)).^2+(Sub_B(:,2,1)-Sys_T(2)).^2+(Sub_B(:,3,1)-Sys_T(3)).^2)+...
    r(1).*(penalty_x1(:,1)+penalty_x2(:,1)+penalty_x3(:,1)+...
                 penalty_y1(:,1)+penalty_y2(:,1));
   

[globalbest_state(1,9), bestindex] = min(fitness(:,1)); 


globalbest_state(1,1:8) = Sub_B(bestindex,:,1); %
selfbest_state(:,9,1) = fitness(:,1); 
selfbest_state(:,1:8,1) = Sub_B(:,:,1); %


% main loop
for jj = 2:1:maxgene
    Sub_B(:,7,jj)=Sys_T(4);
    r(jj)=r(jj-1)*c;
    
   for ii = 1:1:sizepop
%% velocity update

       
       Sub_B(ii,4,jj) = inertia_weight*Sub_B(ii,4,jj-1)...           %
           + cognitive_weight*rand()*(selfbest_state(ii,1,jj-1)-Sub_B(ii,1,jj-1))...%
           + social_weight*rand()*(globalbest_state(jj-1,1)-Sub_B(ii,1,jj-1));
       
       Sub_B(ii,5,jj) = inertia_weight*Sub_B(ii,5,jj-1)...           %
           + cognitive_weight*rand()*(selfbest_state(ii,2,jj-1)-Sub_B(ii,2,jj-1))...%
           + social_weight*rand()*(globalbest_state(jj-1,2)-Sub_B(ii,2,jj-1));  %
       
       Sub_B(ii,6,jj) = inertia_weight*Sub_B(ii,6,jj-1)...           %
           + cognitive_weight*rand()*(selfbest_state(ii,3,jj-1)-Sub_B(ii,3,jj-1))...%
           + social_weight*rand()*(globalbest_state(jj-1,3)-Sub_B(ii,3,jj-1));
       

   % limited speed   
          if Sub_B(ii,4,jj) > Vmax
           Sub_B(ii,4,jj) = Vmax;
       elseif Sub_B(ii,4,jj) < Vmin
               Sub_B(ii,4,jj) = Vmin;
          end
       
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

     
       %% position update
       Sub_B(ii,1,jj) = Sub_B(ii,1,jj-1)+Sub_B(ii,4,jj);
       Sub_B(ii,2,jj) = Sub_B(ii,2,jj-1)+Sub_B(ii,5,jj);
       Sub_B(ii,3,jj) = Sub_B(ii,3,jj-1)+Sub_B(ii,6,jj);
       
       val=Sub_B(ii,1,jj)+Sub_B(ii,3,jj)+sqrt(Sys_T(4));
       Sub_B(ii,8,jj)=val;
       
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
        
     if Sub_B(ii,8,jj)>=24
    penalty_y2(ii,jj)=(Sub_B(ii,8,jj)-24)^2;
    else 
     penalty_y2(ii,jj) = 0;
    end
    
    
    
    % fitness update          
    fitness(ii,jj) = Sub_B(ii,2,jj).^2+Sub_B(ii,3,jj)+Sub_B(ii,7,jj)+exp(-Sub_B(ii,8,jj))+...
    lamda.*((Sub_B(ii,1,jj)-Sys_T(1)).^2+(Sub_B(ii,2,jj)-Sys_T(2)).^2+(Sub_B(ii,3,jj)-Sys_T(3)).^2)+...
    r(jj).*(penalty_x1(ii,jj)+penalty_x2(ii,jj)+penalty_x3(ii,jj)+...
                 penalty_y1(ii,jj)+penalty_y2(ii,jj));         
             
    
     %% find global best
      [globalbest_state(jj,9), bestindex] = min(fitness(:,jj)); 
      globalbest_state(jj,1:8) = Sub_B(bestindex,:,jj); 
     
       if globalbest_state(jj,9) <= globalbest_state(jj-1,9)
           
           globalbest_state(jj,:) = globalbest_state(jj,:);

           
       else
           globalbest_state(jj,:) = globalbest_state(jj-1,:);
       
       end
      
       
       %% find self best
       selfbest_state(:,9,jj) = fitness(:,jj);  %
       
       if fitness(ii,jj) <= selfbest_state(ii,9,jj-1)
           selfbest_state(ii,9,jj) = fitness(ii,jj);
           selfbest_state(ii,1:8,jj) = Sub_B(ii,:,jj);
         
       else 
           selfbest_state(ii,:,jj) = selfbest_state(ii,:,jj-1);
          
       end   
   end
   
end

Sub_B = globalbest_state(end,:);






              
