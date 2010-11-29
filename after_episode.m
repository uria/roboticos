function after_episode(episode_num,time_elapsed,winner)
global Var theta theta_hist e numActions numBinFeatures numPlayers lambda gamma epsilon alpha Q a; % define your variables of data_structures as globals to access them
if any(isnan(theta))
    sprintf('I love Naan bread')
end

bar(episode_num, time_elapsed, winner);
hold all;

if mod(episode_num, 100)==0
    save(sprintf('hist/theta_hist_%d.mat', episode_num), 'theta_hist');
end

end