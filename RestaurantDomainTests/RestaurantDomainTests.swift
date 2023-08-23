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
        let sut = RemoteRestaurantLoader(url: anyURL)
        
        sut.load()
        
        XCTAssertNotNil(NetworkClient.shared.urlRequest)
    }

}
