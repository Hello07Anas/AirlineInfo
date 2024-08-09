//
//  ImageLoaderTests.swift
//  AirlineInfoTests
//
//  Created by Anas Salah on 09/08/2024.
//

import XCTest
@testable import AirlineInfo
import SDWebImage

class ImageLoaderTests: XCTestCase {
    
    func testImageLoadingUsedForValidURL() {
        //  Setup || Arrange || Given
        let url = K.Test_Img
        let imageView = UIImageView()
        let expectation = self.expectation(description: "Image should be loaded")
        
        // Exercise || Act || When
        ImageLoader.loadImage(from: url, into: imageView) { image in
        // Verify || Assert || Then
            XCTAssertNotNil(image, "Image should not be nil")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPlaceholderUsedForInvalidURL() {
        // Arrange
        let invalidURL = "https://Anas.com"
        let placeholderImage = UIImage(named: "placeholder")
        let imageView = UIImageView()
        
        // Act
        ImageLoader.loadImage(from: invalidURL, into: imageView, placeholder: placeholderImage) { image in
            // Assert
            XCTAssertEqual(imageView.image, placeholderImage, "Placeholder image should be used for an invalid URL")
        }
    }
}
