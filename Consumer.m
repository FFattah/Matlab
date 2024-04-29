% clc; 
% close all;
% clear all;
%This subprogram presents a pricing method for cognitive radio
%By Zahra Fattah


function [Bnft1,Bnft2,Penalty1,Penalty2,Cons1, PrBS1,Cons2, PrBS2,SecCons, SecBS,IPoS, RBWS]=Consumer (Gt,Gr,L,ht,hr,Pt,N,ReUsFct,Rows,Cols,Spectrm,M,MaxConsPCell,PReqBW,PPrice,Radius,MaxSecConsNo,MaxSpcNo,SecReqBW,SecMinPrice,IncPric,DecPric,Itratn,Lb,Ub)


    UBndwPChanel=Spectrm*1000/M;            %evailable bandwidth in each channel without Interference and signal and Noise Power
    

    OneorSec=0;
    [Cons1, PrBS1]=PrimaryConsumer(ReUsFct,Rows,Cols,Spectrm,M,OneorSec,MaxConsPCell,PReqBW,PPrice,Radius, N, Pt,Gt,Gr,ht,hr);
    [Cons2, PrBS2]=PrimaryConsumer(ReUsFct,Rows,Cols,Spectrm,M,OneorSec,MaxConsPCell,PReqBW,PPrice,Radius, N, Pt,Gt,Gr,ht,hr);
    OneorSec=0;

    SecSpectrm= Spectrm*2;
    SecM= M*2;                              %It is assumed that tow primary provderrs have continious spectrums
    [SecCons, SecBS,IPoS, RBWS]=SecondaryConsumer(PrBS1,PrBS2,Rows,Cols,SecSpectrm,SecM,OneorSec,MaxSecConsNo,Radius, N, Pt,Gt,Gr,ht,hr);
   


                                            %Uper bound of ratio betweeen requested BW and earned BW of primary users to penalty primery provider
    [Bnft1,Bnft2,Penalty1,Penalty2,SecCons,SecBS]=Learn(Itratn ,SecCons, SecBS,Cons1,PrBS1 ,Cons2 ,PrBS2 ,IPoS,RBWS ,IncPric ,DecPric ,PPrice ,PReqBW ,SecReqBW ,SecMinPrice,MaxSpcNo ,M,OneorSec ,UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub)
    
    
end
