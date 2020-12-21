%   2DP4 - Microproccesors Systems - Final Project
%   Serial Communication between ESDX and MATLAB
%   Kapithaan Pathmanathan - pathmk2 - 001415745

clc;
clear; 

delete(instrfindall);       % delete all and close any ports
s = serial('COM2');         % select COM Port 2
s.BaudRate = 115200;        % set Baud Rate based on 14 Mhz bus speed: 115200
s.Terminator = 'CR';        % set CR as terminator
fopen(s);                   % open file

%Initilization - Variables
VFS = 5;                    % full scale voltage
bits = 12;                  % number of bits
voltage = 0;                % Voltage Low
res = (VFS/((2^bits)-1));   % resolution (step size)


% Plot Parameters
% set x limits (time)
xmin = 0;                   
xmax = 500;
% set y limits (voltage)
ymin = 0;
ymax = 5;

%Plot Titles
title('Voltage.vs.Time: Kapithaan Pathmanathan 001415745')
xlabel('Time (seconds)')
ylabel('Voltage (V)')

line = animatedline;
startT = datetime('now');

while 1>0
    Output = fgetl(s)               % returns the next line (value)
    if isempty(Output)              % do nothing if no output value is present
        val = 0;
    else      
        val = str2double(Output)*res      % normalize ADC value 
    end
    t = datetime('now') - startT;        % calculate time
    addpoints(line,datenum(t),val)
    
    [x,y] = getpoints(line);
    xlim(datenum([t-seconds(10) t]));
    
    drawnow          % draw continuous waveform using values serially communicated by ESDX 

end

% make sure to close COM port and delete on going 
fclose(s);
delete(s);
clear (s);
