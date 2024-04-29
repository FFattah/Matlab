% clc; 
% close all;
% clear all;
%This program is for pricing in cognitive radio
%By Zahra Fattah


function PrimaryCost(Cons,A)
    PrGain=0;                                                               %  Total gain of Primary providers.
    PricePClass=[100,200,300];                                              %  Prices for each class of primary Consumers 


    PrConsNo=size(Cons);                                                    %number of primary consumers
    
    for i=1 : PrConsNo
         if Cons(i).CLUS == 1
            Cons(i).Price=PricePClass(Cons(i).class);
            PrGain=PrGain+ Cons(i).Price;
         end
    end
        
        
        
        
        
end
