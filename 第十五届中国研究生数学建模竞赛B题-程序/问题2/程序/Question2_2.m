clear all
close all
clc

%% 读取数据 %%
pop = xlsread('..\数据结果\问题2-1.xlsx',2,'C3:C14');%市人口（省人口切换为pop = xlsread('..\数据结果\问题2-1.xlsx',2,'D3:D14')）
c = xlsread('..\数据结果\问题2-1.xlsx',3,'C3:N14');
pop_cor = sqrt(pop * pop');% 连接人口
w = pop_cor .* c;%计算权重

%% 最小生成树计算 %%
W = sparse(w);
UG = tril(-W);
[ST,pred] = graphminspantree(UG,'Method','kruskal');
view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

[index_i,index_j] = find(ST);%找连接线

s = zeros(12,12);
for k=1:length(index_i)
    W(index_i(k),index_j(k)) = 0;%权值赋零
    s(index_i(k),index_j(k)) = 1;
    s(index_j(k),index_i(k)) = 1;%连接线路
end

%% 增加线路 %%
C = c .* s;%有效容量
% 遍历
ll = 5;%需增加的根数
Nvalmax = zeros(1,ll);
for l = 1 : ll
    for i = 2 : 12
        for j = 1 : (i-1)
            C1 = C;
            C1(i,j) = C1(i,j) + c(i,j);
            C1(j,i) = C1(j,i) + c(j,i);
            [V, Nval] = MidPointOptim(pop_cor, C1);% 计算流量
            if Nval > Nvalmax(l)
                Nvalmax(l) = Nval;
                imax(l) = i;
                jmax(l) = j;
                Vmax = V;
            end
        end
    end
    s(imax(l),jmax(l)) = s(imax(l),jmax(l)) + 1;
    s(jmax(l),imax(l)) = s(jmax(l),imax(l)) + 1;
    C(imax(l),jmax(l)) = C(imax(l),jmax(l)) + c(imax(l),jmax(l));
    C(jmax(l),imax(l)) = C(jmax(l),imax(l)) + c(jmax(l),imax(l));
end

%% 增添为33根时，添加以下程序 %%
% ll = 17;%需增加的根数
% Nvalmax = zeros(1,ll);
% for l = 1 : ll
%     for i = 2 : 12
%         for j = 1 : (i-1)
%             C1 = C;
%             C1(i,j) = C1(i,j) + c(i,j);
%             C1(j,i) = C1(j,i) + c(j,i);
%             [V, Nval] = MidPointOptim(pop_cor, C1);% 计算流量
%             if Nval > Nvalmax(l)
%                 Nvalmax(l) = Nval;
%                 imax(l) = i;
%                 jmax(l) = j;
%                 Vmax = V;
%             end
%         end
%     end
%     s(imax(l),jmax(l)) = s(imax(l),jmax(l)) + 1;
%     s(jmax(l),imax(l)) = s(jmax(l),imax(l)) + 1;
%     C(imax(l),jmax(l)) = C(imax(l),jmax(l)) + c(imax(l),jmax(l));
%     C(jmax(l),imax(l)) = C(jmax(l),imax(l)) + c(jmax(l),imax(l));
% end

%% 结果输出 %%
Flow = VtoNval(Vmax);%计算连接线路及其流量
NV = sum(sum(w .* s)) / 2 / 12.5;%计算网络价值
fprintf('Network Value = %f\n',NV);