//
//  Post.swift
//  TwoPhoto
//
//  Created by Иван Смолин on 20/01/16.
//  Copyright © 2016 null inc. All rights reserved.
//

import Foundation

class Post : EKObjectModel {
    class Author : EKObjectModel {
        var id: NSNumber!
        var name: String!
        var avatarUrl: String!
    }
    
    var id: NSNumber!
    
    var author: Author!
}