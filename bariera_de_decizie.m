% Vom face functia pentru plotarea barierei de decizie
% Aceasta functie ploteaza datele de intrare T1, T2 si y intr-o figura noua
% cu tot cu bariera de decizie (aceasta este definita de theta)
% In plus, aceasta la plotare va respecta urmatoarele idei:
% -> pentru persoanele cu anticorpi va plota folosind simbolul
% "cerc-albastru", iar pentru persoanele fara anticorpi va plota folosind
% simbolul "cerc-rosu'
% In plus, va contine si variabila theta_zero care are mereu valoarea 1
function bariera_de_decizie(theta, P, y)
% functia primeste ca parametrii: parametrul de fitting, P si label-ul
    plotare(P(:, 2:3), y);
    hold on;
    
    if size(P, 2) <= 3
        % pentru a trage linia, avem nevoie de doua puncte (minim)
        plot_x = [min(P(:, 2)) - 2, max(P(:, 2)) + 2]; 
        % calculam bariera de decizie
        plot_y = (-1./theta(3)).*(theta(2).*plot_x + theta(1));
        plot(plot_x, plot_y);
        
        % definirea legendei
        legend('Persoana cu anticorpi', 'Persoana fara anticorpi', 'Bariera de decizie');
        axis([30, 100, 30, 100]);
    else
        u = linspace(-1, 1.5, 50);
        v = linspace(-1, 1.5, 50); 
        z = zeros(length(u), length(v));
        for i = 1 : length(u)
                for j = 1 : length(v)
                    z(i,j) = mapFeature(u(i), v(j)) * theta;
                end
        end
        z = z';
        contour(u, v, z, [0, 0], 'LineWidth', 3);
    end
    hold off;
end