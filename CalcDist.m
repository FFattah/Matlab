function d = CalcDist(X1, Y1, X2, Y2, Clus, Radius)
% CalcDist - Calculate the Euclidean distance between two points in a 
% hexagonal cellular layout with cluster-based offset adjustment.
%
% Syntax:
%   d = CalcDist(X1, Y1, X2, Y2, Clus, Radius)
%
% Inputs:
%   X1, Y1   - Coordinates of the first point (reference base station)
%   X2, Y2   - Coordinates of the second point (target base station)
%   Clus     - Cluster number (2 through 7) for offset adjustment
%   Radius   - Radius of a hexagonal cell (used for geometric translation)
%
% Output:
%   d        - Euclidean distance between adjusted (X2, Y2) and (X1, Y1)
%
% Description:
%   This function calculates the distance between two base stations in a 
%   cellular network considering hexagonal layout and spatial shifts 
%   based on cluster reuse patterns. The (X2, Y2) coordinates are offset 
%   according to the specified cluster number to reflect relative positions
%   in a standard 7-cell frequency reuse scheme.

% Apply coordinate transformation based on cluster number
switch Clus
    case 2
        X2 = X2 + 3 * Radius;
    case 3
        X2 = X2 + 1.5 * Radius;
        Y2 = Y2 + 1.5 * sqrt(3) * Radius;
    case 4
        X2 = X2 - 1.5 * Radius;
        Y2 = Y2 + 1.5 * sqrt(3) * Radius;
    case 5
        X2 = X2 - 3 * Radius;
    case 6
        X2 = X2 - 1.5 * Radius;
        Y2 = Y2 - 1.5 * sqrt(3) * Radius;
    case 7
        X2 = X2 + 1.5 * Radius;
        Y2 = Y2 - 1.5 * sqrt(3) * Radius;
end

% Calculate Euclidean distance
d = sqrt((X2 - X1)^2 + (Y2 - Y1)^2);

end
