% initial vom gasi persoanele care au iesit pozitive, 
% adica care au anticorpi Covid
% si persoanele care au iesit negative, adica care nu au anticorpi Covid

% vom plota persoanele care au anticorpi covid cu simbolul "cerc-albastru", 
% iar persoanele care nu au acesti anticorpi cu simbolul "cerc-rosu"
function plotare(P, y)
    figure; hold on;
    pers_cu_anticorpi = find(y == 1);
    pers_fara_anticorpi = find(y == 0);
    plot(P(pers_cu_anticorpi, 1), P(pers_cu_anticorpi, 2), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
    plot(P(pers_fara_anticorpi, 1), P(pers_fara_anticorpi, 2), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 7);
end