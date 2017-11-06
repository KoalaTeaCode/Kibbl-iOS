//
//  DataSource.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 9/12/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import Foundation

protocol DataSource {
    associatedtype T
    
    func getAll() -> [T]
    func getById(id: String) -> T?
    func insert(item: T)
    func update(item: T)
    func clean()
    func deleteById(id: String)
}

//struct Book {
//    let title: String
//    let authors: [Author]
//    let isbn: String
//}
//
//struct Author {
//    let name: String
//    let surname: String
//}
//
//import RealmSwift
//
//class BooksRealmDataSource: DataSource {
//    func getById(id: String) -> Book? {
//        return nil
//    }
//
//    func update(item: Book) {
//        
//    }
//
//    typealias T = Book
//
//    private let realm = try! Realm()
//    
//    func getAll() -> [Book] {
//        return realm.objects(RealmBook.self).map { $0.entity }
//    }
//    
//    func getById(id: String) -> Book {
//        return realm.objects(RealmBook.self).filter("title = %@", id).first!.entity
//    }
//    
//    func insert(item: Book) {
//        try! realm.write {
//            realm.add(RealmBook(book: item))
//        }
//    }
//    
//    func clean() {
//        try! realm.write {
//            realm.delete(realm.objects(RealmBook.self))
//        }
//    }
//    
//    func deleteById(id: String) {
//        let object = self.getById(id: id)
//        try! realm.write {
//            realm.delete(RealmBook(book: object))
//        }
//    }
//}
//
//class RealmBook: Object {
//    dynamic var title: String = ""
//    dynamic var isbn: String = ""
//    dynamic var publishDate: NSDate = NSDate()
//    var authors = List<RealmAuthor>()
//    
//    convenience init(book: Book) {
//        self.init()
//        title = book.title
//        isbn = book.isbn
//        authors = List(book.authors.map { RealmAuthor(author: $0) })
//    }
//    
//    var entity: Book {
//        return Book(title: title,
//                    authors: authors.map { $0.entity },
//                    isbn: isbn)
//    }
//}
//
//class RealmAuthor: Object {
//    dynamic var name: String = ""
//    dynamic var surname: String = ""
//    
//    convenience init(author: Author) {
//        self.init()
//        name = author.name
//        surname = author.surname
//    }
//    
//    var entity: Author {
//        return Author(name: name,
//                      surname: surname)
//    }
//}
