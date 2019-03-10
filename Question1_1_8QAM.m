% ����˥���ŵ��µ�8QAM���ƽ������

% ��ʼ��
clc;
clear all;
close all;

%% ���ò��� %%
format long;
bit_count = 9000;%֡��
SNR = 0: 1: 20;%����SNR
Eb_N0 = SNR - 10*log10(3);%���������

M=8;%Mֵ
d=1;%����ͼ��dminֵ

%% �Բ�ͬ��������Ƚ��м��� %%
for a = 1: 1: length(SNR)
    
    % ��ʼ������
    Errors = 0;
    Bits = 0;
    
    % ���ѭ����߾�ȷ��
    while Bits < 10000000
        % ����ԭʼ�ź�
        uncoded_bits  = round(rand(1,bit_count));
        % ��������ת��Ϊ16����
        B1 = uncoded_bits(1:3:end);
        B2 = uncoded_bits(2:3:end);
        B3 = uncoded_bits(3:3:end);
        % 16QAM����
        qam = ((B1==0).*(B2==0).*(B3==0).*(-d+1i*d)...
            +(B1==0).*(B2==0).*(B3==1).*(d+1i*d)...
            +(B1==0).*(B2==1).*(B3==0).*(-d-1i*d)...
            +(B1==0).*(B2==1).*(B3==1).*(d-1i*d)...
            +(B1==1).*(B2==0).*(B3==0).*(-(1+sqrt(3))*d+1i*0)...
            +(B1==1).*(B2==0).*(B3==1).*(0+1i*(1+sqrt(3))*d)...
            +(B1==1).*(B2==1).*(B3==0).*(0-1i*(1+sqrt(3))*d)...
            +(B1==1).*(B2==1).*(B3==1).*((1+sqrt(3))*d+1i*0));
        % �Ӹ�˹����
        tz = awgn(qam,SNR(a),'measured');

        % 16QAM���
        for b = 1 : length(tz)
            distancemin = abs(tz(b)-(-d+1i*d));
            flag = 0;
            distance(1) = abs(tz(b)-(d+1i*d));
            distance(2) = abs(tz(b)-(-d-1i*d));
            distance(3) = abs(tz(b)-(d-1i*d));
            distance(4) = abs(tz(b)-(-(1+sqrt(3))*d+1i*0));
            distance(5) = abs(tz(b)-(0+1i*(1+sqrt(3))*d));
            distance(6) = abs(tz(b)-(0-1i*(1+sqrt(3))*d));
            distance(7) = abs(tz(b)-((1+sqrt(3))*d+1i*0));
            for j = 1 : 7
                if distance(j) < distancemin
                    distancemin = distance(j);
                    flag = j;
                end
            end
            if flag == 0
                B4(b) = 0;
                B5(b) = 0;
                B6(b) = 0;
            end
            if flag == 1
                B4(b) = 0;
                B5(b) = 0;
                B6(b) = 1;
            end
            if flag == 2
                B4(b) = 0;
                B5(b) = 1;
                B6(b) = 0;
            end
            if flag == 3
                B4(b) = 0;
                B5(b) = 1;
                B6(b) = 1;
            end
            if flag == 4
                B4(b) = 1;
                B5(b) = 0;
                B6(b) = 0;
            end
            if flag == 5
                B4(b) = 1;
                B5(b) = 0;
                B6(b) = 1;
            end
            if flag == 6
                B4(b) = 1;
                B5(b) = 1;
                B6(b) = 0;
            end
            if flag == 7
                B4(b) = 1;
                B5(b) = 1;
                B6(b) = 1;
            end
        end
            
        uncoded_bits_jt = zeros(1,3*length(tz));
        uncoded_bits_jt(1:3:end) = B4;
        uncoded_bits_jt(2:3:end) = B5;
        uncoded_bits_jt(3:3:end) = B6;


        % ���������
        Error = uncoded_bits - uncoded_bits_jt;
        Errors = Errors + sum(abs(Error));
        Bits = Bits + length(uncoded_bits);
        
    end

    % �������������
    BER(a) = Errors / Bits;
    fprintf('bit error probability = %f\n',BER(a));

end

%% ��ͼ %%
% ������ͼ
figure(1);
semilogy(SNR,BER,'or');
hold on;
xlabel('SNR/dB');
ylabel('BER');

% ����������
figure(1);
semilogy(SNR,BER,'g-','LineWidth',1.5);
grid on;
legend('������', '����ֵ');
axis([SNR(1) SNR(end) 0.00001 10]);