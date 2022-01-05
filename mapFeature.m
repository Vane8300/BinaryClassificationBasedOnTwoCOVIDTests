% Cu ajutorul functiei implementate aici, ne vom transforma termenii T1 si
% T2 in termeni polinominali pana la puterea a6-a
% In plus, din formularea matematica, observam ca termenii vor fi de forma:
% 1, T1, T2, T1^2, T1*T2, T2^2, T1^3,..., T1*(T2^5), T2^6
function map = mapFeature(T1, T2)
    order = 6;
    map = ones(size(T1(:, 1)));
    for i = 1 : order
            for j = 0 : i
                map(:, end + 1) = (T1.^(i - j)).*(T2.^j);
            end
    end
end