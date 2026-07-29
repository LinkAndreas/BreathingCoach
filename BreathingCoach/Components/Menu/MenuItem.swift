import SwiftUI

/// One sidebar entry: its identity, its label, and the detail route selecting it opens.
struct MenuItem<ID: Hashable>: Identifiable {
    let id: ID
    let title: LocalizedStringKey
    let detailRoute: DetailRoute
}
