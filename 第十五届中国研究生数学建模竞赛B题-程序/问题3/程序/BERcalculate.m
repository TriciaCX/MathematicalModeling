function BER = BERcalculate(p,SNR)
global Scheme
global M

%% 产生信号 %%
bit = 10000;
S = 0;
for a = 1 : M
    S = [S, (a-1) * ones(1,round(p(a)*bit))];
end

%% 计算星座点坐标 %%
% 8QAMto16QAM 
if Scheme == 1
    A = (2 + sqrt(3) +sqrt(5)) / 2;
    B = A - 1;
    D0 = (1 + 1i);
    D1 = (-1 + 1i);
    D2 = (-1 - 1i);
    D3 = (1 - 1i);
    D4 = (1 + sqrt(3));
    D5 = ((1 + sqrt(3)) * 1i);
    D6 = (-(1 + sqrt(3)));
    D7 = (-(1 + sqrt(3)) * 1i);
    D8 = (A + 1i * B);
    D9 = (B + 1i * A); 
    D10 = (-B + 1i * A);
    D11 = (-A + 1i * B);
    D12 = (-A - 1i * B);
    D13 = (-B - 1i * A);
    D14 = (B - 1i * A);
    D15 = (A - 1i * B);
end

% 矩形16QAM
if Scheme == 2
    D0 = (1 + 1i);
    D1 = (-1 + 1i);
    D2 = (-1 - 1i);
    D3 = (1 - 1i);
    D4 = (3 + 1i);
    D5 = (1 + 1i * 3);
    D6 = (-1 + 1i * 3);
    D7 = (-3 + 1i);
    D8 = (-3 - 1i);
    D9 = (-1 - 1i * 3);
    D10 = (1 - 1i * 3);
    D11 = (3 - 1i);
    D12 = (3 + 1i * 3);
    D13 = (-3 + 1i * 3);
    D14 = (-3 - 1i * 3);
    D15 = (3 - 1i * 3);
end

% 8QAMto12QAM
if Scheme == 3
    A = (1 + sqrt(3));
    B = 2;
    D0 = (1 + 1i);
    D1 = (-1 + 1i);
    D2 = (-1 - 1i);
    D3 = (1 - 1i);
    D4 = (1 + sqrt(3));
    D5 = ((1 + sqrt(3)) * 1i);
    D6 = (-(1 + sqrt(3)));
    D7 = (-(1 + sqrt(3)) * 1i);
    D8 = (A + 1i * B);
    D9 = (-A + 1i * B);
    D10 = (-A - 1i * B);
    D11 = (A - 1i * B);
end

% 十字12QAM
if Scheme == 4
    D0 = (1 + 1i);
    D1 = (-1 + 1i);
    D2 = (-1 - 1i);
    D3 = (1 - 1i);
    D4 = (3 + 1i);
    D5 = (1 + 1i * 3);
    D6 = (-1 + 1i * 3);
    D7 = (-3 + 1i);
    D8 = (-3 - 1i);
    D9 = (-1 - 1i * 3);
    D10 = (1 - 1i * 3);
    D11 = (3 - 1i);
end

%% 仿真 %%
% 编码
if M == 12
    qam = (S == 0) .* D0...
        + (S == 1) .* D1...
        + (S == 2) .* D2...
        + (S == 3) .* D3...
        + (S == 4) .* D4...
        + (S == 5) .* D5...
        + (S == 6) .* D6...
        + (S == 7) .* D7...
        + (S == 8) .* D8...
        + (S == 9) .* D9...
        + (S == 10) .* D10...
        + (S == 11) .* D11;
else
    qam = (S == 0) .* D0...
        + (S == 1) .* D1...
        + (S == 2) .* D2...
        + (S == 3) .* D3...
        + (S == 4) .* D4...
        + (S == 5) .* D5...
        + (S == 6) .* D6...
        + (S == 7) .* D7...
        + (S == 8) .* D8...
        + (S == 9) .* D9...
        + (S == 10) .* D10...
        + (S == 11) .* D11...
        + (S == 12) .* D12...
        + (S == 13) .* D13...
        + (S == 14) .* D14...
        + (S == 15) .* D15;
end

% 加噪
tz = awgn(qam,SNR,'measured');
    
% 解调
for b = 1 : length(tz)
    if M == 12
        distancemin = abs(tz(b)-D0);
        Sj(b) = 0;
        distance(1) = abs(tz(b)-D1);
        distance(2) = abs(tz(b)-D2);
        distance(3) = abs(tz(b)-D3);
        distance(4) = abs(tz(b)-D4);
        distance(5) = abs(tz(b)-D5);
        distance(6) = abs(tz(b)-D6);
        distance(7) = abs(tz(b)-D7);
        distance(8) = abs(tz(b)-D8);
        distance(9) = abs(tz(b)-D9);
        distance(10) = abs(tz(b)-D10);
        distance(11) = abs(tz(b)-D11);
    else
        distancemin = abs(tz(b)-D0);
        Sj(b) = 0;
        distance(1) = abs(tz(b)-D1);
        distance(2) = abs(tz(b)-D2);
        distance(3) = abs(tz(b)-D3);
        distance(4) = abs(tz(b)-D4);
        distance(5) = abs(tz(b)-D5);
        distance(6) = abs(tz(b)-D6);
        distance(7) = abs(tz(b)-D7);
        distance(8) = abs(tz(b)-D8);
        distance(9) = abs(tz(b)-D9);
        distance(10) = abs(tz(b)-D10);
        distance(11) = abs(tz(b)-D11);
        distance(12) = abs(tz(b)-D12);
        distance(13) = abs(tz(b)-D13);
        distance(14) = abs(tz(b)-D14);
        distance(15) = abs(tz(b)-D15);
    end
    for j = 1 : (M-1)
        if distance(j) < distancemin
            distancemin = distance(j);
            Sj(b) = j;
        end
    end
end

% 计算比特信噪比
[number, BER] = biterr(Sj,S);
end
