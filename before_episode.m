function before_episode(episode_num)
global Var theta e numActions numBinFeatures numPlayers lambda gamma epsilon alpha Q a;
    e = zeros(numPlayers,numBinFeatures*numActions);
    Q = zeros(numPlayers,numActions);
end