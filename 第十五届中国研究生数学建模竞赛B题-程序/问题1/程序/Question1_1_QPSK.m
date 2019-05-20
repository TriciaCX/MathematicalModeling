% AWGN信道条件下QPSK调制解调仿真

% 初始化
clc;
clear all;
close all;

%% 设定参数 %%
format long;
bit_count = 10000;% 帧长
SNR = 0: 1: 20;%计算SNR
Eb_N0 = SNR - 10*log10(2);%比特信噪比

%% 对不同比特信噪比进行计算 %%
for a = 1: 1: length(SNR)
   
    % 初始化变量
    Errors = 0;
    Bits = 0;
    
    % 多次循环提高精确度
    while Bits < 10000000
        % 产生原始信号
        uncoded_bits  = round(rand(1,bit_count));
        % 分割成两个流,正交载波
        B1 = uncoded_bits(1:2:end);
        B2 = uncoded_bits(2:2:end);
        % QPSK 调制(格雷编码)
        qpsk = ((B1==0).*(B2==0)*(exp(1i*pi/4))+(B1==0).*(B2==1)...
            *(exp(3*1i*pi/4))+(B1==1).*(B2==1)*(exp(5*1i*pi/4))...
            +(B1==1).*(B2==0)*(exp(7*1i*pi/4))); 
        % 计算噪声方差
        N0 = 1/10^(SNR(a)/10);
        % 加噪
        qpsk = qpsk + sqrt(N0/2)*(randn(1,length(qpsk))+1i*randn(1,length(qpsk)));
        
        % QPSK 解调
        B4 = (real(qpsk)<0);
        B3 = (imag(qpsk)<0);
        uncoded_bits_jt = zeros(1,2*length(qpsk));
        uncoded_bits_jt(1:2:end) = B3;
        uncoded_bits_jt(2:2:end) = B4;
    
        % 计算错误量
        Error = uncoded_bits - uncoded_bits_jt;
        Errors = Errors + sum(abs(Error));
        Bits = Bits + length(uncoded_bits);
        
    end
    
    % 计算比特误码率
    BER(a) = Errors / Bits;
    fprintf('bit error probability = %f\n',BER(a));

end
  
%% 作图 %%
% 仿真结果图
figure(1);
semilogy(SNR,BER,'or');
hold on;
xlabel('SNR/dB');
ylabel('BER');

% AWGN理论误码率
figure(1);
theoryBerAWGN = 0.5*erfc(sqrt(10.^(Eb_N0/10)));
semilogy(SNR,theoryBerAWGN,'g-','LineWidth',1.5);
grid on;
legend('仿真结果','理论值');
axis([SNR(1) SNR(end) 0.00000001 1]);