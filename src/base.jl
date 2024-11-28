

"""
    ImageData{T}

Uniform spacing grid data as images.
"""
struct ImageData{T} <: AbstractArray{T, 2}
    mat::Matrix{T}
    
    function ImageData(mat::Matrix{T}) where T<:Real
        return new{T}(mat)
    end

    function ImageData(mat::OpenCV.Mat{T}) where T<:Real
        return new{T}(permutedims(mat.data, [3,2,1])[:,:,1])
    end
end

Matrix{T}(idt::ImageData) where T= Matrix{T}(idt.mat)

Base.eltype(idt::ImageData) = Base.eltype(idt.mat)
Base.length(idt::ImageData) = Base.length(idt.mat)
Base.iterate(idt::ImageData) = Base.iterate(idt.mat)
Base.iterate(idt::ImageData, state...) = Base.iterate(idt.mat, state...)
Base.isdone(idt::ImageData; state...) = Base.isdone(idt.mat; state...)
Base.size(idt::ImageData{T}, x2...) where T = Base.size(idt.mat, x2...)


function Base.show(io::IO, idt::ImageData{T}) where T
    h, w = size(idt.mat)
    println(io, "$h","x","$w ImageData{$T}")
end

Base.getindex(idt::ImageData{T}, idx...) where T= Base.getindex(idt.mat, idx...)
Base.getindex(idt::ImageData{T}, inds::Vararg{Int,N}) where {T,N} = idt.mat[inds...]

Base.setindex!(idt::ImageData{T}, idx...) where T = Base.setindex!(idt.mat, idx...)
Base.setindex!(idt::ImageData{T}, val, inds::Vararg{Int, N}) where {T,N} = idt.mat[inds...]

Base.showarg(io::IO, idt::ImageData, toplevel) = print(io, typeof(idt))

Base.firstindex(idt::ImageData{T}) where T = Base.firstindex(idt.mat)
Base.lastindex(idt::ImageData{T}) where T = Base.lastindex(idt.mat)

Base.BroadcastStyle(::Type{ImageData}) = ImageData()

Base.axes(idt::ImageData{T}) where T = Base.axes(idt.mat)

# Start of broadcast part to maintain shape after operation
Base.BroadcastStyle(::Type{<:ImageData}) = Broadcast.ArrayStyle{ImageData}()

function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{ImageData}}, ::Type{ElType}) where ElType
    # Scan the inputs for the ImageData:
    A = find_aac(bc)
    # Use the char field of A to create the output
    ImageData(similar(Array{ElType}, axes(bc)))
end

"`A = find_aac(As)` returns the first ArrayAndChar among the arguments."
find_aac(bc::Base.Broadcast.Broadcasted) = find_aac(bc.args)
find_aac(args::Tuple) = find_aac(find_aac(args[1]), Base.tail(args))
find_aac(x) = x
find_aac(::Tuple{}) = nothing
find_aac(a::ImageData, rest) = a
find_aac(::Any, rest) = find_aac(rest)



# OpenCV.Mat and Array compatibiliby function

"""
    Mat2Array(img::OpenCV.Mat{T}

convert `OpenCV.Mat{T}` to `Array{T, 3}`
"""
function Mat2Array(img::OpenCV.Mat{T}) where T<:Integer
    return permutedims(img.data, [3,2,1])
end

"""
    Array2Mat(img::Array{T})

convert `Array{T, N}` to `Array{T, 3}` only for N = 2 or 3.
"""
function Array2Mat(img::Array{T}) where {T<:Real}
    ll = length(size(img))
    @assert ll ∈ (2, 3)
    if ll == 3 
        return OpenCV.Mat(permutedims(img, [3,2,1]))
    else 
        return OpenCV.Mat(permutedims(stack([img, ]), [3,2,1]))
    end
end


# ImageData to Array conversion
Array{T1}(idt::ImageData{T2}) where {T1<:Real, T2<:Real} =  idt.mat[:,:]

