% clc; 
% close all;
% clear all;
%This subprogram is for pricing in cognitive radio
%By Zahra Fattah

% input parameters:
% Cons              %Cons struct wich it's Interference shuould be calculated
% Cons              %Bs of this consumer
% SecBS             % BS es that will couse Interference for given node
% ItfRows,ItfCols   %number of rows and columns for ItfBS es
% M                 % an array of Spectrum numbers wich User Cons uses them
% I                 % Sum of interferences for each user in each spectrum of M
% This function calculates Interference and available bandwidth for one consumer in it's different spectrums

function [I,RBW]=CalcIntrFrncSecOnPri(PrCons,ConsBS, SecBS,SecCons,M,OneorSec,S,UBndwPChanel,N, Pt,Gt,Gr,ht,hr)
    ConsSpeIndx=ConsBS(PrCons.CellNo(1),PrCons.CellNo(2)).Cons;                            
    SpecIndx=find(ConsSpeIndx==PrCons.Index);                                       % spectrum Index that Primary Cons uses them in his cell 
    SpecNo=ConsBS(PrCons.CellNo(1),PrCons.CellNo(2)).M(SpecIndx);                   % spectrum number that Primary Cons uses them in his cell
    I(M)=0;
    RBW=0;
    SecConsNo=length(SecCons);
    
    for i=1: SecConsNo
        for m=1:length(SpecNo)
                if SecCons(i).BS.Cons(SpecNo(m)+OneorSec)==i 
                        X1 = ConsBS(PrCons.CellNo(1),PrCons.CellNo(2)).X + PrCons.XLoc;   % X1 and Y1 are the location of consumer;
                        X2 = SecCons(i).BS.X;
                        Y1 = ConsBS(PrCons.CellNo(1),PrCons.CellNo(2)).Y + PrCons.YLoc;   % X2 and Y2 are the location of Base Station that has interference with Consumer;
                        Y2 = SecCons(i).BS.Y;
                        d2BS = ((X2-X1)^2+(Y2-Y1)^2)^ 0.5;
                        PG_two_ray=Pt*Gt*Gr*ht^2*hr^2*(1./d2BS).^4;
                        I(SpecNo(m)) = I(SpecNo(m)) + PG_two_ray;                   % 'I' will save the Interferance in each spectrum in the first cluster
                end
        end
    end
    
    for m=1:length(SpecNo)
        SIR = S/(I(SpecNo(m)) + N);
        RBW = RBW + UBndwPChanel * log(1 + SIR)/log(2);                             % Real bandwidth for each user in different spectrums         
    end
end
