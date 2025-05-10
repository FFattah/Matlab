function PrimaryCost(Cons, A)
% PrimaryCost - Calculates total revenue for primary providers.
%
% This function evaluates the gain (total collected price) from primary users
% who are associated with a specific cluster (`CLUS == 1`), based on their 
% service class.
%
% Inputs:
%   Cons - Array of primary consumers, each with fields:
%          .class - Service class index (1 to 3)
%          .CLUS  - Cluster index (1 = Provider 1, etc.)
%   A    - Unused parameter (reserved for future use or placeholder)
%
% Outputs:
%   Prints the total revenue of provider 1 (CLUS == 1)
%
% Author: Zahra Fattah

% ----------------------------
% Class-based price tiers (e.g., bandwidth or QoS classes)
PricePClass = [100, 200, 300];  % in arbitrary currency units

% Initialize total gain
PrGain = 0;

% Total number of primary users
PrConsNo = length(Cons);

% ----------------------------
% Iterate through consumers
for i = 1:PrConsNo
    if Cons(i).CLUS == 1
        Cons(i).Price = PricePClass(Cons(i).class);
        PrGain = PrGain + Cons(i).Price;
    end
end

% Display result (optional)
fprintf('Total revenue for primary provider (CLUS == 1): %d\n', PrGain);

end
