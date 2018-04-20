module Operators

using Compat
using Compat.Test
using EAGO
using IntervalArithmetic
using StaticArrays


function about(calc,val,tol)
    return (val - tol <= calc <= val + tol)
end

################################################################################
######################## Tests Standard McCormick Relaxations ##################
################################################################################
EAGO.set_diff_relax(0)

######## tests division of same object ######
a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(1.0,5.0);Interval(-1.0,2.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(3.0,3.0,a,a,xIBox[1],false,xIBox,mBox)
out = X/X
@test out == 1.0

a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-3.0,8.0);Interval(-3.0,8.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.5,4.5,a,a,xIBox[1],false,xIBox,mBox)
out = abs(X)
@test about(out.cc,6.409090909090908,1E-1)
@test about(out.cv,4.5,1E-1)
@test about(out.cc_grad[1],0.454545,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],1.0,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,0,1E-4)
@test about(out.Intv.hi,8,1E-4)

# tests powers (square)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,7.0); Interval(3.0,7.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.0,4.0,a,a,xIBox[1],false,xIBox,mBox)
out = X^2
@test about(out.cc,19,1E-8)
@test about(out.cv,16,1E-8)
@test about(out.cc_grad[1],10.0,1E-1)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],8.0,1E-5)
@test about(out.cv_grad[2],0.0,1E-5)
@test about(out.Intv.lo,9,1E-4)
@test about(out.Intv.hi,49,1E-4)

# tests powers (^-2 on positive domain)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,7.0);Interval(3.0,7.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.0,4.0,a,a,xIBox[1],false,xIBox,mBox)
out = X^(-2)
@test about(out.cc,0.08843537414965986,1E-8)
@test about(out.cv,0.0625,1E-8)
@test about(out.cc_grad[1],-0.0226757,1E-1)
@test about(out.cc_grad[2],0.0,1E-4)
@test about(out.cv_grad[1],-0.03125,1E-5)
@test about(out.cv_grad[2],0.0,1E-4)
@test about(out.Intv.lo,0.0204081,1E-4)
@test about(out.Intv.hi,0.111112,1E-4)

# tests powers (^-2 on negative domain)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-8.0,-3.0);Interval(-8.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-4.5,-4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(-2)
@test about(out.cc,0.08246527777777776,1E-8)
@test about(out.cv,0.04938271604938271,1E-8)
@test about(out.cc_grad[1],0.0190972,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],0.0219479,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,0.015625,1E-4)
@test about(out.Intv.hi,0.111112,1E-4)

# tests powers (^0)
#=
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-8.0,-3.0);Interval(-8.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-4.5,-4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(0)
@test out == 1.0
=#

# tests powers (^1)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-8.0,-3.0),Interval(-8.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-4.5,-4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(1)
@test about(out.cc,-4.5,1E-8)
@test about(out.cv,-4.5,1E-8)
@test about(out.cc_grad[1],1.0,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],1.0,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,-8.0,1E-4)
@test about(out.Intv.hi,-3.0,1E-4)

# tests powers (^2)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-8.0,-3.0),Interval(-8.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-4.5,-4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(2)
@test about(out.cc,25.5,1E-8)
@test about(out.cv,20.25,1E-8)
@test about(out.cc_grad[1],-11.0,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],-9.0,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,9.0,1E-4)
@test about(out.Intv.hi,64.0,1E-4)

# tests powers (^3)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-8.0,-3.0);Interval(-8.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-4.5,-4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(3)
@test about(out.cc,-91.125,1E-8)
@test about(out.cv,-172.5,1E-8)
@test about(out.cc_grad[1],60.75,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],97.0,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,-512,1E-4)
@test about(out.Intv.hi,-27,1E-4)

# tests powers (^4)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-8.0,-3.0),Interval(-8.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-4.5,-4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(4)
@test about(out.cc,1285.5,1E-8)
@test about(out.cv,410.0625,1E-8)
@test about(out.cc_grad[1],-803.0,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],-364.5,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,81,1E-4)
@test about(out.Intv.hi,4096,1E-4)

# tests sqrt
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,9.0),Interval(3.0,9.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.5,4.5,a,a,xIBox[1],false,xIBox,mBox)
out = sqrt(X)
@test about(out.cc,2.1213203435596424,1E-8)
@test about(out.cv,2.049038105676658,1E-8)
@test about(out.cc_grad[1],0.235702,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],0.211325,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,1.73205,1E-4)
@test about(out.Intv.hi,3,1E-4)

# tests powers (^3 greater than zero ISSUE WITH CC)
a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,8.0),Interval(3.0,8.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.5,4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(3)
@test about(out.cc,172.5,1E-8)
@test about(out.cv,91.125,1E-8)
@test about(out.cc_grad[1],97.0,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],60.75,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,27,1E-4)
@test about(out.Intv.hi,512,1E-4)

# tests powers (^4 greater than zero)

a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,8.0),Interval(3.0,8.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.5,4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(4)
@test about(out.cc,1285.5,1E-1)
@test about(out.cv,410.0625,1E-1)
@test about(out.cc_grad[1],803.0,1E-4)
@test about(out.cc_grad[2],0.0,1E-1)
@test about(out.cv_grad[1],364.5,1E-4)
@test about(out.cv_grad[2],0.0,1E-1)
@test about(out.Intv.lo,81,1E-4)
@test about(out.Intv.hi,4096,1E-4)


# tests powers (^4 zero in range)

a = seed_g(Float64,Int64(1),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-8.0,3.0),Interval(-8.0,3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-4.5,-4.5,a,a,xIBox[1],false,xIBox,mBox)
out = X^(4)
@test about(out.cc,2818.5,1)
@test about(out.cv,410.0625,1)
@test about(out.cc_grad[1],-365.0,1)
@test about(out.cc_grad[2],0.0,1)
@test about(out.cv_grad[1],-364.5,1)
@test about(out.cv_grad[2],0.0,1)
@test about(out.Intv.lo,0,1)
@test about(out.Intv.hi,4096,1)

######## tests nonsmooth inverse ######
a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-3.0,4.0);Interval(-5.0,-3.0)])
mBox = mid.(xIBox)
Y = SMCg{2,Interval{Float64},Float64}(-4.0,-4.0,b,b,xIBox[2],false,xIBox,mBox)
out = 1.0/Y
@test about(out.cc,-0.25,1E-6)
@test about(out.cv,-0.266666666,1E-6)
@test about(out.cc_grad[1],0.0,1E-6)
@test about(out.cc_grad[2],-0.0625,1E-6)
@test about(out.cv_grad[1],0.0,1E-6)
@test about(out.cv_grad[2],-0.0666667,1E-6)
@test about(out.Intv.lo,-0.33333333,1E-5)
@test about(out.Intv.hi,-0.199999,1E-5)

######## tests nonsmooth division ######
a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-3.0,4.0);Interval(-5.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-2.0,-2.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(-4.0,-4.0,b,b,xIBox[2],false,xIBox,mBox)
out = X/Y
#println("out!: $out")
@test about(out.cc,0.6,1E-6)
@test about(out.cv,0.41666666,1E-6)
@test about(out.cc_grad[1],-0.2,1E-6)
@test about(out.cc_grad[2],0.2,1E-6)
@test about(out.cv_grad[1],-0.333333,1E-6)
@test about(out.cv_grad[2],0.1875,1E-6)
@test about(out.Intv.lo,-1.33333333,1E-6)
@test about(out.Intv.hi,1.0,1E-6)

######## tests exponent on product ######
a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-3.0,4.0);Interval(-5.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-2.0,-2.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(-4.0,-4.0,b,b,xIBox[2],false,xIBox,mBox)
out = exp(X*Y)
@test about(out.cc,2.708614394334035e6,1E-1)
@test about(out.cv,1096.6331584284585,1E-1)
@test about(out.cc_grad[1],-2.80201e5,1E1)
@test about(out.cc_grad[2],-2.80201e5,1E1)
@test about(out.cv_grad[1],-5483.17,1E-1)
@test about(out.cv_grad[2],-3289.9,1E-1)
@test about(out.Intv.lo,2.06115e-09,1E-1)
@test about(out.Intv.hi,3.26902e+06,1E1)

######## tests log on product ######
a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,7.0);Interval(3.0,9.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.0,4.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(7.0,7.0,b,b,xIBox[2],false,xIBox,mBox)
out = log(X*Y)
@test about(out.cc,3.4011973816621555,1E-8)
@test about(out.cv,2.7377551742960287,1E-8)
@test about(out.cc_grad[1],0.3,1E-1)
@test about(out.cc_grad[2],0.1,1E-1)
@test about(out.cv_grad[1],0.108106,1E-5)
@test about(out.cv_grad[2],0.108106,1E-5)
@test about(out.Intv.lo,2.19722,1E-4)
@test about(out.Intv.hi,4.14314,1E-4)

a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-3.0,4.0);Interval(-5.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-2.0,-2.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(-4.0,-4.0,b,b,xIBox[2],false,xIBox,mBox)
out = exp2(X*Y)
@test about(out.cc,27150.62857159206,1E-1)
@test about(out.cv,128.0,1E-1)
@test about(out.cc_grad[1],-2808.69,1E1)
@test about(out.cc_grad[2],-2808.69,1E1)
@test about(out.cv_grad[1],-443.614,1E-1)
@test about(out.cv_grad[2],-266.169,1E-1)
@test about(out.Intv.lo,9.53674e-07,1E-1)
@test about(out.Intv.hi,32768,1E1)

a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(-3.0,4.0);Interval(-5.0,-3.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(-2.0,-2.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(-4.0,-4.0,b,b,xIBox[2],false,xIBox,mBox)
out = exp10(X*Y)
@test about(out.cc,8.285714285714286e14,1E-1)
@test about(out.cv,1.0e7,1E-1)
@test about(out.cc_grad[1],-8.57143e13,1E8)
@test about(out.cc_grad[2],-8.57143e13,1E8)
@test about(out.cv_grad[1],-1.15129e8,1E3)
@test about(out.cv_grad[2],-6.90776e7,1E3)
@test about(out.Intv.lo,9.99999e-21,1E-1)
@test about(out.Intv.hi,1e+15,1E1)

a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,7.0);Interval(3.0,9.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.0,4.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(7.0,7.0,b,b,xIBox[2],false,xIBox,mBox)
out = log2(X*Y)
@test about(out.cc,4.906890595608519,1E-7)
@test about(out.cv,3.94974581312498,1E-7)
@test about(out.cc_grad[1],0.432809,1E-5)
@test about(out.cc_grad[2],0.14427,1E-5)
@test about(out.cv_grad[1],0.155964,1E-5)
@test about(out.cv_grad[2],0.155964,1E-5)
@test about(out.Intv.lo,3.16992,1E-5)
@test about(out.Intv.hi,5.97728,1E-5)

a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,7.0);Interval(3.0,9.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.0,4.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(7.0,7.0,b,b,xIBox[2],false,xIBox,mBox)
out = log10(X*Y)
@test about(out.cc,1.4771212547196624,1E-7)
@test about(out.cv,1.1889919649988407,1E-7)
@test about(out.cc_grad[1],0.130288,1E-5)
@test about(out.cc_grad[2],0.0434294,1E-5)
@test about(out.cv_grad[1],0.0469499,1E-5)
@test about(out.cv_grad[2],0.0469499,1E-5)
@test about(out.Intv.lo,0.954242,1E-5)
@test about(out.Intv.hi,1.79935,1E-5)


################################################################################
######################## Tests Smooth McCormick Relaxations ##################
################################################################################

EAGO.set_diff_relax(1)
a = seed_g(Float64,Int64(1),Int64(2))
b = seed_g(Float64,Int64(2),Int64(2))
xIBox = SVector{2,Interval{Float64}}([Interval(3.0,7.0);Interval(3.0,9.0)])
mBox = mid.(xIBox)
X = SMCg{2,Interval{Float64},Float64}(4.0,4.0,a,a,xIBox[1],false,xIBox,mBox)
Y = SMCg{2,Interval{Float64},Float64}(7.0,7.0,b,b,xIBox[2],false,xIBox,mBox)
Xn = SMCg{2,Interval{Float64},Float64}(-4.0,-4.0,a,a,-xIBox[1],false,xIBox,mBox)
Xz = SMCg{2,Interval{Float64},Float64}(-2.0,-2.0,a,a,Interval(-3.0,1.0),false,xIBox,mBox)

out1 = sqrt(X)
@test about(out1.cc,2.0,1E-5)
@test about(out1.cv,1.9604759334428057,1E-5)
@test about(out1.cc_grad[1],0.25,1E-5)
@test about(out1.cc_grad[2],0.0,1E-5)
@test about(out1.cv_grad[1],0.228425,1E-5)
@test about(out1.cv_grad[2],0.0,1E-5)
@test about(out1.Intv.lo,1.73205,1E-5)
@test about(out1.Intv.hi,2.64576,1E-5)


out2 = exp2(X)
@test about(out2.cc,38.0,1E-5)
@test about(out2.cv,16.0,1E-5)
@test about(out2.cc_grad[1],30.0,1E-5)
@test about(out2.cc_grad[2],0.0,1E-5)
@test about(out2.cv_grad[1],11.0904,1E-4)
@test about(out2.cv_grad[2],0.0,1E-5)
@test about(out2.Intv.lo,8.0,1E-5)
@test about(out2.Intv.hi,128.0,1E-5)

out3 = exp10(X)
@test about(out3.cc,2.50075e6,1E1)
@test about(out3.cv,10000.0,1E-1)
@test about(out3.cc_grad[1],2.49975e6,1E1)
@test about(out3.cc_grad[2],0.0,1E-5)
@test about(out3.cv_grad[1],23025.9,1E0)
@test about(out3.cv_grad[2],0.0,1E-5)
@test about(out3.Intv.lo,1000,1E0)
@test about(out3.Intv.hi,1e+07,1E0)


out4 = log(X)
@test about(out4.cc,1.3862943611198906,1E-5)
@test about(out4.cv,1.3104367537649104,1E-5)
@test about(out4.cc_grad[1],0.25,1E-5)
@test about(out4.cc_grad[2],0.0,1E-5)
@test about(out4.cv_grad[1],0.211824,1E-5)
@test about(out4.cv_grad[2],0.0,1E-5)
@test about(out4.Intv.lo,1.09861,1E-4)
@test about(out4.Intv.hi,1.94592,1E-4)

out5 = log2(X)
@test about(out5.cc,2.0,1E-5)
@test about(out5.cv,1.890560606055268,1E-5)
@test about(out5.cc_grad[1],0.360674,1E-5)
@test about(out5.cc_grad[2],0.0,1E-5)
@test about(out5.cv_grad[1],0.305598,1E-5)
@test about(out5.cv_grad[2],0.0,1E-5)
@test about(out5.Intv.lo,1.58496,1E-5)
@test about(out5.Intv.hi,2.80736,1E-5)


out6 = log10(X)
@test about(out6.cc,0.6020599913279624,1E-5)
@test about(out6.cv,0.5691154510433111,1E-5)
@test about(out6.cc_grad[1],0.108574,1E-5)
@test about(out6.cc_grad[2],0.0,1E-5)
@test about(out6.cv_grad[1],0.0919942,1E-5)
@test about(out6.cv_grad[2],0.0,1E-5)
@test about(out6.Intv.lo,0.477121,1E-5)
@test about(out6.Intv.hi,0.845099,1E-5)


out7 = abs(X)
@test about(out7.cc,4.0,1E-5)
@test about(out7.cv,1.3061224489795915,1E-5)
@test about(out7.cc_grad[1],1.0,1E-5)
@test about(out7.cc_grad[2],0.0,1E-5)
@test about(out7.cv_grad[1],0.979592,1E-5)
@test about(out7.cv_grad[2],0.0,1E-5)
@test about(out7.Intv.lo,3.0,1E-5)
@test about(out7.Intv.hi,7.0,1E-5)

out8 = cosh(X)
@test about(out8.cc,144.63000528563632,1E-5)
@test about(out8.cv,27.308232836016487,1E-5)
@test about(out8.cc_grad[1],134.562,1E-2)
@test about(out8.cc_grad[2],0.0,1E-5)
@test about(out8.cv_grad[1],-27.2899,1E-3)
@test about(out8.cv_grad[2],0.0,1E-5)
@test about(out8.Intv.lo,10.0676,1E-3)
@test about(out8.Intv.hi,548.318,1E-3)

out9 = acosh(X)
@test about(out9.cc,2.0634370688955608,1E-5)
@test about(out9.cv,1.9805393289917226,1E-5)
@test about(out9.cc_grad[1],0.258199,1E-5)
@test about(out9.cc_grad[2],0.0,1E-5)
@test about(out9.cv_grad[1],0.217792,1E-5)
@test about(out9.cv_grad[2],0.0,1E-5)
@test about(out9.Intv.lo,1.76274,1E-5)
@test about(out9.Intv.hi,2.63392,1E-5)

out10 = sinh(X)
@test about(out10.cc,144.59243701386904,1E-5)
@test about(out10.cv,27.28991719712775,1E-5)
@test about(out10.cc_grad[1],134.575,1E-2)
@test about(out10.cc_grad[2],0.0,1E-1)
@test about(out10.cv_grad[1],27.3082,1E-2)
@test about(out10.cv_grad[2],0.0,1E-1)
@test about(out10.Intv.lo,10.0178,1E-2)
@test about(out10.Intv.hi,548.317,1E-2)
out10a = sinh(Xn)
@test about(out10a.cc,-27.28991719712775,1E-5)
@test about(out10a.cv,-144.59243701386904,1E-5)
@test about(out10a.cc_grad[1],27.3082,1E-2)
@test about(out10a.cc_grad[2],0.0,1E-1)
@test about(out10a.cv_grad[1],134.575,1E-2)
@test about(out10a.cv_grad[2],0.0,1E-1)
@test about(out10a.Intv.lo,-548.317,1E-2)
@test about(out10a.Intv.hi,-10.0178,1E-2)

out11 = asinh(X)
@test about(out11.cc,2.0947125472611012,1E-5)
@test about(out11.cv,2.024865034688707,1E-5)
@test about(out11.cc_grad[1],0.242536,1E-5)
@test about(out11.cc_grad[2],0.0,1E-5)
@test about(out11.cv_grad[1],0.206419,1E-5)
@test about(out11.cv_grad[2],0.0,1E-5)
@test about(out11.Intv.lo,1.81844,1E-5)
@test about(out11.Intv.hi,2.64413,1E-5)
out11a = asinh(Xn)
@test about(out11a.cc,-2.024865034688707,1E-5)
@test about(out11a.cv,-2.0947125472611012,1E-5)
@test about(out11a.cc_grad[1],0.206419,1E-5)
@test about(out11a.cc_grad[2],0.0,1E-5)
@test about(out11a.cv_grad[1],0.242536,1E-5)
@test about(out11a.cv_grad[2],0.0,1E-5)
@test about(out11a.Intv.lo,-2.64413,1E-5)
@test about(out11a.Intv.hi,-1.81844,1E-5)
out11b = asinh(Xz)
@test about(out11b.cc,-1.1434914478276093,1E-5)
@test about(out11b.cv,-1.4436354751788103,1E-5)
@test about(out11b.cc_grad[1],0.674955,1E-5)
@test about(out11b.cc_grad[2],0.0,1E-5)
@test about(out11b.cv_grad[1],0.447214,1E-5)
@test about(out11b.cv_grad[2],0.0,1E-5)
@test about(out11b.Intv.lo,-1.81845,1E-5)
@test about(out11b.Intv.hi,0.881374,1E-5)

out12 = tanh(X)
@test about(out12.cc,0.999329299739067,1E-5)
@test about(out12.cv,0.996290649501034,1E-5)
@test about(out12.cc_grad[1],0.00134095,1E-5)
@test about(out12.cc_grad[2],0.0,1E-5)
@test about(out12.cv_grad[1],0.0012359,1E-5)
@test about(out12.cv_grad[2],0.0,1E-5)
@test about(out12.Intv.lo,0.995054,1E-5)
@test about(out12.Intv.hi,0.999999,1E-5)
out12a = tanh(Xn)
@test about(out12a.cc,-0.996290649501034,1E-5)
@test about(out12a.cv,-0.999329299739067,1E-5)
@test about(out12a.cc_grad[1],0.0012359,1E-5)
@test about(out12a.cc_grad[2],0.0,1E-5)
@test about(out12a.cv_grad[1],0.00134095,1E-5)
@test about(out12a.cv_grad[2],0.0,1E-5)
@test about(out12a.Intv.lo,-0.999999,1E-5)
@test about(out12a.Intv.hi,-0.995054,1E-5)
out12b = tanh(Xz)
@test about(out12b.cc,-0.6633698357911536,1E-5)
@test about(out12b.cv,-0.9640275800758169,1E-5)
@test about(out12b.cc_grad[1],0.331685,1E-5)
@test about(out12b.cc_grad[2],0.0,1E-5)
@test about(out12b.cv_grad[1],0.0706508,1E-5)
@test about(out12b.cv_grad[2],0.0,1E-5)
@test about(out12b.Intv.lo,-0.995055,1E-5)
@test about(out12b.Intv.hi,0.761595,1E-5)

#out13 = atanh(X)
#=
@test about(out13.cc,,1E-5)
@test about(out13.cv,,1E-5)
@test about(out13.cc_grad[1],0.0,1E-5)
@test about(out13.cc_grad[2],0.0,1E-5)
@test about(out13.cv_grad[1],0.0,1E-5)
@test about(out13.cv_grad[2],0.0,1E-5)
@test about(out13.Intv.lo,,1E-5)
@test about(out13.Intv.hi,,1E-5)
=#

out14 = inv(X)
@test about(out14.cc,0.2857142857142857,1E-5)
@test about(out14.cv,0.25,1E-5)
@test about(out14.cc_grad[1],-0.047619,1E-5)
@test about(out14.cc_grad[2],0.0,1E-5)
@test about(out14.cv_grad[1],-0.0625,1E-5)
@test about(out14.cv_grad[2],0.0,1E-5)
@test about(out14.Intv.lo,0.142857,1E-5)
@test about(out14.Intv.hi,0.333334,1E-5)
out14a = inv(Xn)
#println("out14a: $out14a")
#@test about(out14a.cc,-0.25,1E-5)
#@test about(out14a.cv,-0.19047619047619047,,1E-5)
#@test about(out14a.cc_grad[1],-0.0625,1E-5)
#@test about(out14a.cc_grad[2],0.0,1E-5)
#@test about(out14a.cv_grad[1],0.047619,1E-5)
#@test about(out14a.cv_grad[2],0.0,1E-5)
#@test about(out14a.Intv.lo,-0.333334,1E-5)
#@test about(out14a.Intv.hi,-0.142857,1E-5)

out16 = atan(X)
@test about(out16.cc,1.3258176636680326,1E-5)
@test about(out16.cv,1.294009147346374,1E-5)
@test about(out16.cc_grad[1],0.0588235,1E-5)
@test about(out16.cc_grad[2],0.0,1E-5)
@test about(out16.cv_grad[1],0.0449634,1E-5)
@test about(out16.cv_grad[2],0.0,1E-5)
@test about(out16.Intv.lo,1.24904,1E-3)
@test about(out16.Intv.hi,1.4289,1E-3)
out16a = atan(Xn)
@test about(out16a.cc,-1.294009147346374,1E-5)
@test about(out16a.cv,-1.3258176636680326,1E-5)
@test about(out16a.cc_grad[1],0.0449634,1E-5)
@test about(out16a.cc_grad[2],0.0,1E-5)
@test about(out16a.cv_grad[1],.0588235,1E-5)
@test about(out16a.cv_grad[2],0.0,1E-5)
@test about(out16a.Intv.lo,-1.4289,1E-3)
@test about(out16a.Intv.hi,-1.24904,1E-3)
out16b = atan(Xz)
@test about(out16b.cc,-0.7404162771337869,1E-5)
@test about(out16b.cv,-1.1071487177940904,1E-5)
@test about(out16b.cc_grad[1],0.508629,1E-5)
@test about(out16b.cc_grad[2],0.0,1E-5)
@test about(out16b.cv_grad[1],0.2,1E-5)
@test about(out16b.cv_grad[2],0.0,1E-5)
@test about(out16b.Intv.lo,-1.24905,1E-3)
@test about(out16b.Intv.hi,0.785399,1E-3)

out17 = sin(X)
@test about(out17.cc,0.2700866557245978,1E-5)
@test about(out17.cv,-0.7568024953079283,1E-5)
@test about(out17.cc_grad[1],0.128967,1E-5)
@test about(out17.cc_grad[2],0.0,1E-5)
@test about(out17.cv_grad[1],-0.653644,1E-5)
@test about(out17.cv_grad[2],0.0,1E-5)
@test about(out17.Intv.lo,-1,1E-2)
@test about(out17.Intv.hi,0.656987,1E-5)
out17a = sin(Xn)
@test about(out17a.cc,0.7568024953079283,1E-5)
@test about(out17a.cv,-0.2700866557245979,1E-5)
@test about(out17a.cc_grad[1],-0.653644,1E-5)
@test about(out17a.cc_grad[2],0.0,1E-5)
@test about(out17a.cv_grad[1],0.128967,1E-5)
@test about(out17a.cv_grad[2],0.0,1E-5)
@test about(out17a.Intv.lo,-0.656987,1E-2)
@test about(out17a.Intv.hi,1.0,1E-5)
out17b = sin(Xz)
@test about(out17b.cc,0.10452774015707458,1E-5)
@test about(out17b.cv,-0.9092974268256817,1E-5)
@test about(out17b.cc_grad[1],0.245648,1E-5)
@test about(out17b.cc_grad[2],0.0,1E-5)
@test about(out17b.cv_grad[1],-0.416147,1E-5)
@test about(out17b.cv_grad[2],0.0,1E-5)
@test about(out17b.Intv.lo,-1,1E-2)
@test about(out17b.Intv.hi,0.841471,1E-5)

out19 = cos(X)
@test about(out19.cc,-0.31034065427934965,1E-5)
@test about(out19.cv,-0.703492113936536,1E-5)
@test about(out19.cc_grad[1],0.679652,1E-5)
@test about(out19.cc_grad[2],0.0,1E-5)
@test about(out19.cv_grad[1],0.485798,1E-5)
@test about(out19.cv_grad[2],0.0,1E-5)
@test about(out19.Intv.lo,-1.0,1E-5)
@test about(out19.Intv.hi,1.0,1E-5)
out19a = cos(Xn)
@test about(out19a.cc,-0.31034065427934965,1E-5)
@test about(out19a.cv,-0.703492113936536,1E-5)
@test about(out19a.cc_grad[1],-0.679652,1E-5)
@test about(out19a.cc_grad[2],0.0,1E-5)
@test about(out19a.cv_grad[1],-0.485798,1E-5)
@test about(out19a.cv_grad[2],0.0,1E-5)
@test about(out19a.Intv.lo,-1.0,1E-5)
@test about(out19a.Intv.hi,1.0,1E-5)
out19b = cos(Xz)
@test about(out19b.cc,-0.222468094224762,1E-5)
@test about(out19b.cv,-0.6314158569813042,1E-5)
@test about(out19b.cc_grad[1],0.76752,1E-5)
@test about(out19b.cc_grad[2],0.0,1E-5)
@test about(out19b.cv_grad[1],0.390573,1E-5)
@test about(out19b.cv_grad[2],0.0,1E-5)
@test about(out19b.Intv.lo,-0.989993,1E-5)
@test about(out19b.Intv.hi,1.0,1E-5)

out21 = step(X)
@test about(out21.cc,1.0,1E-5)
@test about(out21.cv,1.0,1E-5)
@test about(out21.cc_grad[1],0.0,1E-5)
@test about(out21.cc_grad[2],0.0,1E-5)
@test about(out21.cv_grad[1],0.0,1E-5)
@test about(out21.cv_grad[2],0.0,1E-5)
@test about(out21.Intv.lo,1.0,1E-5)
@test about(out21.Intv.hi,1.0,1E-5)
out21a = step(Xn)
@test about(out21a.cc,0.0,1E-5)
@test about(out21a.cv,0.0,1E-5)
@test about(out21a.cc_grad[1],0.0,1E-5)
@test about(out21a.cc_grad[2],0.0,1E-5)
@test about(out21a.cv_grad[1],0.0,1E-5)
@test about(out21a.cv_grad[2],0.0,1E-5)
@test about(out21a.Intv.lo,0.0,1E-5)
@test about(out21a.Intv.hi,0.0,1E-5)
out21b = step(Xz)
@test about(out21b.cc,0.5555555555555556,1E-5)
@test about(out21b.cv,0.0,1E-5)
@test about(out21b.cc_grad[1],0.444444,1E-5)
@test about(out21b.cc_grad[2],0.0,1E-5)
@test about(out21b.cv_grad[1],0.0,1E-5)
@test about(out21b.cv_grad[2],0.0,1E-5)
@test about(out21b.Intv.lo,0.0,1E-5)
@test about(out21b.Intv.hi,1.0,1E-5)

out22 = sign(X)
@test about(out22.cc,1.0,1E-5)
@test about(out22.cv,1.0,1E-5)
@test about(out22.cc_grad[1],0.0,1E-5)
@test about(out22.cc_grad[2],0.0,1E-5)
@test about(out22.cv_grad[1],0.0,1E-5)
@test about(out22.cv_grad[2],0.0,1E-5)
@test about(out22.Intv.lo,1.0,1E-5)
@test about(out22.Intv.hi,1.0,1E-5)
out22a = sign(Xn)
@test about(out22a.cc,-1.0,1E-5)
@test about(out22a.cv,-1.0,1E-5)
@test about(out22a.cc_grad[1],0.0,1E-5)
@test about(out22a.cc_grad[2],0.0,1E-5)
@test about(out22a.cv_grad[1],0.0,1E-5)
@test about(out22a.cv_grad[2],0.0,1E-5)
@test about(out22a.Intv.lo,-1.0,1E-5)
@test about(out22a.Intv.hi,-1.0,1E-5)
out22b = sign(Xz)
@test about(out22b.cc,0.11111111111111116,1E-5)
@test about(out22b.cv,-1.0,1E-5)
@test about(out22b.cc_grad[1],0.888889,1E-5)
@test about(out22b.cc_grad[2],0.0,1E-5)
@test about(out22b.cv_grad[1],0.0,1E-5)
@test about(out22b.cv_grad[2],0.0,1E-5)
@test about(out22b.Intv.lo,-1.0,1E-5)
@test about(out22b.Intv.hi,1.0,1E-5)

out23 = sqr(X)
@test about(out23.cc,19.0,1E-5)
@test about(out23.cv,16.0,1E-5)
@test about(out23.cc_grad[1],10.0,1E-5)
@test about(out23.cc_grad[2],0.0,1E-5)
@test about(out23.cv_grad[1],8.0,1E-5)
@test about(out23.cv_grad[2],0.0,1E-5)
@test about(out23.Intv.lo,9.0,1E-5)
@test about(out23.Intv.hi,49.0,1E-5)

out23a = sqr(Xn)
@test about(out23a.cc,19.0,1E-5)
@test about(out23a.cv,16.0,1E-5)
@test about(out23a.cc_grad[1],-10.0,1E-5)
@test about(out23a.cc_grad[2],0.0,1E-5)
@test about(out23a.cv_grad[1],-8.0,1E-5)
@test about(out23a.cv_grad[2],0.0,1E-5)
@test about(out23a.Intv.lo,9.0,1E-5)
@test about(out23a.Intv.hi,49.0,1E-5)


out23b = sqr(Xz)
@test about(out23b.cc,7.0,1E-5)
@test about(out23b.cv,2.66666666666,1E-5)
@test about(out23b.cc_grad[1],-2.0,1E-5)
@test about(out23b.cc_grad[2],0.0,1E-5)
@test about(out23b.cv_grad[1],-4.0,1E-5)
@test about(out23b.cv_grad[2],0.0,1E-5)
@test about(out23b.Intv.lo,0.0,1E-5)
@test about(out23b.Intv.hi,9.0,1E-5)


################################################################################
#                  Test Power Functions Not Accessed Previously                #
################################################################################
out1a = pow(X,3)
@test about(out1a.cc,106.0,1E-5)
@test about(out1a.cv,64.0,1E-5)
@test about(out1a.cc_grad[1],79.0,1E-5)
@test about(out1a.cc_grad[2],0.0,1E-5)
@test about(out1a.cv_grad[1],48.0,1E-5)
@test about(out1a.cv_grad[2],0.0,1E-5)
@test about(out1a.Intv.lo,27.0,1E-5)
@test about(out1a.Intv.hi,343.0,1E-5)

out1b = pow(Xn,3)
@test about(out1b.cc,-64.0,1E-5)
@test about(out1b.cv,-106.0,1E-5)
@test about(out1b.cc_grad[1],48.0,1E-5)
@test about(out1b.cc_grad[2],0.0,1E-5)
@test about(out1b.cv_grad[1],79,1E-5)
@test about(out1b.cv_grad[2],0.0,1E-5)
@test about(out1b.Intv.lo,-343.0,1E-5)
@test about(out1b.Intv.hi,-27.0,1E-5)

out1c = pow(Xz,3)
@test about(out1c.cc,-7.75,1E-5)
@test about(out1c.cv,-20.25,1E-5)
@test about(out1c.cc_grad[1],12.25,1E-5)
@test about(out1c.cc_grad[2],0.0,1E-5)
@test about(out1c.cv_grad[1],6.75,1E-5)
@test about(out1c.cv_grad[2],0.0,1E-5)
@test about(out1c.Intv.lo,-27.0,1E-5)
@test about(out1c.Intv.hi,1.0,1E-5)

out2a = pow(X,-3)
@test about(out2a.cc,0.02850664075153871,1E-5)
@test about(out2a.cv,0.015625,1E-5)
@test about(out2a.cc_grad[1],-0.0085304,1E-5)
@test about(out2a.cc_grad[2],0.0,1E-5)
@test about(out2a.cv_grad[1],-0.0117188,1E-5)
@test about(out2a.cv_grad[2],0.0,1E-5)
@test about(out2a.Intv.lo,0.00291545,1E-5)
@test about(out2a.Intv.hi,0.0370371,1E-5)

out2b = pow(Xn,-3)
@test about(out2b.cc,-0.015625,1E-5)
@test about(out2b.cv,-0.02850664075153871,1E-5)
@test about(out2b.cc_grad[1],-0.0117188,1E-5)
@test about(out2b.cc_grad[2],0.0,1E-5)
@test about(out2b.cv_grad[1],-0.0085304,1E-5)
@test about(out2b.cv_grad[2],0.0,1E-5)
@test about(out2b.Intv.lo,-0.0370371,1E-5)
@test about(out2b.Intv.hi,-0.00291545,1E-5)

out3a = pow(X,-4)
@test about(out3a.cc,0.009363382541225106,1E-5)
@test about(out3a.cv,0.00390625,1E-5)
@test about(out3a.cc_grad[1],-0.0029823,1E-5)
@test about(out3a.cc_grad[2],0.0,1E-5)
@test about(out3a.cv_grad[1],-0.00390625,1E-5)
@test about(out3a.cv_grad[2],0.0,1E-5)
@test about(out3a.Intv.lo,0.000416493,1E-5)
@test about(out3a.Intv.hi,0.0123457,1E-5)

out3b = pow(Xn,-4)
@test about(out3b.cc,0.009363382541225106,1E-5)
@test about(out3b.cv,0.00390625,1E-5)
@test about(out3b.cc_grad[1],0.0029823,1E-5)
@test about(out3b.cc_grad[2],0.0,1E-5)
@test about(out3b.cv_grad[1],0.00390625,1E-5)
@test about(out3b.cv_grad[2],0.0,1E-5)
@test about(out3b.Intv.lo,0.000416493,1E-5)
@test about(out3b.Intv.hi,0.0123457,1E-5)

out4 = pow(X,4)
@test about(out4.cc,661.0,1E-5)
@test about(out4.cv,256.0,1E-5)
@test about(out4.cc_grad[1],580.0,1E-5)
@test about(out4.cc_grad[2],0.0,1E-5)
@test about(out4.cv_grad[1],256,1E-5)
@test about(out4.cv_grad[2],0.0,1E-5)
@test about(out4.Intv.lo,81.0,1E-5)
@test about(out4.Intv.hi,2401.0,1E-5)

out4a = pow(Xn,4)
@test about(out4a.cc,661.0,1E-5)
@test about(out4a.cv,256.0,1E-5)
@test about(out4a.cc_grad[1],-580.0,1E-5)
@test about(out4a.cc_grad[2],0.0,1E-5)
@test about(out4a.cv_grad[1],-256,1E-5)
@test about(out4a.cv_grad[2],0.0,1E-5)
@test about(out4a.Intv.lo,81.0,1E-5)
@test about(out4a.Intv.hi,2401.0,1E-5)

out4b = pow(Xz,4)
@test about(out4b.cc,61.0,1E-5)
@test about(out4b.cv,16.0,1E-5)
@test about(out4b.cc_grad[1],-20.0,1E-5)
@test about(out4b.cc_grad[2],0.0,1E-5)
@test about(out4b.cv_grad[1],-32.0,1E-5)
@test about(out4b.cv_grad[2],0.0,1E-5)
@test about(out4b.Intv.lo,0.0,1E-5)
@test about(out4b.Intv.hi,81.0,1E-5)

end
