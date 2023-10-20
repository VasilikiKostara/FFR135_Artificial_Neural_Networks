% Boolean functions

function binaryVector = NumToBinary(num, dim)
    binaryVector = zeros(1, dim);
    i = 1;

    while num>0
        binaryVector(i) = mod(num, 2);
        num = fix(num/2);
        i = i+1;
    end

    binaryVector = flip(binaryVector);
end