% clc; 
% close all;
% clear all;
%This program is for pricing in cognitive radio
%By Zahra Fattah

function [AvgBnft1,AvgBnft2,AvgPenalty1,AvgPenalty2,SecCons,SecBS]=Price(Itratn, SPrc, SecCons, SecBS,Cons1,PrBS1 ,Cons2 ,PrBS2 ,IPoS,RBWS ,PPrice ,PReqBW ,SecReqBW ,SecMinPrice,MaxSpcNo ,M,OneorSec ,UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub)

    w1=1;
    w2=10;
    tag=0;
    SecConsNo=length(SecCons);
    PriceP1(Itratn,SecConsNo)=0;
    PriceP2(Itratn,SecConsNo)=0;
    Penalty1(Itratn,length(Cons1))=0;
    Penalty2(Itratn,length(Cons2))=0;
    S(SecConsNo)=0;
    ISoS(SecConsNo,M)=0;
    [SRows,SCols]=size(SecBS);
    Bnft1(Itratn)=0;
    Bnft2(Itratn)=0;
    SelectedSP{SecConsNo}=0;
    d2BS(SecConsNo)=0;
    S(SecConsNo)=0;
       
    s = cell(M, SecConsNo);
    for i = 1:M
        for j = 1:SecConsNo
            s{i,j} = sprintf('s%d%d',i,j);
        end
    end
    
    %Optimization parameters
%       Itr=1;  
     for Itr=1:Itratn
        PriceP1(Itratn,SecConsNo)=0;
        PriceP2(Itratn,SecConsNo)=0;
        Penalty1(Itratn)=0;
        Penalty2(Itratn)=0;
        intcon = (1:M);
        lb = zeros(M,1);
        ub = ones(1,M);
        SelectedSP{SecConsNo}=0;

        for i=1: SecConsNo 
            SecCons(i).BS.Cons(:)=0;
            d2BS(i) = ((SecCons(i).XLoc)^2+(SecCons(i).YLoc)^2)^ 0.5;
            S(i) = Gt*Gr*ht^2*hr^2*(1./d2BS(i)).^4;                                % signal power for the Sec consumer;            
        end
        for i=1: SecConsNo 
            %This V function should be maximized. 
%           V = @(s) w1*( RBW(i,1:M)*(s(1:M,i)) - ReqBW(SecCons(i).class)  ) + w2*(ReqPrice(SecCons(i).class) - (SPrc(1:M)*s(1:M,i)) );
            f = -1 *(w1* RBWS(i,1:M))-(w2*SPrc(1:M));
            A = [-1* RBWS(i,1:M); SPrc(1:M);-1* ones(1,M);ones(1,M)];
            b = [-1* SecReqBW(SecCons(i).class);PPrice(SecCons(i).class);-1;MaxSpcNo];
%             options = optimoptions('intlinprog','MaxTime',10, 'Display','iter');
            options = optimoptions('intlinprog', 'Display','iter');
            s = intlinprog(f,intcon,A,b,[],[],lb,ub,options);
            SelectedSP{i}=find(s);
            % for calculating Interference:
            SecCons(i).BS.Cons(SelectedSP{i}) = i;                                              % allocate spectrum to this user
            SecBS(SecCons(i).CellNo(1),SecCons(i).CellNo(2)).Cons(SelectedSP{i}) = i;           % allocate spectrum to this Cell
            %
            SecCons(i).BW=sum(RBWS(i,SelectedSP{i}));
            SecCons(i).Price=sum(SPrc(SelectedSP{i}));
            
            if ~isempty(SelectedSP{i})
                for m=1:length(SelectedSP{i})
                    if SelectedSP{i}(m)< (M/2)
                        PriceP1(Itr,i)=PriceP1(Itr,i)+SPrc(SelectedSP{i}(m));
                    else
                        PriceP2(Itr,i)=PriceP2(Itr,i)+SPrc(SelectedSP{i}(m));
                    end
                end
            end 
            
            
            ConsSpeIndx=SecBS(SecCons(i).CellNo(1),SecCons(i).CellNo(2)).Cons;                            
            SpecIndx=find(ConsSpeIndx==SecCons(i).Index);                         % spectrum Index that Cons uses them in his cell 
            SpecNo=SecBS(SecCons(i).CellNo(1),SecCons(i).CellNo(2)).M(SpecIndx);  % spectrum number that Cons uses them in his cell

         
            for j=i: SecConsNo
                % Calculate effect of Sec Users on each other and recalculate RBW
                [ISoS(j,:),RBWSS(j)]=CalcIntrFrncSecOnSec(SecCons(j),SecBS,SecCons,SecBS,M,S(j),UBndwPChanel,N,tag, Pt,Gt,Gr,ht,hr); %
                for m=1:M
                    if SecCons(i).BS.Cons(m)==i 
                        SIR = S(j)/(IPoS(j,m)+ ISoS(j,m)+ N);
                        RBWS(j,m) = UBndwPChanel * log(1 + SIR)/log(2);                    % Real bandwidth for each user in different spectrums         
                    end
                end              
            end
        
        end
        SecBSP1=SecBS;
        SecBSP2=SecBS;
        for i=1:SRows
            for j=1:SCols
                for m=1:M/2
                   SecBSP1(i,j).M(m+M/2)=0; 
                   SecBSP2(i,j).M(m)=0; 
                end
            end
        end    

        [RBWPric1(Itr,:),IIPric1,Penalty1(Itr,:)]=NegSecOnPri(SecCons ,SecBSP1 ,Cons1 ,PrBS1 ,M,OneorSec ,PReqBW, UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub);
        OneorSec=M/2;
        [RBWPric2(Itr,:),IIPric2,Penalty2(Itr,:)]=NegSecOnPri(SecCons ,SecBSP2 ,Cons2 ,PrBS2 ,M,OneorSec ,PReqBW, UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub);
        OneorSec=0;
                
        Bnft1(Itr)= sum(PriceP1(Itr,:))-sum(Penalty1(Itr,:));
        Bnft2(Itr)= sum(PriceP2(Itr,:))-sum(Penalty2(Itr,:));       
        
    end
    AvgBnft1=sum(Bnft1)/Itratn;
    AvgBnft2=sum(Bnft2)/Itratn;
    AvgPenalty1=sum(Penalty1)/Itratn;
    AvgPenalty2=sum(Penalty2)/Itratn;
    
    
end
    
    
    
    
    
   