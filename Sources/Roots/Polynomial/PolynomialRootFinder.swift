//
//  File.swift
//  
//
//  Created by Matteo Nicoli on 2/26/23.
//

import RealModule

class PolynomialRootFinder<R: Real> {
    private let tol: R
    private let max_iter: Int64
    
    init(tol: R, max_iter: Int64) {
        self.tol = tol
        self.max_iter = max_iter
    }
}
