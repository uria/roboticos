function data_structures(full_obs)
%dummy variable
global Var theta e numActions numBinFeatures numPlayers lambda gamma epsilon alpha Q a;   %define all your variables to be used in TeamAgent as globals

if(full_obs)    %full-observability scenario
    Var=zeros(1,10);

    'first time'
    numPlayers = 5;
    numBinFeatures = 37;
    numActions = 4;

    a = ones(1, numPlayers);
    theta = [ones(1,numBinFeatures) zeros(1,numBinFeatures*(numActions-1))];
    
    e = zeros(numPlayers,numBinFeatures*numActions);
    Q = zeros(numPlayers,numActions);
    
    alpha = 0.025;
    lambda = 0.5;
    gamma = 0.9;
    epsilon = 0.1;    
    
    theta_hist = zeros(1, numBinFeatures*numActions);    
    %figure(1);
    %bar(0,0);
    hold all;   
    
else        %partial-observability scenario
    %
    %
end


end
