using Pkg
Pkg.activate(".")

x = x_poly()

@show p1 = 5x^2 + 6x + 1

include("poly_factorization_project.jl")

5x + 7x^3 - 4x^7 - 5x^6 + 1

typeof(p.terms[1])

p.terms[1].coeffs

p.terms[1].degree

Term

function show(io::IO, p::Polynomial) 
    if iszero(p)
        print(io,"0")
    else
        n = length(p.terms)
        for (i,t) in enumerate(reverse(p.terms))
            if !iszero(t)
                if t.degree == 0 
                   print(io, t.coeff,  i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                elseif t.coeff == 1 
                   if t.degree == 1
                      print(io, "x", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                   else 
                      print(io, "x^$(t.degree)", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                   end
                elseif t.coeff == -1
                    if t.degree == 1
                        print(io, "-x", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                     else 
                        print(io, "-x^$(t.degree)", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                     end
                else
                    if t.degree == 1
                        print(io, "$(t.coeff)x", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                    else 
                        print(io, "$(t.coeff)x^$(t.degree)", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                    end
                end
            end
        end
    end
end

typeof(enumerate(p.terms))

@show 5*x_poly() + 1*x_poly()


p.terms[1].coeff
p.terms[1].degree

p.terms[1].coeff
print(p.terms[1], +)

@show p
enumerate(reverse(p.terms))





reverse(p.terms)


function show(io::IO, p::Polynomial) 
    if iszero(p)
        print(io,"0")
    else
        n = length(p.terms)
        for (i,t) in enumerate(reverse(p.terms))
            if !iszero(t)
                if t.degree == 0 
                   print(io, t.coeff,  (i != n && p.terms[i+1].coeff >= 0) ? " + " : "")
                elseif t.degree == 1 
                   if t.coeff == 1
                      print(io, "x", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                   elseif t.coeff == -1
                      print(io, "-x", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                   else 
                      print(io, "$(t.coeff)x", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                   end
                else
                    if t.coeff == 1
                        print(io, "x^$(t.degree)", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                    elseif t.coeff == -1
                        print(io, "-x^$(t.degree)", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                     else 
                        print(io, "$(t.coeff)x^$(t.degree)", i != n && p.terms[i+1].coeff >= 0 ? " + " : "")
                     end
                end
            end
        end
    end
end