function [Bnft1, Bnft2, Penalty1, Penalty2, ...
          Cons1, PrBS1, Cons2, PrBS2, ...
          SecCons, SecBS, IPoS, RBWS] = Consumer( ...
          Gt, Gr, L, ht, hr, Pt, N, ...
          ReUsFct, Rows, Cols, Spectrm, M, ...
          MaxConsPCell, PReqBW, PPrice, Radius, ...
          MaxSecConsNo, MaxSpcNo, SecReqBW, SecMinPrice, ...
          IncPric, DecPric, Itratn, Lb, Ub)
% Consumer - Main function for simulating cognitive radio network pricing.
%
% This function initializes a cognitive radio environment with primary and 
% secondary users, sets up base stations and spectrum, and evaluates the
% impact of interference and adaptive pricing via a learning loop.
%
% Inputs:
%   Gt, Gr         - Transmit and receive antenna gains
%   L              - System loss (not used)
%   ht, hr         - Transmit and receive antenna heights
%   Pt             - Transmit power
%   N              - Noise power
%   ReUsFct        - Frequency reuse factor
%   Rows, Cols     - Grid size of the network
%   Spectrm        - Total spectrum per provider (in kbps)
%   M              - Number of channels per provider
%   MaxConsPCell   - Max number of primary users per cell
%   PReqBW         - Requested bandwidth per class (primary)
%   PPrice         - Price per class (primary)
%   Radius         - Cell radius
%   MaxSecConsNo   - Maximum number of secondary users
%   MaxSpcNo       - Max channels per secondary user
%   SecReqBW       - Requested bandwidth for secondary users
%   SecMinPrice    - Minimum acceptable price per secondary user
%   IncPric        - Price increment step
%   DecPric        - Price decrement step
%   Itratn         - Number of learning iterations
%   Lb, Ub         - Bounds for penalizing unsatisfied primary users
%
% Outputs:
%   Bnft1, Bnft2   - Benefit earned by primary provider 1 and 2
%   Penalty1,2     - Penalty due to under-service (QoS violations)
%   Cons1,2        - Primary user objects
%   PrBS1,2        - Primary base stations for both providers
%   SecCons        - Secondary user objects
%   SecBS          - Secondary base station grid
%   IPoS           - Interference Positioning State for secondaries
%   RBWS           - Real bandwidth assigned to each secondary user

% ------------------------------------------------------------------------
% Calculate channel unit bandwidth (in bps) assuming uniform channel division
UBndwPChanel = Spectrm * 1000 / M;

% ------------------------------------------------------------------------
% Step 1: Generate primary consumers and their base stations
OneorSec = 0;
[Cons1, PrBS1] = PrimaryConsumer(ReUsFct, Rows, Cols, Spectrm, M, ...
                                 OneorSec, MaxConsPCell, PReqBW, ...
                                 PPrice, Radius, N, Pt, Gt, Gr, ht, hr);

[Cons2, PrBS2] = PrimaryConsumer(ReUsFct, Rows, Cols, Spectrm, M, ...
                                 OneorSec, MaxConsPCell, PReqBW, ...
                                 PPrice, Radius, N, Pt, Gt, Gr, ht, hr);

% ------------------------------------------------------------------------
% Step 2: Generate secondary consumers and their base stations
SecSpectrm = Spectrm * 2;  % Total spectrum = sum of both providers
SecM = M * 2;              % Total number of channels for secondaries

[SecCons, SecBS, IPoS, RBWS] = SecondaryConsumer( ...
    PrBS1, PrBS2, Rows, Cols, SecSpectrm, SecM, OneorSec, ...
    MaxSecConsNo, Radius, N, Pt, Gt, Gr, ht, hr);

% ------------------------------------------------------------------------
% Step 3: Adaptive pricing and learning loop for spectrum allocation
[Bnft1, Bnft2, Penalty1, Penalty2, SecCons, SecBS] = Learn( ...
    Itratn, SecCons, SecBS, ...
    Cons1, PrBS1, Cons2, PrBS2, ...
    IPoS, RBWS, ...
    IncPric, DecPric, PPrice, ...
    PReqBW, SecReqBW, SecMinPrice, MaxSpcNo, ...
    M, OneorSec, UBndwPChanel, ...
    N, Pt, Gt, Gr, ht, hr, ...
    Lb, Ub);

end
