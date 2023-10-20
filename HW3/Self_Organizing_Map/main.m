% Self organizing map
clc
clear

irisLabels = table2array(readtable( "iris-labels.csv"));
irisData = table2array(readtable( "iris-data.csv"));
nInstances = size(irisData, 1);

nAttributes = size(irisData, 2);
nEpochs = 10;
nPatterns = 3;
normalizationFactor = max(irisData);
etaInitial = 0.1;
etaDecay = 0.01;
widthInitial = 10;
widthDecay = 0.05;
mapSize = 40;

weights = randn(mapSize,mapSize,nAttributes);
locationInitial = zeros(nInstances, nPatterns);
locationFinal = zeros(nInstances, nPatterns);
irisData = irisData ./ normalizationFactor;

for instance = 1:nInstances
    input = irisData(instance, :);
    minDistance = inf;
    for i = 1:mapSize
        for j = 1:mapSize

            distance = 0;
            for k = 1:nAttributes
                distance = distance + (weights(i, j, k) - input(k))^2;
            end

            if distance <= minDistance
                minDistance = distance;
                iWinning = i;
                jWinning = j;
            end
        end
    end
    locationInitial(instance, :) = [iWinning, jWinning, irisLabels(instance)];
end


for epoch = 1:nEpochs
    eta = etaInitial * exp(-etaDecay * epoch);
    width = widthInitial * exp(-widthDecay *epoch);
    for instance = 1:nInstances
        inputIndex = randi(nInstances);
        input = irisData(inputIndex, :);
        minDistance = inf;
        for i = 1:mapSize
            for j = 1:mapSize
    
                distance = 0;
                for k = 1:nAttributes
                    distance = distance + (weights(i, j, k) - input(k))^2;
                end
                if distance <= minDistance
                    minDistance = distance;
                    iMin = i;
                    jMin = j;
                    winningPosition = [iMin, jMin];
                end
            end
        end

        for i = 1:mapSize
            for j = 1:mapSize
                neighbourhoodFunction = exp(-norm([i, j] - winningPosition)^2/(2 * width^2));
                if neighbourhoodFunction < 3 * width
                    for k = 1:nAttributes
                        deltaWeights = eta * neighbourhoodFunction * (input(k) - weights(i, j, k));
                        weights(i, j, k) = weights(i, j, k) + deltaWeights;
                    end
                end
            end
        end
    end
end

for instance = 1:nInstances
    input = irisData(instance, :);
    minDistance = inf;
    for i = 1:mapSize
        for j = 1:mapSize
            distance = 0;
            for k = 1:nAttributes
                distance = distance + (weights(i, j, k) - input(k))^2;
            end
            if distance <= minDistance
                minDistance = distance;
                iWinning = i;
                jWinning = j;
            end
        end
    end
    locationFinal(instance, :) = [iWinning, jWinning, irisLabels(instance)];
end

subplot(1,2,1);
gscatter(locationInitial(:, 1), locationInitial(:, 2), locationInitial(:, 3));
legend('Iris Setosa', 'Iris Versicolour', 'Iris Virginica');

subplot(1,2,2);
gscatter(locationFinal(:, 1), locationFinal(:, 2), locationFinal(:, 3));
legend('Iris Setosa', 'Iris Versicolour', 'Iris Virginica');

