//
//  PostsViewModel.swift
//  Posts
//
//  Created by jrasmusson on 2022-07-07.
//

import Foundation

enum NetworkError: Error {
    case networkFailed, invalidResponse, decodeFailed
}

struct Post: Hashable, Identifiable, Codable {
    var id: String
    let title: String
    let body: String
}

let post1 = Post(id: "1", title: "title1", body: "body1")

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts = [post1]
    @Published var showingError = false
    var errorMessage = ""

    func updateModel(_ newPost: Post) {
        let possibleUpdateIndex = posts.firstIndex { $0.id == newPost.id }
        guard let updateIndex = possibleUpdateIndex else { return }
        posts[updateIndex] = newPost
    }
}

// MARK: - Networking
extension PostViewModel {
    func fetchPosts() async {
        let fetchTask = Task { () -> [Post] in
            let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/posts")!
            let data: Data
            let urlResponse: URLResponse

            do {
                (data, urlResponse) = try await URLSession.shared.data(from: url)
                guard let response = urlResponse as? HTTPURLResponse else { return [Post]() }

                if response.statusCode == 200 {
                    if let companies = try JSONDecoder().decode([Post].self, from: data) {
                        return companies
                    } else {
                        throw NetworkError.decodeFailed
                    }
                }
                else {
                    throw NetworkError.invalidResponse
                }
            } catch {
                throw NetworkError.networkFailed
            }
        }

        let result = await fetchTask.result

        do {
            self.posts = try result.get()
            self.showingError = false
        } catch NetworkError.networkFailed {
            showError("Unable to fetch the quotes.")
        } catch NetworkError.decodeFailed {
            showError("Unable to convert quotes to text.")
        } catch NetworkError.invalidResponse {
            showError("Invalid HTTP response.")
        } catch {
            showError("Unknown error.")
        }
    }

    func savePost(_ post: Post) {
        guard let uploadData = try? JSONEncoder().encode(post) else {
            return
        }

        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    }

    func updatePost(_ post: Post) {
        guard let uploadData = try? JSONEncoder().encode(post) else { return }
        guard let id = Int(post.id) else { return }

        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/posts/\(id - 1)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    }

    func deletePost() {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/posts/1")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }.resume()
    }

    func showError(_ message: String) {
        self.showingError = true
        self.errorMessage = message
    }
}
