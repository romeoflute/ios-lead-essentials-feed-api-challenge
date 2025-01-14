
import Foundation

internal final class FeedImagesMapper {
	private struct Root: Decodable {
		let items: [Item]
		var feed: [FeedImage] {
			return items.map { $0.item }
		}
	}

	private struct Item: Decodable {
		let imageId: UUID
		let imageDesc: String?
		let imageLoc: String?
		let imageUrl: URL

		var item: FeedImage {
			return FeedImage(id: imageId, description: imageDesc, location: imageLoc, url: imageUrl)
		}
	}

	private static var OK_200: Int { return 200 }

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase

		guard response.statusCode == OK_200, let root = try? decoder.decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
		return .success(root.feed)
	}
}
