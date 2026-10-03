"""
    ComplexNumbers

Pacote com uma implementação própria de números complexos (`ComplexNumber`),
com conversão entre as formas cartesiana e polar, conversão para string,
sobrecarga dos operadores aritméticos e conjugado.
"""
module ComplexNumbers

import Base: +, -, *, /, ==, show, real, imag, abs, angle, conj, adjoint, isapprox

export ComplexNumber, frompolar, topolar, modulus, argument, tostring

"""
    ComplexNumber(re, im)
    ComplexNumber(x)

Número complexo na forma cartesiana `re + im·i`.
"""
struct ComplexNumber{T<:Real} <: Number
    re::T
    im::T
end

ComplexNumber(re::Real, im::Real) = ComplexNumber(promote(re, im)...)
ComplexNumber(x::Real) = ComplexNumber(x, zero(x))

# Interoperabilidade com o Complex nativo do Julia (ex.: z + 10im).
# Com a regra de promoção, os operadores entre ComplexNumber são reutilizados.
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
# Conversões polar <-> cartesiana
# ---------------------------------------------------------------------------

"""
    frompolar(r, θ; degrees=false) -> ComplexNumber

Converte da forma polar (módulo `r`, ângulo `θ`) para a forma cartesiana.
`θ` é interpretado em radianos, ou em graus se `degrees=true`.
"""
function frompolar(r::Real, θ::Real; degrees::Bool=false)
    θrad = degrees ? deg2rad(θ) : θ
    return ComplexNumber(r * cos(θrad), r * sin(θrad))
end

"""
    modulus(z) -> Real

Módulo (magnitude) de `z`: `√(re² + im²)`.
"""
modulus(z::ComplexNumber) = hypot(z.re, z.im)

"""
    argument(z; degrees=false) -> Real

Argumento (ângulo) de `z` no intervalo (−π, π], em radianos ou graus.
"""
function argument(z::ComplexNumber; degrees::Bool=false)
    θ = atan(z.im, z.re)
    return degrees ? rad2deg(θ) : θ
end

abs(z::ComplexNumber) = modulus(z)
angle(z::ComplexNumber) = argument(z)

"""
    topolar(z; degrees=false) -> (r, θ)

Converte `z` da forma cartesiana para a forma polar, retornando a tupla
`(módulo, argumento)`.
"""
topolar(z::ComplexNumber; degrees::Bool=false) = (modulus(z), argument(z; degrees=degrees))

_fmt(x::Integer, ::Integer) = x
_fmt(x::Real, digits::Integer) = round(x; digits=digits)

# ---------------------------------------------------------------------------
# Conversão para string
# ---------------------------------------------------------------------------

# Arredonda apenas valores de ponto flutuante; inteiros são mantidos como estão.
"""
    tostring(z; form=:cartesian, digits=4, degrees=false) -> String

Representação textual de `z`, semelhante ao `toString` do Java.

- `form=:cartesian` → `"3.0 + 4.0i"`
- `form=:polar`     → `"5.0∠0.9273 rad"` (ou `"5.0∠53.1301°"` com `degrees=true`)

Os valores são arredondados para `digits` casas decimais.
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
        throw(ArgumentError("forma inválida: $(repr(form)); use :cartesian ou :polar"))
    end
end

show(io::IO, z::ComplexNumber) = print(io, tostring(z))

# ---------------------------------------------------------------------------
# Operadores aritméticos
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

# Operações com números reais
+(a::ComplexNumber, x::Real) = ComplexNumber(a.re + x, a.im)
+(x::Real, a::ComplexNumber) = a + x
-(a::ComplexNumber, x::Real) = ComplexNumber(a.re - x, a.im)
-(x::Real, a::ComplexNumber) = ComplexNumber(x - a.re, -a.im)
*(a::ComplexNumber, x::Real) = ComplexNumber(a.re * x, a.im * x)
*(x::Real, a::ComplexNumber) = a * x
*(x::Bool, a::ComplexNumber) = a * x   # evita ambiguidade com Base.*(::Bool, ::Number)
function /(a::ComplexNumber, x::Real)
    iszero(x) && throw(DivideError())
    return ComplexNumber(a.re / x, a.im / x)
end
/(x::Real, a::ComplexNumber) = ComplexNumber(x) / a

# Comparações
==(a::ComplexNumber, b::ComplexNumber) = a.re == b.re && a.im == b.im
isapprox(a::ComplexNumber, b::ComplexNumber; atol::Real=1e-10, rtol::Real=1e-10) =
    isapprox(a.re, b.re; atol=atol, rtol=rtol) && isapprox(a.im, b.im; atol=atol, rtol=rtol)

# ---------------------------------------------------------------------------
# Conjugado
# ---------------------------------------------------------------------------

"""
    conj(z)
    z'

Conjugado complexo de `z` (`re - im·i`). O operador pós-fixo `'` também
retorna o conjugado.
"""
conj(z::ComplexNumber) = ComplexNumber(z.re, -z.im)
adjoint(z::ComplexNumber) = conj(z)

end # module
