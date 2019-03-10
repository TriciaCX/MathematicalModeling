function [V,numPath]=PathGen(UG)
%Positive Weight

numPoint = length(UG);

sPoint = struct();
ePoint = struct();
numPath = zeros(numPoint,numPoint);
for i=1:(numPoint-1)
    for j = (i+1):numPoint
        sPoint.key=i;
        sPoint.flag=1;
        ePoint.key=j;
        ePoint.flag=1;
        [resultMat,~,~,nPath] = getPath(UG,sPoint,ePoint,1,zeros(2,1),zeros(2,1),1);
        nPath = nPath-1;
        numPath(i,j) = nPath;
        
        maxNumV = size(resultMat,2);
        V(i,j).numEdge= zeros(nPath,1);
        V(i,j).edgePath = zeros(nPath,2*(maxNumV-1));
        for ki=1:nPath
            for kj = 1:(maxNumV-1)
                if(resultMat(ki,kj+1)==0)
                    break;
                end
                kindex = kj*2-1;
                V(i,j).edgePath(ki,kindex:kindex+1) = sort(resultMat(ki,kj:kj+1));
            end
            
            if(resultMat(ki,kj+1)==0)
                V(i,j).numEdge(ki) = kj-1;
            else
                V(i,j).numEdge(ki) = kj;
            end
        end
    end
end