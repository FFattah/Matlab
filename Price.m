function [AvgBnft1, AvgBnft2, AvgPenalty1, AvgPenalty2, SecCons, SecBS] = Price( ...
    Itratn, SPrc, SecCons, SecBS, Cons1, PrBS1, Cons2, PrBS2, ...
    IPoS, RBWS, PPrice, PReqBW, SecReqBW, SecMinPrice, MaxSpcNo, ...
    M, OneorSec, UBndwPChanel, N, Pt, Gt, Gr, ht, hr, Lb, Ub)
% Price - Optimizes spectrum pricing for secondary users and evaluates benefit
% and penalty for two competing primary service providers in a cognitive radio setup.
%
% Inputs:
%   Itratn           - Number of optimization iterations
%   SPrc             - Initial spectrum price vector (1 x 2M)
%   SecCons, SecBS   - Secondary users and their base stations
%   Cons1, PrBS1     - Primary consumers and BSs of provider 1
%   Cons2, PrBS2     - Primary consumers and BSs of provider 2
%   IPoS, RBWS       - Initial interference and bandwidth of secondary users
%   PPrice           - Price classes for primary users
%   PReqBW           - Requested bandwidth of primary users
%   SecReqBW         - Requested bandwidth per secondary user class
%   SecMinPrice      - Minimum acceptable price per secondary
%   MaxSpcNo         - Maximum number of channels a secondary user may use
%   M                - Number of channels per provider (total 2M)
%   OneorSec         - Spectrum index offset (0 for P1, M/2 for P2)
%   UBndwPChanel     - Unit bandwidth per channel (bps)
%   N, Pt, Gt, Gr    - Noise, transmit power, and antenna gains
%   ht, hr           - Transmit and receive antenna heights
%   Lb, Ub           - QoS thresholds for penalty policy
%
% Outputs:
%   AvgBnft1, AvgBnft2       - Average benefits for provider 1 and 2
%   AvgPenalty1, AvgPenalty2 - Average penalties applied to provider 1 and 2
%   SecCons, SecBS           - Updated secondary consumers and BSs
%
% Author: Zahra Fattah

% ----------------------------
% Weight parameters
w1 = 1;     % Importance of bandwidth satisfaction
w2 = 10;    % Importance of spectrum price cost

SecConsNo = length(SecCons);
[SRows, SCols] = size(SecBS);

% Initialize tracking arrays
PriceP1 = zeros(Itratn, SecConsNo);
PriceP2 = zeros(Itratn, SecConsNo);
Penalty1 = zeros(Itratn, length(Cons1));
Penalty2 = zeros(Itratn, length(Cons2));
S = zeros(1, SecConsNo);
ISoS = zeros(SecConsNo, M);
d2BS = zeros(1, SecConsNo);
Bnft1 = zeros(1, Itratn);
Bnft2 = zeros(1, Itratn);
SelectedSP = cell(SecConsNo, 1);

% ----------------------------
% Main Iteration Loop
for Itr = 1:Itratn
    % Reset spectrum allocations
    for i = 1:SecConsNo
        SecCons(i).BS.Cons(:) = 0;
        d2BS(i) = sqrt(SecCons(i).XLoc^2 + SecCons(i).YLoc^2);
        S(i) = Gt * Gr * ht^2 * hr^2 / d2BS(i)^4;  % Signal power
    end

    % ------------------------
    % Secondary spectrum selection via optimization
    for i = 1:SecConsNo
        f = -1 * (w1 * RBWS(i, 1:M) + w2 * SPrc(1:M));
        A = [-RBWS(i, 1:M); SPrc(1:M); -ones(1, M); ones(1, M)];
        b = [-SecReqBW(SecCons(i).class); PPrice(SecCons(i).class); -1; MaxSpcNo];
        intcon = 1:M;
        lb = zeros(M,1);
        ub = ones(M,1);

        options = optimoptions('intlinprog', 'Display', 'off');
        s = intlinprog(f, intcon, A, b, [], [], lb, ub, options);

        % Store selected spectrums
        SelectedSP{i} = find(s);
        SecCons(i).BS.Cons(SelectedSP{i}) = i;
        SecBS(SecCons(i).CellNo(1), SecCons(i).CellNo(2)).Cons(SelectedSP{i}) = i;

        SecCons(i).BW = sum(RBWS(i, SelectedSP{i}));
        SecCons(i).Price = sum(SPrc(SelectedSP{i}));

        % Price accounting for each provider
        for m = SelectedSP{i}
            if m <= M/2
                PriceP1(Itr, i) = PriceP1(Itr, i) + SPrc(m);
            else
                PriceP2(Itr, i) = PriceP2(Itr, i) + SPrc(m);
            end
        end

        % Update RBW due to secondary interference
        for j = i:SecConsNo
            [ISoS(j,:), RBWSS(j)] = CalcIntrFrncSecOnSec(SecCons(j), SecBS, SecCons, SecBS, M, S(j), UBndwPChanel, N, 0, Pt, Gt, Gr, ht, hr);
            for m = 1:M
                if SecCons(i).BS.Cons(m) == i
                    SIR = S(j) / (IPoS(j, m) + ISoS(j, m) + N);
                    RBWS(j, m) = UBndwPChanel * log2(1 + SIR);
                end
            end
        end
    end

    % ------------------------
    % Penalty calculation
    SecBSP1 = SecBS; SecBSP2 = SecBS;
    for i = 1:SRows
        for j = 1:SCols
            SecBSP1(i,j).M((M/2 + 1):M) = 0;
            SecBSP2(i,j).M(1:(M/2)) = 0;
        end
    end

    [~, ~, Penalty1(Itr,:)] = NegSecOnPri(SecCons, SecBSP1, Cons1, PrBS1, M, OneorSec, PReqBW, UBndwPChanel, N, Pt, Gt, Gr, ht, hr, Lb, Ub);
    [~, ~, Penalty2(Itr,:)] = NegSecOnPri(SecCons, SecBSP2, Cons2, PrBS2, M, M/2, PReqBW, UBndwPChanel, N, Pt, Gt, Gr, ht, hr, Lb, Ub);

    % ------------------------
    % Final benefit for this iteration
    Bnft1(Itr) = sum(PriceP1(Itr,:)) - sum(Penalty1(Itr,:));
    Bnft2(Itr) = sum(PriceP2(Itr,:)) - sum(Penalty2(Itr,:));
end

% ----------------------------
% Average performance over iterations
AvgBnft1 = mean(Bnft1);
AvgBnft2 = mean(Bnft2);
AvgPenalty1 = mean(Penalty1, 1);
AvgPenalty2 = mean(Penalty2, 1);

end
