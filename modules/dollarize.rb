def dollarize(s)
    pfx = [ '0.00', '0.0', '0.' ]
    if(pfx[s.length])
        s = pfx[s.length] + s
    else
        s = s.dup
        s[-2, 0] = '.'
    end
    s
end