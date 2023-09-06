import Base: show

function show(p::Polynomial) 
    println(io, r.numerator)
    num_chars = max(length(string(r.numerator)),length(string(r.denominator)))
    println(io,"-"^num_chars)
    println(io,r.denominator)
end




