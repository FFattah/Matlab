PrconN=40;
M=10;
 temp=1:PrconN;
 temp=randperm(PrconN);
 gap=PrconN/M;
 for i=1:M-1
     A(i).count=temp(i*gap);
 end
 b=diff(sort([A.count])); 
 b(M)= PrconN-sum(b);
 A().count=b;
 A.count