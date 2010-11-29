% Reinforcement Learning
% V1.5 
% -----------------------------------------

function start(obs,p)

addpath('files');
if(nargin<1)
    obs='0';
end
if(nargin<2)
    p='0';
end

simulator(obs,p);

end
