clear all;
close all;
clc

%% ��ȡ���� %%
w = xlsread('..\���ݽ��\����2-1.xlsx',4,'C3:N14');
W = sparse(w);
UG = tril(-W);

%% ��С���������� %%
[ST,pred] = graphminspantree(UG,'Method','kruskal');
view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

[index_i,index_j] = find(ST);%��������

s = zeros(12,12);
for k=1:length(index_i)
    W(index_i(k),index_j(k)) = 0;%Ȩֵ����
    s(index_i(k),index_j(k)) = 1;%������·
end

%% ������· %%
w1 = full(W);%������Ȩ��
l = 5; %�����ӵ���·����
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
%�����Ż�
[x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

%% ����Ϊ33��ʱ��������³��� %%
% flag2 = 0;
% for i = 2 : 12
%     for j = 1 : (i-1)
%         flag2 = flag2 + 1;
%         if x(flag2) > 0
%             s(i,j) = x(flag2);
%         end
%     end
% end
% w2 = w - s .* w;%������Ȩ��
% l = 17; %�����ӵ���·����
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
% %�����Ż�
% [x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

%% ������ %%
%�������Ӿ���
flag3 = 0;
for i = 2 : 12
    for j = 1 : (i-1)
        flag3 = flag3 + 1;
        if x(flag3) > 0
            s(i,j) = x(flag3);
        end
    end
end

%���������ֵ
NV = sum(sum(w .* s));
fprintf('Network Value = %f\n',NV);
