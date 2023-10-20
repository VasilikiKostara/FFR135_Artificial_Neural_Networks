% Boolean functions

function d = BinaryToDecimal(bin) % put binary with -1s instead of 0s
    d = 0;
    dim = length(bin);
    bin(bin == -1) = 0;
    bin = flip(bin);

    for i = 1:dim
        d = d + 2^(i-1) * bin(i);
    end
end