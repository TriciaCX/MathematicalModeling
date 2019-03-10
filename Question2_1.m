clc
clear

%% 读取数据 %%
w = xlsread('..\数据结果\问题2-1.xlsx',4,'C3:N14');


%% 线路优化 %%
intcon = 144;f = zeros(144,1);
flag1 = 0;
for i = 1 : 12
    for j = 1 : 12
        flag1 = flag1 + 1;
        f(flag1) = -w(i,j);
    end
end
l = 16; %总线路条数
A = zeros(24,144);
for i = 1 : 12
    A(i,12*i-11:12*i) = -ones(1,12);
    for j = 1 : 12
        A((i+12),j*12-12+i) = -1;
    end
end
b = -ones(24,1);
Aeq = ones(1,144);
beq = (l-1) * 2;
lb = zeros(144,1);
ub = ones(144,1);
[x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

%% 结果输出 %%
%计算连接矩阵
s = zeros(12,12);
flag2 = 0;
for i = 1 : 12
    for j = 1 : 12
        flag2 = flag2 + 1;
        s(i,j) = x(flag2);
    end
end
s(12, 2) = 1;
s(2, 12) = 1;

%计算网络价值
NV = sum(sum(w .* s)) / 2;
fprintf('Network Value = %f\n',NV);