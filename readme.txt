% Reinforcement Learning
% Readme file V1.5.1 for Soccer Simulator
%
% Majd Hawasly
% M.Hawasly@sms.ed.ac.uk
% -----------------------------------------

Usage
'start <partial_observability> <episodes>'

'start' (or 'start 0' or 'start 0 1') will run simulation in full observability for one episode (with visualisation)
'start 0 n' will run simulation in full observability for n episodes (in batch mode)

'start 1' (or 'start 1 1') will run simulation in partial observability for one episode (with visualisation)
'start 1 n' will run simulation in partial observability for n episodes (in batch mode)

The field
- a 120X60 grid.
- The origin is at the centre of the field. X axis goes from -60 at the left to +60 at the right. Y axis goes from -30 at the bottom to +30 at the top.
- The angles are measured anticlockwise, from 0 to 360. 
- Your team will be playing from left to right.

The goal line
To win a game, your team should *deliver* the ball to the yellow line defined with X>58. If the ball is delivered to the other side (X<-58), your team will lose.

Bouncy walls
When the ball hits a wall, it will reflect back in a angle opposite to the angle of hitting.


The simulation 
At every time step, your team can specify a vector of actions, one action per team player.

Actions
Each player can perform the following actions:
  - dash <vel>: moves the player in its current heading with the velocity <vel>. <vel> takes values from -10 to 10.
  - turn <ang>: changes the heading of the player by steps of 45 degrees; i.e., round(ang/45)*45. <ang> ranges between 0 and 360 degrees.
  - kick <vel> <dir>: if the ball is in the kicking range of the player, this action moves the ball with velocity <vel> in the direction <dir> relative to the heading of the player. <vel> takes values from [-10,10] and <dir> from [0,360]. Multiple kicks to the ball from multiple players casue the ball to move in the direction of the sum of kick vectors.

Kicking range
The ball is kickable by a player only if:
- the player is on the same grid cell as the ball, OR
- the ball is one cell away from the player, either in X or Y direction, and in 45 degrees angle from the player heading. That means the ball should be either one cell in front of the player, one cell above that, or one cell below that.


Decision process
Every simulation step, your team should produce an action list, A, that contains one action per player. The actions are strings (e.g. 'dash 10','turn 45' or 'kick 10 0'.) Your team will receive a state, S, composed of:
- Full observability scenario: {the ball object, your team players, the opponent players}
B: the ball object: {[B_X,B_Y] , [B_VX, B_VY]}
	B_X: absolute X position of the ball
	B_Y: absolute Y position of the ball
	B_VX:  absolute X velocity of the ball
	B_VY: absolute Y velocity of the ball
T: an ordered list of player objects, P: {[P_X,P_Y,P_theta] , [P_color], [P_num]}
	P_color: color (team) of the player. Your team is team 'r'(red), and the opponents are team 'b'(blue).	
	P_num: id of the player
	P_X: absolute X position of the player
	P_Y: absolute Y position of the player
	P_theta: absolute heading of the player

Accessing variables
B_X: B{1}(1)
B_Y: B{1}(2)
B_VX: B{2}(1)
B_VY: B{2}(2)

P_X: P{1}(1)
P_Y: P{1}(2)
P_theta: P{1}(3)
P_color: P{2}
P_num: P{3}


- Partial observability scenario: A list of partial states, PS, one per player.
A partial state, PS, contains the objects that the player can see in its current position and heading. Each player has a visual field defined by a cone of 90 degrees in the direction of its heading. The retrieved objects are in a coordination frame relative to the player. If the ball is seen, it would be the first element in the list. Otherwise, {-1} will be the first element.
B: the ball object: {[B_R,B_alpha]}
	B_R: relative distance of the ball to the player
	B_alpha: relative angle to the ball position from heading
T: a list of seen players objects, P: {[P_R,P_alpha] , [P_color], [P_num]}
	P_color: the color (team) of the player. Your team is team 'r'(red), and the opponents are team 'b'(blue).	
	P_num: identifier of the player
	P_R: relative distance of the player
	P_alpha: relative angle to the player position from heading

Accessing variables
B_R: B{1}(1)
B_alpha: B{1}(2)
B_VX: B{2}(1)
B_VY: B{2}(2)

P_R: P{1}(1)
P_alpha: P{1}(2)
P_color: P{2}
P_num: P{3}




Noise model
<to be added>




File structure
--------------------
The 'TeamAgent' file
The majority of your algorithmic work will be in the *TeamAgent file* which represents your team agent. As always in RL, the TeamAgent function gets as input a state, S (or an array of partial states), as detailed previously in every simulation step. You are not given explicit reward signal, hence you should extract your reward from the state you have. Then the TeamAgent should return actions (a list of string commands) for the team players. The simulator (Environment) will take in charge of the rest, simulating the outcomes and showing them visually. 

The 'data_structures' file
The function data_structures is called by the simulator at the start of the simulation to initialize your own data sturctures. Make sure that you define your data structures to be *global* so you can access them from the other functions.

The 'before_episode' file
This function is called by the simulator before the episode starts.

The 'after_episode' file
This function is called by the simulator when the episode ends. 

The 'after_simulation' file
This function is called by the simulator when the simulation ends. You can use this function for any 'house keeping' tasks.

'start' script
a script to start the simulation.

Simulator files
All the other files are for the simulator: DO NOT CHANGE ANY OF THE OTHER FILES OR OTHERWISE YOUR CODE MAY NOT RUN ON OUR SYSTEM.


