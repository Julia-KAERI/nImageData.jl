
using OpenCV, Images

abstract type AbstractImageFilter end


struct IdentityFilter <: AbstractImageFilter
    ksize::Integer

    function IdentityFilter(ksize::Integer)
        @assert isodd(ksize) && ksize > 1
        return new(ksize)
    end
end


struct MedianFilter <: AbstractImageFilter
    ksize::Integer

    function MedianFilter(ksize::Integer=3)
        @assert isodd(ksize) && ksize > 1
        return new(ksize)
    end
end

function (flt::IdentityFilter)(img::Matrix{<:Real})
    return img[:, :]    
end

function (flt::MedianFilter)(img::Matrix{<:Real})
    _img = Array2Mat(img)
    result = Mat2Array(OpenCV.medianBlur(_img, flt.ksize))
    return result
end

function (flt::MedianFilter)(img::ImageData{<:Real})
    return ImageData((img.mat |> MedianFilter(flt.ksize))[:,:,1])
end

function (flt::MedianFilter)(img::OpenCV.Mat{T}) where T<:Real
    return OpenCV.medianBlur(img, flt.ksize)
end