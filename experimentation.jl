using DataStructures

lst = MutableLinkedList{Int}()

typeof(lst)

isempty(lst)

append!(lst, 24)

append!(lst, 10)

lst[2]

lst.node 

lst.node

lst = MutableLinkedList{Int}(1,2,3,4)

lst

lst.node.next.next.next.prev

delete!(lst, length(lst))

include("sorted_linked_list.jl")

l = MutableLinkedList{String}()

d = Dict{Int64, DataStructures.ListNode{String}}()

insert_sorted!(l, d, 87, "hello")

l

d[87]


struct PolynomialSparse

    #A zero packed vector of terms
    #Terms are assumed to be in order with first term having degree 0, second degree 1, and so fourth
    #until the degree of the polynomial. The leading term (i.e. last) is assumed to be non-zero except 
    #for the zero polynomial where the vector is of length 1.
    #Note: at positions where the coefficient is 0, the power of the term is also 0 (this is how the Term type is designed)
    terms::Vector{Term}   
    
    #Inner constructor of 0 polynomial
    PolynomialSparse() = new([zero(Term)])

    #Inner constructor of polynomial based on arbitrary list of terms
    function PolynomialSparse(vt::Vector{Term})

        #Filter the vector so that there is not more than a single zero term
        vt = filter((t)->!iszero(t), vt)
        if isempty(vt)
            vt = [zero(Term)]
        end

        max_degree = maximum((t)->t.degree, vt)
        terms = MutableLinkedList{Term}([zero(Term) for _ in 1:max_degree]...) #First set all terms with zeros

        #now update based on the input terms
        for t in vt
            terms[t.degree + 1] = t #+1 accounts for 1-indexing
        end
        return new(terms)
    end
end

PolynomialSparse()

lst = MutableLinkedList{Term}([zero(Term) for _ in 1:5]...)
PolynomialSparse(t::Term) = PolynomialSparse([t])

PolynomialSparse(Term(1,1))

for t in lst 
    print("hi", "\t")
end 

lst[5]


