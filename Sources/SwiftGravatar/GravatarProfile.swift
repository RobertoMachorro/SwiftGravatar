//
//  GravatarProfile.swift
//
//
//  Created by Roberto Machorro on 7/21/23.
//

import Foundation
import Crypto

struct GravatarName: Decodable {
	let givenName: String
	let familyName: String
	let formatted: String
}

struct GravatarEmail: Decodable {
	let primary: String // TODO: Decode to Bool
	let value: String
}

struct GravatarAccount: Decodable {
	let domain: String
	let display: String
	let url: String
	let username: String
	let verified: String // TODO: Decode to Bool
	let shortname: String
}

struct GravatarPhotos: Decodable {
	let value: String
	let type: String // TODO: Decode to Enum
}

struct GravatarIM: Decodable {
	let type: String // TODO: Decode to Enum
	let value: String
}

struct GravatarURL: Decodable {
	let value: String
	let title: String
}

struct GravatarProfileEntry: Decodable {
	//let id: String
	let hash: String
	let requestHash: String
	let profileUrl: String
	let preferredUsername: String
	let thumbnailUrl: String
	let photos: [GravatarPhotos]
	let name: GravatarName
	let displayName: String
	let pronouns: String
	let aboutMe: String
	let currentLocation: String
	let emails: [GravatarEmail]
	let ims: [GravatarIM]
	let accounts: [GravatarAccount]
	let urls: [GravatarURL]
}

struct GravatarProfile: Decodable {
	let entry: [GravatarProfileEntry]
}

extension GravatarProfile {
	/* SWIFTNIO
	static func get(using email: String, on request: Request) -> EventLoopFuture<GravatarProfile> {
		guard let emailData = email.data(using: .utf8) else {
			return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Bad email for Gravatar"))
		}
		let emailMD5 = Insecure.MD5.hash(data: emailData).map { String(format: "%02hhx", $0) }.joined()
		let profileUri: URI = "https://en.gravatar.com/\(emailMD5).json"
		return request.client
			.get(profileUri)
			.flatMapThrowing { response in
				guard response.status == .ok else {
					return GravatarProfile(entry: [])
				}
				// let profile = try response.content.decode(GravatarProfile.self)
				//return profile
				return GravatarProfile(entry: [])
			}
	}
	*/
}
