% create CellNo BS and set them in locations with even-q vertical layout
function BS=BS(Col,Row,Radius)


    W=2*Radius;                             % The horizontal distance between each two hexagon's center is 3/4W
    H=sqrt(3)*Radius;                       % The vertical distance between each two hexagon's center is H

%     for i=1:Row+1
%         BS(i,1).X= 0.5*W + 0.75*(i-1)*W;
%         if mod(i,2)==0
%             BS(i,1).Y= 0.5*H;     
%             BS(i,1).RusCell= 1;
%         else
%             BS(i,1).Y= 1*H;
%             BS(i,1).RusCell= 3;
%        end
%     end
    for i=1:Col
        BS(1,i).X= 0.75*W;
        BS(1,i).Y= (i)*H; 
        BS(1,i).RusCell=mod(i+1,3)+1;
    end
    for i=1:Col
        BS(2,i).X= 1.5*W;
        BS(2,i).Y= (0.5)*H + (i-1)*H;
        BS(2,i).RusCell=mod(i-1,3)+1;
    end
    for i=3:Row
        for j=1:Col
            BS(i,j).X=BS(i-2,j).X + 1.5*W;
            BS(i,j).Y=BS(i-2,j).Y ;
            BS(i,j).RusCell=BS(i-2,j).RusCell;
       end
    end
end


