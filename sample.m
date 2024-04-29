
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

    load('BnftPerSecUsr_15.mat');
    SecConsNo=length(SecCons);

    %%%%%%%%%%%% number of secondary consumers in each Cell
    figure('Name','SecConsNo','NumberTitle','off');
    [ItfRows,ItfCols]=size(SecBS);
    ConsPC(ItfRows,ItfCols)=0;
    for i=1: SecConsNo
        ConsPC(SecCons(i).CellNo(1),SecCons(i).CellNo(2))=ConsPC(SecCons(i).CellNo(1),SecCons(i).CellNo(2))+1;      
    end
    B = reshape(ConsPC,[1,ItfRows*ItfCols]);
    hold off
    bar(B);
    xlabel('Cell Number') % x-axis label
    ylabel('Number of Secondaries') % y-axis label
    title('Number of Secondary Users in each Cell')

    %%%%%%%%%   Profit    %%%%%%%%%%%%%%
    %Base on  diff  primary
    i=0;j=5;
    Bnft(1:10)=0;
    Pnlty(1:10)=0;
    NoPnlty(1:10)=0;
    Pri(1:10)=0;
    NotEmptySU(1:10)=0;
    for i=15:20
        load(['BnftPerPriUsr_' num2str(i) '.mat']);
        Bnft(j)=sum(Bnft1(:))+sum(Bnft2(:));
        Pnlty(j)=sum(Penalty1(:))+sum(Penalty2(:));
        PriConsNo=length(Cons1)+length(Cons2);
        Pri(j)=length(Cons1)+length(Cons2);
        NoPnlty(j)=nnz(Penalty1)+nnz(Penalty2);
        SecConsNo(j)=length(SecCons);
        for m=1:SecConsNo(j)
            if nnz(SecCons(m).BS.Cons) == 0
                    NotEmptySU(j)=NotEmptySU(j)+1;
            end
        end
    j=j+1;
    end

        
    
    figure('Name','Bnft','NumberTitle','off');
    hold off
    bar(Bnft);
    xlabel('Number of Primary consumers in each Cell') % x-axis label
    ylabel('Total Benefit of system') % y-axis label
    title('Total Benefit of system base on Primary consumer Numbers in each cell')
     
    
    %%%%%%%%%   sum of Penalty    %%%%%%%%%%%%%
    figure('Name','Pnlty','NumberTitle','off');
    hold off
    bar(Pnlty);
    xlabel('Number of Primary consumers in each Cell') % x-axis label
    ylabel('Total Penalty of system') % y-axis label
    title('Total Penalty Paied to Primary Consumers base on Primary consumer Numbers in each cell')
    
    
    %%%%%%%%%   Number of Perimery Penalties    %%%%%%%%%%%%%%
    figure('Name','NoPnlty','NumberTitle','off');
    x = (1:10);
    ConsSrvc = [SecConsNo SecConsNo]; 
    w1 = 0.5; 
    bar(x,Pri,w1,'FaceColor',[0.2 0.2 0.5])
    w2 = .25;
    hold on
    bar(x, NoPnlty,w2,'FaceColor',[0 0.7 0.7])
    hold off
    xlabel('Number of Primary consumers in each Cell') % x-axis label
    ylabel('Total Number of Primary Consumers recived Penalty') % y-axis label
    title('Number of Primary Consumers recived Penalty base on Primary consumer Numbers in each cell')



    %%%%%%%%%%%% not empty secondary users %%%%%%%%%%%%%%%%%%%
    figure('Name','NotEmptySU','NumberTitle','off');
   
    x = [1 2];
    ConsSrvc = [SecConsNo SecConsNo]; 
    w1 = 0.5; 
    bar(x,ConsSrvc,w1,'FaceColor',[0.2 0.2 0.5])
    for i=1:SecConsNo
        if nnz(SecCons(i).BS.Cons) == 0
           NotEmptySU(j)=NotEmptySU(j)+1;
        end
    end
    ConsEmpty = [NotEmptySU NotEmptySU]; 

    w2 = .25;
    hold on
    bar(x,ConsEmpty,w2,'FaceColor',[0 0.7 0.7])
    ylabel('Number of Secondaries') % y-axis label
    title('Number of UnServiced Secondary Users Vs. all Secondaries')

    hold off
  
    
    
   
