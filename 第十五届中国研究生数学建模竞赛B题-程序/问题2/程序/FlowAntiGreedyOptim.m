function [V,fval]=FlowAntiGreedyOptim(pop_cor,C,alpha)

UG = sign(C); %无向图矩阵

[V,numPath] = PathGen(UG);
[A,CPath,b,lb] = constructNLPAG(V,C,numPath);

nv = size(UG,1); %节点数
numX = sum(sum(numPath)); %包括虚连接的路径总数
W_pop = zeros(1,numX); %人口权重
indexWP = 1;
for i=1:(nv-1)
    for j=(i+1):nv
        lnp = numPath(i,j);
        W_pop(1,indexWP:(indexWP+lnp-1)) = pop_cor(i,j)*ones(1,lnp);
        indexWP = indexWP + lnp;
    end
end


funcNL = @(x)(-W_pop)*((alpha + tanh((CPath(:,1)-CPath(:,2).*x)./CPath(:,2))).*x);
x0 = zeros(numX,1);
options=optimoptions('fmincon','MaxFunEvals',30000,'MaxIterations',10000,'Algorithm','interior-point','Display','off');
[x,fval] = fmincon(funcNL,x0,A,b,[],[],lb,[],[],options);
fval = -fval;

indexWV = 1;
for i=1:(nv-1)
    for j=(i+1):nv
        pathK = numPath(i,j);
        V(i,j).weight=x(indexWV:(indexWV+pathK-1))';
        indexWV = indexWV+pathK;
    end
end
V(nv,1).numEdge = [];

end