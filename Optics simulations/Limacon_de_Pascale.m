% Plot several Limaçons of Pascal as a function of a and b

% Define parameter grids
a_vals = [0.1:0.1:0.9]; % Rows
b_vals = [0.15];   % Columns

% Define angle domain
theta = linspace(0, 2*pi, 1000);

% Create figure window
figure(3)

% Main title
sgtitle('r = 2(a*cos(theta) - b)', ...
    'Interpreter', 'latex', 'FontSize', 16, 'FontWeight', 'bold');

% Loop through parameter combinations
for i = 1:length(a_vals)
        a = a_vals(i);
        b = b_vals(1);
        
        % Calculate radius and convert to Cartesian coordinates
        r = 2 * (a * cos(theta) - b);
        x = r .* cos(theta);
        y = r .* sin(theta);
        
        % Subplot index calculation
        subplot_idx = i;
        subplot(3, 3, subplot_idx);
        
        % Plot the limaçon
        plot(x, y, 'b-', 'LineWidth', 1.8);
        hold on;
        
        % Format plot aesthetics
        grid on; axis equal;
        xline(0, 'k--', 'Alpha', 0.3);
        yline(0, 'k--', 'Alpha', 0.3);
        
        title(sprintf('a = %.2f, b = %.2f (%s)', a, b), ...
            'FontSize', 10);
        xlabel('x'); ylabel('y');
        xlim([-2 2])
        ylim([-2 2])

end