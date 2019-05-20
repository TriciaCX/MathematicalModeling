function V = findWeightPath(V,sP,eP,pathNum)

numP = length(pathNum);
% V(sP,eP).weightIndex = zeros(pathNum(sP,eP),1);

for i = 1:(numP-1)
    for j=(i+1):numP
        V(i,j).weightIndex = zeros(pathNum(i,j),1);
        for k=1:pathNum(i,j)
            nEdge = V(i,j).numEdge(k);
            for indexEdge=1:nEdge
                indx = indexEdge*2-1;
                if(V(i,j).edgePath(k,indx)==sP && V(i,j).edgePath(k,indx+1)==eP)
                    V(i,j).weightIndex(k) = 1;
                end
            end
        end
    end
end