% Reinforcement Learning
% V1.5.2
% -----------------------------------------

function simulator(p_obs,batch)

% system parameters
global width height player_size ball_size stop;
width=120;
height=60;
player_size=15;
ball_size=8;
stop=0;
winner='';


%full or partial observability mode
if(str2double(p_obs)==0)
    obs=1;
else
    obs=0;
end

%visual or batch mode
if(str2double(batch)<=1)
    p=1;
    episode_count=1;
else
    p=0;
    episode_count=str2double(batch);
end


%initialize data structures
data_structures(obs);


%prepare visualisation
if(p)
    scrsz = get(0,'ScreenSize');%scrsz(4)/2
    f=figure('Position',[0 scrsz(4)-height*10 width*10 height*10],'Name','Soccer simulation window','NumberTitle','off');
    set(f,'CloseRequestFcn',@figclosereq);
    set(gca,'Color',[0 0.7 0.3]);
    axis equal
else
    disp('Running in batch mode...');
end


for e=1:episode_count
    stop=0;
    
    %start episode
    before_episode(e);
    
    % set initial conditions
    t = 0;
    tend = 6000;	% duration of simulation
    
    % set initial positions
    %Ball
    B=Ball(-30,0);
    %B=Ball(sign(cos(rand(1)*360/180*pi))*rand(1)*(width/2),sign(cos(rand(1)*(360)/180*pi))*rand(1)*(height/2));
    
    %Players
    P1=Player(-50,15,315,1,'r');
    P2=Player(-50,0,0,2,'r');
    P3=Player(-50,-15,45,3,'r');
    P4=Player(-40,10,315,4,'r');
    P5=Player(-40,-10,45,5,'r');
    
    P6=Player(40+round(1+rand(1)*(10-1)),-15+round(1+rand(1)*(30-1)),180,1,'b');
    P7=Player(40+round(1+rand(1)*(10-1)),-15+round(1+rand(1)*(30-1)),180,2,'b');
    P8=Player(40+round(1+rand(1)*(10-1)),-15+round(1+rand(1)*(30-1)),180,3,'b');
    P9=Player(40+round(1+rand(1)*(10-1)),-15+round(1+rand(1)*(30-1)),180,4,'b');
    P10=Player(40+round(1+rand(1)*(10-1)),-15+round(1+rand(1)*(30-1)),180,5,'b');
    
    %set up teams
    T1=[P1;P2;P3;P4;P5];
    T2=[P6;P7;P8;P9;P10];
    
    
    % start simulation loop
    while (t < tend)
        try
            t = t + 1;
            
            %main descision making processes
            
            if(obs==0)  %partial observability
                PS11=PartialState(T1,T2,B,T1(1,:));  % generate the partial state of player k
                PS12=PartialState(T1,T2,B,T1(2,:));
                PS13=PartialState(T1,T2,B,T1(3,:));
                PS14=PartialState(T1,T2,B,T1(4,:));
                PS15=PartialState(T1,T2,B,T1(5,:));
                
                A1=TeamAgent(t,T1,PS11,PS12,PS13,PS14,PS15); % ask for joint action
            else
                S=FullState(T1,T2,B);
                A1=TeamAgent(t,T1,S); % ask for joint action
            end
            
           
            T1=ExecuteActions(T1,A1);
            
           
            
            
            if(obs==0)  %partial observability
                PS21=PartialState(T2,T1,B,T2(1,:));  % generate the partial state of player k
                PS22=PartialState(T2,T1,B,T2(2,:));
                PS23=PartialState(T2,T1,B,T2(3,:));
                PS24=PartialState(T2,T1,B,T2(4,:));
                PS25=PartialState(T2,T1,B,T2(5,:));
                
                A2=HeuristicAgent(T2,PS21,PS22,PS23,PS24,PS25); % ask for joint action
            else
                S=FullState(T2,T1,B);
                A2=HeuristicAgent(T2,S); % ask for joint action
            end
            T2=ExecuteActions(T2,A2);
            
%             T2=ExecuteActions(T2,{'dash 0','dash 0','dash 0','dash 0','dash 0'});
            
            
            
            %keep players in field
            for k=1:size(T1,1)
                T1k=T1(k,:);
                T1k_X=T1k{1}(1);
                T1k_Y=T1k{1}(2);
                
                if(T1k_X>width/2)
                    T1k_X=width/2;
                else if(T1k_X<-1*width/2)
                        T1k_X=-1*width/2;
                    end
                end
                if(T1k_Y>height/2)
                    T1k_Y=height/2;
                else if(T1k_Y<-1*height/2)
                        T1k_Y=-1*height/2;
                    end
                end
                
                T1k{1}(1)=T1k_X;
                T1k{1}(2)=T1k_Y;
                T1(k,:)=T1k;
            end
            
            for k=1:size(T2,1)
                T2k=T2(k,:);
                T2k_X=T2k{1}(1);
                T2k_Y=T2k{1}(2);
                
                if(T2k_X>width/2)
                    T2k_X=width/2;
                else if(T2k_X<-1*width/2)
                        T2k_X=-1*width/2;
                    end
                end
                if(T2k_Y>height/2)
                    T2k_Y=height/2;
                else if(T2k_Y<-1*height/2)
                        T2k_Y=-1*height/2;
                    end
                end
                
                
                T2k{1}(1)=T2k_X;
                T2k{1}(2)=T2k_Y;
                T2(k,:)=T2k;
            end
            
            %update the ball
            B=update(B,[T1;T2]);
            
            %any winners?
            B_X=B{1}(1);
            B_Y=B{1}(2);
            
            if(B_X > width/2-2)
                for i=1:size(T1,1)
                    T1i=T1(i,:);
                    T1i_X=T1i{1}(1);
                    T1i_Y=T1i{1}(2);
                    
                    if(abs(T1i_X-B_X)+abs(T1i_Y-B_Y)<2)
                        winner='r';
                        stop=1;
                        break
                    end
                end
            else if(B_X < -1*width/2+2)
                    for i=1:size(T2,1)
                        T2i=T2(i,:);
                        T2i_X=T2i{1}(1);
                        T2i_Y=T2i{1}(2);
                        if(abs(T2i_X-B_X)+abs(T2i_Y-B_Y)<2)
                            winner='b';
                            stop=1;
                            break;
                        end;
                    end
                end
            end
            
            
            
            %reset ball kicking vectors
            for k=1:size(T1)
                T1k=T1(k,:);
                T1k{4}(1)=0;
                T1k{4}(2)=0;
                T1(k,:)=T1k;
            end;
            for k=1:size(T2)
                T2k=T2(k,:);
                T2k{4}(1)=0;
                T2k{4}(2)=0;
                T2(k,:)=T2k;
            end;
            
            %updating the scene
            if(p && ishandle(f))
                figure(f);
                f=plotGrid(f);
                f=plotPlayers(T1,f);
                f=plotPlayers(T2,f);
                plotBall(B);
                drawnow;
            else if(p)
                    break;
                end
            end
            
            
            %end of episode?
            if(stop)
                pause(0.5);
                drawnow;

                if(e==episode_count) %end of simulation?
                    delete(gcf);
                end

                break;
            end
            
            %animation frame rate
            if(p)
                pause(0.05);
                if(ishandle(f))
                    cla(f);
                end
            end
            
            
        catch z
            disp(z);
        end
    end
    
    disp(winner);   %end of episode
    
    after_episode(e,t,winner);
end

after_simulation();

end

        
 


%--------------------------------------------------------------
function figclosereq(src,evnt)
    global stop;
    disp('Exiting...');
    try        
        if(stop~=1),stop=1;
        else delete(gcf);clear;
        end
        
    catch a
        disp(a);
    end
end




%--------------------------------------------------------------
function S=PartialState(T1,T2,B,P)
      
    B_X=B{1}(1);
    B_Y=B{1}(2);
    B_VX=B{2}(1);
    B_VY=B{2}(2);
    
    P_X=P{1}(1);
    P_Y=P{1}(2);
    P_theta=P{1}(3);
    P_num=P{3}; 
    P_BVX=P{4}(1);
    P_BVY=P{4}(2);
    
    angle=atan2(B_Y-P_Y,B_X-P_X)/pi*180;    %compute the angle to the ball in degrees
    ang=angle-P_theta;  %from heading to ball
  
    if(ang<0)
        ang=ang+360;    %correct the angle
    else while(ang>360), ang=ang-360;end;
    end
    
    if(ang>=0 && ang<=50) % in cone
        b_alpha=ang;  % relative angle to the ball
        b_R=sqrt((B_Y-P_Y)^2+(B_X-P_X)^2);  % relative distance to the ball
        b={[b_R,b_alpha], [B_VX,B_VY]};
        S={b};
    elseif(ang>=310 && ang<=360)   % in cone   
        b_alpha=ang-360;  % relative angle to the ball
        b_R=sqrt((B_Y-P_Y)^2+(B_X-P_X)^2);  % relative distance to the ball
        b={[b_R,b_alpha], [B_VX,B_VY]};
        S={b};
    else
        S={-1};
    end
    
    for k=1:size(T1)
        p=T1(k,:);
        
        p_X=p{1}(1);
        p_Y=p{1}(2);
        %p_theta=p{1}(theta);
        p_num=p{3};
        p_color=p{2};
        
        if(P_num==p_num)
            continue;
        end
        
        angle=atan2(p_Y-P_Y,p_X-P_X)/pi*180;    %compute the angle to the mate in degrees
        
        if(angle<0)
            ang=angle+360-P_theta;    %correct the angle
        else
            ang=angle-P_theta;
        end
        
        if(ang<0)
            ang=ang+360;    %correct the angle
        end
        if(ang>=0 && ang<=50) % in cone
            p_alpha=ang;  % relative angle to the player
            p_R=sqrt((p_Y-P_Y)^2+(p_X-P_X)^2);  % relative distance to the player
            
            p={[p_R,p_alpha],p_color,p_num};
            S=[S {p}];
        elseif(ang>=310 && ang<=360)   % in cone   
            p_alpha=ang-360;  % relative angle to the player
            p_R=sqrt((p_Y-P_Y)^2+(p_X-P_X)^2);  % relative distance to the player
            
            p={[p_R,p_alpha],p_color,p_num};
            S=[S {p}];
        end
    end
    for k=1:size(T2)
        p=T2(k,:);
        
        p_X=p{1}(1);
        p_Y=p{1}(2);
        %p_theta=p{1}(theta);
        p_num=p{3};
        p_color=p{2};
        
        angle=atan2(p_Y-P_Y,p_X-P_X)/pi*180;    %compute the angle to the opponent in degrees
        
        if(angle<0)
            ang=angle+360-P_theta;    %correct the angle
        else
            ang=angle-P_theta;
        end
        
        if(ang<0)
            ang=ang+360;    %correct the angle
        end
        if(ang>=0 && ang<=50) % in cone
            p_alpha=ang;  % relative angle to the player
            p_R=sqrt((p_Y-P_Y)^2+(p_X-P_X)^2);  % relative distance to the player
            
            p={[p_R,p_alpha],p_color,p_num};
            S=[S {p}];
        elseif(ang>=310 && ang<=360)   % in cone       
            p_alpha=ang-360;  % relative angle to the player
            p_R=sqrt((p_Y-P_Y)^2+(p_X-P_X)^2);  % relative distance to the player
            
            p={[p_R,p_alpha],p_color,p_num};
            S=[S {p}];
        end
    end
 
end


%--------------------------------------------------------------
function S=FullState(T1,T2,B)
S=cell(1+size(T1,1)+size(T2,1),1);
p=Player(0,0,0,0,'');
S={B};

for k=1:size(T1,1)
    p=T1(k,:);
    S=[S {p}];
end
for k=1:size(T2,1)
    p=T2(k,:);
    S=[S {p}];
end
end

%--------------------------------------------------------------
%Ball update procedure%
function B=update(B,T)
global  width height;%scoring sus_time suspend
B_X=B{1}(1);
B_Y=B{1}(2);
B_VX=B{2}(1);
B_VY=B{2}(2);

for k=1:size(T,1) %for every player
    Tk=T(k,:);    %{positin [x,y,theta], ball_velocity [bvx,bvy]}
    Tk_X=Tk{1}(1);
    Tk_Y=Tk{1}(2);
    Tk_theta=Tk{1}(3);
    Tk_BVX=Tk{4}(1);
    Tk_BVY=Tk{4}(2);
    
    %check if the ball is kickable for the player
    if((round(B_X)==Tk_X && round(B_Y)==Tk_Y) || ...    %over the ball
            (round(B_X)==Tk_X+sign(round(cos(Tk_theta/180*pi))) && round(B_Y)==Tk_Y+sign(round(sin(Tk_theta/180*pi)))) || ...    %in one of the three kicking cells
            (round(B_X)==Tk_X+sign(round(cos((Tk_theta+45)/180*pi))) && round(B_Y)==Tk_Y+sign(round(sin((Tk_theta+45)/180*pi)))) || ...
            (round(B_X)==Tk_X+sign(round(cos((Tk_theta-45)/180*pi))) && round(B_Y)==Tk_Y+sign(round(sin((Tk_theta-45)/180*pi)))))
        
        B_VX=B_VX+Tk_BVX; % add to the kick vector
        B_VY=B_VY+Tk_BVY;
        
    end
    
    
end

if(B_VX~=0 || B_VY~=0)
    if(B_X+B_VX <= width/2 && B_X+B_VX>=-1*width/2)
        B_X=B_X+B_VX;
    else
        if(B_VX>0)
            B_X=width/2;
        else
            B_X=-1*width/2;
        end
        B_VX=-1*B_VX;
    end
    
    if(B_Y+B_VY <= height/2 && B_Y+B_VY>=-1*height/2)
        B_Y=B_Y+B_VY;
    else
        if(B_VY>0)
            B_Y=height/2;
        else
            B_Y=-1*height/2;
        end
        B_VY=-1*B_VY;
    end
    
    
    B_VX=0.9* B_VX;     %dampen the velocity of the ball
    B_VY=0.9* B_VY;
    
end
B={[B_X,B_Y],[B_VX,B_VY]};   % ball {position ,  veocity}
end


%----------------------------------------------------
%Ball plotting procedure%
function plotBall(B)
global ball_size ;
B_X=B{1}(1);
B_Y=B{1}(2);
%B_VX=B{2}(1);
%B_VY=B{2}(2);
hold on
plot(B_X,B_Y,'o', 'MarkerSize',ball_size,'MarkerFaceColor',[1 1 1]);
plot(B_X,B_Y,'*', 'MarkerSize',ball_size/2,'MarkerFaceColor',[0 0 0]);
hold off;
drawnow
end


%--------------------------------------------------
%Ball

% B_X;
% B_Y;
% B_R; % relative distance to the ball - only used in partial states
% B_alpha;    %relative angle to the ball - only used in partial states
% B_VX;   % ball velocity on X axis
% B_VY;   % ball velocity on Y axis
% B={[B_X,B_Y],[B_VX,B_VY],[B_R,B_alpha]};


function B = Ball(X,Y)
B_X=X;
B_Y=Y;
B_VX=0;
B_VY=0;
B={[B_X,B_Y],[B_VX,B_VY]};   % ball {position ,  veocity}
end



%--------------------------------------------------
%Player

%color;  % team identifier
%num;    % player identifier
%theta;    % heading
%X;    % absolute X position
%Y;    % absolute Y position
%R;    % relative distance to the player - only used in partial states
%alpha;    % relative angle to the player - only used in partial states
%BVX;  % player's share of ball movement vector
%BVY;  % player's share of ball movement vector

function P = Player(X,Y,theta,num,color)
P_X=X;
P_Y=Y;
P_theta=theta;
P_BVX=0;
P_BVY=0;
P_color=color;
P_num=num;

P={[P_X,P_Y,P_theta],P_color,P_num,[P_BVX,P_BVY]};  % {position[x,y,theta],  color, num, ball_speed [vx,vy]}
end
