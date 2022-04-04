//
//  Post.swift
//  Mlem
//
//  Created by David Bureš on 25.03.2022.
//

import Foundation
import SwiftUI

// MARK: - RawResponsePost
struct RawResponsePost: Codable {
    let op: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let posts: [Post]
}

// MARK: - Post
struct Post: Codable, Identifiable {
    let id: Int
    let name: String
    let url: String?
    let body: String?
    let creatorID: Int
    let communityID: Int
    let removed, locked: Bool?
    let published: String
    let updated: String?
    let deleted, nsfw, stickied, featured: Bool?
    let embedTitle, embedDescription, embedHTML: String?
    let thumbnailURL: String?
    // let apID: String
    let local: Bool?
    // let creatorActorID: String
    // let creatorLocal: Bool
    let creatorName: String
    let creatorPreferredUsername: JSONNull?
    let creatorPublished: String
    let creatorAvatar: JSONNull?
    let creatorTags: CreatorTags?
    let creatorCommunityTags: JSONNull?
    // let banned, bannedFromCommunity: Bool
    let communityActorID: String
    // let communityLocal: Bool
    let communityName: String
    let communityIcon: JSONNull?
    let communityRemoved, communityDeleted, communityNsfw, communityHideFromAll: Bool?
    let numberOfComments, score, upvotes, downvotes: Int
    let hotRank, hotRankActive: Int?
    let newestActivityTime: String?
    let userID, myVote, subscribed, read: JSONNull?
    let saved: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, name, url, body
        case creatorID = "creator_id"
        case communityID = "community_id"
        case removed, locked, updated, deleted, nsfw, stickied, featured
        case published = "published"
        case embedTitle
        case embedDescription
        case embedHTML
        case thumbnailURL = "thumbnail_url"
        // case apID
        case local
        // case creatorActorID
        // case creatorLocal
        case creatorName = "creator_name"
        case creatorPreferredUsername
        case creatorPublished = "creator_published"
        case creatorAvatar
        case creatorTags
        case creatorCommunityTags
        // case banned
        // case bannedFromCommunity
        case communityActorID = "community_actor_id"
        // case communityLocal
        case communityName = "community_name"
        case communityIcon
        case communityRemoved
        case communityDeleted
        case communityNsfw
        case communityHideFromAll
        case numberOfComments = "number_of_comments"
        case score, upvotes, downvotes
        case hotRank
        case hotRankActive
        case newestActivityTime
        case userID
        case myVote
        case subscribed, read, saved
    }
}

// MARK: - CreatorTags
struct CreatorTags: Codable {
    let pronouns: String
}

// MARK: Můj kód
class PostData_Decoded: ObservableObject {
    
    @Published var isLoading = true
    @Published var decodedPosts = [Post]()
    
    func decodeRawPostJSON(postRawData: String) {
        do {
            let decoder = JSONDecoder()
            let decodedPosts = try decoder.decode(RawResponsePost.self, from: postRawData.data(using: .utf8)!)
            
            print("Decoding post JSON:")
            print(postRawData)
            
            print("Into post objects:")
            print(decodedPosts)
            
            self.isLoading = false
            
            self.decodedPosts = decodedPosts.data.posts
        } catch {
            print("Failed to decode: \(error)")
        }
    }
    
    func pushPostsToStorage(decodedPostData: [Post]) {
        @ObservedObject var decodedPostStorage = DecodedPostStorage()
        
        decodedPostStorage.storedDecodedPosts.append(contentsOf: decodedPostData)
        
        print("""
        Successfuly appended to storage. Now contains:
        \(decodedPostStorage.storedDecodedPosts)
        """)
    }
}
