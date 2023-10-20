% Boolean functions

function weights = GenerateWeights(dim)
    weights = dim^(-0.5) * randn(1,dim);
end