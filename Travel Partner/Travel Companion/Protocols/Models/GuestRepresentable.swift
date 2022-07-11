import Foundation.NSURL

protocol GuestRepresentable: UserRepresentable, Hashable {
    var photoURL: URL? { get set }
    var foodPreferences: [String]? { get }
}
