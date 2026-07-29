import Foundation

/// A parameterless callback passed from a composer down into a view, e.g. a button handler.
typealias Action = () -> Void

/// A callback that carries a value back up to the composer, e.g. the selected device.
typealias ActionWithInput<I> = (I) -> Void
