clear all;
close all;
clc

%% 读取数据 %%
w = xlsread('..\数据结果\问题2-1.xlsx',4,'C3:N14');
W = sparse(w);
UG = tril(-W);

%% 最小生成树计算 %%
[ST,pred] = graphminspantree(UG,'Method','kruskal');
view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

[index_i,index_j] = find(ST);%找连接线

s = zeros(12,12);
for k=1:length(index_i)
    W(index_i(k),index_j(k)) = 0;%权值赋零
    s(index_i(k),index_j(k)) = 1;%连接线路
end

%% 增加线路 %%
w1 = full(W);%计算新权重
l = 5; %需增加的线路条数
f = zeros(66,1);
flag1 = 0;
for i = 2 : 12
    for j = 1 : (i-1)
        flag1 = flag1 + 1;
        f(flag1) = -w1(i,j);
    end
end
intcon = 66;
A = [];
b = [];
Aeq = ones(1,66);
beq = l;
lb = zeros(66,1);
ub = ones(66,1);
%整数优化
[x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

%% 增添为33根时，添加以下程序 %%
% flag2 = 0;
% for i = 2 : 12
%     for j = 1 : (i-1)
%         flag2 = flag2 + 1;
%         if x(flag2) > 0
%             s(i,j) = x(flag2);
%         end
%     end
% end
% w2 = w - s .* w;%计算新权重
% l = 17; %需增加的线路条数
% f = zeros(66,1);
% flag1 = 0;
% for i = 2 : 12
%     for j = 1 : (i-1)
%         flag1 = flag1 + 1;
%         f(flag1) = -w2(i,j);
%     end
% end
% intcon = 66;
% A = [];
% b = [];
% Aeq = ones(1,66);
% beq = l;
% lb = zeros(66,1);
% ub = ones(66,1);
% %整数优化
% [x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

%% 结果输出 %%
%计算连接矩阵
flag3 = 0;
for i = 2 : 12
    for j = 1 : (i-1)
        flag3 = flag3 + 1;
        if x(flag3) > 0
            s(i,j) = x(flag3);
        end
    end
end

%计算网络价值
NV = sum(sum(w .* s));
fprintf('Network Value = %f\n',NV);
