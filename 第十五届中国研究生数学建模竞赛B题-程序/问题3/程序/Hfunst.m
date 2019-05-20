function [c,ceq] = Hfunst (P)
global M

% º∆À„Ïÿ
H = 0;
for i = 1 : M
    H = H + P(i) * log2(P(i));
end
ceq = abs(3 + H);
c = [];