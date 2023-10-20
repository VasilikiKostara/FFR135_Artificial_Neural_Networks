% Recognising digits

function DisplayDigit(bits, rows, columns)
    digit = reshape(bits, columns, rows)';
    pcolor(flip(digit));
    colormap(gray(2));
end