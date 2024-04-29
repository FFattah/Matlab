% clc; 
% close all;
% clear all;
%This program is for pricing in cognitive radio
%By Zahra Fattah


function [I,RBW]=CalcRBW(Cons,ConsBS, ItfBS,ItfConsNo,M,UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr)
    
    SecConsNo=length(Cons);
    S(SecConsNo)=0;
    I(ItfConsNo,M)=0;
    RBW(ItfConsNo,M)=0;

    for k=1 : ItfConsNo
        d2BS = ((ConsBS(k).X)^2+(ConsBS(k).Y)^2)^ 0.5;
        S(k) = Gt*Gr*ht^2*hr^2*(1./d2BS).^4;                                % signal power for the Sec consumer;            
        [I(k,:),RBW(k)]=CalcIntrFrnc(Cons(k),ConsBS, ItfBS,M,S(k),UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr); %  
    end
