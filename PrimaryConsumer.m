function [Cons, PrBS] = PrimaryConsumer( ...
    ReUsFct, Rows, Cols, Spectrm, M, OneorSec, ...
    MaxConsPCell, ReqBW, PPrice, Radius, N, Pt, Gt, Gr, ht, hr, L)
% PrimaryConsumer - Assigns and provisions primary users and spectrum in a CRN.
%
% Inputs:
%   ReUsFct         - Frequency reuse factor
%   Rows, Cols      - Grid size for cellular layout
%   Spectrm         - Total spectrum (in Kbps)
%   M               - Number of spectrum channels
%   OneorSec        - Offset index for spectrum identification (0 = primary)
%   MaxConsPCell    - Max primary users per cell
%   ReqBW           - Array of required BW per user class
%   PPrice          - Price levels per user class
%   Radius          - Radius of hexagonal cell
%   N, Pt, Gt, Gr   - Noise, transmit power, antenna gains
%   ht, hr          - Antenna heights
%   L               - Not used here
%
% Outputs:
%   Cons            - Array of primary consumers
%   PrBS            - Grid of base stations
%
% Author: Zahra Fattah

% ----------------------------
% Initial Setup
UBndwPChanel = Spectrm * 1000 / M;          % Bandwidth per channel (bps)
MaxPrConsNo = MaxConsPCell * Rows * Cols;   % Total primary users
PrConsNo = MaxPrConsNo;

% Initialize base stations
PrBS = BS(Rows, Cols, Radius);

% Assign M spectrum channels to 3 reuse groups
for i = 1:Rows
    for j = 1:Cols
        for k = 1:M/ReUsFct
            PrBS(i,j).M(k) = (M/ReUsFct) * (PrBS(i,j).RusCell - 1) + k;
            PrBS(i,j).Cons(k) = 0;  % Unallocated spectrum index
        end
    end
end

% ----------------------------
% Generate primary consumers
Cons = struct;
for i = 1:PrConsNo
    Cons(i).Index = i;
    Cons(i).class = randi(3);  % Random class 1,2,3
    x = randi(Rows);
    y = randi(Cols);
    Cons(i).CellNo = [x, y];
    Cons(i).BS = PrBS(x, y);
    Cons(i).XLoc = randi([-Radius, Radius]);
    Cons(i).YLoc = randi([-Radius, Radius]);
    Cons(i).BW = 0;
    Cons(i).Price = PPrice(Cons(i).class);
end

% ----------------------------
% Allocate spectrum based on SNR and minimum BW
for i = 1:PrConsNo
    while Cons(i).BW < ReqBW(Cons(i).class)
        cell = PrBS(Cons(i).CellNo(1), Cons(i).CellNo(2));
        if length(find(cell.Cons)) < M / ReUsFct
            x = randi(M / ReUsFct);
            if cell.Cons(x) == 0
                % Allocate channel
                cell.Cons(x) = i;
                Cons(i).BS.Cons(x) = i;
                PrBS(Cons(i).CellNo(1), Cons(i).CellNo(2)).Cons(x) = i;

                % Calculate SNR and bandwidth
                d2BS = sqrt(Cons(i).XLoc^2 + Cons(i).YLoc^2);
                S = Pt * Gt * Gr * ht^2 * hr^2 / d2BS^4;
                SIR = S / N;
                BW = UBndwPChanel * log2(1 + SIR);
                Cons(i).BW = Cons(i).BW + BW;
            end
        else
            fprintf('Not enough bandwidth in Cell (%d,%d)\n', x, y);
            break;
        end
    end
end

% ----------------------------
% Adjust BW with Interference Consideration
for k = 1:PrConsNo
    tag = 0; % intra-cell interference ignored
    [~, RBW(k)] = CalcIntrFrnc(Cons(k), PrBS, PrBS, M, OneorSec, S, UBndwPChanel, N, tag, Pt, Gt, Gr, ht, hr);
    Cons(k).BW = RBW(k);

    % Allocate additional channels if needed
    while Cons(k).BW < ReqBW(Cons(k).class)
        cell = PrBS(Cons(k).CellNo(1), Cons(k).CellNo(2));
        if length(find(cell.Cons)) < M / ReUsFct
            x = randi(M / ReUsFct);
            if cell.Cons(x) == 0
                cell.Cons(x) = k;
                Cons(k).BS.Cons(x) = k;
                PrBS(Cons(k).CellNo(1), Cons(k).CellNo(2)).Cons(x) = k;
                Cons(k).BW = Cons(k).BW + UBndwPChanel;
            end
        else
            fprintf('No available bandwidth for user %d\n', k);
            break;
        end
    end
end

end
