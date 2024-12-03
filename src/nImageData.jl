module nImageData

using OpenCV
using CairoMakie

include("base.jl")
include("MatUtils.jl")
include("transforms.jl")
include("filters.jl")
include("noise.jl")
include("utils.jl")


export ImageData,
    Array2Mat,
    Mat2Array,
    Mat2ImageData,
    ImageData2Mat,
    mat2gray,
    image_profile,

    openWithMedianBlur,
    convertMatType,
    rotate,
    IdentityFilter,
    MedianFilter,
    sand_pepper_noise

end # module nImageData
