%% Initial data
clear all
% loading the initial data
load('proj_fit_04.mat');

% identification data
x1_id = id.X{1,1};
x2_id = id.X{2,1};
y_id = id.Y;

% validation data
x1_val = val.X{1,1};
x2_val = val.X{2,1};
y_val = val.Y;

% plotting the identification data
surf(x1_id,x2_id,y_id) 
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title('Identification data')

% plotting the validation data
figure
surf(x1_val,x2_val,y_val)
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title('Validation data')

%% Arranging the data in convenable form
% the number of identification output values
N_id = length(y_id);
% the number of validation output values
N_val = length(y_val);

% arranging the input values (both identification and validation) into all 
% the possible combinations
xflat_id = xf(x1_id,x2_id);
xflat_val = xf(x1_val,x2_val);

% arranging the output values (both identification and validation) into a
% column
yflat_id = reshape(y_id',N_id^2,1);
yflat_val = reshape(y_val',N_val^2,1);

% variables in which we stored the first, respectively the second column of
% xflat_id and xflat_val
xf1_id = xflat_id(:,1)';
xf2_id = xflat_id(:,2)';
xf1_val = xflat_val(:,1)';
xf2_val = xflat_val(:,2)';

%% Finding the model and its best performance
% tuning the polynomial degree in order to obtain the best performance of
% the model
m = 1:30;

% array in which will be stored all MSEs on identification and validation
mse_id = zeros(1,length(m));
mse_val = zeros(1,length(m));

for i = 1:30
    % i represents the degree m
    
    % computing the regressors for both the identification and validation
    % data inputs
    phi_id = regressor(i,xf1_id,xf2_id);
    phi_val = regressor(i,xf1_val,xf2_val);
    
    % finding the unknown parameters of the polynomial approximator which
    % will be stored in theta
    theta = phi_id\yflat_id;
    
    % approximated values of the identification output
    yhat_id = phi_id*theta;
    
    % approximated values of the validation output
    yhat_val = phi_val*theta;
    
    % computing the mean squared error on identification data
    mse_id(i) = 1/N_id*sum((yhat_id'-yflat_id').^2);
    % computing the mean squared error on validation data
    mse_val(i) = 1/N_val*sum((yhat_val'-yflat_val').^2);
end

% plotting the mse_id and mse_val vectors depending on the degree m
figure
subplot(121), plot(m,mse_id)
xlabel('m'), ylabel('MSE')
title({'The mean squared errors','on identification data'})
subplot(122), plot(m,mse_val)
xlabel('m'), ylabel('MSE')
title({'The mean squared errors','on validation data'})
sgtitle('The mean squared errors depending on m')

% finding the minimal MSE on validation and the corresponding degree m
[mse_min,m_best] = min(mse_val,[],'linear');

%% Computing the approximated values of the outputs
% computing the regressors for both the identification and validation
% data inputs using the optimal degree m
phi_id_final = regressor(m_best,xf1_id,xf2_id);
phi_val_final = regressor(m_best,xf1_val,xf2_val);

% finding the unkonwn parameters of the polynomial approximator which
% will be stored in theta
theta_final = phi_id_final\yflat_id;

% the model (the best approximated values of the output on identification) 
yhat_id_best = phi_id_final*theta_final;
% the model (the best approximated values of the output on validation) 
yhat_val_best = phi_val_final*theta_final;

% the final approximated values arranged in a matrix of the same size as
% the matrix with the true output values
yhat_id_final = reshape(yhat_id_best,N_id,N_id)';
yhat_val_final = reshape(yhat_val_best,N_val,N_val)';

%% Representative graphs with the true and approximated values of the outputs
% plotting the identification data
figure
subplot(121)
surf(x1_id,x2_id,y_id)
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title({'True values of the','identification output'})
% plotting the approximated values of the identification outputs
subplot(122)
surf(x1_id,x2_id,yhat_id_final)
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title({'Approximated values of the','identification output'})

% graph with the comparison between the true identification output values
% and the approximated values
figure
surf(x1_id,x2_id,y_id), hold on
surf(x1_id,x2_id,yhat_id_final)
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title({'Comparison between the true values and the approximated values','of the identification outputs'})

% plotting the validation data
figure
subplot(121)
surf(x1_val,x2_val,y_val)
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title({'True values of the','validation output'})
% plotting the approximated values
subplot(122)
surf(x1_val,x2_val,yhat_val_final)
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title({'Approximated values of the','validation output'})

% graph with the comparison between the true validation output values
% and the approximated values
figure
surf(x1_val,x2_val,y_val), hold on
surf(x1_val,x2_val,yhat_val_final)
xlabel('x_1'), ylabel('x_2'), zlabel('y')
title({'Comparison between the true values and the approximated values','of the validation outputs'})
