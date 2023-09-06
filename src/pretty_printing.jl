import Base: show

function show(io::IO, p::Polynomial) 
    if iszero(p)
        print(io,"0")
    else
        n = length(p.terms)
        for (i,t) in enumerate(p.terms)
            if !iszero(t)
                print(io, t, i != n ? " + " : "")
            end
        end
    end
end


p1 = 5*x_poly()

@show p1.terms
