% clc; 
% close all;
% clear all;
%This subprogram presents a pricing method for cognitive radio
%By Zahra Fattah

% input parameters:
% SecCons           %Cons es that couse penalty on Primary ones
% PrCons            %Primary consumer wich sense decrementatin of BW and shouhd recieve penaltye

%Calculate negative effect of secondary consumers on primary ones to pay penalty
function [RBW,II,Penalty]=NegSecOnPri(SecCons ,SecBS ,PrCons , PrBS,M,OneorSec,ReqBW, UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub)
    RBW(length(PrCons))=0;
    S(length(PrCons))=0;
    IfPr(length(PrCons),M)=0;
    IfSec(length(PrCons),M)=0;
    for k=1: length(PrCons) 
        d2BS = ((PrCons(k).XLoc)^2+(PrCons(k).YLoc)^2)^ 0.5;
        S(k) = Pt*Gt*Gr*ht^2*hr^2*(1./d2BS).^4;                            % signal power for the consumer in this spectrum;
        tag=0;
        [IfPr(k,:),nvld(k)]=CalcIntrFrnc(PrCons(k),PrBS, PrBS,M,0,S(k),UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr); %
        [IfSec(k,:),nvld(k)]=CalcIntrFrncSecOnPri(PrCons(k),PrBS, SecBS,SecCons,M,OneorSec,S(k),UBndwPChanel,N, Pt,Gt,Gr,ht,hr); %
        II=IfSec+IfPr;
        
        ConsSpeIndx=PrBS(PrCons(k).CellNo(1),PrCons(k).CellNo(2)).Cons;                            
        SpecIndx=find(ConsSpeIndx==PrCons(k).Index);                       % spectrum Index that Cons uses them in his cell 
        SpecNo=PrBS(PrCons(k).CellNo(1),PrCons(k).CellNo(2)).M(SpecIndx);  % spectrum number that Cons uses them in his cell

        for m=1:length(SpecNo)
%             SIR = S(k)/(II(k,SpecNo(m)+OneorSec) + N);
            SIR = S(k)/(II(k,SpecNo(m)) + N);
            RBW(k) =  RBW(k) + UBndwPChanel * log(1 + SIR)/log(2);                      % Real bandwidth for each user in different spectrums         
        end
    end
    
    Penalty(length(PrCons))=0;
    for k=1: length(PrCons)
        if (RBW(k)/(ReqBW(PrCons(k).class))) > Ub
            Penalty(k)=0;
        else
            if (RBW(k)/(ReqBW(PrCons(k).class))) < Ub && (RBW(k)/(ReqBW(PrCons(k).class)))> Lb
%                 Penalty(k)=(-PrCons(k).Price/0.6)*(RBW(k)/(ReqBW(PrCons(k).class))) +PrCons(k).Price - 0.2;
                Penalty(k)=PrCons(k).Price*(RBW(k)/(ReqBW(PrCons(k).class)));
            else
                if (RBW(k)/(ReqBW(PrCons(k).class))) < Lb
                    Penalty(k)=PrCons(k).Price;
                end
            end
        end
     end

end