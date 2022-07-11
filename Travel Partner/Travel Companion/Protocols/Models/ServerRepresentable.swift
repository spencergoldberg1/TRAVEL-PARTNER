import Foundation.NSURL
import Firebase

protocol ServerRepresentable: UserRepresentable, Equatable {
    var firstName: String? { get set }
    var lastName: String? { get set }
    var phoneNumber: String? { get }
    var birthDate: String? { get set }
    var workplace1: String? { get }
    var workplace2: String? { get }
    var hometown: String? { get }
    var menuURL: String? { get }
    var languages: [String: String] { get }
    var gender: String? { get }
//    var greet: String? { get }
    var compliments: [Server.Compliment.RawValue: Int] { get }
    var friends: [String]? { get }
    var position: String? { get }
    var versionNumber: String? { get }
    var buildNumber: Int? { get }
}
