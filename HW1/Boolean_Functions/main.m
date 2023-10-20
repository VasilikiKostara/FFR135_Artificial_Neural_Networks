% Boolean functions

nDims = [2, 3, 4, 5];

for t = 1:length(nDims)
    n = nDims(t);
    nTrials = 10^4;
    nEpochs = 20;
    eta = 0.05;
    counter = 0;
    booleanInputs = GenerateInputs(n);
    usedBool = [];

    for trial = 1:nTrials
        booleanOutputs = GenerateOutputs(n);
        decimalOutput = BinaryToDecimal(booleanOutputs);

        if not(ismember( decimalOutput, usedBool))
            weights = GenerateWeights(n);
            threshold = 0;

            for epoch = 1:nEpochs
                totalError = 0;

                for i = 1:2^n
                    y = sign(dot(booleanInputs(i, :), weights) - threshold);
                    error = booleanOutputs(i) - y;
                    deltaWeights = eta * error * booleanInputs(i, :);
                    deltaThreshold = -eta * error;
                    weights = weights + deltaWeights;
                    threshold = threshold + deltaThreshold;
                    totalError = totalError + abs(error);
                end

                if totalError == 0
                    counter = counter + 1;
                    break
                end

            end

        usedBool(end+1) = decimalOutput;
        end
        
    end
    counter
end