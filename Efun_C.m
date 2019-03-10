function f = Efun_C(p)
global C1
global Scheme

f = C1 * (p(1) + p(2) + p(3) + p(4));

%% 8QAM扩展16QAM %%
if Scheme == 1
    A = (2 + sqrt(3) + sqrt(5)) / 2;
    for i = 1 : 4
        f = f + p(i) * 2;
    end
    for i = 5 : 8
        f = f + p(i) * (4 + 2 * sqrt(3));
    end
    for i = 9 : 16
        f = f + p(i) * (A^2 + (A-1)^2);
    end
end

%% 矩形16QAM %%
if Scheme == 2
    for i = 1 : 4
        f = f + p(i) * 2;
    end
    for i = 5 : 12
        f = f + p(i) * 10;
    end
    for i = 13 : 16
        f = f + p(i) * 18;
    end
end

%% 8QAM扩展12QAM %%
if Scheme == 3
    for i = 1 : 4
        f = f + p(i) * 2;
    end
    for i = 5 : 8
        f = f + p(i) * (4 + 2 * sqrt(3));
    end
    for i = 9 : 12
        f = f + p(i) * (8 + 2 * sqrt(3));
    end
end

%% 十字形12QAM %%
if Scheme == 4
    for i = 1 : 4
        f = f + p(i) * 2;
    end
    for i = 5 : 12
        f = f + p(i) * 10;
    end
end