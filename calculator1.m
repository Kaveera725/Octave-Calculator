function scientific_calculator
    f = figure('Name', 'Scientific Calculator', ...
              'Position', [300 300 400 600], ...
              'MenuBar', 'none', ...
              'NumberTitle', 'off', ...
              'Color', [0.9 0.9 0.9]);

    display = uicontrol('Style', 'edit', ...
                       'Position', [20 520 360 60], ...
                       'String', '0', ...
                       'HorizontalAlignment', 'right', ...
                       'FontSize', 16, ...
                       'BackgroundColor', 'white');

    btn_width = 65;
    btn_height = 50;
    gap = 10;

    buttons = {
        'log', 'ln', '%', 'DEL', 'AC';
        'mod', 'asin', 'acos', 'atan', 'π';
        'sqrt', 'sin', 'cos', 'tan', 'e';
        '7', '8', '9', '/', '^';
        '4', '5', '6', '*', '(';
        '1', '2', '3', '-', ')';
        '0', '.', ',', '+', '='
    };

    start_x = 20;
    start_y = 450;

    for row = 1:size(buttons, 1)
        for col = 1:size(buttons, 2)
            if ~isempty(buttons{row, col})
                x_pos = start_x + (col-1)*(btn_width + gap);
                y_pos = start_y - (row-1)*(btn_height + gap);
                if ismember(buttons{row, col}, {'0','1','2','3','4','5','6','7','8','9','.'})
                    bgcolor = [1 1 1];
                elseif ismember(buttons{row, col}, {'DEL','AC'})
                    bgcolor = [1 0.8 0.8];
                elseif strcmp(buttons{row, col}, '=')
                    bgcolor = [0.8 0.9 1];
                elseif ismember(buttons{row, col}, {'+','-','*','/','^','(',')'})
                    bgcolor = [0.9 0.9 1];
                else
                    bgcolor = [0.9 1 0.9];
                end
                create_button(buttons{row, col}, [x_pos y_pos btn_width btn_height], display, bgcolor);
            end
        end
    end
end

function create_button(label, position, display, bgcolor)
    btn = uicontrol('Style', 'pushbutton', ...
                   'String', label, ...
                   'Position', position, ...
                   'FontSize', 12, ...
                   'BackgroundColor', bgcolor);

    switch label
        case {'0','1','2','3','4','5','6','7','8','9','.','+','-','*','/','^','(',')'}
            set(btn, 'Callback', {@append_display, display, label});
        case {'sin','cos','tan','asin','acos','atan','log','ln','sqrt'}
            set(btn, 'Callback', {@append_function, display, label});
        case 'π'
            set(btn, 'Callback', {@append_display, display, 'pi'});
        case 'e'
            set(btn, 'Callback', {@append_display, display, '2.71828182846'});
        case 'mod'
            set(btn, 'Callback', {@append_display, display, ' rem('});
        case '%'
            set(btn, 'Callback', {@append_display, display, '/100'});
        case '='
            set(btn, 'Callback', {@calculate, display});
        case 'AC'
            set(btn, 'Callback', {@clear_display, display});
        case 'DEL'
            set(btn, 'Callback', {@backspace, display});
    end
end

function append_display(~, ~, display, value)
    current = get(display, 'String');
    if strcmp(current, '0') && ~strcmp(value, '.') && ~ismember(value, {'+','-','*','/','^'})
        set(display, 'String', value);
    else
        set(display, 'String', [current value]);
    end
end

function append_function(~, ~, display, func)
    current = get(display, 'String');
    if strcmp(current, '0')
        set(display, 'String', [func '(']);
    else
        set(display, 'String', [current func '(']);
    end
end

function calculate(~, ~, display)
    try
        expr = get(display, 'String');
        expr = strrep(expr, 'ln', 'log');
        expr = strrep(expr, 'log', 'log10');
        expr = strrep(expr, 'π', 'pi');
        result = eval(expr);
        formatted_result = num2str(result, '%g');
        set(display, 'String', formatted_result);
    catch
        set(display, 'String', 'Error');
    end
end

function clear_display(~, ~, display)
    set(display, 'String', '0');
end

function backspace(~, ~, display)
    current = get(display, 'String');
    if length(current) > 1
        set(display, 'String', current(1:end-1));
    else
        set(display, 'String', '0');
    end
end



