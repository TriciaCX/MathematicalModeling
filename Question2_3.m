clear all
close all
clc

%% 设置类型 %%
flag1 = 0;%是否解决过度连接问题
flag2 = 0;%是否解决链路分配不均问题
flag3 = 1;%是否考虑经济效益

%% 读取数据 %%
if flag3 == 1
    pop = xlsread('..\数据结果\问题2-3.xlsx',1,'C3:C14');%GDP
else
    pop = xlsread('..\数据结果\问题2-1.xlsx',2,'C3:C14');%市人口
end
c = xlsread('..\数据结果\问题2-1.xlsx',3,'C3:N14');
c = c / 12.5;
pop_cor = sqrt(pop * pop');% 连接人口
w = pop_cor .* c;%计算权重
alpha = 0.2;%反贪婪指数

%% 最小生成树计算 %%
W = sparse(w);
UG = tril(-W);
[ST,pred] = graphminspantree(UG,'Method','kruskal');
view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

[index_i,index_j] = find(ST);%找连接线

%连接线路
s = zeros(12,12);
for k=1:length(index_i)
    s(index_i(k),index_j(k)) = 1;
    s(index_j(k),index_i(k)) = 1;
end

%% 增加线路 %%
ll = 22;% 需增加的根数
% 遍历
Nvalmax = zeros(1,ll);
for l = 1 : ll
    for i = 2 : 12
        for j = 1 : ( i-1 )
            % 计算有效容量
            s1 = s;
            s1(i,j) = s1(i,j) + 1;
            s1(j,i) = s1(j,i) + 1;
            C1 = c .* s1;
            if flag1 == 1        
                % 添加激活函数
                smax = max(max(s1));
                pop_cor1 = pop_cor * 1/(1+exp(smax));
            else
                pop_cor1 = pop_cor;
            end
            if flag2 == 1
                [V,Nval] = FlowAntiGreedyOptim(pop_cor1,C1,alpha);%增加反贪婪指数
            else
                [V,Nval] = MidPointOptim(pop_cor1,C1);% 计算流量
            end
            if Nval >= Nvalmax(l)
                Nvalmax(l) = Nval;
                imax(l) = i;
                jmax(l) = j;
                Vmax = V;
            end
        end
    end
    s(imax(l),jmax(l)) = s(imax(l),jmax(l)) + 1;
    s(jmax(l),imax(l)) = s(jmax(l),imax(l)) + 1;
end

%% 增添为33根时，添加以下程序 %%
% ll = 17;% 需增加的根数
% % 遍历
% Nvalmax = zeros(1,ll);
% for l = 1 : ll
%     for i = 2 : 12
%         for j = 1 : ( i-1 )
%             % 计算有效容量
%             s1 = s;
%             s1(i,j) = s1(i,j) + 1;
%             s1(j,i) = s1(j,i) + 1;
%             C1 = c .* s1;
%             if flag1 == 1        
%                 % 添加激活函数
%                 smax = max(max(s1));
%                 pop_cor1 = pop_cor * 1/(1+exp(smax));
%             else
%                 pop_cor1 = pop_cor;
%             end
%             if flag2 == 1
%                 [V,Nval]=FlowAntiGreedyOptim(pop_cor1,C1,alpha);%增加反贪婪指数
%             else
%                 [V,Nval] = MidPointOptim(pop_cor1,C1);% 计算流量
%             end
%             if Nval >= Nvalmax(l)
%                 Nvalmax(l) = Nval;
%                 imax(l) = i;
%                 jmax(l) = j;
%                 Vmax = V;
%             end
%         end
%     end
%     s(imax(l),jmax(l)) = s(imax(l),jmax(l)) + 1;
%     s(jmax(l),imax(l)) = s(jmax(l),imax(l)) + 1;
% end

%% 结果输出 %%
Flow = VtoNval(Vmax);%计算连接线路及其流量
NV = sum(sum(w .* s)) / 2;%计算网络价值
fprintf('Network Value = %f\n',NV);