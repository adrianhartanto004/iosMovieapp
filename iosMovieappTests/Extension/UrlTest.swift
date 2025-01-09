import XCTest
@testable import iosMovieapp

class URLTests: XCTestCase {
    
    func test_validURL_should_returnData() {
        let urlString = "https://www.google.com"
        let url = URL.initURL(urlString)
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, urlString)
    }
    
    func test_invalidURL_shouldReturnNil() {
        let urlString = "https://www.goo gle.com" 
        let url = URL.initURL(urlString)
        
        XCTAssertNil(url)
    }
    
    func test_emptyURLString_shouldReturnNil() {
        let urlString = ""
        let url = URL.initURL(urlString)
        
        XCTAssertNil(url)
    }
}
