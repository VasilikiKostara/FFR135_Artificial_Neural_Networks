% One-step error probability

function w = Weights(patterns)
    nBits = size(patterns, 2);
    nPatterns = size(patterns, 1);
    w = zeros(nBits);

    for m=1:nPatterns
        w = w + patterns(m, :)' * patterns(m, :);
    end    
    w = w/nBits;        % w = w - diag(diag(w));
end