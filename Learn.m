function [AvgBnft1, AvgBnft2, AvgPenalty1, AvgPenalty2, SecCons, SecBS] = Learn( ...
    Itratn, SecCons, SecBS, Cons1, PrBS1, Cons2, PrBS2, ...
    IPoS, RBWS, IncPric, DecPric, PPrice, ...
    PReqBW, SecReqBW, SecMinPrice, MaxSpcNo, M, OneorSec, ...
    UBndwPChanel, N, Pt, Gt, Gr, ht, hr, Lb, Ub)
% Learn - Adaptive pricing using probabilistic learning for spectrum allocation.
%
% This function uses a reinforcement learning method to adjust the spectrum prices
% offered to secondary users in order to optimize the benefits of two primary
% providers in a cognitive radio network.
%
% Inputs:
%   Itratn          - Number of learning iterations for evaluation
%   SecCons, SecBS  - Secondary consumers and base stations
%   Cons1, PrBS1    - Primary consumers and BSs for provider 1
%   Cons2, PrBS2    - Primary consumers and BSs for provider 2
%   IPoS, RBWS      - Interference states and real bandwidth of secondaries
%   IncPric         - Incremental price step for increasing prices
%   DecPric         - Decremental step for lowering prices
%   PPrice          - Primary user prices (upper limits)
%   PReqBW          - Primary user requested bandwidth
%   SecReqBW        - Secondary user requested bandwidth
%   SecMinPrice     - Minimum acceptable price for secondary users
%   MaxSpcNo        - Max number of channels a secondary user may access
%   M               - Number of channels per provider
%   OneorSec        - Flag for identifying user type
%   UBndwPChanel    - Unit bandwidth per channel
%   N, Pt, Gt, Gr   - Noise, transmission power, antenna gains
%   ht, hr          - Transmit/receive antenna heights
%   Lb, Ub          - Lower and upper satisfaction bounds (penalty thresholds)
%
% Outputs:
%   AvgBnft1, AvgBnft2 - Benefit trends for both primary providers
%   AvgPenalty1, AvgPenalty2 - Accumulated penalties from underservice
%   SecCons, SecBS     - Updated secondary user and BS states

% -------------------------------------------------------------------------
% Initialization
a = 0.01; % Learning rate for success reinforcement
b = 0.01; % Learning rate for penalty

SPrc = ones(1, 2*M) * (SecMinPrice(1) / 10); % Initial spectrum prices

% Initial benefit and penalty calculations
[PureBnft1, PureBnft2, AvgPenalty1, AvgPenalty2, SecCons, SecBS] = ...
    Price(Itratn, SPrc, SecCons, SecBS, Cons1, PrBS1, Cons2, PrBS2, ...
          IPoS, RBWS, PPrice, PReqBW, SecReqBW, SecMinPrice, MaxSpcNo, ...
          2*M, OneorSec, UBndwPChanel, N, Pt, Gt, Gr, ht, hr, Lb, Ub);

% -------------------------------------------------------------------------
% Initialize probability distributions for spectrum learning
Prob1 = ones(1, 2*M) / (2*M + 1);
SumPrb1 = cumsum(Prob1);
Prob2 = Prob1;  % Same start
SumPrb2 = SumPrb1;

% Benefit tracking
AvgBnft1 = zeros(1, M);
AvgBnft2 = zeros(1, M);

i = 1;

while i < 1000
    % Select spectrum index for Provider 1 and adjust price
    x1 = rand();
    [~, LearnCel1(i)] = min(abs(SumPrb1 - x1));
    if LearnCel1(i) <= M
        if SPrc(LearnCel1(i)) + IncPric < PPrice(1)/10
            SPrc(LearnCel1(i)) = SPrc(LearnCel1(i)) + IncPric;
        end
    else
        idx = LearnCel1(i) - M;
        if SPrc(idx) - DecPric > SecMinPrice(1)/10
            SPrc(idx) = SPrc(idx) - DecPric;
        end
    end

    % Select spectrum index for Provider 2 and adjust price
    x2 = rand();
    [~, LearnCel2(i)] = min(abs(SumPrb2 - x2));
    if LearnCel2(i) <= M
        if SPrc(M + LearnCel2(i)) + IncPric < PPrice(1)/10
            SPrc(M + LearnCel2(i)) = SPrc(M + LearnCel2(i)) + IncPric;
        end
    else
        idx = LearnCel2(i);
        if SPrc(idx) - DecPric > SecMinPrice(1)/10
            SPrc(idx) = SPrc(idx) - DecPric;
        end
    end

    % Re-evaluate pricing effects after update
    [AvgBnft1(LearnCel1(i)), AvgBnft2(LearnCel2(i)), ...
     AvgPenalty1, AvgPenalty2, SecCons, SecBS] = ...
        Price(Itratn, SPrc, SecCons, SecBS, Cons1, PrBS1, Cons2, PrBS2, ...
              IPoS, RBWS, PPrice, PReqBW, SecReqBW, SecMinPrice, MaxSpcNo, ...
              2*M, OneorSec, UBndwPChanel, N, Pt, Gt, Gr, ht, hr, Lb, Ub);

    % Reinforcement learning update for Provider 1
    if AvgBnft1(LearnCel1(i)) >= PureBnft1
        Prob1 = (1 - a) * Prob1;
        Prob1(LearnCel1(i)) = Prob1(LearnCel1(i)) + a;
    else
        if Prob1(LearnCel1(i)) - b * (1 - Prob1(LearnCel1(i))) > 0
            Prob1(LearnCel1(i)) = Prob1(LearnCel1(i)) - b * (1 - Prob1(LearnCel1(i)));
        end
        Prob1 = Prob1 .* (1 + b);
    end

    % Reinforcement learning update for Provider 2
    if AvgBnft2(LearnCel2(i)) >= PureBnft2
        Prob2 = (1 - a) * Prob2;
        Prob2(LearnCel2(i)) = Prob2(LearnCel2(i)) + a;
    else
        if Prob2(LearnCel2(i)) - b * (1 - Prob2(LearnCel2(i))) > 0
            Prob2(LearnCel2(i)) = Prob2(LearnCel2(i)) - b * (1 - Prob2(LearnCel2(i)));
        end
        Prob2 = Prob2 .* (1 + b);
    end

    % Normalize probability sums
    SumPrb1 = cumsum(Prob1);
    SumPrb2 = cumsum(Prob2);

    i = i + 1;
end

end
