% Reset
clear all
close all
clc

% Parameters
H = 74;        % Height of jump point (m)
D = 31;        % Deck height (m)
c = 0.9;            % Drag coefficient (kg/m)
m = 80;             % Mass of jumper (kg)
L = 25;             % length of bungee rope (m)
k = 90;             % spring constant (N/m)
g = 9.8;            % gravitational acceleration (m/s^2)
C = c/m;            % Scaled drag coefficient
K = k/m;            % Scaled spring constant

% Initial conditions
y0 = 0;
v0 = 0;
T = 60;
n = 10000;

% Acceleration
a = @(t,y,v) g - C*v*abs(v) - K*max(0, y - L);

% subintervals
h = T/n;        % time step 
t = 0:h:T;     % time vector

% State arrays
y = zeros(1,n+1);  v = zeros(1,n+1);

% RK4
for j = 1:n
    k1 = h*(g - C*abs(v(j))*v(j) - max(0, K*(y(j) - L)));
    k2 = h*(g - C*abs(v(j) + k1/2)*(v(j) + k1/2) - max(0, K*(y(j) - L)));
    k3 = h*(g - C*abs(v(j) + k2/2)*(v(j) + k2/2) - max(0, K*(y(j) - L)));
    k4 = h*(g - C*abs(v(j) + k3)*(v(j) + k3) - max(0, K*(y(j) - L)));
    v(j+1) = v(j) + 1/6 * (k1 + 2*k2 + 2*k3 + k4);
    y(j+1) = y(j) + h*v(j);
end

% DISPLACEMENT GRAPH
figure(1); 
plot(t,y,'b', 'LineWidth',1)
xlabel('time (seconds)');
ylabel('Distance travelled (m)');
title('Distance travelled using RK4 method');


% BOUNCES
peaks = 0;
for i = 3:n
    if (y(i) < y(i-1) && y(i-1) > y(i-2))
    peaks = peaks + 1;
    end
end
fprintf('In %d seconds, %d bounces take place.\n', T, peaks)

% VELOCITY GRAPH
figure(2);
plot(t,v,'r', 'LineWidth',1)
xlabel('time (seconds)');
ylabel('Velocity (m/s)');
title('Velocity using RK4 method');

% MAXIMUM SPEED
[value, index] = max(v);
fprintf('Maximum speed of %.2fm/s occurs at %.2f seconds.\n', value, t(index))

% ACCELERATION GRAPH
a = (v(3:end) - v(1:end-2))/(2*h);
figure(3);
plot(t(1:n-1), a, 'g', 'LineWidth',1)
xlabel('time (seconds)'); ylabel('Acceleration (m/s^2)');
title('Acceleration using RK4 method');

% MAX ACCELERATION
[value2, index2] = max(abs(a));
fprintf('Maximum acceleration of %.3fm/s^2 after %.2f seconds during the 60 second jump.\n', value2, t(index2))


% Automated Camera System

camera = H - D;

closest_points = findClosestPoints(camera, y);
p = interpolation(closest_points);
r = rootFinder([p(1), p(2), p(3), p(4) - camera]);

result = r(isbetween(r,closest_points(1,1),closest_points(4,1)));
result_seconds = result * h;

fprintf('The camera should take a photograph at %.2f seconds after the jump.\n', result_seconds)

% Water Touch

distance_from_water = H - (max(y) + 1.75);
initial_distance_from_water = distance_from_water;

L = H - distance_from_water;

magnitude = 0.01;

while 1
    % State arrays
    y = zeros(1,n+1);  v = zeros(1,n+1);
    
    % RK4
    for j = 1:n
        k1 = h*(g - C*abs(v(j))*v(j) - max(0, K*(y(j) - L)));
        k2 = h*(g - C*abs(v(j) + k1/2)*(v(j) + k1/2) - max(0, K*(y(j) - L)));
        k3 = h*(g - C*abs(v(j) + k2/2)*(v(j) + k2/2) - max(0, K*(y(j) - L)));
        k4 = h*(g - C*abs(v(j) + k3)*(v(j) + k3) - max(0, K*(y(j) - L)));
        v(j+1) = v(j) + 1/6 * (k1 + 2*k2 + 2*k3 + k4);
        y(j+1) = y(j) + h*v(j);
    end

    distance_from_water = H - (max(y) + 1.75);
    a = (v(3:end) - v(1:end-2))/(2*h);

    if isbetween(distance_from_water, -0.01, 0.01) && max(abs(a)) < 2*g
        break;
    end

    if max(abs(a)) > 2*g
        k = k - 0.1 * magnitude; 
        L = L - 1 * magnitude;
    elseif distance_from_water > 0
        k = k + 0.1 * magnitude;
        L = L + distance_from_water;
    elseif distance_from_water < 0
        L = L + distance_from_water;
    end

    K = k/m;

end

fprintf('Water Touch achieved with L=%.1f & k=%.2f.\n', L, k);

% BOUNCES
peaks = 0;
for i = 3:n
    if (y(i) < y(i-1) && y(i-1) > y(i-2))
    peaks = peaks + 1;
    end
end
fprintf('Water Touch: In %d seconds, %d bounces take place.\n', T, peaks)

% DISPLACEMENT GRAPH
figure(4); 
plot(t,y,'b', 'LineWidth',1)
xlabel('time (seconds)');
ylabel('Distance travelled (m)');
title('Water Touch: Distance travelled using RK4 method');

