clear all;
close all;

%% 参数设置 %%
L=80;%单跨距离
h=6.62606896*10^(-34);%普朗克常数
f = 193.1*10^12;%光波频率
B = 50*10^9;%带宽
G = 2^(L/15);%增益
Pn = 2*pi*f*h*B*(4-1/G)*1000;%放大器噪声
a = 2/3*G*Pn;

%% 计算跨数 %%
ii=1;
seg = zeros(1,20);
P_N = zeros(1,20);
for Ps = 0:0.01:15
SNR = 10^(10.33/10);%SNR门限
p_n_max = Ps/SNR;

p_nk = 0;
Po = Ps;
p_nk_old = 0;
seg(ii) = 0;
while p_nk<p_n_max
    p_nk_old = p_nk;
    P_nl = a*(Po^2);
    Po = Po + G*Pn + P_nl;
    p_nk = Po-Ps;
    seg(ii) = seg(ii)+1;
end

seg(ii) = seg(ii)-1;
P_N(ii) = p_nk_old;
ii = ii+1;
end

%% 作图 %%
Ps = 0:0.01:15;
plot(Ps,seg);
grid on;
% figure;
% SNR_rx = 10*log10(Ps./P_N);
% plot(Ps,SNR_rx);
% grid on;