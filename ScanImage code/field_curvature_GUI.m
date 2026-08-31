function field_curvature_GUI

    % Create figure and axes
    fig = figure('Name', 'Piecewise Editor', 'NumberTitle', 'off', ...
                 'MenuBar', 'none', 'ToolBar', 'none', 'Position', [500, 300, 700, 400]);
    ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
    hold(ax, 'on'); grid(ax, 'on');
    xlim(ax, [0 1]); ylim(ax, [-20 95]);
    xlabel(ax, 'Slow scanning axis'); ylabel(ax, 'Z-scanning axis');
    
    % Initial points (fixed at x = 0 and x = 1)
    xData = [0 1];
    yData = [0 0];
    smoothedY = [];
    smoothFactor = 0.2; % Default smoothness
    PiecewisePlot = plot(ax, xData, yData, 'k-', 'LineWidth', 2);
    pointPlot = plot(ax, xData, yData, 'bo', 'MarkerFaceColor', 'r', 'MarkerSize', 6);
    
    % Add mouse click callback
    set(fig, 'WindowButtonDownFcn', @mouseClick);
    set(fig, 'WindowButtonUpFcn', @mouseRelease);
    set(fig, 'WindowButtonMotionFcn', @mouseMove);
    
    draggingIdx = [];
    
    % Create buttons
    uicontrol('Style', 'pushbutton', 'String', 'Reset', 'Position', [50, 20, 80, 30], ...
              'Callback', @resetPlot);
    uicontrol('Style', 'pushbutton', 'String', 'Save', 'Position', [150, 20, 80, 30], ...
              'Callback', @saveData);
    uicontrol('Style', 'pushbutton', 'String', 'Save As', 'Position', [250, 20, 80, 30], ...
              'Callback', @saveAsData);  % Save As button
    uicontrol('Style', 'pushbutton', 'String', 'Load', 'Position', [350, 20, 80, 30], ...
              'Callback', @loadData);  % Load button
    
    % Create smoothness slider
    uicontrol('Style', 'text', 'String', 'Smoothness', 'Position', [450, 25, 100, 20]);
    smoothSlider = uicontrol('Style', 'slider', 'Min', 0, 'Max', 1, 'Value', smoothFactor, ...
                             'Position', [550, 20, 150, 30], 'Callback', @updateSmoothness);
    
    function mouseClick(~, event)
        pt = get(ax, 'CurrentPoint');
        xClick = pt(1,1); yClick = pt(1,2);
        
        dists = sqrt((xData - xClick).^2);
        [minDist, idx] = min(dists);
        
        if strcmp(event.Source.SelectionType, 'alt') && minDist < 0.05 && idx > 1 && idx < length(xData)
            % Right-click to delete a point (except fixed ones)
            xData(idx) = [];
            yData(idx) = [];
            updatePiecewise();
        elseif minDist < 0.05 && idx >= 1 && idx <= length(xData)
            % Drag existing point
            draggingIdx = idx;
        elseif xClick > 0 && xClick < 1
            % Add new point
            xData = [xData, xClick];
            yData = [yData, yClick];
            
            % Sort by x values
            [xData, idx] = sort(xData);
            yData = yData(idx);
            
            updatePiecewise();
        end
    end
    
    function mouseMove(~, ~)
        if ~isempty(draggingIdx)
            pt = get(ax, 'CurrentPoint');
            newX = min(max(pt(1,1), 0), 1); % Ensure x stays in range [0,1]
            newY = min(max(pt(1,2),-10),85);
            
            if draggingIdx == 1 || draggingIdx == length(xData)
                % Fixed x for first and last points, only move in y-direction
                yData(1) = newY;
                yData(length(xData)) = newY;
            else
                % Move freely in both x and y directions
                xData(draggingIdx) = newX;
                yData(draggingIdx) = newY;
                
                % Keep points sorted after dragging in x-direction
                [xData, sortIdx] = sort(xData);
                yData = yData(sortIdx);
                
                % Update dragging index in case it moved after sorting
                draggingIdx = find(sortIdx == draggingIdx, 1);
            end
            
            updatePiecewise();
        end
    end
    
    function mouseRelease(~, ~)
        draggingIdx = [];
    end
    
    function updatePiecewise()
        xx = linspace(0, 1, 1000);
        try
            yy = interp1(xData, yData, xx, 'linear');
    
            % Perform smoothing using periodic conditions
            nb_datapoints = numel(yy);
            yy = [yy,yy,yy];
            
            % Apply smoothing but keep y-values at x = 0 and x = 1 fixed
            smoothedY = smoothdata(yy, 'movmean', round(smoothFactor * 200 + 1));
            
            % Retrieve center part
            smoothedY = smoothedY(nb_datapoints+1:nb_datapoints*2);
            
            smoothedY = min(max(smoothedY,0),75);
            
            set(PiecewisePlot, 'XData', xx, 'YData', smoothedY);
            set(pointPlot, 'XData', xData, 'YData', yData);
        catch ME
            disp(['Error: ',ME.message])
        end
    end
    
    function updateSmoothness(~, ~)
        smoothFactor = get(smoothSlider, 'Value');
        updatePiecewise();
    end
    
    function resetPlot(~, ~)
        xData = [0 1];
        yData = [0 0];
        updatePiecewise();
    end
    
    function saveData(~, ~)
        path = 'C:\Scanimage\SI-Premium_2023\field_curvature';
        file = 'Piecewise_data.mat';
        if ischar(file)
            save(fullfile(path, file), 'xData','yData','smoothedY');
            disp(['Z-scanning trajectory saved to ', fullfile(path, file)]);
        end
    end

    % Save As function
    function saveAsData(~, ~)
        [file, path] = uiputfile('*.mat', 'Save As');
        if ischar(file)
            save(fullfile(path, file), 'xData','yData', 'smoothedY');
            disp(['Z-scanning trajectory saved to ', fullfile(path, file)]);
        end
    end
    
    % Load function
    function loadData(~, ~)
        [file, path] = uigetfile('*.mat', 'Load Data');
        if ischar(file)
            loadedData = load(fullfile(path, file));
            if isfield(loadedData, 'xData') && isfield(loadedData, 'smoothedY') && isfield(loadedData, 'yData')
                xData = loadedData.xData;
                smoothedY = loadedData.smoothedY;
                yData = loadedData.yData;
                [xData, sortIdx] = sort(xData);
                updatePiecewise();
                disp(['Data loaded from ', fullfile(path, file)]);
            else
                disp('Loaded file does not contain the correct variables.');
            end
        end
    end

end
