
using Images

"""
    mat2gray(mat::Matrix{<:Real}, range::Union{Nothing, Tuple{Real, Real}} )

Convert matrix to gray Image of Images.jl. 
"""
function mat2gray(mat::Matrix{T}, range::Union{Nothing, Tuple{Real, Real}} = nothing ) where T<: Real
    if range === nothing
        mv, Mv = extrema(mat)
        return  Gray.((mat .- mv)./(Mv-mv))
    else 
        mv, Mv = minmax(range...)
        return Gray.(clamp.((mat .-mv)/(Mv-mv), zero(T), one(T)))

    end
end

function mat2gray(mat::Matrix{T}, range::Union{Nothing, Tuple{Real, Real}} = nothing ) where T<: Integer
    return mat2gray(Float32.(mat), range)
end

mat2gray(idt::ImageData{T}, range::Union{Nothing, Tuple{Real, Real}} = nothing ) where T<:Real = mat2gray(idt.mat, range)

mat2gray(mat::OpenCV.Mat{T}, range::Union{Nothing, Tuple{Real, Real}} = nothing ) where T<:Real = mat2gray(Mat2Array(mat)[:,:,1], range)