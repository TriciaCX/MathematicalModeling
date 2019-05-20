% AWGN信道下的16QAM调制解调仿真

% 初始化
clc;
clear all;
close all;

%% 设置参数 %%
format long;
bit_count = 10000;%帧长
SNR = 0: 1: 20;%计算SNR
Eb_N0 = SNR - 10*log10(4);%比特信噪比
M=16;%M值
d=2;%星座图中dmin值

%% 对不同比特信噪比进行计算 %%
for a = 1: 1: length(SNR)
    
    % 初始化变量
    Errors = 0;
    Bits = 0;
    
    % 多次循环提高精确度
    while Bits < 10000000
        % 产生原始信号
        uncoded_bits  = round(rand(1,bit_count));
        % 将二进制转化为16进制
        B1 = uncoded_bits(1:4:end);
        B2 = uncoded_bits(2:4:end);
        B3 = uncoded_bits(3:4:end);
        B4 = uncoded_bits(4:4:end);
        % 16QAM调制
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
        % 加高斯噪声
        tz = awgn(qam,SNR(a),'measured');

        % 16QAM解调
        B5 = (real(tz)<0);
        B7 = (imag(tz)>0);
        B6 = (abs(real(tz))>d);
        B8 = (abs(imag(tz))<d);
        uncoded_bits_jt = zeros(1,4*length(tz));
        uncoded_bits_jt(1:4:end) = B5;
        uncoded_bits_jt(2:4:end) = B6;
        uncoded_bits_jt(3:4:end) = B7;
        uncoded_bits_jt(4:4:end) = B8;

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

% 理论误码率
figure(1);
theoryBerAWGN = 0.25*1.5*erfc(sqrt(4*0.1*(10.^(Eb_N0/10))));
semilogy(SNR,theoryBerAWGN,'g-','LineWidth',1.5);
grid on;
legend('仿真结果', '理论值');
axis([SNR(1) SNR(end) 0.000001 1]);