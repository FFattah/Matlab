% clc; 
% close all;
% clear all;
%This subprogram presents a pricing method for cognitive radio
%By Zahra Fattah


function [SecCons, SecBS,I, RBW]=SecondaryConsumer(PrBS1 ,PrBS2,Rows,Cols,Spectrm,M,OneorSec,MaxSecConsNo,Radius, N, Pt,Gt,Gr,ht,hr,L)


%     SecConsNo=randi(MaxSecConsNo);                                          %number of secondary consumers
    SecConsNo=MaxSecConsNo;                                                 %number of secondary consumers
    UBndwPChanel=Spectrm*1000/M;                                            %evailable bandwidth in each channel without Interference and signal and Noise Power

    SecBS=BS(Rows,Cols,Radius);
    
    
    % Spectrum of each Primary Bs is between 1 to M, but for secondary
    % one, this value is from 1 t0 2M
    for i=1: Rows
        for j=1:Cols
            for k=1:M
                    SecBS(i,j).M(k)=k;                                       %currently unused spectrum;
                    SecBS(i,j).Cons(k)=0;                                    %currently unused spectrum;
            end
        end
    end

    
    % produce PrconsN Consumr and assign Cell, Class and distance of each Consumr    
    SecCons=struct;    
    for i=1: SecConsNo         
        SecCons(i).Index=i;   
%         SecCons(i).class=randi(3);   
        SecCons(i).class=1;   
        x=randi(Rows);
        y=randi(Cols);
        SecCons(i).BS=SecBS(x,y);   
        SecCons(i).CellNo=[x,y];          
        SecCons(i).XLoc=randi([-Radius,Radius],1);                          %a random location for x position of user i
        SecCons(i).YLoc=randi([-Radius,Radius],1);                          %a random location for y position of user i
        SecCons(i).BW=0;                                                    %should be calculated.   
        SecCons(i).Price=0;                                                 %should be calculated. 
      
     end


    % Calculate real bandwidth for each SecCostumer for each Spectrum to
    % pass to simulannealbnd Function 
    % be noted that only Interference with primary consumers are 
    % calculated, not other secondary consumers
    S(SecConsNo)=0;
    I(SecConsNo,M)=0;
    RBW(SecConsNo,M)=0;
    tag=1;

    for k=1 : SecConsNo
        d2BS = ((SecCons(k).XLoc)^2+(SecCons(k).YLoc)^2)^ 0.5;
        S(k) = Gt*Gr*ht^2*hr^2*(1./d2BS).^4;                                % signal power for the Sec consumer;            
            
        for m=1:M
            SecBS(SecCons(k).CellNo(1),SecCons(k).CellNo(2)).Cons(m) = k;   
        end        
        [I(k,:),nvld(k)]=CalcIntrFrnc(SecCons(k),SecBS, PrBS1,M,OneorSec,S(k),UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr); %             
        [I2(k,:),nvld(k)]=CalcIntrFrnc(SecCons(k),SecBS, PrBS2,M,OneorSec,S(k),UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr); %
        I(k,[(M/2)+1:M])=I2(k,[1:M/2]);
            
        for m=1:M
            SIR = S(k)/(I(k,m) + N);                   
            RBW(k,m) =  UBndwPChanel * log(1 + SIR)/log(2);                 % Real bandwidth for each SecCons in each Spectrum          
        end
        for m=1:M
            SecBS(SecCons(k).CellNo(1),SecCons(k).CellNo(2)).Cons(m) = 0;   %Clear temporary assighnment of all spectrums to each sec Consumer to calculate it's real BW
        end        

    end
 
 
end