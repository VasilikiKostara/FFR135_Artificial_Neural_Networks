% One-step error probability

function success = OneStep(weights, patterns)
    nPatterns = size(patterns, 1);
    nBits = size(patterns, 2);
    iPattern = randi(nPatterns);
    jBit = randi(nBits);
    b = 0;

    for i = 1:nBits
    b = b + weights(i, jBit)*patterns(iPattern, i);
    end

    if sign(b)==patterns(iPattern,jBit)
        success = 1;
    else
        success = 0;
    end
end