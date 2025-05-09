function [I, RBW] = CalcRBW(Cons, ConsBS, ItfBS, ItfConsNo, M, UBndwPChanel, N, tag, Pt, Gt, Gr, ht, hr)
% CalcRBW - Computes signal power, interference, and real bandwidth for 
% secondary users in a cognitive radio network.
%
% Inputs:
%   Cons            - Array of secondary user structures (length = SecConsNo)
%   ConsBS          - Struct array of base stations serving each secondary user
%   ItfBS           - Struct array of base stations causing interference
%   ItfConsNo       - Number of interfering secondary users (scalar)
%   M               - Number of spectrum channels
%   UBndwPChanel    - Unit bandwidth per channel (e.g., in MHz)
%   N               - Noise power
%   tag             - Boolean flag to allow intra-cell interference
%   Pt, Gt, Gr      - Transmission power and antenna gains
%   ht, hr          - Antenna heights for transmitter and receiver
%
% Outputs:
%   I               - Matrix of interference values [ItfConsNo x M] per user/channel
%   RBW             - Vector of total real bandwidth per user [ItfConsNo x 1]
%
% Author: Zahra Fattah
% Cognitive Radio Pricing and Interference Evaluation

% Number of secondary users
SecConsNo = length(Cons);

% Preallocate signal power, interference, and RBW arrays
S = zeros(1, SecConsNo);              % Signal power per user
I = zeros(ItfConsNo, M);              % Interference matrix: users x spectrums
RBW = zeros(ItfConsNo, 1);            % Real bandwidth per user

% Loop through each interfering consumer
for k = 1:ItfConsNo
    % Compute distance from BS to consumer
    d2BS = sqrt(ConsBS(k).X^2 + ConsBS(k).Y^2);

    % Compute received signal power using the two-ray ground model
    S(k) = Gt * Gr * ht^2 * hr^2 / (d2BS^4);

    % Calculate interference and bandwidth using helper function
    [I(k, :), RBW(k)] = CalcIntrFrnc(...
        Cons(k), ConsBS, ItfBS, M, S(k), UBndwPChanel, N, tag, Pt, Gt, Gr, ht, hr);
end

end
