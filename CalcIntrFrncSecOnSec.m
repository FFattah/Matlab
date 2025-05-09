function [I, RBW] = CalcIntrFrncSecOnSec(Cons, ConsBS, SecCons, ItfBS, M, S, UBndwPChanel, N, tag, Pt, Gt, Gr, ht, hr)
% CalcIntrFrncSecOnSec - Calculates the interference caused by other secondary users 
% on a specific secondary user, and computes the real bandwidth available.
%
% Inputs:
%   Cons            - Target secondary user (struct with Index, CellNo, XLoc, YLoc)
%   ConsBS          - Base stations serving secondary users (matrix of structs)
%   SecCons         - Array of secondary user structures, each with a BS subfield
%   ItfBS           - Interfering base stations (not used in this version)
%   M               - Total number of spectrum channels (scalar)
%   S               - Desired signal power received by the secondary user
%   UBndwPChanel    - Unit bandwidth per channel (in MHz or similar)
%   N               - Noise power
%   tag             - Boolean flag to consider intra-cell interference (not used here)
%   Pt, Gt, Gr      - Transmission power and antenna gains
%   ht, hr          - Antenna heights for transmitter and receiver
%
% Outputs:
%   I               - Interference vector (1 x M), storing total interference per spectrum
%   RBW             - Real bandwidth available based on interference and SIR
%
% Author: Zahra Fattah

% Initialize interference vector and accumulated bandwidth
I = zeros(1, M);
RBW = 0;

% Coordinates of the target secondary user
X1 = ConsBS(Cons.CellNo(1), Cons.CellNo(2)).X + Cons.XLoc;
Y1 = ConsBS(Cons.CellNo(1), Cons.CellNo(2)).Y + Cons.YLoc;

% Loop over all secondary consumers
for i = 1:length(SecCons)
    for m = 1:M
        % Check if the secondary user 'i' is using channel 'm'
        if SecCons(i).BS.Cons(m) == i
            % Get interfering BS coordinates
            X2 = SecCons(i).BS.X;
            Y2 = SecCons(i).BS.Y;

            % Calculate distance between the current secondary user and the interferer
            d2BS = sqrt((X2 - X1)^2 + (Y2 - Y1)^2);

            % Compute interference power using the two-ray ground propagation model
            PG_two_ray = Pt * Gt * Gr * ht^2 * hr^2 / (d2BS^4);

            % Accumulate interference for channel m
            I(m) = I(m) + PG_two_ray;
        end
    end
end

% Calculate bandwidth using Shannon capacity formula for each channel
for m = 1:M
    SIR = S / (I(m) + N);  % Signal-to-Interference-plus-Noise Ratio
    RBW = RBW + UBndwPChanel * log2(1 + SIR);  % Sum bandwidth across all channels
end

end
