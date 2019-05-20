clear all
close all
clc

%% ��ȡ���� %%
pop = xlsread('..\���ݽ��\����2-1.xlsx',2,'C3:C14');%���˿ڣ�ʡ�˿��л�Ϊpop = xlsread('..\���ݽ��\����2-1.xlsx',2,'D3:D14')��
c = xlsread('..\���ݽ��\����2-1.xlsx',3,'C3:N14');
pop_cor = sqrt(pop * pop');% �����˿�
w = pop_cor .* c;%����Ȩ��

%% ��С���������� %%
W = sparse(w);
UG = tril(-W);
[ST,pred] = graphminspantree(UG,'Method','kruskal');
view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

[index_i,index_j] = find(ST);%��������

s = zeros(12,12);
for k=1:length(index_i)
    W(index_i(k),index_j(k)) = 0;%Ȩֵ����
    s(index_i(k),index_j(k)) = 1;
    s(index_j(k),index_i(k)) = 1;%������·
end

%% ������· %%
C = c .* s;%��Ч����
% ����
ll = 5;%�����ӵĸ���
Nvalmax = zeros(1,ll);
for l = 1 : ll
    for i = 2 : 12
        for j = 1 : (i-1)
            C1 = C;
            C1(i,j) = C1(i,j) + c(i,j);
            C1(j,i) = C1(j,i) + c(j,i);
            [V, Nval] = MidPointOptim(pop_cor, C1);% ��������
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

%% ����Ϊ33��ʱ��������³��� %%
% ll = 17;%�����ӵĸ���
% Nvalmax = zeros(1,ll);
% for l = 1 : ll
%     for i = 2 : 12
%         for j = 1 : (i-1)
%             C1 = C;
%             C1(i,j) = C1(i,j) + c(i,j);
%             C1(j,i) = C1(j,i) + c(j,i);
%             [V, Nval] = MidPointOptim(pop_cor, C1);% ��������
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

%% ������ %%
Flow = VtoNval(Vmax);%����������·��������
NV = sum(sum(w .* s)) / 2 / 12.5;%���������ֵ
fprintf('Network Value = %f\n',NV);