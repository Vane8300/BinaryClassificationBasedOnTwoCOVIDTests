% Cu ajutorul functiei urmatoare ne vom face cost-ul
% vom folosi ideea de cate antrenate
function [F, grad] = costF(theta, P, y, lambda)
% functia primeste ca argumente: parametrul de fitting, P , label-ul si
% parametru de regularizare
    m = length(y); % reprezinta numarul de date antrenate
    %F = 0;
    %grad = zeros(size(theta));
    h = sigmoid(P * theta);
    F = (1 / m) * (-y' * log(h) - (1 - y)' *log(1 - h)) + (lambda / (2 * m)) * (theta(2:length(theta)))' * theta(2:length(theta));
    theta_zero = theta;
    theta_zero(1) = 0;
    grad = ((1 / m) * (h - y)' * P) + lambda / m * theta_zero';
end