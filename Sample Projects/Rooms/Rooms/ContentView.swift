import SwiftUI

struct ContentView: View {
    var rooms: [Room] = []
    
    var body: some View {
        List(rooms) { room in
            Image(room.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(room.name)
                Text("\(room.capacity) people")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(rooms: testData )
    }
}
