function objective=constraintfun(x)

% [prop, power, location, food, crew, chemisp, nucisp]=x(:);

%variable bounds
xb(1,1:2)=[0,1]; %prop
xb(2,1:2)=[0,1];
xb(3,1:2)=[0,4];
xb(4,1:2)=[0,4];
xb(5,1:2)=[0,2];
xb(6,1:2)=[0,3];
xb(7,1:2)=[0,2];

i=length(x);
penalty=zeros(i);
xround=zeros(i);

for i
    if (x(i)< xb(i,1)) || (x(i) > xb(i,2))
        penalty(i)=100;
    end
    xround(i)=round(x(i));
end

objective=SingleTradeFunction(xround);

        
        

end


