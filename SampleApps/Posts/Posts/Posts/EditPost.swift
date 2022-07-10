//
//  EditPost.swift
//  Posts
//
//  Created by jrasmusson on 2022-07-10.
//

import SwiftUI

struct EditPost: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: PostViewModel
    @State var newTitle = ""
    @State var post: Post

    @Binding var isEditting: Bool

    var body: some View {
        VStack(alignment: .leading) {
            TextField(post.title, text: $newTitle)
            Button("Save", action: update)
                .buttonStyle(.bordered)
            Spacer()
        }
    }

    func update() {
        let newPost = Post(id: post.id, title: newTitle)
        post = newPost
        vm.updateModel(newPost)
        vm.updatePost(newPost)
        isEditting = false
        dismiss()
    }
}

struct EditPost_Previews: PreviewProvider {
    @State private var isEditting: Bool = false

    static var previews: some View {
        EditPost(vm: PostViewModel(), post: post1, isEditting: .constant(false))
    }
}
