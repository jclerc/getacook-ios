//
//  GetACookTests.swift
//  GetACookTests
//
//  Created by Jonathan on 18/05/2017.
//
//

import XCTest
@testable import GetACook

//MARK: Item Class Tests
class GetACookTests: XCTestCase {
    
    // Confirm that the Item initializer returns a Item object when passed valid parameters.
    func testItemInitializationSucceeds() {
        // Zero rating
        let zeroRatingItem = Item.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingItem)
        
        // Highest positive rating
        let positiveRatingItem = Item.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingItem)
    }
    
    // Confirm that the Item initialier returns nil when passed a negative rating or an empty name.
    func testItemInitializationFails() {
        // Negative rating
        let negativeRatingItem = Item.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingItem)
    
        // Rating exceeds maximum
        let largeRatingItem = Item.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingItem)
        
        // Empty String
        let emptyStringItem = Item.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringItem)
   
    }
}
