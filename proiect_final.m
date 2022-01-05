clear; close all; clc;
%% Datele
% datele le vom lua dintr-un fisier .txt, structura acestuia fiind
% urmatoarea: primele 2 coloane reprezinta datele pentru P, iar a treia
% coloana contine eticheta pentru y (label)

data = load('fisier_date_de_input.txt');
P = data(:, [1, 2]);
y = data(:, 3);

% verificare pentru incarcarea datelor
% disp('verificare incarcare pentru P;');
% disp(P);
% disp('verificare incarcare pentru y');
% disp(y);

figure; 
hold on;
% Gasirea persoanelor care au anticorpi, deci sunt pozitive si a
% persoanelor fara anticorpi, adica sunt negative
pers_cu_anticorpi = find(y == 1);
pers_fara_anticorpi = find(y == 0);
% Plotarea datelor de intrare dupa regula urmatoare:
% -> persoanele cu anticorpi au simbolul "cerc-albastru"
% -> persoanele fara anticorpi au simbolul "cerc-rosu"
plot(P(pers_cu_anticorpi, 1), P(pers_cu_anticorpi, 2), 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 7);
plot(P(pers_fara_anticorpi, 1), P(pers_fara_anticorpi, 2), 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 7);

hold off;
hold on;

% Definirea legendei tabelului
xlabel('Test anticorpi 1');
ylabel('Test anticorpi 2');
legend('y = 1 (pozitiv)', 'y = 0 (negativ)');

hold off;

%% Regularizarea logistica
% In aceasta sectiune a aplicatie vrem sa utilizam regularizarea logistica
% pentru a clasifica datele de intrare.
% In schimb, ele nu pot fi separate liniar, de aceea o sa avem nevoie sa
% introducem niste caracteristici polinomiale (vezi formularea matematica,
% si functia implementata pentru mai multe detalii)

% Caracteristicile polinomiale le adaugam cu ajutorul functie mapFeature
 P = mapFeature(P(:, 1), P(:, 2));
 
% Ulterior vom avea dnevoie de parametrii de fiting, deci ii vom initializa
theta_initial = zeros(size(P, 2), 1);

lambda = 1; % am setat parametrul de regularizare

[F, grad] = costF(theta_initial, P, y, lambda); % am calculat cost-ul,
% folosind functia costF implementata

% afisam cost-ul si gradientul
fprintf('Cost-ul pentru parametrul de fitting initial este: %f\n', F);
fprintf('Gradientul la parametru de fitting initial este: \n');
fprintf('%f\n', grad);

%% Metoda Newton -> pas constant
% Initializare
w = zeros(size(P, 2), 1);
iter = 0;
alpha = 1;
n = length(y);
x = mapFeature(P(:, 1), P(:, 2));
h = sigmoid(P * w);

% definim functia cost-ului
cost = @(w)1/n * (-log(sigmoid(w' * x)) * y - log(ones(1, n) - sigmoid(w' * x)) * (ones(n, 1) - y));
% calculam gradientul in w_0
grad = 1/n * (sigmoid(w'*x') - y') * x;
% calculam Hessiana in w_0
H = 1/n * x' * diag(sigmoid(w' * x').*(ones(1, n) - sigmoid(w' * x'))) * x;
% calculam diresctia Newton
newton_direction_0 = H / grad;
newton_direction = newton_direction_0;
norma = norm(grad);
normPasIdeal = norma;
norma = normPasIdeal(1);
normPasConst = norma;

while (norma > 0.001 && iter < 100000)
    % actualizam pasul
    w = w - alpha * newton_direction;
    % actualizam gradientul
    grad = 1/n * (sigmoid(w' * x') - y') * x;
    % actualizam Hessiana 
    H = 1/n * x' * diag(sigmoid(w' * x').*(ones(1, n) - sigmoid(w' * x'))) * x;
    newton_direction_0 = H /  grad;
    norma = norm(grad);
    normPasConst = [normPasConst, norma];
    iter = iter + 1;
end
w_mnConst = w;
%% Regularizarea 
% In aceasta parte, ii dam diferite valori parametrului de regularizare
% pentru a vedeam cum afecteaza regularizarea

% Initializam parametrul de fitting
theta_initial = zeros(size(P, 2), 1);

%% Pentru lambda = 0
% setam parametrul de regularizare mai intai cu 0
lambda = 0;

% setam optiunile de functionare
options = optimset('GradObj', 'on', 'MaxIter', 400);

[theta, F, ~] = fminunc(@(t)(costF(t, P, y, lambda)), theta_initial, options);

fprintf('Cost-ul pentru theta obtinut din fminunc este: %f\n', F);
%fprintf('theta este: \n');
%fprintf(' %f\n', theta);

% Plotam bariera de decizie
bariera_de_decizie(theta, P, y);
hold on;
title(sprintf('lambda = %g', lambda));

xlabel('Test anticorpi 1');
ylabel('Test anticorpi 2');
legend('y = 1 (pozitiv)', 'y = 0 (negativ)', 'Bariera de decizie')
hold off;

% calcularea setului de date
p = prediction(theta, P);
fprintf('Acuratetea antrenamentului: %f\n', mean(double(p == y)) * 100);

%% Pentru lambda = 1

% setam parametrul de regularizare mai intai cu 0
lambda = 1;

% setam optiunile de functionare
options = optimset('GradObj', 'on', 'MaxIter', 400);

[theta, F, ~] = fminunc(@(t)(costF(t, P, y, lambda)), theta_initial, options);

fprintf('Cost-ul pentru theta obtinut din fminunc este: %f\n', F);
%fprintf('theta este: \n');
%fprintf(' %f\n', theta);

% Plotam bariera de decizie
bariera_de_decizie(theta, P, y);
hold on;
title(sprintf('lambda = %g', lambda));

xlabel('Test anticorpi 1');
ylabel('Test anticorpi 2');
legend('y = 1 (pozitiv)', 'y = 0 (negativ)', 'Bariera de decizie')
hold off;

% calcularea setului de date
p = prediction(theta, P);
fprintf('Acuratetea antrenamentului: %f\n', mean(double(p == y)) * 100);

%% Pentru lambda = 5
% setam parametrul de regularizare mai intai cu 0
lambda = 5;

% setam optiunile de functionare
options = optimset('GradObj', 'on', 'MaxIter', 400);

[theta, F, ~] = fminunc(@(t)(costF(t, P, y, lambda)), theta_initial, options);

fprintf('Cost-ul pentru theta obtinut din fminunc este: %f\n', F);
%fprintf('theta este: \n');
%fprintf(' %f\n', theta);

% Plotam bariera de decizie
bariera_de_decizie(theta, P, y);
hold on;
title(sprintf('lambda = %g', lambda));

xlabel('Test anticorpi 1');
ylabel('Test anticorpi 2');
legend('y = 1 (pozitiv)', 'y = 0 (negativ)', 'Bariera de decizie')
hold off;

% calcularea setului de date
p = prediction(theta, P);
fprintf('Acuratetea antrenamentului: %f\n', mean(double(p == y)) * 100);

%% Pentru lambda = 10
% setam parametrul de regularizare mai intai cu 0
lambda = 10;

% setam optiunile de functionare
options = optimset('GradObj', 'on', 'MaxIter', 400);

[theta, F, ~] = fminunc(@(t)(costF(t, P, y, lambda)), theta_initial, options);

fprintf('Cost-ul pentru theta obtinut din fminunc este: %f\n', F);
%fprintf('theta este: \n');
%fprintf(' %f\n', theta);

% Plotam bariera de decizie
bariera_de_decizie(theta, P, y);
hold on;
title(sprintf('lambda = %g', lambda));

xlabel('Test anticorpi 1');
ylabel('Test anticorpi 2');
legend('y = 1 (pozitiv)', 'y = 0 (negativ)', 'Bariera de decizie')
hold off;

% calcularea setului de date
p = prediction(theta, P);
fprintf('Acuratetea antrenamentului: %f\n', mean(double(p == y)) * 100);
