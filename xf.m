function [xflat] = xf(x1,x2)
% function for arranging the input values into all 
% the possible combinations

xflat = zeros(length(x1)*length(x2),2);
% arranging the values of x1 into the first column, each value being 
% repeated of length(x1) times
for j = 0:length(x1)-1
    for i = 1+j*length(x1):(j+1)*length(x1)
        xflat(i,1) = x1(j+1);
    end
end

% arranging the values of x2 into the second column, all values being
% repeated of length(x2) times
for j = 0:length(x2)-1
    xflat(1+j*length(x1):(j+1)*length(x1),2) = x2;
end
end