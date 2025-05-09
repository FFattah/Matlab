function [I, RBW] = CalcIntrFrnc(Cons, ConsBS, ItfBS, M, OneorSec, S, UBndwPChanel, N, tag, Pt, Gt, Gr, ht, hr)
% CalcIntrFrnc - Calculates interference and available bandwidth for a consumer in a cognitive radio network.
%
% Inputs:
%   Cons            - Consumer structure containing index, cell location, and local X/Y offset
%   ConsBS          - Base station array assigned to each consumer
%   ItfBS           - Interfering base stations (ItfRows x ItfCols struct array)
%   M               - Array of spectrum indices used
%   OneorSec        - Offset index for primary/secondary user lookup
%   S               - Signal power from serving BS
%   UBndwPChanel    - Unit bandwidth per channel
%   N               - Noise power
%   tag             - Boolean flag to consider intra-cell interference
%   Pt, Gt, Gr      - Transmission power and antenna gains
%   ht, hr          - Transmitter and receiver antenna heights
%
% Outputs:
%   I               - Interference power per spectrum (indexed by spectrum number)
%   RBW             - Real bandwidth achieved by the user across allocated spectrums
%
% Author: Zahra Fattah

% Get interfering grid dimensions
[ItfRows, ItfCols] = size(ItfBS);

% Identify which spectrum numbers this consumer is using
ConsSpeIndx = ConsBS(Cons.CellNo(1), Cons.CellNo(2)).Cons;
SpecIndx = find(ConsSpeIndx == Cons.Index);              % Consumer's spectrum index in the cell
SpecNo = ConsBS(Cons.CellNo(1), Cons.CellNo(2)).M(SpecIndx);  % Spectrum numbers used

% Initialize interference array and RBW accumulator
I(M) = 0;
RBW = 0;

% Loop over interfering BSs
for i = 1:ItfRows
    for j = 1:ItfCols
        for m = 1:length(SpecNo)
            % Check if interfering BS uses same spectrum
            tt = find(ItfBS(i, j).M == SpecNo(m));
            
            % Skip current BS unless tag = true (intra-cell interference allowed)
            if (i ~= Cons.CellNo(1) || j ~= Cons.CellNo(2)) || tag
                if ~isempty(tt) && ItfBS(i, j).Cons(tt + OneorSec) ~= 0
                    % Calculate user and BS coordinates
                    X1 = ConsBS(Cons.CellNo(1), Cons.CellNo(2)).X + Cons.XLoc;
                    Y1 = ConsBS(Cons.CellNo(1), Cons.CellNo(2)).Y + Cons.YLoc;
                    X2 = ItfBS(i, j).X;
                    Y2 = ItfBS(i, j).Y;

                    % Compute distance and interference power using two-ray ground model
                    d2BS = sqrt((X2 - X1)^2 + (Y2 - Y1)^2);
                    PG_two_ray = Pt * Gt * Gr * ht^2 * hr^2 / (d2BS^4);

                    % Accumulate interference per spectrum
                    I(SpecNo(m)) = I(SpecNo(m)) + PG_two_ray;
                end
            end
        end
    end
end

% Calculate effective bandwidth per spectrum using Shannon capacity formula
for m = 1:length(SpecNo)
    SIR = S / (I(SpecNo(m)) + N);
    RBW = RBW + UBndwPChanel * log2(1 + SIR);  % Sum over usable spectrums
end

end
