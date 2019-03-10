clear all
close all
clc

%% �������� %%
flag1 = 0;%�Ƿ���������������
flag2 = 0;%�Ƿ�����·���䲻������
flag3 = 1;%�Ƿ��Ǿ���Ч��

%% ��ȡ���� %%
if flag3 == 1
    pop = xlsread('..\���ݽ��\����2-3.xlsx',1,'C3:C14');%GDP
else
    pop = xlsread('..\���ݽ��\����2-1.xlsx',2,'C3:C14');%���˿�
end
c = xlsread('..\���ݽ��\����2-1.xlsx',3,'C3:N14');
c = c / 12.5;
pop_cor = sqrt(pop * pop');% �����˿�
w = pop_cor .* c;%����Ȩ��
alpha = 0.2;%��̰��ָ��

%% ��С���������� %%
W = sparse(w);
UG = tril(-W);
[ST,pred] = graphminspantree(UG,'Method','kruskal');
view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'));

[index_i,index_j] = find(ST);%��������

%������·
s = zeros(12,12);
for k=1:length(index_i)
    s(index_i(k),index_j(k)) = 1;
    s(index_j(k),index_i(k)) = 1;
end

%% ������· %%
ll = 22;% �����ӵĸ���
% ����
Nvalmax = zeros(1,ll);
for l = 1 : ll
    for i = 2 : 12
        for j = 1 : ( i-1 )
            % ������Ч����
            s1 = s;
            s1(i,j) = s1(i,j) + 1;
            s1(j,i) = s1(j,i) + 1;
            C1 = c .* s1;
            if flag1 == 1        
                % ��Ӽ����
                smax = max(max(s1));
                pop_cor1 = pop_cor * 1/(1+exp(smax));
            else
                pop_cor1 = pop_cor;
            end
            if flag2 == 1
                [V,Nval] = FlowAntiGreedyOptim(pop_cor1,C1,alpha);%���ӷ�̰��ָ��
            else
                [V,Nval] = MidPointOptim(pop_cor1,C1);% ��������
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

%% ����Ϊ33��ʱ��������³��� %%
% ll = 17;% �����ӵĸ���
% % ����
% Nvalmax = zeros(1,ll);
% for l = 1 : ll
%     for i = 2 : 12
%         for j = 1 : ( i-1 )
%             % ������Ч����
%             s1 = s;
%             s1(i,j) = s1(i,j) + 1;
%             s1(j,i) = s1(j,i) + 1;
%             C1 = c .* s1;
%             if flag1 == 1        
%                 % ��Ӽ����
%                 smax = max(max(s1));
%                 pop_cor1 = pop_cor * 1/(1+exp(smax));
%             else
%                 pop_cor1 = pop_cor;
%             end
%             if flag2 == 1
%                 [V,Nval]=FlowAntiGreedyOptim(pop_cor1,C1,alpha);%���ӷ�̰��ָ��
%             else
%                 [V,Nval] = MidPointOptim(pop_cor1,C1);% ��������
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

%% ������ %%
Flow = VtoNval(Vmax);%����������·��������
NV = sum(sum(w .* s)) / 2;%���������ֵ
fprintf('Network Value = %f\n',NV);