import Foundation
import Accelerate

/// Uses vImage to convert a buffer of float16 values to regular Swift Floats.
///
/// - Parameters:
///   - input: A pointer to an array of `Float16`s.
///   - count: Number of elements in the array.
/// - Returns: An array of regular Swift `Float`s.
public func float16to32(_ input: UnsafeMutableRawPointer,
                        count: Int) -> [Float]? {
    var output = [Float](repeating: 0,
                         count: count)
    let status = output.withUnsafeMutableBytes { p -> Int in
        var bufferFloat16 = vImage_Buffer(data: input,
                                          height: 1,
                                          width: .init(count),
                                          rowBytes: count * 2)
        var bufferFloat32 = vImage_Buffer(data: p.baseAddress,
                                          height: 1,
                                          width: .init(count),
                                          rowBytes: count * 4)
        return vImageConvert_Planar16FtoPlanarF(&bufferFloat16,
                                                &bufferFloat32,
                                                0)
    }
    return status == kvImageNoError ? output : nil
}

/// Uses vImage to convert an array of Swift floats into a buffer of float16s.
///
/// - Parameters:
///   - input: A pointer to an array of `Float`s.
///   - count: Number of elements in the array.
/// - Returns: An array of `Float16`s.
public func float32to16(_ input: UnsafeMutablePointer<Float>,
                        count: Int) -> [Float16]? {
    var output = [Float16](repeating: 0,
                           count: count)
    let status = output.withUnsafeMutableBytes { p -> Int in
        var bufferFloat32 = vImage_Buffer(data: input,
                                          height: 1,
                                          width: .init(count),
                                          rowBytes: count * 4)
        var bufferFloat16 = vImage_Buffer(data: p.baseAddress,
                                          height: 1,
                                          width: .init(count),
                                          rowBytes: count * 2)
        return vImageConvert_PlanarFtoPlanar16F(&bufferFloat32, &bufferFloat16, 0)
    }
    return status == kvImageNoError ? output : nil
}
