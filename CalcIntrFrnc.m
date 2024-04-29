% clc; 
% close all;
% clear all;
%This subprogram is for pricing in cognitive radio
%By Zahra Fattah

% input parameters:
% Cons              %Cons struct wich it's Interference shuould be calculated
% Cons              %Bs of this consumer
% ItfBS             % BS es that will couse Interference for given node
% ItfRows,ItfCols   %number of rows and columns for ItfBS es
% M                 % an array of Spectrum numbers wich User Cons uses them
% I                 % Sum of interferences for each user in each spectrum of M
% This function calculates Interference and available bandwidth for one consumer in it's different spectrums

function [I,RBW]=CalcIntrFrnc(Cons,ConsBS, ItfBS,M,OneorSec,S,UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr)
    [ItfRows,ItfCols]=size(ItfBS);
    ConsSpeIndx=ConsBS(Cons.CellNo(1),Cons.CellNo(2)).Cons;                            
    SpecIndx=find(ConsSpeIndx==Cons.Index);                                       % spectrum Index that Cons uses them in his cell 
    SpecNo=ConsBS(Cons.CellNo(1),Cons.CellNo(2)).M(SpecIndx);                     % spectrum number that Cons uses them in his cell
    I(M)=0;
    RBW=0;
    for i=1:ItfRows
        for j=1:ItfCols
            for m=1:length(SpecNo)
                tt=find(ItfBS(i,j).M==SpecNo(m)) ; 
                if (i~=Cons.CellNo(1) || j~=Cons.CellNo(2))|| tag
                    if ItfBS(i,j).Cons(tt+OneorSec)~=0 
                        X1 = ConsBS(Cons.CellNo(1),Cons.CellNo(2)).X + Cons.XLoc;   % X1 and Y1 are the location of consumer;
                        X2 = ItfBS(i,j).X;
                        Y1 = ConsBS(Cons.CellNo(1),Cons.CellNo(2)).Y + Cons.YLoc;   % X2 and Y2 are the location of Base Station that has interference with Consumer;
                        Y2 = ItfBS(i,j).Y;
                        d2BS = ((X2-X1)^2+(Y2-Y1)^2)^ 0.5;
                        PG_two_ray=Pt*Gt*Gr*ht^2*hr^2*(1./d2BS).^4;
                        I(SpecNo(m)) = I(SpecNo(m)) + PG_two_ray;                   % 'I' will save the Interferance in each spectrum in the first cluster
                    end
               end    
            end   
        end
    end
    for m=1:length(SpecNo)
        SIR = S/(I(SpecNo(m)) + N);
        RBW = RBW + UBndwPChanel * log(1 + SIR)/log(2);                             % Real bandwidth for each user in different spectrums         
    end
end
