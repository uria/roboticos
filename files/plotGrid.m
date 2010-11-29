% Reinforcement Learning
% V1.5 
% -----------------------------------------

function f=plotGrid(f)
global width height;

figure(f);
axis([-1*width/2 width/2 -1*height/2 height/2]);


line('xdata',[58,58], 'ydata',[-30,30], 'color','y','LineWidth',2);%, 'YLimInclude','off'); 
line('xdata',[-58,-58], 'ydata',[-30,30], 'color','y','LineWidth',2);

end
