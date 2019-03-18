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
        bookRoutes.get(Int.parameter, use: getBookForId)
        bookRoutes.post(Book.self, use: createBookHandler)
        bookRoutes.put(Book.parameter, use: updateHandler)
        bookRoutes.delete(Book.parameter, use: deleteHandler)
        bookRoutes.delete("clear", use: resetData)
    }
    
    func getAllBooks(_ req: Request) throws -> Future<[Book]> {
        return Book.query(on: req).all()
    }

    func getBookForId(_ req: Request) throws -> Future<Book> {
        let id = try req.parameters.next(Int.self)
        return Book.find(id, on: req).unwrap(or: Abort.init(HTTPResponseStatus.notFound))
    }
    
    func createBookHandler(_ req: Request, book: Book) throws -> Future<Book> {
        return book.save(on: req)
    }
    
    func updateHandler(_ req: Request) throws -> Future<Book> {
        return try flatMap(to: Book.self,
                           req.parameters.next(Book.self),
                           req.content.decode(Book.self),
                           { book, updateBook -> Future<Book>  in
            
                            book.title = updateBook.title
                            book.author = updateBook.author
                            book.lastCheckedOut = updateBook.lastCheckedOut
                            book.lastCheckedOutBy = updateBook.lastCheckedOutBy
                            return book.save(on: req)
        })
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Book.self)
                   .delete(on: req)
                   .transform(to: HTTPStatus.noContent)
    }
    
    func resetData(req: Request) throws -> Future<Response> {
        return Book.query(on: req).delete().map(to: Response.self) {
            return Response(http: HTTPResponse(status: .ok), using: req)
        }
    }
}
