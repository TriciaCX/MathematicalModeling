function [V,fval]=MidPointOptim(pop_cor,C)

UG = sign(C); %����ͼ����

[V,numPath] = PathGen(UG);
[A,b,lb] = constructLP(V,C,numPath);

nv = size(UG,1); %�ڵ���
numX = sum(sum(numPath)); %���������ӵ�·������
W_pop = zeros(1,numX); %�˿�Ȩ��
indexWP = 1;
for i=1:(nv-1)
    for j=(i+1):nv
        lnp = numPath(i,j);
        W_pop(1,indexWP:(indexWP+lnp-1)) = pop_cor(i,j)*ones(1,lnp);
        indexWP = indexWP + lnp;
    end
end

[x,fval] = linprog(-W_pop,A,b,[],[],lb);
fval = -fval;

indexWV = 1;
for i=1:(nv-1)
    for j=(i+1):nv
        pathK = numPath(i,j);
        V(i,j).weight=x(indexWV:(indexWV+pathK-1))';
        indexWV = indexWV+pathK;
    end
end
V(nv,1).numEdge =[];

end