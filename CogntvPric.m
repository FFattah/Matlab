% clc; 
% close all;
% clear all;
%This subprogram presents a pricing method for cognitive radio
%By Zahra Fattah


function CogntvPric(  )     

% tworay ground Parameters
     Gt=1;
     Gr=1;
     L=1;
     ht=30;
     hr=1;
     Pt=20;
     N=0.000000001;

    
    ReUsFct=3;                              %Reuse factor
    Rows=3;
    Cols=3;    
    Spectrm=90;                             %totally Spectrum available for each Provider that should be devided per cells by MbPSec
    M=90;                                   %Number of channels in each 3 cells
    MaxConsPCell=15;
    PReqBW=[1000,3000,5000];                %Requested Bandwidth for each class of primary Consumers by KbpSec
    PPrice=[1000,2000,3000];                %Price for each class of Primary Consumers
    Radius=700;                             %Radius of each Cell
    
    MaxSecConsNo=15;                        %Maximumm number of all secondary consumers
    MaxSpcNo=10;                            % maximum number of specrums each secondary consumer could allocate it
    SecReqBW=[1000];              %Requested Bandwidth for each class of Secondary Consumers by KbpSec
    SecMinPrice=[300];             %Price for each class of Primary Consumers
    
    IncPric=50;
    DecPric =50;
    Itratn=5;
    Lb=0.2;                                 %Lower bound of ratio betweeen requested BW and earned BW of primary users to penalty primery provider
    Ub=0.8; 
    
    
    
%     [Bnft1,Bnft2,Penalty1,Penalty2,Cons1, PrBS1,Cons2, PrBS2,SecCons, SecBS,IPoS, RBWS]=Consumer (Gt,Gr,L,ht,hr,Pt,N,ReUsFct,Rows,Cols,Spectrm,M,MaxConsPCell,PReqBW,PPrice,Radius,MaxSecConsNo,MaxSpcNo,SecReqBW,SecMinPrice,IncPric,DecPric,Itratn,Lb,Ub);
%     save('Def.mat');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Graphs
%     SecConsNo=length(SecCons);
%     for i=1: SecConsNo 
%         
%     end

%     
%     % not empty secondary users
%     figure(2);
%     x = [1 2];
%     ConsSrvc = [SecConsNo SecConsNo]; 
%     w1 = 0.5; 
%     bar(x,ConsSrvc,w1,'FaceColor',[0.2 0.2 0.5])    
%     ConsEmpty = [NotEmptySU NotEmptySU]; 
%     w2 = .25;
%     hold on
%     bar(x,ConsEmpty,w2,'FaceColor',[0 0.7 0.7])
%     hold off
%     
%     %number of secondary consumers in each Cell
%     figure(3);
%     [ItfRows,ItfCols]=size(SecBS);
%     ConsPC(ItfRows,ItfCols)=0;
%     for i=1: SecConsNo
%         ConsPC(SecCons(i).CellNo(1),SecCons(i).CellNo(2))=ConsPC(SecCons(i).CellNo(1),SecCons(i).CellNo(2))+1;      
%     end
%     B = reshape(ConsPC,[1,ItfRows*ItfCols]);
%     hold off
%     bar(B);
%     
    
    
    %Profit per Primary consumer number       
%     for MaxConsPCell=15:20
%         [Bnft1,Bnft2,Penalty1,Penalty2,Cons1, PrBS1,Cons2, PrBS2,SecCons, SecBS,IPoS, RBWS]=Consumer (Gt,Gr,L,ht,hr,Pt,N,ReUsFct,Rows,Cols,Spectrm,M,MaxConsPCell,PReqBW,PPrice,Radius,MaxSecConsNo,MaxSpcNo,SecReqBW,SecMinPrice,IncPric,DecPric,Itratn,Lb,Ub);
%         save(['BnftPerPriUsr_' num2str(MaxConsPCell) '.mat']);
%     end
%     MaxConsPCell=5;
%     
%     %Profit per Secondary consumer number    
%     for MaxSecConsNo=15:10:65
%        [Bnft1,Bnft2,Penalty1,Penalty2,Cons1, PrBS1,Cons2, PrBS2,SecCons, SecBS,IPoS, RBWS]=Consumer (Gt,Gr,L,ht,hr,Pt,N,ReUsFct,Rows,Cols,Spectrm,M,MaxConsPCell,PReqBW,PPrice,Radius,MaxSecConsNo,MaxSpcNo,SecReqBW,SecMinPrice,IncPric,DecPric,Itratn,Lb,Ub);
%         save(['BnftPerSecUsr_' num2str(MaxSecConsNo) '.mat']);
%     end
%     MaxSecConsNo=15;
% 
%     %Profit per different primary Prices    
    PPrices(10,3)=0;
    for i=110:100:1000
       PPrices(i/10,:)=[1000+i,2000+i,3000+i] ;
    end
    for i=11:10:100
        [Bnft1,Bnft2,Cons1, PrBS1,Cons2, PrBS2,SecCons, SecBS,IPoS, RBWS]=Consumer (Gt,Gr,L,ht,hr,Pt,N,ReUsFct,Rows,Cols,Spectrm,M,MaxConsPCell,PReqBW,PPrices(i,:),Radius,MaxSecConsNo,MaxSpcNo,SecReqBW,SecMinPrice,IncPric,DecPric,Itratn,Lb,Ub);
        save(['BnftPerPrice_' num2str(PPrices(i,:)) '.mat']');
    end
    
    
    
    %Profit per different Secondary Spectrum Output    
%     PPrices(10,3)=0;
%     for i=10:100:1000
%        PPrices(i/10,:)=[1000+i,2000+i,3000+i] ;
%     end
%     for i=1:10
%         [Bnft1,Bnft2,Penalty1,Penalty2,Cons1, PrBS1,Covns2, PrBS2,SecCons, SecBS,IPoS, RBWS]=Consumer (Gt,Gr,L,ht,hr,Pt,N,ReUsFct,Rows,Cols,Spectrm,M,MaxConsPCell,PReqBW,PPrices(i,:),Radius,MaxSecConsNo,MaxSpcNo,SecReqBW,SecMinPrice,IncPric,DecPric,Itratn,Lb,Ub);
%         save(['BnftPerPriUsr_' num2str(PPrices(i,:)) '.mat']);
%     end
 
    
    
    
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end
