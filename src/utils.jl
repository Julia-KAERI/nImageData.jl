
using Images
using CairoMakie

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


"""
    hist 

generate histogram
"""
function hist(A::Array{T}) where {T<:Union{UInt8, Int8, UInt16, Int16}}
    t1, t2 = Int64(typemin(T)), Int64(typemax(T))
    bins = t1:t2
    h = zeros(Int64,t2-t1+1)
    for a in A
        @inbounds h[a-t1+1] += 1
    end
    return (bins, h)
end

function hist(A::Array{T} , st::Union{UnitRange{S}, StepRange{S, S}}) where {T<:Integer, S<:Integer}
    if typeof(st) <: UnitRange
        step = 1
    else 
        step = st.step
    end
    start, stop = st.start, st.stop
    
    if start>stop || step <0
        return nothing
    end

    h = zeros(Int64, length(st)-1)
    for a in A
        if start ≤ a < stop 
            @inbounds h[div(a-start, step)+1] += 1
        end
    end
    return st, h
end

function hist(A::Array{T} , st::Union{UnitRange{S}, StepRange{S, S}}) where {T<:Real, S<:Real}
    if typeof(st) <: UnitRange
        step = 1
    else 
        step = st.step
    end
    start, stop = st.start, st.stop
    
    if start>stop || step <0
        return nothing
    end

    h = zeros(Int64, length(st)-1)
    for a in A
        if start ≤ a < stop 
            @inbounds h[round(Int64, (a-start)/step) + 1] += 1
        end
    end
    return st, h
end

hist(A::ImageData, v...) = hist(A.mat, v...)
hist(A::OpenCV.Mat, v...) = hist(A.data, v...)

"""
    image_profile(img, figsize, binsize, xlog, ylog)


Generate makie figure with two plots. The left one is image and the right one is histogram of it
"""
function image_profile(img::Matrix{T}; figsize::Union{Nothing, Tuple{Int64, Int64}} = nothing, binsize=2, xlog::Bool=false, ylog::Bool=false) where T<:Real

    _xscale = (xlog == false) ? identity : log10
    _yscale = (ylog == false) ? identity : log10

    if isa(figsize, Nothing) == false
        @assert (400 ≤ figsize[1] ≤ 10000) && (400 ≤  figsize[2] ≤ 6000)
    else         
        figsize = (800, 400)
    end

    f = Figure(size = figsize)

    Mv = maximum(img)
    v1 = CairoMakie.image(f[1, 1:2], img', axis=(aspect = DataAspect(), yreversed=true, xticklabelsvisible=true, yticklabelsvisible=true))
    v2 = CairoMakie.hist(f[1, 3], vec(img), bins = 0:binsize:Mv, axis = (xscale = _xscale, yscale = _yscale))

    return f
end

image_profile(img::ImageData; kwargs...) = image_profile(img.mat; kwargs...)
image_profile(img::OpenCV.Mat; kwargs...) = image_profile(img.data[1,:,:]; kwargs...)

