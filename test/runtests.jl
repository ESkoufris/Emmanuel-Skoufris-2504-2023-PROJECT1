#############################################################################
#############################################################################
#
# A script that runs all unit tests in the project.
#                                                                               
#############################################################################
#############################################################################

using Pkg
Pkg.activate(".")

include("../poly_factorization_project.jl")

####
# Execute unit tests for integers
###
include("integers_test.jl")
test_euclid_ints()
test_ext_euclid_ints()

####
# Execute unit tests for polynomials
####
include("polynomials_test.jl")
prod_test_poly()
prod_derivative_test_poly()
ext_euclid_test_poly()
division_test_poly()

include("polynomial_sparse_tests.jl")
prod_test_poly_sparse()
prod_derivative_test_poly_sparse()
ext_euclid_test_poly_sparse()
division_test_poly_sparse()
overflow_test()

prod_test_poly_sparse128()
prod_derivative_test_poly_sparse128()
ext_euclid_test_poly_sparse128()
division_test_poly_sparse128()
crt_multiply_test_poly_sparse()
pow_mod_test()


include("polynomial_modp_tests.jl")
prod_test_poly_modp()
division_test_poly_modp()
ext_euclid_test_poly_modp()
repeated_squaring_test()

####
# Execute unit tests for polynomial factorization
####
include("factorization_test.jl")
factor_test_poly()
factor_test_poly_sparse()
factor_test_poly_modp()

