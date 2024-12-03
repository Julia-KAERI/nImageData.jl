function openWithMedianBlur(fp, ksize::Integer = 3, ftime::Integer = 1,  v... )
    @assert ftime > 0
    img0 = OpenCV.imread(fp, v...)
    for i in 1:ftime
        img0 = OpenCV.medianBlur(img0, ksize)
    end
    return ImageData(Mat2Array(img0)[:, :, 1])
end

"""
    convert element type of OpenCV.Mat
"""
convertMatType(T::Type, idt::OpenCV.Mat) = OpenCV.Mat(convert.(T, idt.data))

Base.eltype(idt::OpenCV.Mat) = Base.eltype(idt.data)
Base.length(idt::OpenCV.Mat) = Base.length(idt.data)
Base.iterate(idt::OpenCV.Mat) = Base.iterate(idt.data)
Base.iterate(idt::OpenCV.Mat, state...) = Base.iterate(idt.data, state...)
Base.isdone(idt::OpenCV.Mat; state...) = Base.isdone(idt.data; state...)

Base.getindex(idt::OpenCV.Mat{T}, idx...) where T= Base.getindex(idt.data, idx...)
Base.getindex(idt::OpenCV.Mat{T}, inds::Vararg{Int,N}) where {T,N} = idt.data[inds...]

Base.setindex!(idt::OpenCV.Mat{T}, idx...) where T = Base.setindex!(idt.data, idx...)
Base.setindex!(idt::OpenCV.Mat{T}, val, inds::Vararg{Int, N}) where {T,N} = idt.data[inds...]

Base.showarg(io::IO, idt::OpenCV.Mat, toplevel) = print(io, typeof(idt))

Base.firstindex(idt::OpenCV.Mat{T}) where T = Base.firstindex(idt.data)
Base.lastindex(idt::OpenCV.Mat{T}) where T = Base.lastindex(idt.data)

Base.BroadcastStyle(::Type{OpenCV.Mat}) = OpenCV.Mat()

Base.axes(m::OpenCV.Mat{T}) where T = Base.axes(m.data)

function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{OpenCV.Mat}}, ::Type{ElType}) where ElType
    # Scan the inputs for the ImageData:
    A = find_aac(bc)
    # Use the char field of A to create the output
    OpenCV.Mat(similar(Array{ElType}, axes(bc)))
end

# find_aac(bc::Base.Broadcast.Broadcasted) = find_aac(bc.args)

# find_aac(args::Tuple) = find_aac(find_aac(args[1]), Base.tail(args))
# find_aac(x) = x
# find_aac(::Tuple{}) = nothing
# find_aac(::Any, rest) = find_aac(rest)
find_aac(a::OpenCV.Mat, rest) = a

function Base.show(io::IO, tp::MIME"text/markdown", idt::OpenCV.Mat{T}) where T
    # println("2")
    h, w, c = size(idt.data)
    t = "$(h) x $(w) x $(c) OpenCV.Mat{$T}"
    println(t)
end

function Base.show(io::IO, tp::MIME"text/plain", idt::OpenCV.Mat{T}) where T
    #println("1")
    # h, w, c = size(idt.data)
    # t = "$(h) x $(w) x $(c) OpenCV.Mat{$T}"
    # println("")    
end