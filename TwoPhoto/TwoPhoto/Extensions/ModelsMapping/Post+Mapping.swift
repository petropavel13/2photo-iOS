//
//  Post+Mapping.swift
//  TwoPhoto
//
//  Created by Иван Смолин on 20/01/16.
//  Copyright © 2016 null inc. All rights reserved.
//

import Foundation

extension Post {
    override class func objectMapping() -> EKObjectMapping {
        return EKObjectMapping(forClass: self, withBlock: { mapping in
            mapping.mapPropertiesFromArray(["id"])

            mapping.hasOne(Post.Author.self, forKeyPath: "author")
        })
    }
}

extension Post.Author {
    override class func objectMapping() -> EKObjectMapping {
        return EKObjectMapping(forClass: self, withBlock: { mapping in
            mapping.mapPropertiesFromArray(["id", "name"])

            mapping.mapKeyPath("avatar_url", toProperty: "avatarUrl")
        })
    }
}