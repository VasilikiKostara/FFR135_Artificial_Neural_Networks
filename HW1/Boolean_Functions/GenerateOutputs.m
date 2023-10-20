% Boolean functions

function randOut = GenerateOutputs(dim)
    randOut = round(rand(2^dim, 1));
    randOut(randOut == 0) = -1;
end