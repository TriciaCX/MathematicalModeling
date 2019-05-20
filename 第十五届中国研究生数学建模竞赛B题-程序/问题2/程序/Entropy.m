function F = Entropy(p)
    F = [sum(p.*log2(p))+3;
        sum(p)-1];
end