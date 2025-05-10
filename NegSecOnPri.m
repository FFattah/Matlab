function [RBW, II, Penalty] = NegSecOnPri( ...
    SecCons, SecBS, PrCons, PrBS, M, OneorSec, ReqBW, ...
    UBndwPChanel, N, Pt, Gt, Gr, ht, hr, Lb, Ub)
% NegSecOnPri - Calculates interference from secondary users to primary users
% and determines penalties if primary QoS is violated.
%
% Inputs:
%   SecCons        - Secondary consumer array
%   SecBS          - Base stations for secondary users
%   PrCons         - Primary consumer array
%   PrBS           - Base stations for primary users
%   M              - Number of total spectrum channels
%   OneorSec       - Offset index to identify secondary or primary user in .Cons list
%   ReqBW          - Array of requested bandwidth per primary user class
%   UBndwPChanel   - Unit bandwidth per channel (bps)
%   N              - Noise power
%   Pt, Gt, Gr     - Transmit power and antenna gains
%   ht, hr         - Transmit and receive antenna heights
%   Lb, Ub         - Lower and upper bounds for QoS satisfaction thresholds
%
% Outputs:
%   RBW            - Achieved bandwidth per primary user
%   II             - Total interference (from both primary and secondary sources)
%   Penalty        - Penalty assigned per primary user based on RBW degradation
%
% Author: Zahra Fattah

% Initialize arrays
numUsers = length(PrCons);
RBW = zeros(1, numUsers);     % Real bandwidth achieved
S = zeros(1, numUsers);       % Signal power
IfPr = zeros(numUsers, M);    % Interference from primary BSs
IfSec = zeros(numUsers, M);   % Interference from secondary BSs

% Calculate signal power and interference for each primary user
for k = 1:numUsers
    % Compute signal power using two-ray ground model
    d2BS = sqrt(PrCons(k).XLoc^2 + PrCons(k).YLoc^2);
    S(k) = Pt * Gt * Gr * ht^2 * hr^2 / d2BS^4;

    % Compute intra-primary and secondary interference
    tag = 0;  % Intra-cell interference disabled
    [IfPr(k, :), ~] = CalcIntrFrnc(PrCons(k), PrBS, PrBS, M, 0, S(k), UBndwPChanel, N, tag, Pt, Gt, Gr, ht, hr);
    [IfSec(k, :), ~] = CalcIntrFrncSecOnPri(PrCons(k), PrBS, SecBS, SecCons, M, OneorSec, S(k), UBndwPChanel, N, Pt, Gt, Gr, ht, hr);
end

% Total interference
II = IfPr + IfSec;

% Compute real bandwidth for each primary user
for k = 1:numUsers
    ConsSpeIndx = PrBS(PrCons(k).CellNo(1), PrCons(k).CellNo(2)).Cons;
    SpecIndx = find(ConsSpeIndx == PrCons(k).Index);
    SpecNo = PrBS(PrCons(k).CellNo(1), PrCons(k).CellNo(2)).M(SpecIndx);

    for m = 1:length(SpecNo)
        SIR = S(k) / (II(k, SpecNo(m)) + N);
        RBW(k) = RBW(k) + UBndwPChanel * log2(1 + SIR);
    end
end

% Determine penalties based on achieved vs. requested BW
Penalty = zeros(1, numUsers);
for k = 1:numUsers
    satisfaction = RBW(k) / ReqBW(PrCons(k).class);

    if satisfaction > Ub
        Penalty(k) = 0;
    elseif satisfaction >= Lb
        Penalty(k) = PrCons(k).Price * satisfaction;
    else
        Penalty(k) = PrCons(k).Price;  % Full penalty
    end
end

end
