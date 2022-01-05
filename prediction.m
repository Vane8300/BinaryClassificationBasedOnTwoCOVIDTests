% Urmatoare functie prezice daca persoana are anticorpi pentru Covid, adica
% are valoarea 1 sau 0 daca nu are anticorpi, folosind din regresia
% logistica invatata theta

function  p = prediction(theta, P)
   m = size(P, 1); 
   p = zeros(m, 1);
   p = sigmoid(P * theta) >= 0.5;
end