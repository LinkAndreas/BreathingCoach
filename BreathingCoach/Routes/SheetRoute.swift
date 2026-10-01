import NavigationKit

nonisolated enum SheetRoute: Route {
    case onboarding

    var presentation: PresentationStyle? { .sheet }
}
