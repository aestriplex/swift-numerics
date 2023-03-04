import RealModule

//
//public func horner<R: Real>(coeffs: [R], grade: Int64, z: R) -> R {
//    var b = [coeffs[0]]
//    var num_iter = 1
//
//    //TODO Aggiungere controllo: len(coeffs) == grade + 1
//    while (num_iter <= grade) {
//        b.append(coeffs[num_iter] + b[num_iter - 1] * z)
//        num_iter += 1
//    }
//
//    return b[num_iter+1]
//}

