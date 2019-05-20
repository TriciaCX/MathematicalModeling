function [resultMatrix,nPos,result,numPath]=getPath(Graph,startData,endData,nPos,result,resultMatrix,numPath)
 
result(nPos)=startData.key;
nPos=nPos+1;
while nPos~=1
    tempVal=startData.key;
    if tempVal==endData.key
        for lengthPath=1:(nPos-1)
            resultMatrix(numPath,lengthPath)=result(lengthPath);
        end
       nPos=nPos-1;
       result(nPos)=0;
       startData.flag=1;
       numPath=numPath+1;
       break;
    end
    while startData.flag<=(length(Graph))
        t= Graph(tempVal,startData.flag);
        if t>0
          if  isempty(find(result==startData.flag, 1))
              newData=struct('key',startData.flag,'flag',1);
              [resultMatrix,nPos,result,numPath]=getPath(Graph,newData,endData,nPos,result,resultMatrix,numPath);
          end
        end
        startData.flag=startData.flag+1;
    end
    if startData.flag==(length(Graph)+1)
        nPos=nPos-1;
        startData.flag=1;
        result(nPos)=0;
        break;
    end
end
