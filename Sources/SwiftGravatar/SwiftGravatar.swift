//
//  SwiftGravatar.swift
//
//
//  Created by Roberto Machorro on 7/21/23.
//

import Foundation
import Crypto

public struct GravatarProfile: Decodable {
	public let entry: [Entry]

	public init(entry: [Entry]) {
		self.entry = entry
	}

	public struct Entry: Decodable {
		public let id: String?
		public let hash: String
		public let requestHash: String
		public let profileUrl: String?
		public let preferredUsername: String?
		public let thumbnailUrl: String?
		public let photos: [Photo]?
		public let name: Name?
		public let displayName: String?
		public let pronouns: String?
		public let aboutMe: String?
		public let currentLocation: String?
		public let emails: [Email]?
		public let ims: [InstantMessenger]?
		public let accounts: [Account]?
		public let urls: [Websites]?
	}

	public struct Photo: Decodable {
		public let value: String
		public let type: String // WISHLIST: Build Enum with all types
	}

	public struct Name: Decodable {
		public let givenName: String?
		public let familyName: String?
		public let formatted: String?
	}

	public struct Email: Decodable {
		public let primary: BooleanString
		public let value: String
	}

	public struct InstantMessenger: Decodable {
		public let type: String // WISHLIST: Build Enum with all types
		public let value: String
	}

	public struct Account: Decodable {
		public let domain: String
		public let display: String
		public let url: String
		public let username: String
		public let verified: BooleanString
		public let shortname: String
	}

	public struct Websites: Decodable {
		public let value: String
		public let title: String
	}

	// WORKAROUND: Gravatar sends Booleans as Strings, which bypasses decoding.
	public enum BooleanString: String, Decodable {
		case yes = "true"
		case no = "false" // swiftlint:disable:this identifier_name
	}
}

extension GravatarProfile {
	// Converts e-mail address to a Gravatar web address.
	public static func getProfileAddress(using email: String) -> String? {
		guard let emailData = email.data(using: .utf8) else {
			return nil
		}
		let emailMD5 = Insecure.MD5.hash(data: emailData).map { String(format: "%02hhx", $0) }.joined()
		return "https://en.gravatar.com/\(emailMD5).json"
	}

	// Request JSON Profile Data from Gravatar
	// Docs: https://en.gravatar.com/site/implement/profiles/json/
	public static func getProfile(using email: String) async throws -> GravatarProfile? {
		guard let address = getProfileAddress(using: email), let url = URL(string: address) else {
			return nil
		}
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let profile = try JSONDecoder().decode(GravatarProfile.self, from: data)
			return profile
		} catch {
			// Silent fail
		}
		return nil
	}

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
