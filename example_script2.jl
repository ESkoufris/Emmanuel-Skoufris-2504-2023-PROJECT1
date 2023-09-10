using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")


x = x_polysparse()

@show -4x^2 + 6x + 1 - 6x^3 - 5x^1 - 9089x^5
@show 0*x + 5x^2 + 0*x^3 - 7x^4

typeof(0*x) 
iszero(0*x)
p1 = x^2 + 5x - 56x + x^4 - 6x

PolynomialSparse([Term(-3,3), Term(1,2)]).dict[2]


lst = MutableLinkedList{Term}(Term(0,0), Term(1,2))


d = Dict{Int, DataStructures.ListNode{Term}}(0 => DataStructures.ListNode{Term}(Term(0,0)))

d[0]

x = x_polysparse()
x.terms
last(x.terms)
coeffs(x)

for t in x.terms
    print("hi")
end

typeof(lst.node.next)

zero(Term).degree

evaluate(x,2)

push!(x_polysparse(), Term(1,2))



x.terms

get_element(x.terms, x.dict, 1)

derivative(Term(1,2))

derivative(PolynomialSparse([Term(1,2), Term(2,3), Term(5,60)])).dict

pop!(x)

x = x_polysparse()

trim!(PolynomialSparse([Term(0,0), Term(1,2)]))

push!(PolynomialSparse(Term(1,1)),Term(1,2))

x.terms[2] = Term(1,2)

x.dict[1] = DataStructures.ListNode{Term}(Term(1,1))

PolynomialSparse(Term(1,1)) + PolynomialSparse(Term(1,2))

x = x_polysparse()

p = x + PolynomialSparse(Term(-2,50)) 

+(t::Term, p::PolynomialSparse) = p + t

iszero(PolynomialSparse())




(x+1)*(x-1)



x^4 



x
derivative(PolynomialSparse([Term(4,5), Term(-3,6)]))

p = x
t = Term(1,1)

PolynomialSparse(map((pt)->t*pt, [get_element(p.terms, p.dict, term.degree) for term in p.terms]))





u = 2x^4 + 3x^2 + 2
v = 3x+2 


f = (2x^4 + 3x^2 + 4x ) ÷ (3x+2)

mod(v, 2)

(x ÷ x)(6)

u - u*v

÷(u,v)(5)

(u ÷ v)(5)
(u ÷ v)(5)

x = x_poly()
u = 2x^4 + 3x^2 + 2
v = 3x+2

h = PolynomialSparse( (leading(u) ÷ leading(v))(5) )  
#syzergy 
h.dict
(2x).dict


f = mod(u + - h*v, 5)

u - u*v

iszero(mod((u + f) + - u*v, 5))

x = x_polysparse()
