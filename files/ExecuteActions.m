% Reinforcement Learning
% V1.5 
% -----------------------------------------

function T=ExecuteActions(T,A)
    for k=1:size(T,1)
        %Tk=T(k,:);
        T(k,:)=ExecuteAction(T(k,:),A(k));
    end
end

function p=ExecuteAction(p,a)
    %disp([p{2},'-',num2str(p{3})]);
    %a
    
    tokens=regexpi(a,'\s*(\w+)\s+(-?[0-9]+)\s+(-?[0-9]+)\s*|\s*(\w+)\s+(-?[0-9]+)\s*','tokens');

    if(~isempty(tokens{:}) && strcmp(tokens{:}{1}(1),'dash'))
        p=dash(p,str2double(tokens{:}{1}{2}));
    else
        if(~isempty(tokens{:}) && strcmp(tokens{:}{1}(1),'kick'))
            p=kick(p,str2double(tokens{:}{1}{2}),str2double(tokens{:}{1}{3}));
        else
            if(~isempty(tokens{:}) && strcmp(tokens{:}{1}(1),'turn'))
                p=turn(p,str2double(tokens{:}{1}{2}));
            end
        end
    end
end



%Turn behaviour%
function P=turn(P,angle)
P_theta=P{1}(3);
P_theta=P_theta+angle;

if(P_theta>360)
    P_theta=P_theta-360;
else if(P_theta<0)
        P_theta= P_theta+360;
    end
end

P_theta=round(P_theta/45)*45;
P{1}(3)=P_theta;
end %turn


%Dash behaviour%
function P=dash(P,vel)
P_X=P{1}(1);
P_Y=P{1}(2);
P_theta=P{1}(3);

if(vel>10)
    vel=10;
else if(vel<-10)
        vel=-10;
    end
end


P_X=round(P_X+vel/7*cos(P_theta/180*3.14));
P_Y=round(P_Y+vel/7*sin(P_theta/180*3.14));

P{1}(1)=P_X;
P{1}(2)=P_Y;
P{1}(3)=P_theta;
end % dash


function P=kick(P,vel,dir)

P_theta=P{1}(3);
if(vel>10)
    vel=10;
else if(vel<-10)
        vel=-10;
    end
end

P_BVX=round(vel/7*cos((P_theta+dir)/180*pi));
P_BVY=round(vel/7*sin((P_theta+dir)/180*pi));
P{4}(1)=P_BVX;
P{4}(2)=P_BVY;
%P{1}(3)=P_theta;
end % kick


