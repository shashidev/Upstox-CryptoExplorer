//
//  CoreDataService.swift
//  CryptoExplorer
//
//  Created by Shashi Ranjan on 05/12/24.
//

import Foundation


protocol CoreDataService {

    func save<T: Codable>(object: T, entityName: String, completion: @escaping (Result<Void, Error>) -> Void)

    func fetch<T: Codable>(entityName: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void)

    func delete(entityName: String, completion: @escaping (Result<Void, Error>) -> Void)
}
