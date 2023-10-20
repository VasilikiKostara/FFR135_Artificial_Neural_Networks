% Boolean functions

function binaryMatrix = GenerateInputs(dim)
    binaryMatrix = zeros(2^dim, dim);

    for i = 1:2^dim
        binaryMatrix(i, :) = NumToBinary(i-1, dim);
    end
    
    binaryMatrix (binaryMatrix == 0) = -1;
end