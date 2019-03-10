function f = Hfun (P)
global M

H = 0;
for i = 1 : M
    H = H + P(i) * log2(P(i));
end
f = abs(3 + H);