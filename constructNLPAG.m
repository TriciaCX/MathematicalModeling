function [A,CPath,b,lb] = constructNLPAG(V,C,numPath)

n = size(C,1);
b = zeros(2,1);
numX = sum(sum(numPath));
A = zeros(1,numX);

lb = zeros(numX,1);

ci = 1;
for i=1:(n-1)
    for j=(i+1):n
        if(C(i,j)>0)
            b(ci) = C(i,j);
            V = findWeightPath(V,i,j,numPath);
            
            indexK = 1;
            for indI=1:(n-1)
                for indJ=(indI+1):n
                    A(ci,indexK:(numPath(indI,indJ)+indexK-1)) = V(indI,indJ).weightIndex';
                    indexK = indexK+numPath(indI,indJ);
                end
            end
            
            CPath = findCapPath(V,numPath,C);
            
            ci = ci+1;
        end
    end
end