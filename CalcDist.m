function d=CalcDist(X1,Y1,X2,Y2,Clus,Radius)

switch Clus
    case 2
        X2=X2 + 3*Radius;
    case 3
        X2=X2 + 1.5*Radius;
        Y2=Y2 + 1.5*sqrt(3)*Radius;        
    case 4
        X2=X2 - 1.5*Radius;
        Y2=Y2 + 1.5*sqrt(3)*Radius;                
    case 5
        X2=X2 - 3*Radius;
    case 6
        X2=X2 - 1.5*Radius;
        Y2=Y2 - 1.5*sqrt(3)*Radius;        
    case 7
        X2=X2 + 1.5*Radius;
        Y2=Y2 - 1.5*sqrt(3)*Radius;        
end
d = ((X2-X1)^2+(Y2-Y1)^2)^0.5;


