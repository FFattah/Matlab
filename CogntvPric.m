function CogntvPric()
% CogntvPric - Cognitive radio pricing simulation and evaluation.
%
% Description:
%   This script models spectrum pricing strategies in a cognitive radio network
%   with primary and secondary users using a two-ray ground propagation model.
%   It simulates system performance under varying pricing and consumer configurations.
%
% Author: Zahra Fattah

%% -----------------------------
% Two-ray ground model parameters
Gt = 1;               % Transmit antenna gain
Gr = 1;               % Receive antenna gain
L = 1;                % System loss (not used in current version)
ht = 30;              % Transmit antenna height
hr = 1;               % Receive antenna height
Pt = 20;              % Transmit power (watts)
N = 1e-9;             % Noise power

%% -----------------------------
% Network configuration
ReUsFct = 3;                          % Frequency reuse factor
Rows = 3;                             % Number of rows in cell grid
Cols = 3;                             % Number of columns in cell grid
Spectrm = 90;                         % Total spectrum per provider (kbps)
M = 90;                               % Number of channels (total)
MaxConsPCell = 15;                   % Max primary consumers per cell
PReqBW = [1000, 3000, 5000];          % Requested bandwidth (kbps) by class
PPrice = [1000, 2000, 3000];          % Initial price levels per primary user class
Radius = 700;                         % Radius of each hexagonal cell (meters)

% Secondary user configuration
MaxSecConsNo = 15;                    % Max number of all secondary consumers
MaxSpcNo = 10;                        % Max number of channels per secondary user
SecReqBW = [1000];                   % Requested bandwidth for secondary (kbps)
SecMinPrice = [300];                % Minimum acceptable price for secondary users

% Pricing and iteration control
IncPric = 50;                         % Step to increase price
DecPric = 50;                         % Step to decrease price
Itratn = 5;                           % Number of iterations for adaptive pricing
Lb = 0.2;                             % Lower bound for service satisfaction ratio
Ub = 0.8;                             % Upper bound for service satisfaction ratio

%% -----------------------------
% Example: Evaluate profit vs primary pricing scenarios
PPrices = zeros(10, 3);               % Initialize price variation matrix
for i = 110:100:1000
    PPrices(i/10, :) = [1000+i, 2000+i, 3000+i];  % Adjust price per class
end

for i = 11:10:100
    % Run pricing simulation with adjusted primary prices
    [Bnft1, Bnft2, Cons1, PrBS1, Cons2, PrBS2, SecCons, SecBS, IPoS, RBWS] = ...
        Consumer(Gt, Gr, L, ht, hr, Pt, N, ...
        ReUsFct, Rows, Cols, Spectrm, M, MaxConsPCell, ...
        PReqBW, PPrices(i,:), Radius, MaxSecConsNo, MaxSpcNo, ...
        SecReqBW, SecMinPrice, IncPric, DecPric, Itratn, Lb, Ub);

    % Save simulation results to .mat file
    filename = ['BnftPerPrice_' num2str(PPrices(i,1)) '_' num2str(PPrices(i,2)) '_' num2str(PPrices(i,3)) '.mat'];
    save(filename);
end

%% -----------------------------
% Note:
% Many additional test blocks, including visualization and batch testing,
% have been commented out. Uncomment relevant blocks as needed to:
% - Analyze profit vs. number of users
% - Visualize user satisfaction
% - Monitor system-level KPIs

end
