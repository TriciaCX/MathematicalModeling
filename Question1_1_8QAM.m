% 瑞利衰落信道下的8QAM调制解调仿真

% 初始化
clc;
clear all;
close all;

%% 设置参数 %%
format long;
bit_count = 9000;%帧长
SNR = 0: 1: 20;%计算SNR
Eb_N0 = SNR - 10*log10(3);%比特信噪比

M=8;%M值
d=1;%星座图中dmin值

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
        B1 = uncoded_bits(1:3:end);
        B2 = uncoded_bits(2:3:end);
        B3 = uncoded_bits(3:3:end);
        % 16QAM调制
        qam = ((B1==0).*(B2==0).*(B3==0).*(-d+1i*d)...
            +(B1==0).*(B2==0).*(B3==1).*(d+1i*d)...
            +(B1==0).*(B2==1).*(B3==0).*(-d-1i*d)...
            +(B1==0).*(B2==1).*(B3==1).*(d-1i*d)...
            +(B1==1).*(B2==0).*(B3==0).*(-(1+sqrt(3))*d+1i*0)...
            +(B1==1).*(B2==0).*(B3==1).*(0+1i*(1+sqrt(3))*d)...
            +(B1==1).*(B2==1).*(B3==0).*(0-1i*(1+sqrt(3))*d)...
            +(B1==1).*(B2==1).*(B3==1).*((1+sqrt(3))*d+1i*0));
        % 加高斯噪声
        tz = awgn(qam,SNR(a),'measured');

        % 16QAM解调
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
semilogy(SNR,BER,'g-','LineWidth',1.5);
grid on;
legend('仿真结果', '理论值');
axis([SNR(1) SNR(end) 0.00001 10]);