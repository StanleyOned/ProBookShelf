//
//  Book.swift
//  App
//
//  Created by Stanle De La Cruz on 10/18/18.
//

import FluentPostgreSQL
import Vapor

final class Book: Codable {
    
    var id: Int?
    let title: String
    let author: String
    
    init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}
// The Fluent packages provide Model helper protocols for each database provider so you don’t have to specify the database or ID types, or the key. The SQLiteModel protocol must have an ID of type Int? called id, but there are SQLiteUUIDModel and SQLiteStringModel protocols for models with IDs of type UUID or String. If you want to customize the ID property name, you must conform to the standard Model protocol.
extension Book: PostgreSQLModel {}
// When your app’s user enters a new acronym, you need a way to save it. In Swift 4 and Vapor 3, Codable makes this trivial. Vapor provides Content, a wrapper around Codable, which allows you to convert models and other data between various formats. This is used extensively in Vapor
extension Book: Content {}
extension Book: Parameter {}
// To save the model in the database, you must create a table for it. Fluent does this with a migration. Migrations allow you to make reliable, testable, reproducible changes to your database. They are commonly used to create a database schema, or table description, for your models. They are also used to seed data into your database or make changes to your models after they’ve been saved.
extension Book: Migration {}
