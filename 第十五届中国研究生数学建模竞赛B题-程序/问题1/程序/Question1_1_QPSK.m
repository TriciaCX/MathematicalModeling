% AWGN�ŵ�������QPSK���ƽ������

% ��ʼ��
clc;
clear all;
close all;

%% �趨���� %%
format long;
bit_count = 10000;% ֡��
SNR = 0: 1: 20;%����SNR
Eb_N0 = SNR - 10*log10(2);%���������

%% �Բ�ͬ��������Ƚ��м��� %%
for a = 1: 1: length(SNR)
   
    % ��ʼ������
    Errors = 0;
    Bits = 0;
    
    % ���ѭ����߾�ȷ��
    while Bits < 10000000
        % ����ԭʼ�ź�
        uncoded_bits  = round(rand(1,bit_count));
        % �ָ��������,�����ز�
        B1 = uncoded_bits(1:2:end);
        B2 = uncoded_bits(2:2:end);
        % QPSK ����(���ױ���)
        qpsk = ((B1==0).*(B2==0)*(exp(1i*pi/4))+(B1==0).*(B2==1)...
            *(exp(3*1i*pi/4))+(B1==1).*(B2==1)*(exp(5*1i*pi/4))...
            +(B1==1).*(B2==0)*(exp(7*1i*pi/4))); 
        % ������������
        N0 = 1/10^(SNR(a)/10);
        % ����
        qpsk = qpsk + sqrt(N0/2)*(randn(1,length(qpsk))+1i*randn(1,length(qpsk)));
        
        % QPSK ���
        B4 = (real(qpsk)<0);
        B3 = (imag(qpsk)<0);
        uncoded_bits_jt = zeros(1,2*length(qpsk));
        uncoded_bits_jt(1:2:end) = B3;
        uncoded_bits_jt(2:2:end) = B4;
    
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

% AWGN����������
figure(1);
theoryBerAWGN = 0.5*erfc(sqrt(10.^(Eb_N0/10)));
semilogy(SNR,theoryBerAWGN,'g-','LineWidth',1.5);
grid on;
legend('������','����ֵ');
axis([SNR(1) SNR(end) 0.00000001 1]);