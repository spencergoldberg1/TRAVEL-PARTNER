protocol TableRepresentable {
    associatedtype Guest: GuestRepresentable
    
    var name: String { get }
    var alias: String? { get }
    var occasion: Table.Occasion? { get }
    var guests: Set<Guest> { get }
    var pendingGuests: Set<Guest> { get }
    var serverId: String? { get set }
    var isOpen: Bool { get }
    var code: String? { get }
}
