% One-step error probability

nPatternList = [12, 24, 48, 70, 100, 120];
nBits = 120;
nTrials = 10^5;

for p = 1:length(nPatternList)
    nPatterns = nPatternList(p);
    success = 0;

    for t = 1:nTrials
        patterns = CreatePatterns(nPatterns, nBits);
        weights = Weights(patterns);
        trial = OneStep(weights, patterns);
        success = success + trial;
    end
    fail = 1 - success/nTrials
end