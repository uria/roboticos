% Reinforcement Learning
% V1.5 
% -----------------------------------------

function A=HeuristicAgent(T2,S1,S2,S3,S4,S5)
if(nargin==2)   % number of passed args==1 - full observability case
    S=S1;
    % takes in full state, S, and generates a vector of actions, A
    %A={'turn 45','turn 45','turn 45','turn 45','turn 45'};
    a1=Agent(T2(1,:),S,'f');
    a2=Agent(T2(2,:),S,'f');
    a3=Agent(T2(3,:),S,'f');
    a4=Agent(T2(4,:),S,'f');
    a5=Agent(T2(5,:),S,'f');
    A={a1,a2,a3,a4,a5};
    
else if(nargin==6)    % partial observability case
    % takes in partial states, S1 to S5, and generates a vector of actions,
    % A.
    % Each partial state is a cell array of objects. To access individual
    % properties of, e.g, the 4th object of S2, use 
    a1=Agent(T2(1,:),S1,'p');
    a2=Agent(T2(2,:),S2,'p');
    a3=Agent(T2(3,:),S3,'p');
    a4=Agent(T2(4,:),S4,'p');
    a5=Agent(T2(5,:),S5,'p');
    A={a1,a2,a3,a4,a5};
    end
end


end


function [a,P]=Agent(P,S,mode)
if(mode=='f')
    if(~isempty(S) && size(S{1},2)==2 )    % if can see the ball
        B=S{1};
        still=0;
        
        B_X=B{1}(1);
        B_Y=B{1}(2);
        %B_VX=B{2}(1);
        %B_VY=B{2}(2);
        
        P_X=P{1}(1);
        P_Y=P{1}(2);
        P_theta=P{1}(3);
        P_color=P{2};
        P_num=P{3};
        %P_VX=B{2}(1);
        %B_VY=B{2}(2);
        
        
        dist=sqrt((B_X-P_X)^2+(B_Y-P_Y)^2);    % compute the distance to the ball
        %if(abs(P_X-round(B_X))+abs(P_Y-round(B_Y))>1)   % the ball is not kickable - should I go for it?
            
            if(~((round(B_X)==P_X && round(B_Y)==P_Y) || ...    %over the ball
            (round(B_X)==P_X+sign(round(cos(P_theta/180*pi))) && round(B_Y)==P_Y+sign(round(sin(P_theta/180*pi)))) || ...    %in one of the three kicking cells
            (round(B_X)==P_X+sign(round(cos((P_theta+45)/180*pi))) && round(B_Y)==P_Y+sign(round(sin((P_theta+45)/180*pi)))) || ...
            (round(B_X)==P_X+sign(round(cos((P_theta-45)/180*pi))) && round(B_Y)==P_Y+sign(round(sin((P_theta-45)/180*pi))))))
            % check mates
            for k=2:6
                if(P_num+1==k), continue;end;
                
                Sk=S{k};
                Sk_X=Sk{1}(1);
                Sk_Y=Sk{1}(2);
                %Sk_theta=Sk{1}(3);
                %Sk_color=Sk{2};
                
%                 if(Sk_color~=P_color)   % not a mate
%                     break;
%                 else                        % a mate is seen
                    dist2=sqrt((B_X-Sk_X)^2+(B_Y-Sk_Y)^2);    %compute the distance to the ball from that mate
                    if(dist2<dist)          % the mate is closer to the ball, keep open
                        %[a,P]
                        %a=GoToBall(P,S);%KeepOpen(P,S);
                        if(P_X-3 > B_X),a='dash 8';
                        else a='';
                        end
                        still=1;
                        break;
                    else
                        continue;
                    end
                %end
            end
            
            if(~still)                 % closest to ball, go for it
                a=GoToBall(P,S,mode);
            end
            
        else    %the ball is kickable
            % should I pass or can I dribble?
            close=0;
            %check the distance to the nearest opponent
            for l=size(S,2):-1:7  %for all possible opponents
                Sl=S{l};
                
                Sl_X=Sl{1}(1);
                Sl_Y=Sl{1}(2);
                %Sk_theta=Sk{1}(3);
                %Sl_color=Sl{2};
                
                
               
                   % an opponent
                    if(abs(Sl_X-P_X) + abs(Sl_Y-P_Y) <16 &&  abs(Sl_X-(-58)) < abs(P_X-(-58)) )    % close - do not dribble - dangerous
                        % try to pass safely, then break
                        close=1;
%                         %find a mate to pass to
%                         for k=1:l-1 %min(4,size(S,2)-1)  %for all possible mates
%                             if(S{k+1}.color~=P_color)   % end of mates
%                                 break
%                             else                        % a mate is seen
%                                 %S{k+1}.num
%                                 angle=atan2(S{k+1}.Y-P_Y,S{k+1}.X-P_X)/pi*180;    % compute the angle to mate in degrees
%                                 %P_theta
%                                 if(angle<0)
%                                     angle=angle+360;    % correct the angle
%                                 end
%                                 
%                                 unsafe=0;
%                                 
%                                 for j=k+2:size(S,2) % for all possible opponents
%                                     if(S{j}.color==P_color)
%                                         continue;   %not an opponent
%                                     else    % an opponent
%                                         %compute the (squared) threshold for safe kicks:
%                                         %(d1*d2/d)^2<(thr)^2
%                                         if(((P_X-S{j}.X)^2+(P_Y-S{j}.Y)^2)*((S{k+1}.X-S{j}.X)^2+(S{k+1}.Y-S{j}.Y)^2)...
%                                                 /((S{k+1}.X-P_X)^2+(S{k+1}.Y-P_Y)^2)<49)    %very close: unsafe
%                                             unsafe=1;
%                                             break;
%                                             
%                                         end
%                                     end
%                                 end
%                                 % if break brings us here then pass is *unsafe*
%                                 % otherwise, all the opponents are away and the
%                                 %pass is safe
%                                 if(~unsafe)   %safe to pass
%                                     angle=angle-P_theta;
%                                     dist=sqrt((S{k+1}.X-P_X)^2+(S{k+1}.Y-P_Y)^2);    %compute the distance
%                                     %  if(angle<0)
%                                     %     angle=angle+360;    %correct the angle
%                                     % end
%                                     a=sprintf('kick %d %d',round(dist/8),round(angle));
%                                     return;
%                                 end
%                             end
%                         end
%                         
%                         % if we reached here then we did not decide an action yet
%                         % all passes are not feasible
%                         % dribble is considered dangerous
%                         
%                         r=rand(1);
%                         if(r<0.75)
%                             %disp('dribbling');
%                             ang=atan2(S{l}.Y-P_Y,S{l}.X-P_X)/pi*180;   %angle to the close opponent to avoid
%                             
%                             % if(ang<0), ang=ang+360; end;
%                             
%                             ang=ang-P_theta;
%                             
%                             
%                             if(ang>0), ang=ang-30;
%                             else ang=ang+30; end;
%                             
                            a=sprintf('kick %d %d',5,round(180+((-1)^(round(1+rand(1)*(2-1))))*(30+round(1+rand(1)*(45-1))))-P_theta);%round(45*rand(1)));
                            break;
%                             
%                         else if(r<0.9)
%                                 a='turn 45';
%                                 
%                             else
%                                 a='dash 10';
%                             end
%                         end
%                         break;
%                         %                 else            % no opponent is close. Just keep the ball
%                         %                     a=' ';
                     end
                
             end
            
            % no opponents at all or no close opponents
            % just dribble
          if(close==0),a=sprintf('kick %d %d',7,180+((-1)^(round(1+rand(1)*(2-1))))*round(rand(1)*15)-P_theta    );end;
%                 if(P_color=='r')
%                     a=sprintf('kick %d %d',1,-1*P_theta+sign(cos(randi(360)/180*pi))*round(rand(1)*30));
%                 else
%                     if(P_color=='b')
                        %a=sprintf('kick %d %d',7,180+sign(sin(round(1+rand(1)*(360-1))/180*pi))*round(rand(1)*30)-P_theta);
%                     end
                 %end
           % end
            
        end
    else    % cannot see the ball
        %[a,P]
        a=GoToBall(P,S,mode);%KeepOpen(P,S);
    end
else % partial observability
    if(~isempty(S) && size(S{1},2)==2)    % if can see the ball
        
        B=S{1};
        still=0;
        
        dist=B{1}(1);
        
        B_R=B{1}(1);
        B_alpha=B{1}(2);
        %B_VX=B{2}(1);
        %B_VY=B{2}(2);
        
        P_X=P{1}(1);
        P_theta=P{1}(3);
        P_color=P{2};
        P_num=P{3};
        %P_VX=B{2}(1);
        %B_VY=B{2}(2);
        
        
        if(B_R>1)   % the ball is not kickable - should I go for it?
            % check mates
            for k=2:min(5,size(S,2))
                Sk=S{k};
                
                Sk_color=Sk{2};
                Sk_R=Sk{1}(1);
                Sk_alpha=Sk{1}(2);
                
                if(Sk_color~=P_color)   % not a mate
                    break;
                else                        % a mate is seen
                    dist2=sqrt(B_R^2+Sk_R^2-2*B_R*Sk_R*cos((B_alpha-Sk_alpha)/pi*180));    %compute the distance to the ball from that mate
                    if(dist2<dist)          % the mate is closer to the ball, keep open
                        %[a,P]
                        %a=GoToBall(P,S,mode);%KeepOpen(P,S);
                        if(B_R > 0),if(rand(1)<0.4),a='';
                            else a='dash 8';
                            end
                        else a='';
                        end
                        still=1;
                        break;
                    else
                        continue;
                    end
                end
            end
            
            if(~still)                 % closest to ball, go for it
                a=GoToBall(P,S,mode);
            end
            
        else    %the ball is kickable
            % should I pass or can I dribble?
            close=0;
            %check the distance to the nearest opponent
            for l=size(S,2):-1:2  %for all possible opponents
                Sl=S{l};
                
                Sl_color=Sl{2};
                Sl_R=Sl{1}(1);
                Sl_alpha=Sl{1}(2);
                
                if(Sl_color==P_color)   % start of mates
                    break
                else    % an opponent
                    if(Sl_R<16 &&  abs(P_X+Sl_R*cos((Sl_alpha+P_theta)/180*pi)-(-58)) < abs(P_X-(-58)) )
                        %                    if(Sl_R <20)    % close - do not dribble - dangerous
                        % try to pass safely, then break
                        close=1;
                        %find a mate to pass to
                        %                         for k=2:l %min(4,size(S,2)-1)  %for all possible mates
                        %                             Sk=S{k};
                        %
                        %                             Sk_color=Sk{2};
                        %                             Sk_R=Sk{1}(1);
                        %                             Sk_alpha=Sk{1}(2);
                        %
                        %
                        %                             if(Sk_color~=P_color)   % end of mates
                        %                                 break
                        %                             else                        % a mate is seen
                        %                                 %S{k+1}.num
                        %                                 angle=Sk_alpha;    % compute the angle to mate in degrees
                        %                                 %P_theta
                        %                                 if(angle<0)
                        %                                     angle=angle+360;    % correct the angle
                        %                                 end
                        %
                        %                                 unsafe=0;
                        %
                        %                                 for j=k+2:size(S,2) % for all possible opponents
                        %                                     Sj=S{j};
                        %
                        %                                     Sj_color=Sj{2};
                        %                                     Sj_R=Sj{1}(1);
                        %                                     Sj_alpha=Sj{1}(2);
                        %
                        %                                     if(Sj_color==P_color)
                        %                                         continue;   %not an opponent
                        %                                     else    % an opponent
                        %                                         %compute the (squared) threshold for safe kicks:
                        %                                         %(d1*d2/d)^2<(thr)^2
                        %                                         if(  (Sj_R)^2 *  ( Sk_R^2 +Sj_R^2- 2*Sk_R*Sj_R*cos( (Sj_alpha-Sk_alpha) /pi*180)  )...
                        %                                                 /Sk_R^2  <49 )    %very close: unsafe
                        %                                             unsafe=1;
                        %                                             break;
                        %
                        %                                         end
                        %                                     end
                        %                                 end
                        %                                 % if break brings us here then pass is *unsafe*
                        %                                 % otherwise, all the opponents are away and the
                        %                                 %pass is safe
                        %                                 if(~unsafe)   %safe to pass
                        % %%%                                    angle=angle-P_theta;
                        %                                     dist=Sk_R;    %compute the distance
                        %                                     %  if(angle<0)
                        %                                     %     angle=angle+360;    %correct the angle
                        %                                     % end
                        %                                     a=sprintf('kick %d %d',round(dist/8),round(angle));
                        %                                     return;
                        %                                 end
                        %                             end
                        %                         end
                        %
                        %                         % if we reached here then we did not decide an action yet
                        %                         % all passes are not feasible
                        %                         % dribble is considered dangerous
                        %
                        %                         r=rand(1);
                        %                         if(r<0.75)
                        %                             %disp('dribbling');
                        %                             ang=Sl_alpha;%+P_theta;   %angle to the close opponent to avoid
                        %
                        %                             % if(ang<0), ang=ang+360; end;
                        %
                        %  %%%                           ang=ang-P_theta;
                        %
                        %
                        %                             if(ang>0), ang=ang-30;
                        %                             else ang=ang+30; end;
                        %
                        %a=sprintf('kick %d %d',7,(180+((-1)^(round(1+rand(1)*(2-1))))*(30+round(1+rand(1)*(45-1))))-P_theta  );

                        if(abs(180-P_theta)<=45)
                            if(Sl_alpha>=0), a=sprintf('kick %d %d',7,round(Sl_alpha-45));
                            else a=sprintf('kick %d %d',7,round(Sl_alpha+45));
                            end;
                        else a='';
                        end
                        break;
                        %                         else if(r<0.9)
                        %                                 a='turn 45';
                        %
                        %                             else
                        %                                 a='dash 10';
                        %                             end
                        %                         end
                        %                         break;
                        %                         %                 else            % no opponent is close. Just keep the ball
                        %                         %                     a=' ';
                        %                     end
                    end
                end
                
                
                
                
            end
            % no opponents at all or no close opponents
                % just dribble towards the goal
                
            if(close==0),a=sprintf('kick %d %d',7,180+((-1)^(round(1+rand(1)*(2-1))))*round(rand(1)*15)-P_theta    );end;%-P_theta
        end
    else    % cannot see the ball
        %[a,P]
        a=GoToBall(P,S,mode);%KeepOpen(P,S);
    end
    
end
end


function a=GoToBall(P,S,mode)
if(isempty(S) || size(S{1},2)~=2),a='turn 45';
else if(~isempty(S) && size(S{1},2)==2)
        B=S{1};
        
        P_X=P{1}(1);
        P_Y=P{1}(2);
        P_theta=P{1}(3);
        
        
        B_VX=B{2}(1);
        B_VY=B{2}(2);
        angle=0;
        
        if(mode=='p')    %partial observability
            B_R=B{1}(1);
            B_alpha=B{1}(2);
            
            
            angle=P_theta+B_alpha;
            
            B_X=P_X+B_R*cos(angle/180*pi);
            B_Y=P_Y+B_R*sin(angle/180*pi);
            
            
        else
            B_X=B{1}(1);
            B_Y=B{1}(2);
            angle=atan2(B_Y-P_Y,B_X-P_X)/pi*180;    %compute the angle to the ball in degrees
        end
        
        %B_VX=B{2}(1);
        %B_VY=B{2}(2);
        
        
        
        
        %angle=atan2(B_Y-P_Y,B_X-P_X)/pi*180;    %compute the angle to the ball in degrees
        
        angle3=atan2(B_Y+3*B_VY-P_Y,B_X+3*B_VX-P_X)/pi*180;    %compute the angle to the ball after 3 time steps in degrees
        %if(angle<0)
        %    angle=angle+360;    %correct the angle
        %end
        %angle=angle-P_theta;
        %if(angle<0)
        %    angle=angle+360;    %correct the angle
        %end
        
        %angle=round(angle/45)*45;   %approximate the angle difference into the nearest 45 degree
        
        if(angle3<0)
            angle3=angle3+360;    %correct the angle3
        end
        angle3=angle3-P_theta;      %the angle between the player and the ball after 3 steps
        if(angle3<0)
            angle3=angle3+360;    %correct the angle3
        end
        
        angle3=round(angle3/45)*45;   %discretize angle3 into the nearest 45 degree
        
        
        %g=round(rand(1)*5); % an interval between [0,360] and [g,360-g]
        %if(angle<g || angle>360-g)
        
        
        %if(angle3==0 || angle3==360)
        if(angle3<=45 || angle3>=360-45)
            a='dash 10';
            
        else
            r=rand(1);
            if(r>0.7),a='dash 10';
            else
                if(angle3<180)
                    a=sprintf('turn %d',angle3);
                else
                    a=sprintf('turn %d',angle3-360);
                end
            end
        end
        
    end
    
end
end
