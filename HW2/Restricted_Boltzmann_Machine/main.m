% Restricted Boltzmann Machine
clear all

x1 = [-1, -1, -1];
x2 = [1, -1, 1];
x3 = [-1, 1, 1];
x4 = [1, 1, -1];
x5 = [1, 1, 1];
x6 = [-1, 1, -1];
x7 = [1, -1, -1];
x8 = [-1, -1, 1];

X = [x1; x2; x3; x4; x5; x6; x7; x8];
M = [1, 2, 4, 8];

nHidden = size(M, 2);
nVisible = 3;
ntrials = 1000;
counter = 1;
k = 200;
eta = 0.005;
N_out = 3000;
N_in = 2000;
D_klFinal = [];

for numberOfHiddenNeurons = 1:nHidden
    visibleNeuron = zeros(nVisible,1);
    hiddenNeuron = zeros(M(numberOfHiddenNeurons),1);
    thresholdHidden = zeros(M(numberOfHiddenNeurons), 1);
    thresholdVisible = zeros(nVisible, 1);
    weights = randn(M(numberOfHiddenNeurons), nVisible);
    
    for c = 1:counter
        for trial = 1:ntrials
            delta_weights = zeros(M(numberOfHiddenNeurons), nVisible);
            delta_theta_h = zeros(M(numberOfHiddenNeurons), 1);
            delta_theta_v = zeros(nVisible, 1);

            for minibatches = 1:20
                patternIndex = randi(4);
                visibleNeuron = X(patternIndex, :)';
                visibleNeuron_0 = visibleNeuron;
                bh = weights * visibleNeuron - thresholdHidden;
                bh_0 = bh;
                prob_bh_0 = (1 + exp(-2 * bh_0)) .^ (-1);

                for i = 1:M(numberOfHiddenNeurons)
                    if rand<prob_bh_0(i)
                        hiddenNeuron(i) = 1;
                    else
                        hiddenNeuron(i) = -1;
                    end
                end
                for t = 1:k
                    bv = (hiddenNeuron' * weights)' - thresholdVisible;
                    p_bv = (1 + exp(-2 * bv)) .^ (-1);
                    for j = 1:nVisible
                        if rand<p_bv(j)
                            visibleNeuron(j) = 1;
                        else
                            visibleNeuron(j) = -1;
                        end
                    end

                    bh = weights * visibleNeuron - thresholdHidden;
                    prob_bh = (1 + exp(-2 * bh)) .^ (-1);
                    for i = 1:M(numberOfHiddenNeurons)
                        if rand<prob_bh(i)
                            hiddenNeuron(i) = 1;
                        else
                            hiddenNeuron(i) = -1;
                        end
                    end
                end
                delta_weights = delta_weights + eta * (tanh(bh_0) * visibleNeuron_0' - tanh(bh) * visibleNeuron');
                delta_theta_v = delta_theta_v -eta * (visibleNeuron_0 - visibleNeuron);
                delta_theta_h = delta_theta_h -eta * (tanh(bh_0) - tanh(bh));
            end
            weights = weights +delta_weights;
            thresholdVisible = thresholdVisible + delta_theta_v;
            thresholdHidden = thresholdHidden + delta_theta_h;
        end
        probBoltzmann = zeros(1, 8);
        for outerLoop = 1:N_out
            patternIndex = randi(8);
            visibleNeuron = X(patternIndex, :)';
            bh = weights * visibleNeuron - thresholdHidden;
            prob_bh = (1 + exp(-2 * bh)) .^ (-1);

            for i = 1:M(numberOfHiddenNeurons)
                if rand<prob_bh(i)
                    hiddenNeuron(i) = 1;
                else
                    hiddenNeuron(i) = -1;
                end
            end

            for innerLoop = 1:N_in
                bv = (hiddenNeuron' * weights)' - thresholdVisible;
                p_bv = (1 + exp(-2 * bv)) .^ (-1);

                for j = 1:nVisible
                    if rand<p_bv(j)
                        visibleNeuron(j) = 1;
                    else
                        visibleNeuron(j) = -1;
                    end
                end
                bh = weights * visibleNeuron - thresholdHidden;
                prob_bh = (1 + exp(-2 * bh)) .^ (-1);

                for i = 1:M(numberOfHiddenNeurons)
                    if rand<prob_bh(i)
                        hiddenNeuron(i) = 1;
                    else
                        hiddenNeuron(i) = -1;
                    end
                end
                for i = 1:8
                    if isequal(visibleNeuron,X(i,:)')
                        probBoltzmann(i) = probBoltzmann(i) + 1;
                    end
                end
            end
        end
        probBoltzmann = probBoltzmann / (N_in * N_out);
        for patternIndex = 1:8
            if patternIndex <5
                probD(patternIndex) = 0.25;
                logD(patternIndex) = log(probD(patternIndex));
            else
                probD(patternIndex) = 0;
                logD(patternIndex) = 0;
            end
        end
        for i = 1:8
            if probBoltzmann(i) == 0
                logBoltzmann(i) = 0;
            else
                logBoltzmann(i) = log(probBoltzmann(i));
            end
        end
        D_kl = 0;
        for i = 1:8
            D_kl = D_kl + probD(i) * (logD(i) - logBoltzmann(i));
        end
    end
    D_klFinal = [D_klFinal,D_kl]
end


%%
M1 = [1,2,3,4,8];
D_klTheoretical = zeros(5, 1);

for i = 1:5
    nHidden = M1(i);
    if nHidden >= 2^(nVisible-1)-1
        continue
    end
    logarithm = floor(log2(nHidden+1));
    D_klTheoretical(i) = log(2) * (nVisible - logarithm - (nHidden+1)/(2^logarithm));
end

hold on;
plot(M1, D_klTheoretical);
scatter(M, D_klFinal);
legend('theoretical upper bound', 'numerical estimates');
xlabel('Number of Hidden Neurons' );
ylabel('Kullback-Leibler Divergence' );
hold off;








