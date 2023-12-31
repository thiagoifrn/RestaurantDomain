//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Thiago Pereira de souza on 23/08/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {
    
    private func makeSut() -> (sut: RemoteRestaurantLoader, clientSpy: NetworkClientSpy, anyUrl: URL){
        let anyURL = URL(string: "https://comitando.com.br")!
        let clientSpy = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: clientSpy)
        
        return (sut, clientSpy, anyURL)
    }
    
    func testInitRestaurantloader() throws {
        
        let (sut, clientSpy, anyUrl) = makeSut()
        
        sut.load() { _ in }
        
        XCTAssertEqual(clientSpy.urlRequests, [anyUrl])
    }
    
    func testloadTwice() throws {
        
        let (sut, clientSpy, anyUrl) = makeSut()
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(clientSpy.urlRequests, [anyUrl, anyUrl])
    }
    
    func testNotConnectivity() throws {
        let (sut, clientSpy, _) = makeSut()
        
        let exp = expectation(description: "Esperando retorno da clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        sut.load { result in
            returnedResult = result
            exp.fulfill()
        }
        clientSpy.completionWithError()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(returnedResult, .connectivity)
    }
    
    func testInvaliData() throws {
        let (sut, clientSpy, _) = makeSut()
        
        let exp = expectation(description: "Esperando retorno da clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        sut.load { result in
            returnedResult = result
            exp.fulfill()
        }
        clientSpy.completionWithSuccess()
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(returnedResult, .invalidData)
    }

}

final class NetworkClientSpy: NetworkClient {
    
    private(set) var urlRequests: [URL] = []
    private(set) var completionHandler: ((NetworkState) -> Void )?
    
    func request(from url: URL, completion: @escaping (NetworkState) -> Void) {
        urlRequests.append(url)
        completionHandler = completion
    }
    
    func completionWithError() {
        completionHandler?(.error(anyError()))
    }
    
    func completionWithSuccess() {
        completionHandler?(.success)
    }
    
    func anyError() -> Error {
        return NSError(domain: "Any error", code: -1)
    }
}
