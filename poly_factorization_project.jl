#############################################################################
#############################################################################
#
# This is the main project file for polynomial factorization
#                                                                               
#############################################################################
#############################################################################

using Distributions, StatsBase, Random

import Base: %
import Base: push!, pop!, iszero, show, isless, map, map!, iterate, length, last
import Base: +, -, *, mod, %, ÷, ==, ^, rand, rem, zero, one

include("src/general_alg.jl")
include("src/term.jl")
include("src/polynomial.jl")
include("src/sorted_linked_list.jl")
include("src/polynomial_sparse.jl")
include("src/polynomial_modp.jl")
    include("src/basic_polynomial_operations/polynomial_addition.jl")
    include("src/basic_polynomial_operations/polynomial_multiplication.jl")
    include("src/basic_polynomial_operations/polynomial_division.jl")
    include("src/basic_polynomial_operations/polynomial_gcd.jl")
    include("src/basic_polynomial_operations/polynomial_sparse_addition.jl")
    include("src/basic_polynomial_operations/polynomial_sparse_multiplication.jl")
    include("src/basic_polynomial_operations/polynomial_sparse_division.jl")
    include("src/basic_polynomial_operations/polynomial_sparse_gcd.jl")
include("src/polynomial_factorization/factor.jl")
include("src/polynomial_factorization/factor_sparse.jl")




nothing