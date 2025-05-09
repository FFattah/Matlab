function [I, RBW] = CalcIntrFrncSecOnPri(PrCons, ConsBS, SecBS, SecCons, M, OneorSec, S, UBndwPChanel, N, Pt, Gt, Gr, ht, hr)
% CalcIntrFrncSecOnPri - Calculates interference caused by secondary users
% on a primary user in a cognitive radio network, and computes available bandwidth.
%
% Inputs:
%   PrCons         - Primary consumer structure (includes index, cell number, and local coordinates)
%   ConsBS         - Matrix of base stations serving primary consumers
%   SecBS          - (Not used directly) Base stations of secondary consumers (struct matrix)
%   SecCons        - Array of secondary user structs (each with BS field containing .X, .Y, .Cons)
%   M              - Array of spectrum numbers
%   OneorSec       - Index offset indicating primary or secondary user lookup
%   S              - Desired signal power from the serving BS
%   UBndwPChanel   - Unit bandwidth per channel (e.g., in MHz)
%   N              - Noise power
%   Pt, Gt, Gr     - Transmit power and antenna gains
%   ht, hr         - Transmitter and receiver antenna heights
%
% Outputs:
%   I              - Interference power per spectrum used by the primary consumer
%   RBW            - Total real bandwidth available to the primary user after accounting for interference
%
% Author: Zahra Fattah
% Cognitive Radio Pricing Model - Secondary Interference Calculation

% Get the list of spectrums assigned to the primary consumer
ConsSpeIndx = ConsBS(PrCons.CellNo(1), PrCons.CellNo(2)).Cons;
SpecIndx = find(ConsSpeIndx == PrCons.Index);  % Find index of this consumer in BS's consumer list
SpecNo = ConsBS(PrCons.CellNo(1), PrCons.CellNo(2)).M(SpecIndx);  % Spectrum numbers used by primary

% Initialize interference and total bandwidth
I(M) = 0;
RBW = 0;
SecConsNo = length(SecCons);

% Loop through all secondary consumers
for i = 1:SecConsNo
    for m = 1:length(SpecNo)
        % If the secondary consumer is using the same spectrum
        if SecCons(i).BS.Cons(SpecNo(m) + OneorSec) == i
            % Coordinates of primary user
            X1 = ConsBS(PrCons.CellNo(1), PrCons.CellNo(2)).X + PrCons.XLoc;
            Y1 = ConsBS(PrCons.CellNo(1), PrCons.CellNo(2)).Y + PrCons.YLoc;

            % Coordinates of interfering secondary BS
            X2 = SecCons(i).BS.X;
            Y2 = SecCons(i).BS.Y;

            % Distance between primary user and secondary BS
            d2BS = sqrt((X2 - X1)^2 + (Y2 - Y1)^2);

            % Interference power using the two-ray ground model
            PG_two_ray = Pt * Gt * Gr * ht^2 * hr^2 / (d2BS^4);

            % Accumulate interference for this spectrum
            I(SpecNo(m)) = I(SpecNo(m)) + PG_two_ray;
        end
    end
end

% Compute real bandwidth for the primary user based on SIR
for m = 1:length(SpecNo)
    SIR = S / (I(SpecNo(m)) + N);  % Signal-to-Interference-plus-Noise Ratio
    RBW = RBW + UBndwPChanel * log2(1 + SIR);  % Shannon capacity
end

end
