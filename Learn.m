function [AvgBnft1,AvgBnft2,AvgPenalty1,AvgPenalty2,SecCons,SecBS]=Learn(Itratn ,SecCons, SecBS,Cons1,PrBS1 ,Cons2 ,PrBS2 ,IPoS,RBWS ,IncPric ,DecPric ,PPrice ,PReqBW ,SecReqBW ,SecMinPrice,MaxSpcNo ,M,OneorSec ,UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub)

    a=0.01;
    b=0.01;
    SPrc(2*M)=0;
    % Initial Price of each Spectrum for Secondary consumers for both provider 1 and 2
    for m=1:2*M
%         SPrc(m)=randi([SecMinPrice(1),PPrice(1)]/10);
%         SPrc(m)=((PPrice(1)/10)+(SecMinPrice(1)/10))/2;
        SPrc(m)=(SecMinPrice(1)/10);
    end
    % Let Secondary consumers select spectrums base this initial price and
    % calculate Total benefit of provider 1 & 2
    [PureBnft1,PureBnft2,AvgPenalty1,AvgPenalty2,SecCons,SecBS]=Price(Itratn,SPrc, SecCons, SecBS,Cons1,PrBS1 ,Cons2 ,PrBS2 ,IPoS,RBWS ,PPrice ,PReqBW ,SecReqBW ,SecMinPrice,MaxSpcNo ,2*M,OneorSec ,UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub);

    Prob1(2*M)=0;
    SumPrb1(2*M)=0;
    Prob1(1)=1/(2*M+1);
    SumPrb1(1)=Prob1(1);
    for m=2:2*M
        Prob1(m)=1/(2*M+1);
        SumPrb1(m)=SumPrb1(m-1)+Prob1(m);
    end
    Prob2(2*M)=0;
    SumPrb2(2*M)=0;
    Prob2(1)=2/(2*M+1);
    SumPrb2(1)=Prob2(1);
    for m=2:2*M
        Prob2(m)=1/(2*M+1);
        SumPrb2(m)=SumPrb2(m-1)+Prob2(m);
    end
       
    
    %Optimization parameters
    AvgBnft1(M)=0;
    AvgBnft2(M)=0;
    i=1;
%     while(true)
    while(i<1000)
        % generate random number x1 to determine wich cell price should change
        x1=rand();
        % LearnCell1 will be the nearest index of SumPrb1 to x1 wich is from 1:2M
        [val1,LearnCel1(i)]=min(abs(SumPrb1-x1));
        if LearnCel1(i) <= M
            if (SPrc(LearnCel1(i))+IncPric) < (PPrice(1)/10)
                SPrc(LearnCel1(i))=SPrc(LearnCel1(i))+IncPric;
            end
        else
            if (SPrc(LearnCel1(i)-M)-DecPric) > (SecMinPrice(1)/10)
                SPrc(LearnCel1(i)-M)=SPrc(LearnCel1(i)-M)-DecPric;
            end    
        end
        % LearnCel2 will be the nearest index of SumPrb2 to x2 wich is from 1:2M
        x2=rand();
        [val1,LearnCel2(i)]=min(abs(SumPrb2-x2));
        if LearnCel2(i) <= M
            if (SPrc(M+LearnCel2(i))+IncPric) < (PPrice(1)/10)
                SPrc(M+LearnCel2(i))=SPrc(M+LearnCel2(i))+IncPric;
            end
        else
            if (SPrc(LearnCel2(i))-DecPric) > (SecMinPrice(1)/10)
                SPrc(LearnCel2(i))=SPrc(LearnCel2(i))-DecPric;
            end    
        end
       % Let Secondary consumers select spectrums base on change cell and
       % calculate Total benefit of provider 1 & 2
     
        [AvgBnft1(LearnCel1(i)),AvgBnft2(LearnCel2(i)),AvgPenalty1,AvgPenalty2,SecCons,SecBS]=Price(Itratn,SPrc, SecCons, SecBS,Cons1,PrBS1 ,Cons2 ,PrBS2 ,IPoS,RBWS ,PPrice ,PReqBW ,SecReqBW ,SecMinPrice,MaxSpcNo ,2*M,OneorSec ,UBndwPChanel, N, Pt,Gt,Gr,ht,hr,Lb,Ub);

        % AvgBnft1(LearnCel1) will save total benefit of Provider1 when
        % LearnCel1 price is changed.
        if  AvgBnft1(LearnCel1(i))>=PureBnft1
            for m=1:2*M
                if m==LearnCel1(i)
                    Prob1(m)=Prob1(m)+a*(1-Prob1(m));
                else
                    Prob1(m)=(1-a)*Prob1(m);
                end
            end    
        else
             for m=1:2*M
                if m==LearnCel1(i)
                    if Prob1(m)-b*(1-Prob1(m))> 0
                        Prob1(m)=Prob1(m)-b*(1-Prob1(m));
                    end
                else
                    Prob1(m)=Prob1(m)*(1+b);
                end
            end    
        end    
        if  AvgBnft2(LearnCel2(i))>=PureBnft2
            for m=1:2*M
                if m==LearnCel2(i)
                    Prob2(m)=Prob2(m)+a*(1-Prob2(m));
                else
                    Prob2(m)=(1-a)*Prob2(m);
                end
            end    
        else
             for m=1:2*M
                if m==LearnCel2(i) 
                    if Prob2(m)-b*(1-Prob2(m))> 0
                        Prob2(m)=Prob2(m)-b*(1-Prob2(m));
                    end
                else
                    Prob2(m)=Prob2(m)*(1+b);
                end
            end    
        end  
        % recalculate probability of selection of other spectrums base on
        % selected spectrum LearnCel
        for m=2:2*M
            SumPrb1(m)=SumPrb1(m-1)+Prob1(m);
            SumPrb2(m)=SumPrb2(m-1)+Prob2(m);
        end
        
        %Graphs
%         figure(1);
%         plot(i, AvgBnft1(LearnCel1(i)),'b*',i, AvgBnft2(LearnCel2(i)),'r*')
%         hold on
%         
%         figure(2);
%         plot(i, sum(AvgPenalty1(:)),'b*',i, sum(AvgPenalty2(:)),'r*')
%         hold on

%         plot(i, AvgBnft1(LearnCel1(i)),'b*',i, AvgBnft2(LearnCel2(i)),'r*')
%         hold on

        i=i+1;        
    end
end


