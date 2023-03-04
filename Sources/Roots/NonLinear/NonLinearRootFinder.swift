import RealModule

public typealias RealFunc<R: Real> = (R) -> (R)

public struct NonLinearRoot<R: Real> {
    public var root: R
    public var xvect: [R]
    public var xdiff: [R]
}

public enum NonLinearRootFinderError<R: Real>: Error, Equatable {
    case invalidEndpoints
    case zeroDerivative(bestApproximation: R)
    case invalidTolerance(tol: R)
}

public class NonLinearRootFinder<R: Real> {
    private var tol: R
    private var maxIter: Int64
    
    public init(_ tol: R, _ maxIter: Int64) {
        self.tol = tol
        self.maxIter = maxIter
    }
    
    public func setTolerance(_ tol: R) {
        self.tol = tol
    }
    
    public func setMaxIterations(_ maxIter: Int64) {
        self.maxIter = maxIter
    }
    
    private func areEndpointsStraddlingAbscissa(fa: R, fb: R) -> Bool {
        return (fa * fb) < 0
    }
    
    public func bisect(_ f: RealFunc<R>, _ a: R, _ b: R) throws -> NonLinearRoot<R> {
        var num_iter: Int = 0
        var err: R = self.tol + 1
        var xvect: [R] = []
        var xdiff: [R] = []
        var inf = a
        var sup = b
        
        guard self.areEndpointsStraddlingAbscissa(fa: f(a), fb: f(b)) else {
            throw NonLinearRootFinderError<R>.invalidEndpoints
        }
        
        guard self.tol > 0 else {
            throw NonLinearRootFinderError.invalidTolerance(tol: self.tol)
        }
        
        while (err > self.tol && num_iter < self.maxIter) {
            num_iter += 1
            let x = (inf + sup) / 2
            let fx = f(x)
            xvect.append(x)
            let fa = f(inf)
            if self.areEndpointsStraddlingAbscissa(fa: fx, fb: fa) {
                sup = x
            } else {
                inf = x
            }
            err = abs(sup - inf) / 2
            xdiff.append(err)
        }
        
        return NonLinearRoot(root: xvect.last!, xvect: xvect, xdiff: xdiff)
    }
    
    public func chord(_ f: RealFunc<R>, _ a: R, _ b: R, _ x0: R) throws -> NonLinearRoot<R> {
        var num_iter: Int = 0
        var err = self.tol + 1
        var xvect: [R] = [x0]
        var xdiff: [R] = []
        let fa = f(a)
        let fb = f(b)
        var fx = f(x0)
        let r = (fb - fa) / (b - a)
        var curr_x = x0
        
        guard self.areEndpointsStraddlingAbscissa(fa: fa, fb: fb) else {
            throw NonLinearRootFinderError<R>.invalidEndpoints
        }
        
        guard self.tol > 0 else {
            throw NonLinearRootFinderError.invalidTolerance(tol: self.tol)
        }
        
        while (err > self.tol && num_iter < self.maxIter) {
            num_iter += 1
            let x = curr_x - fx / r
            fx = f(x)
            err = abs(x - curr_x)
            xdiff.append(err)
            xvect.append(x)
            curr_x = x
        }
        
        return NonLinearRoot(root: xvect.last!, xvect: xvect, xdiff: xdiff)
    }
    
    public func secant(_ f: RealFunc<R>, _ x0: R, _ x1: R) throws -> NonLinearRoot<R> {
        var num_iter: Int = 0
        var err = self.tol + 1
        var curr_x1 = x1
        var curr_x0 = x0
        var curr_fx1 = f(x1)
        var curr_fx0 = f(x0)
        var xvect: [R] = [x1, x0]
        var xdiff: [R] = []
        
        guard self.areEndpointsStraddlingAbscissa(fa: curr_fx0, fb: curr_fx1) else {
            throw NonLinearRootFinderError<R>.invalidEndpoints
        }
        
        guard self.tol > 0 else {
            throw NonLinearRootFinderError.invalidTolerance(tol: self.tol)
        }
        
        while (err > self.tol && num_iter < self.maxIter) {
            num_iter += 1
            let x =  curr_x0 - curr_fx0 * (curr_x0 - curr_x1) / ( curr_fx0 - curr_fx1)
            let y = f(x)
            xvect.append(x)
            err = abs(curr_x0 - x)
            xdiff.append(err)
            curr_x1 = curr_x0
            curr_fx1 = curr_fx0
            curr_x0 = x
            curr_fx0 = y
        }
        
        return NonLinearRoot(root: xvect.last!, xvect: xvect, xdiff: xdiff)
    }
    
    public func newton(_ f: RealFunc<R>, _ df: RealFunc<R>, _ x0: R) throws -> NonLinearRoot<R> {
        var num_iter: Int = 0
        var err = self.tol + 1
        var xvect: [R] = [x0]
        var xdiff: [R] = []
        var fx0 = f(x0)
        var curr_x0 = x0
        
        guard self.tol > 0 else {
            throw NonLinearRootFinderError.invalidTolerance(tol: self.tol)
        }
        
        while (err > self.tol && num_iter < self.maxIter) {
            let dfx0 = df(curr_x0)
            guard dfx0 != 0 else {
                throw NonLinearRootFinderError<R>.zeroDerivative(bestApproximation: xvect.last!)
            }
            let x = curr_x0 - fx0 / dfx0
            err = abs(x - curr_x0)
            xdiff.append(err)
            curr_x0 = x
            fx0 = f(curr_x0)
            num_iter += 1
            xvect.append(curr_x0)
        }
        
        return NonLinearRoot(root: xvect.last!, xvect: xvect, xdiff: xdiff)
    }
}
