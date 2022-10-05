//
//  CharactersDto.swift
//  ricky
//
//  Created by Jose Montero on 3/10/22.
//
// This file was generated from JSON Schema using codebeautify, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let characatersDto = try CharacatersDto(json)

import Foundation

// MARK: - CharacatersDto
struct CharacatersDto: Decodable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Decodable{
    let count, pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result
struct Character : Decodable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location : Decodable{
    let name: String
    let url: String
}
