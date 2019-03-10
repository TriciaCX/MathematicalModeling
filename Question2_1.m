clc
clear

%% ��ȡ���� %%
w = xlsread('..\���ݽ��\����2-1.xlsx',4,'C3:N14');


%% ��·�Ż� %%
intcon = 144;f = zeros(144,1);
flag1 = 0;
for i = 1 : 12
    for j = 1 : 12
        flag1 = flag1 + 1;
        f(flag1) = -w(i,j);
    end
end
l = 16; %����·����
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

%% ������ %%
%�������Ӿ���
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

%���������ֵ
NV = sum(sum(w .* s)) / 2;
fprintf('Network Value = %f\n',NV);