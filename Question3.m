clear all
clc
global C1     %罚因子
global Scheme %方案类别（1：8QAM扩展16QAM；2：矩形16QAM；3：8QAM扩展12QAM；4：十字12QAM）
global M      %星座图点数

%% 参数设置 %%
Scheme = 1;%方案类别
if Scheme <= 2;
    M = 16;
else
    M = 12;
end
c = 0 : 10;%罚因子
SNR = 3;%信噪比


%% 寻找最优罚因子，并进行优化 %%
for a = 1 : 11
    % 固定罚因子
    C1 = c(a);
    
    % 优化
    fun = @Efun_C;
    x0 = ones(M,1)/M;%优化初始值（可以改变）
    A = [];
    b = [];
    Aeq = ones(1,M);
    beq = 1;
    lb = zeros(M,1);
    ub = [];
    nonlcon = @Hfunst;
    options=optimoptions('fmincon','MaxFunEvals',30000,'MaxIterations',10000,'Algorithm','interior-point');
    [x1,fval1,exitflag,output] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
    
    % 计算此时的误码率及熵的误差
    x(:,a) = x1;
    fval(a) = fval1;
    BER(a) = BERcalculate(x,SNR);%误码率
    H(a) = Hfun(x);%熵的误差
end