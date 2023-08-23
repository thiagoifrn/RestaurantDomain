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
        sut.load()
        
        XCTAssertEqual(clientSpy.urlRequests, [anyURL])
    }
    
    func testloadTwice() throws {
        let anyURL = try XCTUnwrap(URL(string: "https://comitando.com.br"))
        let clientSpy = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: clientSpy)
        sut.load()
        sut.load()
        
        XCTAssertEqual(clientSpy.urlRequests, [anyURL, anyURL])
    }

}

final class NetworkClientSpy: NetworkClient {
    private(set) var urlRequests: [URL] = []
    
    func request(from url: URL) {
        urlRequests.append(url)
    }
}
