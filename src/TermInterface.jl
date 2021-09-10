module TermInterface

"""
    istree(x)

Returns `true` if `x` is a term. If true, `operation`, `arguments`
must also be defined for `x` appropriately.
"""
istree(x) = istree(typeof(x))
istree(x::Type{T}) where {T} = false
export istree

"""
    symtype(x)

Returns the symbolic type of `x`. By default this is just `typeof(x)`.
Define this for your symbolic types if you want `SymbolicUtils.simplify` to apply rules
specific to numbers (such as commutativity of multiplication). Or such
rules that may be implemented in the future.
"""
function symtype(x)
    typeof(x)
end
export symtype

"""
    issym(x)

Returns `true` if `x` is a symbol. If true, `nameof` must be defined
on `x` and must return a Symbol.
"""
issym(x) = issym(typeof(x))
issym(x::Type{T}) where {T} = false
export issym

"""
    exprhead(x)

If `x` is a term as defined by `istree(x)`, `exprhead(x)` must return a symbol,
corresponding to the head of the `Expr` most similar to the term `x`.
If `x` represents a function call, for example, the `exprhead` is `:call`.
If `x` represents an indexing operation, such as `arr[i]`, then `exprhead` is `:ref`.
Note that `exprhead` is different from `operation` and both functions should 
be defined correctly in order to let other packages provide code generation 
and pattern matching features. 
"""
function exprhead end
export exprhead


"""
    operation(x)

If `x` is a term as defined by `istree(x)`, `operation(x)` returns the
head of the term if `x` represents a function call, for example, the head
is the function being called.
"""
function operation end
export operation

"""
    arguments(x)

Get the arguments of `x`, must be defined if `istree(x)` is `true`.
"""
function arguments end
export arguments

"""
    arity(x)

Returns the number of arguments of `x`. Implicitly defined 
if `arguments(x)` is defined.
"""
arity(x) = length(arguments(x))
export arity


"""
    metadata(x)

Return the metadata attached to `x`.
"""
metadata(x) = nothing
export metadata


"""
    metadata(x, md)

Returns a new term which has the structure of `x` but also has
the metadata `md` attached to it.
"""
function metadata(x, data)
    error("Setting metadata on $x is not possible")
end


"""
    similarterm(x, head, args, symtype=nothing; metadata=nothing)

Returns a term that is in the same closure of types as `typeof(x)`,
with `head` as the head and `args` as the arguments, `type` as the symtype
and `metadata` as the metadata. By default this will execute `head(args...)`.
`x` parameter can also be a `Type`.
"""
similarterm(x, head, args, symtype=nothing; metadata=nothing, exprhead=exprhead(x)) = 
    similarterm(typeof(x), head, args, symtype; metadata=metadata, exprhead=exprhead)

function similarterm(x::Type{T}, head, args, symtype=nothing; metadata=nothing, exprhead=:call) where T
    !istree(T) ? head : head(args...)
end 
export similarterm

include("utils.jl")

include("expr.jl")

end # module

