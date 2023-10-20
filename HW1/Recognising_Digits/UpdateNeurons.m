% Recognising digits

function finalState = UpdateNeurons(state, weights)
    nBits = length(state);

    for i = 1:nBits
        b = 0;

        for j = 1:nBits
            bi = weights(i, j)*state(j);
            b = b + bi;
        end

        if b == 0
            state(i) = 1;
        else
            state(i) = sign(b);
        end
        
    end
    finalState = state;
end