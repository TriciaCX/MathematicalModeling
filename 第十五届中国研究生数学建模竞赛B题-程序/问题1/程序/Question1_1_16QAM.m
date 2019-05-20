% AWGN�ŵ��µ�16QAM���ƽ������

% ��ʼ��
clc;
clear all;
close all;

%% ���ò��� %%
format long;
bit_count = 10000;%֡��
SNR = 0: 1: 20;%����SNR
Eb_N0 = SNR - 10*log10(4);%���������
M=16;%Mֵ
d=2;%����ͼ��dminֵ

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
        B1 = uncoded_bits(1:4:end);
        B2 = uncoded_bits(2:4:end);
        B3 = uncoded_bits(3:4:end);
        B4 = uncoded_bits(4:4:end);
        % 16QAM����
        qam = ((B1==0).*(B2==0).*(B3==1).*(B4==1)*(d/2+1i*d/2)...
            +(B1==1).*(B2==0).*(B3==1).*(B4==1)*(-d/2+1i*d/2)...
            +(B1==1).*(B2==0).*(B3==0).*(B4==1)*(-d/2-1i*d/2)...
            +(B1==0).*(B2==0).*(B3==0).*(B4==1)*(d/2-1i*d/2)...
            +(B1==0).*(B2==1).*(B3==1).*(B4==1)*(3*d/2+1i*d/2)...
            +(B1==0).*(B2==1).*(B3==1).*(B4==0)*(3*d/2+1i*3*d/2)...
            +(B1==0).*(B2==0).*(B3==1).*(B4==0)*(d/2+1i*3*d/2)...
            +(B1==1).*(B2==0).*(B3==1).*(B4==0)*(-d/2+1i*3*d/2)...
            +(B1==1).*(B2==1).*(B3==1).*(B4==0)*(-3*d/2+1i*3*d/2)...
            +(B1==1).*(B2==1).*(B3==1).*(B4==1)*(-3*d/2+1i*d/2)...
            +(B1==1).*(B2==1).*(B3==0).*(B4==1)*(-3*d/2-1i*d/2)...
            +(B1==1).*(B2==1).*(B3==0).*(B4==0)*(-3*d/2-1i*3*d/2)...
            +(B1==1).*(B2==0).*(B3==0).*(B4==0)*(-d/2-1i*3*d/2)...
            +(B1==0).*(B2==0).*(B3==0).*(B4==0)*(d/2-1i*3*d/2)...
            +(B1==0).*(B2==1).*(B3==0).*(B4==0)*(3*d/2-1i*3*d/2)...
            +(B1==0).*(B2==1).*(B3==0).*(B4==1)*(3*d/2-1i*d/2));
        % �Ӹ�˹����
        tz = awgn(qam,SNR(a),'measured');

        % 16QAM���
        B5 = (real(tz)<0);
        B7 = (imag(tz)>0);
        B6 = (abs(real(tz))>d);
        B8 = (abs(imag(tz))<d);
        uncoded_bits_jt = zeros(1,4*length(tz));
        uncoded_bits_jt(1:4:end) = B5;
        uncoded_bits_jt(2:4:end) = B6;
        uncoded_bits_jt(3:4:end) = B7;
        uncoded_bits_jt(4:4:end) = B8;

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
theoryBerAWGN = 0.25*1.5*erfc(sqrt(4*0.1*(10.^(Eb_N0/10))));
semilogy(SNR,theoryBerAWGN,'g-','LineWidth',1.5);
grid on;
legend('������', '����ֵ');
axis([SNR(1) SNR(end) 0.000001 1]);