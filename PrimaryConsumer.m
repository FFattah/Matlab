% clc; 
% close all;
% clear all;
%This subprogram presents a pricing method for cognitive radio
%By Zahra Fattah

% input parameters:
% ReUsFct              %Reuse factor
% Rows&Cols            %Rows*Cols will show number of cells
% Spectrm              %totally Spectrum available for each Provider that should be devided per cells by MbPSec
% M                    %Number of channels in each 3 cells
% MaxConsPCell         %Spectrm*1000/BRReqPCons*ReUsFct;
% ReqBW                %Requested Bandwidth for each class of primary Consumers by KbpSec
% Radius               %Radius of each Cell


function [Cons, PrBS]=PrimaryConsumer(ReUsFct,Rows,Cols,Spectrm,M,OneorSec,MaxConsPCell,ReqBW,PPrice,Radius, N, Pt,Gt,Gr,ht,hr,L)   
     
    UBndwPChanel=Spectrm*1000/M;            %evailable bandwidth in each channel without Interference and signal and Noise Power

    MaxPrConsNo=MaxConsPCell*Rows*Cols;     %Maximumm number of all primary consumers
%     PrConsNo=randi(MaxPrConsNo);            %number of primary consumers 
    PrConsNo=MaxPrConsNo;                   %number of primary consumers 
    
    PrBS=BS(Rows,Cols,Radius);
  
    
% Distribute M spectrums in ReUsFct(3) Cells:
    for i=1: Rows
        for j=1:Cols
            for k=1:M/ReUsFct
                    PrBS(i,j).M(k)=(M/ReUsFct)*(PrBS(i,j).RusCell-1)+k;     %currently unused spectrum;
                    PrBS(i,j).Cons(k)=0;                                    %currently unused spectrum;
            end
        end
    end
    
% produce PrconsN Consumr and assign Cell, Class and distance of each Consumr 
    Cons=struct;    
    for i=1 : PrConsNo
            Cons(i).Index=i;
            Cons(i).class=randi(3);
            x=randi(Rows);
            y=randi(Cols);
            Cons(i).BS=PrBS(x,y);               
            Cons(i).CellNo=[x,y];          
            Cons(i).XLoc=randi([-Radius,Radius],1);             %a random location for x position of user i
            Cons(i).YLoc=randi([-Radius,Radius],1);             %a random location for y position of user i
            Cons(i).BW=0;                                       %should be calculated. 
            Cons(i).Price=PPrice(Cons(i).class);                                    %should be calculated.   
    end
    
% assign requested spectrum to each Consumer
    for i=1 : PrConsNo
        while Cons(i).BW < ReqBW(Cons(i).class)
            if length(find(PrBS(Cons(i).CellNo(1),Cons(i).CellNo(2)).Cons)) ~=  (M/ReUsFct)
                x = randi (M/ReUsFct);
%               if Cons(i).BS.Cons(x) == 0                                    % check if the cell number of randomly generated M is the same as consumer cell number and it isn't occupied:
                if PrBS(Cons(i).CellNo(1),Cons(i).CellNo(2)).Cons(x) == 0       % check if the cell number of randomly generated M is the same as consumer cell number and it isn't occupied:
                    Cons(i).BS.Cons(x) = i;                                         % allocate spectrum to this user
                    PrBS(Cons(i).CellNo(1),Cons(i).CellNo(2)).Cons(x) = i;          % allocate spectrum to this Cell
                    d2BS = ((Cons(i).XLoc)^2+(Cons(i).YLoc)^2)^ 0.5;
                    S(i) = Pt*Gt*Gr*ht^2*hr^2*(1./d2BS).^4;                         % signal power for the consumer in this spectrum;
                    SIR = S(i)/N;
                    BndwPChanel(i) = UBndwPChanel * log(1 + SIR)/log(2);
                    Cons(i).BW=Cons(i).BW + BndwPChanel(i);                         % sum up bandwidth of diferent spectrums allocated to user i with out calculating interferense
                end
            else
                fprintf('not available bandwitdth');
                break;
            end    
        end
    end
    
    

% calculating Interferences for each consumer and increase avaliable bandwidth if needed
    tag=0;
    for k=1 : PrConsNo
        [I(k,:),RBW(k)]=CalcIntrFrnc(Cons(k),PrBS, PrBS,M,OneorSec,S(k),UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr); %
        Cons(k).BW=RBW(k);
        while Cons(k).BW < ReqBW(Cons(k).class)
            if length(find(PrBS(Cons(k).CellNo(1),Cons(k).CellNo(2)).Cons)) ~=  (M/ReUsFct)
                x = randi (M/ReUsFct);
                if PrBS(Cons(k).CellNo(1),Cons(k).CellNo(2)).Cons(x) == 0   % check if the cell number of randomly generated M is the same as consumer cell number and it isn't occupied:
                    PrBS(Cons(k).CellNo(1),Cons(k).CellNo(2)).Cons(x) = k;  % allocate thi spectrum to this user
                    Cons(k).BS.Cons(x) = k;                                 % allocate spectrum to this user
                    Cons(k).BW=Cons(k).BW + BndwPChanel(k);
                end
            else
                fprintf('not available bandwitdth\n');
                break;
            end
        end    
    end
    bb=1;



    
    
    

    
 
 
    
    
    