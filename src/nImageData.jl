module nImageData

using OpenCV

include("base.jl")
include("transforms.jl")
include("filters.jl")
include("noise.jl")
include("utils.jl")

export ImageData,
    rotate,
    IdentityFilter,
    MedianFilter,
    Array2Mat,
    Mat2Array,
    mat2gray,
    sand_pepper_noise

end # module nImageData
