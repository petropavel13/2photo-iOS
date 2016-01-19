//
//  TwoPhotoTests.swift
//  TwoPhotoTests
//
//  Created by Иван Смолин on 20/01/16.
//  Copyright © 2016 null inc. All rights reserved.
//

import XCTest
@testable import TwoPhoto

class TwoPhotoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let authorAvatarUrl = "http://static.2photo.ru/images/anonym100.png"
        let authorName = "John"

        let post = Post.objectWithProperties([
                "id": 1,
                "author": [
                        "id": 1,
                        "name": authorName,
                        "avatar_url": authorAvatarUrl
                ]
        ])

        XCTAssertEqual(post.id, 1)
        XCTAssertEqual(post.author.id, 1)
        XCTAssertEqual(post.author.name, authorName)
        XCTAssertEqual(post.author.avatarUrl, authorAvatarUrl)
    }
}
