% Reinforcement Learning
% V1.5.1
% -----------------------------------------

function f=plotPlayers(Players,f)
global player_size;
figure(f);


Ns=[];
for k=1:size(Players,1)
    P=Players(k,:);
    
    P_X=P{1}(1);
    P_Y=P{1}(2);
    P_theta=P{1}(3);
    P_color=P{2};
    P_num=P{3};
    
    Xs(k)=P_X;
    Ys(k)=P_Y;
    
    if(P_color =='r')   
        Xs=Xs-0.09;
        Ys=Ys-0.09;
    end
    
    Xs(find(Xs<-60))=-60;
    Ys(find(Ys<-30))=-30;
    
    Ns=[Ns;num2str(P_num)];  
    
    FaceX(k)=P_X+player_size/20*cos(P_theta/180*pi);
    FaceY(k)=P_Y+player_size/20*sin(P_theta/180*pi);
    
    if(P_color=='r')
        FaceX=FaceX-0.09;
        FaceY=FaceY-0.09;
    end
    
    FaceX(find(FaceX<-60))=-60;
    FaceY(find(FaceY<-30))=-30;
end

hold on
plot(Xs,Ys,'o', 'MarkerSize',player_size,'MarkerFaceColor',P_color,'MarkerEdgeColor',P_color);
text(Xs(1,:),Ys(1,:), Ns,'FontSize',8,'HorizontalAlignment','center','color',[0.9 0.9 0.9] );
plot(FaceX,FaceY,'o','MarkerSize',player_size/4,'MarkerFaceColor',[1 1 0]);
hold off
drawnow

end
