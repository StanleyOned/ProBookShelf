//
//  BookController.swift
//  App
//
//  Created by Stanle De La Cruz on 10/18/18.
//

import Vapor

final class BookController: RouteCollection {
    
    func boot(router: Router) throws {
        let bookRoutes = router.grouped("api", "books")
        
        bookRoutes.get(use: getAllBooks)
        bookRoutes.post(Book.self, use: createBookHandler)
    }
    
    func getAllBooks(_ req: Request) throws -> Future<[Book]> {
        return Book.query(on: req).all()
    }
    
    func createBookHandler(_ req: Request, book: Book) throws -> Future<Book> {
        return book.save(on: req)
    }
}
