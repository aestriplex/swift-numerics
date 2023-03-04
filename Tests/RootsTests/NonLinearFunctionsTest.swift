import RealModule
import XCTest
import Roots
import _TestSupport

final class NonLinearRootFinderTest: XCTestCase {
    
    let DEFAULT_MAX_ITER : Int64 = Int64(1e2)
    let DEFAULT_TOLERANCE : Float64 = 1e-10
    
    private func function(x: Float64) -> Float64 {
        return sin(x)
    }
    
    private func derivative(x: Float64) -> Float64 {
        return cos(x)
    }
    
    func testZeroToleranceShouldThrow() {
        let finder = NonLinearRootFinder(0, DEFAULT_MAX_ITER)
        
        XCTAssertThrowsError(try finder.bisect(self.function, 3.0001, 3.5)) {
            error in XCTAssertEqual(error as! NonLinearRootFinderError, NonLinearRootFinderError.invalidTolerance(tol: 0))
        }
        
        XCTAssertThrowsError(try finder.secant(function, 3.001, 3.50003)) {
            error in XCTAssertEqual(error as! NonLinearRootFinderError, NonLinearRootFinderError.invalidTolerance(tol: 0))
        }
        
        XCTAssertThrowsError(try finder.chord(self.function, 3.001, 3.50003, 2.90002)) {
            error in XCTAssertEqual(error as! NonLinearRootFinderError, NonLinearRootFinderError.invalidTolerance(tol: 0))
        }
        
        XCTAssertThrowsError(try finder.newton(function, derivative, 2.90002)) {
            error in XCTAssertEqual(error as! NonLinearRootFinderError, NonLinearRootFinderError.invalidTolerance(tol: 0))
        }
    }

    func testBisect() throws {
        let finder = NonLinearRootFinder(DEFAULT_TOLERANCE, DEFAULT_MAX_ITER)

        let actual = try finder.bisect(self.function, 3.0001, 3.5)
        let tenDigitsPi = 3.1415926535

        XCTAssert(abs(tenDigitsPi - actual.root) < 10 * DEFAULT_TOLERANCE)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testSecant() throws {
        let finder = NonLinearRootFinder(DEFAULT_TOLERANCE, DEFAULT_MAX_ITER)

        let actual = try finder.secant(function, 3.001, 3.50003)
        let tenDigitsPi = 3.1415926535

        XCTAssert(abs(tenDigitsPi - actual.root) < 10 * DEFAULT_TOLERANCE)
    }

    func testChord() throws {
        let finder = NonLinearRootFinder(DEFAULT_TOLERANCE, DEFAULT_MAX_ITER)

        let actual = try finder.chord(self.function, 3.001, 3.503, 2.90002)
        let tenDigitsPi = 3.1415926535

        XCTAssert(abs(tenDigitsPi - actual.root) < 10 * DEFAULT_TOLERANCE)
    }
    
    func testNewton() throws {
        let finder = NonLinearRootFinder(DEFAULT_TOLERANCE, DEFAULT_MAX_ITER)

        let actual = try finder.newton(function, derivative, 2.90002)
        let tenDigitsPi = 3.1415926535

        XCTAssert(abs(tenDigitsPi - actual.root) < 10 * DEFAULT_TOLERANCE)
    }
}
