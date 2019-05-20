function CPath = findCapPath(V,pathNum,C)

numP = length(pathNum);
% V(sP,eP).weightIndex = zeros(pathNum(sP,eP),1);

CPath = zeros(sum(sum(pathNum)),2);
indexI = 1;
for i = 1:(numP-1)
    for j=(i+1):numP
        for nk = 1:pathNum(i,j)
            ne = V(i,j).numEdge(nk);
            for k=1:ne
                CindexI = V(i,j).edgePath(nk,2*k-1);
                CindexJ = V(i,j).edgePath(nk,2*k);
                CPath(indexI,1) = C(CindexI,CindexJ) + CPath(indexI,1);
            end
            CPath(indexI,2) = ne;
            indexI = indexI + 1;
        end
    end
end