function option_price = binomial_option_pricing(rate, volatility, S0, T, K, steps)
    % Calculate parameters
    dt = T / steps;                                                             % Delta t calculation
    beta = 0.5 * (exp(-rate * dt) + exp((rate + (volatility ^ 2)) * dt));       % Parameter of u
    u = beta + sqrt((beta ^ 2) - 1);                                            % Up movement factor
    d = 1 / u;                                                                  % Down movement factor
    p = 1 - (exp(rate * dt) - d) / (u - d);                                     % Probability of up movement
    

    % Initialize option price and underlying price matrix
    option_price = zeros(steps + 1, steps + 1);
    stock_price = zeros(steps + 1, steps + 1);


    % PRICE OF UNDERLYING

    % Calculate the stock prices matrix at max up factor
    for t = 1:steps+1
        for i = 1:t
            if i == 1 && t == 1
                stock_price(1, 1) = S0;
            else
                stock_price(i, t) = stock_price(i, t - 1) * u;
            end
        end
    end
    
    % Populate the rest of the rows down multiplying by d
    for t = 1:steps+1
        for i = 1:t
            if i > 1
                stock_price(i, t) = stock_price(i-1, t-1) * d;
            end
        end
    end


    % PRICE OF OPTION

    % populate option matrix at t=T
    for i = 0:steps
        option_price(i + 1, steps + 1) = max(K - (S0 * (u ^ i) * (d ^ (steps - i))), 0);
    end
    
    % Backward phase
    for t = steps:-1:1
        for i = 1:t
            option_price(i, t) = exp(-rate * dt) * (p * option_price(i, t + 1) + (1 - p) * option_price(i + 1, t + 1));
        end
    end
    
    option_price = option_price(1, 1);
end
