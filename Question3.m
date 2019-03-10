clear all
clc
global C1     %������
global Scheme %�������1��8QAM��չ16QAM��2������16QAM��3��8QAM��չ12QAM��4��ʮ��12QAM��
global M      %����ͼ����

%% �������� %%
Scheme = 1;%�������
if Scheme <= 2;
    M = 16;
else
    M = 12;
end
c = 0 : 10;%������
SNR = 3;%�����


%% Ѱ�����ŷ����ӣ��������Ż� %%
for a = 1 : 11
    % �̶�������
    C1 = c(a);
    
    % �Ż�
    fun = @Efun_C;
    x0 = ones(M,1)/M;%�Ż���ʼֵ�����Ըı䣩
    A = [];
    b = [];
    Aeq = ones(1,M);
    beq = 1;
    lb = zeros(M,1);
    ub = [];
    nonlcon = @Hfunst;
    options=optimoptions('fmincon','MaxFunEvals',30000,'MaxIterations',10000,'Algorithm','interior-point');
    [x1,fval1,exitflag,output] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
    
    % �����ʱ�������ʼ��ص����
    x(:,a) = x1;
    fval(a) = fval1;
    BER(a) = BERcalculate(x,SNR);%������
    H(a) = Hfun(x);%�ص����
end