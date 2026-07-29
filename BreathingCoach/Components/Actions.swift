import Foundation

typealias Action = () -> Void
typealias ActionWithInput<I> = (I) -> Void
typealias ActionWithOutput<O> = () -> O
typealias ActionWithInputAndOutput<I, O> = (I) -> O
