function [phi] = regressor(m,x1,x2)
% computing the number of columns of the regressor depending on the 
% degree m
nr_columns = sum(1:m+1);

phi = zeros(length(x1),nr_columns);
for line = 1:length(x1)
    column = 1;
    for i = 0:m
        for j = 0:m
            if (i+j) <= m % the sum of the exponents cannot exceed the degree m
                % the regressors are combinations of powers of x1 and x2
                    phi(line,column) = (x1(line)^i)*(x2(line)^j);
                    
                    % moving to the next column
                    column = column+1;
            end
        end
    end
end
end