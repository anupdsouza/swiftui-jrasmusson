import SwiftUI

struct PostsView: View {
    @StateObject var vm: PostViewModel
    @State var isLoading = false
    @State var showAddPost = false

    var body: some View {
        ZStack {
            NavigationStack {
                List(vm.posts) { post in
                    NavigationLink(value: post) {
                        Text(post.title)
                    }
                }
                .navigationTitle("Posts")
                .navigationDestination(for: Post.self) { post in
                    PostView(vm: vm, post: post)
                }
                .toolbar { addButton() }
                .fullScreenCover(isPresented: $showAddPost) {
                    AddPost(vm: vm, nextId: String(vm.posts.count + 1))
                }
                .alert(vm.errorMessage, isPresented: $vm.showingError) {
                    Button("OK", role: .cancel) { }
                }
                .task {
                    startFakeNetworkCall()
                    await vm.fetchPosts()
                }
            }
            if isLoading {
                LoadingView()
            }
        }
    }

    func startFakeNetworkCall() {
        isLoading = true
        // try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .opacity(0.8)
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(3)
        }
    }
}

// MARK: - Controls
extension PostsView {
    private func addButton() -> Button<Image> {
        return Button(action: {
            showAddPost.toggle()
        }) {
            Image(systemName: "plus")
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(vm: PostViewModel())
            .preferredColorScheme(.dark)
    }
}
