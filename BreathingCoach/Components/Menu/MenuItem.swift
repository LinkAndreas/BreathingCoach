import NavigationKit
import SwiftUI

struct MenuItem<ID: Hashable>: Identifiable {
    let id: ID
    let title: LocalizedStringKey
    let detailRoute: DetailRoute
}
