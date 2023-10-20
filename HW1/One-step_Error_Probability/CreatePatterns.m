% One-step error probability

function patterns = CreatePatterns(nPatterns,nBits)
    patterns = zeros(nPatterns,nBits);
    
    for i = 1:nPatterns
        for j = 1:nBits
            if rand >= 0.5
                patterns(i,j) = 1;
                else
                patterns(i,j) = -1;
            end
        end
    end
end