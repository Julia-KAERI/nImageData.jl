using Interpolations, ImageTransformations, CoordinateTransformations, Rotations

interpolation_methods = Dict(:nearest => BSpline(Constant()), :bilinear => BSpline(Linear()), :bicubic => BSpline(Cubic(Line(OnGrid()))))


function rotate(imd::ImageData{T}, θ; rotation_center = nothing, method = :bilinear, fillvalue = 0) where T
    h, w = size(imd)
    if rotation_center == nothing 
        rotation_center = center(imd.mat)
    end
    trfm = recenter(RotMatrix(θ), rotation_center)
    return ImageData(warp(imd.mat, trfm, method = interpolation_methods[method], fillvalue = fillvalue)[1:h, 1:w])
end
