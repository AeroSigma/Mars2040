clear all
close all

objScale = 1; %1e5

for points = 1:10
%initial guess
% x0=[1,0,0,0,0,2,2,0,2;
%     3,1,2,2,1,0,0,0,0;
%     6,3,11,4,2,0,0,1,0;
%     0,0,0,0,0,0,0,0,0;
%     1,1,1,1,1,1,1,1,1;
%     2,2,2,2,2,2,2,0,2;
%     3,3,3,3,1,1,1,1,1;
%     4,1,7,4,1,1,1,1,1;
%     5,2,10,2,1,1,1,1,1;
%     0,2,0,0,0,2,2,0,0];

x0 = [2,2,0,0,2,1,1,1,2;
      0,2,0,0,2,2,2,0,0];

%optimizer controls
maxIter = 30;
convergeTol = 2; %how many repeated solutions indicate converge

%variable bounds
xb(1,1:2)=[0,6]; %propulsion (ISP and type)
xb(2,1:2)=[0,3]; %surface power
xb(3,1:2)=[0,11]; %location
xb(4,1:2)=[0,4]; %food
xb(5,1:2)=[0,2]; %crew (0 is largest)
xb(6,1:2)=[0,2]; %Transit Fuel Source
xb(7,1:2)=[0,2]; %Return Fuel Source
xb(8,1:2)=[0,1]; %Entry Type
xb(9,1:2)=[0,2]; %Staging Location

%test initial case
x = x0(points,:);
obj = objScale*constraintfun(x);
xBest = x;
objBest = obj;
feval = 1;

i = 1;
converge = 0;
n = length(x);
while i < maxIter
    if converge < convergeTol  %if not converged, find new guess
        localSearch = [];
        localSearchObj = [];
        k = 1;
        for j = 1:n  %go through all dependent vars and check up and down
            xlow = x(j)-1;
            xhi = x(j)+1;
            if xb(j,1)<= xlow
                localSearch(k,:) = x;
                localSearch(k,j) = xlow;
                localSearchObj(k) = objScale*constraintfun(localSearch(k,:));
                feval = feval + 1;
                k = k+1;
            end
            if xb(j,2)>= xhi
                localSearch(k,:) = x;
                localSearch(k,j) = xhi;                
                localSearchObj(k) = objScale*constraintfun(localSearch(k,:));
                k = k+1;
                feval = feval + 1;
            end
                
        end

        %add in old best design and determine if there is a new best design
        localSearchObj(k) = objBest;
        localSearch(k,:) = xBest;
        [localObjBest, localIndexBest] = max(localSearchObj);
        if localObjBest > objBest            
            xBest = localSearch(localIndexBest,:); 
            objBest = localObjBest;
            x = xBest;
            converge = 0;
        else
            converge = converge + 1;
        end
        
    else %if converged, you are done
        break
    
    end

i = i+1;
%xBest
end

initialpoint = x0(points,:)
i
feval
xBest
objBest
end
