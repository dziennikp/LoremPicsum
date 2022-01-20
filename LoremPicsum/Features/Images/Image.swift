struct Image: Decodable, Identifiable, Hashable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}
