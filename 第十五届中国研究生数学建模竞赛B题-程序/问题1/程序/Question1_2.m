clear all;
close all;

%% �������� %%
L=80;%�������
h=6.62606896*10^(-34);%���ʿ˳���
f = 193.1*10^12;%�ⲨƵ��
B = 50*10^9;%����
G = 2^(L/15);%����
Pn = 2*pi*f*h*B*(4-1/G)*1000;%�Ŵ�������
a = 2/3*G*Pn;

%% ������� %%
ii=1;
seg = zeros(1,20);
P_N = zeros(1,20);
for Ps = 0:0.01:15
SNR = 10^(10.33/10);%SNR����
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

%% ��ͼ %%
Ps = 0:0.01:15;
plot(Ps,seg);
grid on;
% figure;
% SNR_rx = 10*log10(Ps./P_N);
% plot(Ps,SNR_rx);
% grid on;