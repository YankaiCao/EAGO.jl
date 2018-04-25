module IntvHyperbolic_Test

using EAGO
using Base.Test


@testset "Hyperb tests" begin
    @test sinh(EAGO.emptyMCinterval(Float64)) == emptyMCinterval(Float64)
    @test sinh(MCInterval(0.5,0.5)) == MCInterval(0.5210953054937474, 0.5210953054937474)
    @test sinh(MCInterval(0.5, 1.67)) == MCInterval(0.5210953054937474, 2.5619603657712102)
    @test sinh(MCInterval(-4.5, 0.1)) == MCInterval(-45.003011151991785, 0.10016675001984403)

    @test cosh(EAGO.emptyMCinterval(Float64)) == emptyMCinterval(Float64)
    @test cosh(MCInterval(0.5,0.5)) == MCInterval(1.1276259652063807, 1.1276259652063807)
    @test cosh(MCInterval(0.5, 1.67)) == MCInterval(1.1276259652063807, 2.7502074314099567)
    @test cosh(MCInterval(-4.5, 0.1)) == MCInterval(1.0, 45.014120148530026)

    @test tanh(EAGO.emptyMCinterval(Float64)) == emptyMCinterval(Float64)
    @test tanh(MCInterval(0.5,0.5)) == MCInterval(0.46211715726000974, 0.46211715726000974)
    @test tanh(MCInterval(0.5, 1.67)) == MCInterval(0.46211715726000974, 0.9315516846152082)
    @test tanh(MCInterval(-4.5, 0.1)) == MCInterval(-0.9997532108480275, 0.09966799462495582)

    @test asinh(EAGO.emptyMCinterval(Float64)) == emptyMCinterval(Float64)
    @test asinh(MCInterval(-4.5, 0.1)) == EAGO.MCInterval{Float64}(-2.209347708615334, 0.09983407889920758)

    @test acosh(EAGO.emptyMCinterval(Float64)) == emptyMCinterval(Float64)
    @test acosh(MCInterval(0.5, 1.67)) == EAGO.MCInterval{Float64}(0.0, 1.1011083919917022)

    @test atanh(EAGO.emptyMCinterval(Float64)) == emptyMCinterval(Float64)
    @test atanh(MCInterval(0.5,0.5)) == EAGO.MCInterval{Float64}(0.5493061443340548, 0.5493061443340548)
    @test atanh(MCInterval(0.5, 1.67)) == EAGO.MCInterval{Float64}(0.5493061443340548, Inf)
    @test atanh(MCInterval(-4.5, 0.1)) == EAGO.MCInterval{Float64}(-Inf, 0.10033534773107558)

end

end
