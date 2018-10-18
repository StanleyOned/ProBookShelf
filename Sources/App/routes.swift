import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let bookController = BookController()
    try router.register(collection: bookController)
}
