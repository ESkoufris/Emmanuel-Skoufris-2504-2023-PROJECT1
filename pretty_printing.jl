
x = x_poly()
 x^2 - 5x + x^79 - x^50



function show(io::IO, t::Term)  
    iszero(t.coeff) && return print(io,"0")
    iszero(t.degree) && return print(io,t.coeff)
    if abs(t.coeff) == 1
        print(io, t.coeff == 1 ? "x" : "-x", t.degree == 1 ? "" : "^$(t.degree)") 
    else 
        print(io, "$(t.coeff)x", t.degree == 1 ? "" : "^$(t.degree)")
    end
end


function show(io::IO, p::Polynomial) 
    if iszero(p)
        print(io,"0")
    else
        n = length(p.terms)
        for (i,t) in enumerate(reverse(p.terms))
            if !iszero(t)
                print(io, i==1 ? "$t" : (t.coeff ≥ 0 ? " + $t" : " - $(-t)"))
            end
        end
    end
end

t = x.terms[2]

@show (p1 - 2x^3 - 6x^2)

p1.terms