% One-Layer Perceptron

nHidden = 20;
nInputs = 2;
nOutputs = 1;
nEpochs = 10000;
eta = 0.005;

trainingSet = table2array(readtable("training_set.csv"));
validationSet = table2array(readtable("validation_set.csv"));

x1_Train = trainingSet(:, 1);
x2_Train = trainingSet(:, 2);
x1_Valid = validationSet(:, 1);
x2_Valid = validationSet(:, 2);

x1_Train = (x1_Train - mean(x1_Train)) / std(x1_Train);
x2_Train = (x2_Train - mean(x2_Train)) / std(x2_Train);
x1_Valid = (x1_Valid - mean(x1_Valid)) / std(x1_Valid);
x2_Valid = (x2_Valid - mean(x2_Valid)) / std(x2_Valid);

x_Train = [x1_Train, x2_Train];
x_Valid = [x1_Valid, x2_Valid];
t_Train = trainingSet(:, 3);
t_Valid = validationSet(:, 3);

sizeTrain = size(x_Train, 1);
sizeValid = size(x_Valid, 1);

weightsMatrix = randn(nHidden, nInputs) / sqrt(nInputs);
weightsVector = randn(nOutputs, nHidden) / sqrt(nHidden);

thresholdHidden = zeros(nHidden, nOutputs);
thresholdOutput = 0;

isConverged = false;

while ~isConverged
    for epoch = 1:nEpochs
        randomIndex = randi(sizeTrain);
        randomInput = x_Train(randomIndex, :);
        randomTarget = t_Train(randomIndex);

        localFieldHidden = weightsMatrix * randomInput' - thresholdHidden;
        V = tanh(localFieldHidden);

        localFieldOutput = weightsVector * V - thresholdOutput;
        output = tanh(localFieldOutput);

        errorOut = (sech(localFieldOutput))^2 * (randomTarget - output);
        errorHidden = errorOut * weightsVector' .* (1 - (tanh(localFieldHidden)).^2);

        for m = 1:nHidden
            for n = 1:nInputs
                weightsMatrix(m, n) = weightsMatrix(m, n) + eta * errorHidden(m) * randomInput(n);
            end
            thresholdHidden(m) = thresholdHidden(m) - eta * errorHidden(m);
        end
        for n = 1:nHidden
            weightsVector(n) = weightsVector(n) + eta * errorOut * V(n);
        end
        thresholdOutput = thresholdOutput - eta * errorOut;
    end
    classificationError = 0;

    for p = 1:sizeValid
        randValIndex = randi(sizeValid);
        randValInput = x_Valid(randValIndex, :);
        randValTarget = t_Valid(randValIndex);

        localFieldHidden = weightsMatrix * randValInput' - thresholdHidden;
        V = tanh(localFieldHidden);

        localFieldOutput = weightsVector * V - thresholdOutput;
        output = tanh(localFieldOutput);

        if output >= 0
            output = 1;
        else
            output = -1;
        end

        classificationError = classificationError + abs(sign(output) - randValTarget)/(2 * sizeValid);
    end
    if classificationError < 0.105
        isConverged = true;
    end
end

transposedWeightsVector = weightsVector';

classificationError

csvwrite("w1.csv", weightsMatrix);
csvwrite("w2.csv", transposedWeightsVector);
csvwrite("t1.csv", thresholdHidden);
csvwrite("t2.csv", thresholdOutput);


