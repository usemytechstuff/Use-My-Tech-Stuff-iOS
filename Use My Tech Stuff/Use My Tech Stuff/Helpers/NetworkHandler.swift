//
//  NetworkHandler.swift
//
//  Created by Michael Redig on 5/7/19.
//  Copyright © 2019 Michael Redig. All rights reserved.
//
//swiftlint:disable line_length

import Foundation

enum HTTPMethods: String {
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
	case get = "GET"
	case head = "HEAD"
	case patch = "PATCH"
	case options = "OPTIONS"
}

enum NetworkError: Error {
	case otherError(error: Error)
	case badData
	case dataDecodeError(specifically: Error)
	case imageDecodeError
	case noStatusCodeResponse
	case httpNon200StatusCode(code: Int)
}

class NetworkHandler {

	var printErrorsToConsole = false
	var strict200CodeResponse = true
	lazy var netDecoder = {
		return JSONDecoder()
	}()

	func transferMahDatas(with request: URLRequest, session: URLSession = URLSession.shared, completion: @escaping (Result<Data, NetworkError>) -> Void) {
		session.dataTask(with: request) { [weak self] (data, response, error) in
			guard let self = self else { return }
			if let response = response as? HTTPURLResponse {
				if self.strict200CodeResponse && response.statusCode != 200 {
					self.printToConsole("Received a non 200 http response: \(response.statusCode)")
					completion(.failure(.httpNon200StatusCode(code: response.statusCode)))
					return
				} else if !self.strict200CodeResponse && !(200..<300).contains(response.statusCode) {
					self.printToConsole("Received a non 200 http response: \(response.statusCode)")
					completion(.failure(.httpNon200StatusCode(code: response.statusCode)))
					return
				}
			} else {
				self.printToConsole("Did not receive a proper response code")
				completion(.failure(.noStatusCodeResponse))
				return
			}

			if let error = error {
				self.printToConsole("An error was encountered: \(error)")
				completion(.failure(.otherError(error: error)))
				return
			}

			guard let data = data else {
				self.printToConsole("\(NetworkError.badData)")
				completion(.failure(.badData))
				return
			}

			completion(.success(data))

			}.resume()
	}

	func transferMahCodableDatas<T: Decodable>(with request: URLRequest, session: URLSession = URLSession.shared, completion: @escaping (Result<T, NetworkError>) -> Void) {

		self.transferMahDatas(with: request) { [weak self] (result) in
			guard let self = self else { return }
			let decoder = self.netDecoder

			var data = Data()
			do {
				data = try result.get()
			} catch {
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
				return
			}

			do {
				let newType = try decoder.decode(T.self, from: data)
				completion(.success(newType))
			} catch {
				self.printToConsole("Error decoding data: \(error)")
				completion(.failure(.dataDecodeError(specifically: error)))
			}
		}
	}

	private func printToConsole(_ string: String) {
		if printErrorsToConsole {
			print(string)
		}
	}
}
