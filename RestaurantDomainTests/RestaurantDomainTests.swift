//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Thiago Pereira de souza on 23/08/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {
    
    func testInitRestaurantloader() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let clientSpy = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: clientSpy)
        sut.load() { _ in }
        
        XCTAssertEqual(clientSpy.urlRequests, [anyURL])
    }
    
    func testloadTwice() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let clientSpy = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: clientSpy)
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(clientSpy.urlRequests, [anyURL, anyURL])
    }
    
    func testNotConnectivity() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let clientSpy = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: clientSpy)
        
        let exp = expectation(description: "Esperando retorno da clousure")
        var returnedError: Error?
        sut.load { error in
            returnedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(returnedError)
    }

}

final class NetworkClientSpy: NetworkClient {
    
    private(set) var urlRequests: [URL] = []
    
    func request(from url: URL, completion: @escaping (Error) -> Void) {
        urlRequests.append(url)
        completion(anyError())
    }
    
    func anyError() -> Error {
        return NSError(domain: "Any error", code: -1)
    }
}
