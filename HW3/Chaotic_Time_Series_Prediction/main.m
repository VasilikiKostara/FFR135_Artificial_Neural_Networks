% chaotic time series
clc
clear

trainSet = readmatrix('training-set.csv');
testSet = readmatrix('test-set-6');

nReservoir = 500;
nInputs = 3;

sigmaInput = sqrt(.002);
sigmaOutput = sqrt(.004);

ridgeParameter = 0.01;
timeSteps = 500;

weightsInput = randn(nReservoir, nInputs) * sigmaInput;
weightsReservoir = randn(nReservoir);

reservoir = zeros(nReservoir, 1);
storedReservoir = zeros(nReservoir, length(trainSet));

for k = 1:(length(trainSet) - 1)
    input = trainSet(:, k);
    storedReservoir(:, k) = reservoir(:);
    reservoir = tanh(weightsReservoir * reservoir + weightsInput * input);
end

weightsOutput = trainSet * storedReservoir' * (storedReservoir * storedReservoir' + ridgeParameter * eye(nReservoir));

for n = 1:(length(testSet) - 1)
    input = testSet(:, n);
    storedReservoir(:, n) = reservoir(:);
    reservoir = tanh(weightsReservoir * reservoir + weightsInput * input);
end

output = weightsOutput * reservoir;
predictions = zeros(nInputs, timeSteps);

for t = 1:timeSteps
    reservoir = tanh(weightsReservoir * reservoir + weightsInput * output);
    output = weightsOutput * reservoir;
    predictions(:, t) = output;
end

writematrix(predictions(2, :), "prediction.csv");