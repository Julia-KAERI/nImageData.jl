function sand_pepper_noise(img::Matrix{T}, ratio::Real) where {T<:Integer}
    @assert 0<ratio<1
    result = img[:,:]
    tm, tM = typemin(T), typemax(T)
    w, h = size(img)
    Nnoise = round(Int, w*h*ratio)
    _x, _y = rand(1:w, Nnoise), rand(1:h, Nnoise)
    for i in 1:Nnoise 
        if iseven(i)
            result[_y[i], _x[i]] = tm
        else 
            result[_y[i], _x[i]] = tM
        end
    end
    return result
end 

function sand_pepper_noise(img::ImageData{T}, ratio::Real) where {T<:Integer}
    p = sand_pepper_noise(img.mat[:,:], ratio)
    return ImageData(p)
end 