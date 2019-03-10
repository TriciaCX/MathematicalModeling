function Nval=VtoNval(V)

numPoint = size(V,1);
numPath = zeros(numPoint,numPoint);

for i=1:(numPoint-1)
    for j=(i+1):numPoint
        numPath(i,j) = length(V(i,j).weight);
    end
end

allPath = sum(sum(numPath));
Nval = zeros(allPath,3);

indexN = 1;
for i=1:(numPoint-1)
    for j=(i+1):numPoint
       for k=1:numPath(i,j)
           Nval(indexN,1) = V(i,j).weight(k);
           vertexPath = V(i,j).numEdge(k)+1;
           Nval(indexN,3)=i;
           if(Nval(indexN,3)==V(i,j).edgePath(k,1))
               Nval(indexN,4)=V(i,j).edgePath(k,2);
           else
               Nval(indexN,4)=V(i,j).edgePath(k,1);
           end
           indexEdge = 2*2-1;
           for numVP=3:vertexPath
               if(Nval(indexN,2+numVP-1)==V(i,j).edgePath(k,indexEdge))
                    Nval(indexN,2+numVP)=V(i,j).edgePath(k,indexEdge+1);
               else
                   Nval(indexN,2+numVP)=V(i,j).edgePath(k,indexEdge);
               end
               indexEdge = indexEdge + 2;
           end
           
           indexN = indexN + 1;
       end
    end
end