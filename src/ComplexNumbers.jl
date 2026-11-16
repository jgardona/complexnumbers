"""
    ComplexNumbers

A package with a custom implementation of complex numbers (`ComplexNumber`),
featuring conversion between Cartesian and polar forms, string conversion,
arithmetic operator overloading, and the complex conjugate.
"""
module ComplexNumbers

import Base: +, -, *, /, ==, show, real, imag, abs, angle, conj, adjoint, isapprox

export ComplexNumber, frompolar, topolar, modulus, argument, tostring

"""
    ComplexNumber(re, im)
    ComplexNumber(x)

Complex number in Cartesian form `re + im·i`.
"""
struct ComplexNumber{T<:Real} <: Number
    re::T
    im::T
end

ComplexNumber(re::Real, im::Real) = ComplexNumber(promote(re, im)...)
ComplexNumber(x::Real) = ComplexNumber(x, zero(x))

# Interoperability with Julia's built-in Complex (e.g. z + 10im).
# With the promotion rule, the operators between ComplexNumber values are reused.
ComplexNumber(z::Complex) = ComplexNumber(Base.real(z), Base.imag(z))
ComplexNumber{T}(z::Complex) where {T} = ComplexNumber{T}(Base.real(z), Base.imag(z))
ComplexNumber{T}(z::ComplexNumber) where {T} = ComplexNumber{T}(z.re, z.im)
ComplexNumber{T}(x::Real) where {T} = ComplexNumber{T}(x, zero(T))
Base.promote_rule(::Type{ComplexNumber{T}}, ::Type{Complex{S}}) where {T,S} =
    ComplexNumber{promote_type(T, S)}
Base.Complex(z::ComplexNumber) = Complex(z.re, z.im)

real(z::ComplexNumber) = z.re
imag(z::ComplexNumber) = z.im

# ---------------------------------------------------------------------------
# Polar <-> Cartesian conversions
# ---------------------------------------------------------------------------

"""
    frompolar(r, θ; degrees=false) -> ComplexNumber

Convert from polar form (modulus `r`, angle `θ`) to Cartesian form.
`θ` is interpreted in radians, or in degrees if `degrees=true`.
"""
function frompolar(r::Real, θ::Real; degrees::Bool=false)
    θrad = degrees ? deg2rad(θ) : θ
    return ComplexNumber(r * cos(θrad), r * sin(θrad))
end

"""
    modulus(z) -> Real

Modulus (magnitude) of `z`: `√(re² + im²)`.
"""
modulus(z::ComplexNumber) = hypot(z.re, z.im)

"""
    argument(z; degrees=false) -> Real

Argument (angle) of `z` in the interval (−π, π], in radians or degrees.
"""
function argument(z::ComplexNumber; degrees::Bool=false)
    θ = atan(z.im, z.re)
    return degrees ? rad2deg(θ) : θ
end

abs(z::ComplexNumber) = modulus(z)
angle(z::ComplexNumber) = argument(z)

"""
    topolar(z; degrees=false) -> (r, θ)

Convert `z` from Cartesian form to polar form, returning the tuple
`(modulus, argument)`.
"""
topolar(z::ComplexNumber; degrees::Bool=false) = (modulus(z), argument(z; degrees=degrees))

_fmt(x::Integer, ::Integer) = x
_fmt(x::Real, digits::Integer) = round(x; digits=digits)

# ---------------------------------------------------------------------------
# String conversion
# ---------------------------------------------------------------------------

# Rounds floating-point values only; integers are kept as they are.
"""
    tostring(z; form=:cartesian, digits=4, degrees=false) -> String

Textual representation of `z`, similar to Java's `toString`.

- `form=:cartesian` → `"3.0 + 4.0i"`
- `form=:polar`     → `"5.0∠0.9273 rad"` (or `"5.0∠53.1301°"` with `degrees=true`)

Values are rounded to `digits` decimal places.
"""
function tostring(z::ComplexNumber; form::Symbol=:cartesian, digits::Integer=4, degrees::Bool=false)
    if form === :cartesian
        re = _fmt(z.re, digits)
        im = _fmt(z.im, digits)
        sign = im < 0 ? "-" : "+"
        return "$(re) $(sign) $(abs(im))i"
    elseif form === :polar
        r, θ = topolar(z; degrees=degrees)
        unit = degrees ? "°" : " rad"
        return "$(_fmt(r, digits))∠$(_fmt(θ, digits))$(unit)"
    else
        throw(ArgumentError("invalid form: $(repr(form)); use :cartesian or :polar"))
    end
end

show(io::IO, z::ComplexNumber) = print(io, tostring(z))

# ---------------------------------------------------------------------------
# Arithmetic operators
# ---------------------------------------------------------------------------

+(a::ComplexNumber, b::ComplexNumber) = ComplexNumber(a.re + b.re, a.im + b.im)
-(a::ComplexNumber, b::ComplexNumber) = ComplexNumber(a.re - b.re, a.im - b.im)
*(a::ComplexNumber, b::ComplexNumber) =
    ComplexNumber(a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re)

function /(a::ComplexNumber, b::ComplexNumber)
    d = b.re^2 + b.im^2
    iszero(d) && throw(DivideError())
    return ComplexNumber((a.re * b.re + a.im * b.im) / d, (a.im * b.re - a.re * b.im) / d)
end

-(z::ComplexNumber) = ComplexNumber(-z.re, -z.im)

# Operations with real numbers
+(a::ComplexNumber, x::Real) = ComplexNumber(a.re + x, a.im)
+(x::Real, a::ComplexNumber) = a + x
-(a::ComplexNumber, x::Real) = ComplexNumber(a.re - x, a.im)
-(x::Real, a::ComplexNumber) = ComplexNumber(x - a.re, -a.im)
*(a::ComplexNumber, x::Real) = ComplexNumber(a.re * x, a.im * x)
*(x::Real, a::ComplexNumber) = a * x
*(x::Bool, a::ComplexNumber) = a * x   # avoids ambiguity with Base.*(::Bool, ::Number)
function /(a::ComplexNumber, x::Real)
    iszero(x) && throw(DivideError())
    return ComplexNumber(a.re / x, a.im / x)
end
/(x::Real, a::ComplexNumber) = ComplexNumber(x) / a

# Comparisons
==(a::ComplexNumber, b::ComplexNumber) = a.re == b.re && a.im == b.im
isapprox(a::ComplexNumber, b::ComplexNumber; atol::Real=1e-10, rtol::Real=1e-10) =
    isapprox(a.re, b.re; atol=atol, rtol=rtol) && isapprox(a.im, b.im; atol=atol, rtol=rtol)

# ---------------------------------------------------------------------------
# Conjugate
# ---------------------------------------------------------------------------

"""
    conj(z)
    z'

Complex conjugate of `z` (`re - im·i`). The postfix operator `'` also
returns the conjugate.
"""
conj(z::ComplexNumber) = ComplexNumber(z.re, -z.im)
adjoint(z::ComplexNumber) = conj(z)

end # module
