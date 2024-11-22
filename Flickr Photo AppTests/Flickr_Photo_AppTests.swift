//
//  Flickr_Photo_AppTests.swift
//  Flickr Photo AppTests
//
//  Created by Dmytro Ryshchuk on 11/21/24.
//

import XCTest
@testable import Flickr_Photo_App

final class Flickr_Photo_AppTests: XCTestCase {
    let viewModel = PhotoViewModel()
    
    func testFormattedDate() {
        let inputDate = "2024-11-22T10:00:00Z"
        let expectedOutput = "Nov 22, 2024"
        let result = viewModel.formattedDate(from: inputDate)
        XCTAssertEqual(result, expectedOutput, "Formatted date does not match expected value.")
    }
    
    func testExtractDescription() {
        let inputDate = """
                    <p><a href="https://www.flickr.com/people/cowyeow/">cowyeow</a> posted a photo:</p> <p><a href="https://www.flickr.com/photos/cowyeow/54156957470/" title="For Lease"><img src="https://live.staticflickr.com/65535/54156957470_d5cb2e40bf_m.jpg" width="167" height="240" alt="For Lease" /></a></p> <p>Venice Beach, California</p>
                    """
        let expectedOutput = "Venice Beach, California"
        let result = viewModel.extractDescription(from: inputDate)
        XCTAssertEqual(result, expectedOutput, "Description is does not match expected value.")
        
        let inputDate2 = """
                    <p><a href="https://www.flickr.com/people/cowyeow/">cowyeow</a> posted a photo:</p> <p><a href="https://www.flickr.com/photos/cowyeow/54156957470/" title="For Lease"><img src="https://live.staticflickr.com/65535/54156957470_d5cb2e40bf_m.jpg" width="167" height="240" alt="For Lease" /></a></p> <p>Venice Beach, California</p>
                    """
        let expectedOutput2 = "California"
        let result2 = viewModel.extractDescription(from: inputDate2)
        XCTAssertNotEqual(result2, expectedOutput2, "Input and expected value should not match each others.")
    }
    
    func testExtractAuthor() {
        let inputDate = "nobody@flickr.com (\"Dmytro.Ryshchuk\")"
        let expectedOutput = "Dmytro.Ryshchuk"
        let result = viewModel.extractAuthor(from: inputDate)
        XCTAssertEqual(result, expectedOutput, "Author name does not match expected value.")
    }
}
