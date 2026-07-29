import SwiftUI

/// A two-column label/value grid used for device details.
struct GridInfoView: View {
    struct Item: Identifiable {
        let id: UUID
        let title: LocalizedStringKey
        let value: String

        init(title: LocalizedStringKey, value: String) {
            self.id = UUID()
            self.title = title
            self.value = value
        }
    }

    private let items: [Item]

    init(items: [Item]) {
        self.items = items
    }

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: 4) {
            ForEach(items) { item in
                GridRow(alignment: .center) {
                    Text(item.title)
                        .foregroundStyle(Color.secondary)
                    Text(item.value)
                        .foregroundStyle(Color.primary)
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GridInfoView(
        items: [
            GridInfoView.Item(
                title: "Device ID",
                value: "CAPNOSTREAM20 SW v02.14.00"
            ),
            GridInfoView.Item(
                title: "Port",
                value: "/dev/cu.usbserial-A5069RR4"
            ),
            GridInfoView.Item(
                title: "Baud",
                value: "9600"
            ),
            GridInfoView.Item(
                title: "Protocol",
                value: "Oridion/Medtronic Host Protocol v2"
            )
        ]
    )
}
