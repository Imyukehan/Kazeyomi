// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class MangaDetailQuery: GraphQLQuery {
    static let operationName: String = "MangaDetail"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query MangaDetail($id: Int!, $chaptersFirst: Int!, $chaptersOffset: Int!) { manga(id: $id) { __typename id title thumbnailUrl author artist description status genre unreadCount inLibrary } chapters( first: $chaptersFirst offset: $chaptersOffset condition: { mangaId: $id } order: [{ by: SOURCE_ORDER, byType: DESC }] ) { __typename nodes { __typename id name chapterNumber scanlator isRead isDownloaded uploadDate } totalCount } }"#
      ))

    public var id: Int
    public var chaptersFirst: Int
    public var chaptersOffset: Int

    public init(
      id: Int,
      chaptersFirst: Int,
      chaptersOffset: Int
    ) {
      self.id = id
      self.chaptersFirst = chaptersFirst
      self.chaptersOffset = chaptersOffset
    }

    public var __variables: Variables? { [
      "id": id,
      "chaptersFirst": chaptersFirst,
      "chaptersOffset": chaptersOffset
    ] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("manga", Manga.self, arguments: ["id": .variable("id")]),
        .field("chapters", Chapters.self, arguments: [
          "first": .variable("chaptersFirst"),
          "offset": .variable("chaptersOffset"),
          "condition": ["mangaId": .variable("id")],
          "order": [[
            "by": "SOURCE_ORDER",
            "byType": "DESC"
          ]]
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MangaDetailQuery.Data.self
      ] }

      var manga: Manga { __data["manga"] }
      var chapters: Chapters { __data["chapters"] }

      /// Manga
      ///
      /// Parent Type: `MangaType`
      struct Manga: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.MangaType }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int.self),
          .field("title", String.self),
          .field("thumbnailUrl", String?.self),
          .field("author", String?.self),
          .field("artist", String?.self),
          .field("description", String?.self),
          .field("status", GraphQLEnum<TachideskAPI.MangaStatus>.self),
          .field("genre", [String].self),
          .field("unreadCount", Int.self),
          .field("inLibrary", Bool.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MangaDetailQuery.Data.Manga.self
        ] }

        var id: Int { __data["id"] }
        var title: String { __data["title"] }
        var thumbnailUrl: String? { __data["thumbnailUrl"] }
        var author: String? { __data["author"] }
        var artist: String? { __data["artist"] }
        var description: String? { __data["description"] }
        var status: GraphQLEnum<TachideskAPI.MangaStatus> { __data["status"] }
        var genre: [String] { __data["genre"] }
        var unreadCount: Int { __data["unreadCount"] }
        var inLibrary: Bool { __data["inLibrary"] }
      }

      /// Chapters
      ///
      /// Parent Type: `ChapterNodeList`
      struct Chapters: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.ChapterNodeList }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node].self),
          .field("totalCount", Int.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MangaDetailQuery.Data.Chapters.self
        ] }

        var nodes: [Node] { __data["nodes"] }
        var totalCount: Int { __data["totalCount"] }

        /// Chapters.Node
        ///
        /// Parent Type: `ChapterType`
        struct Node: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.ChapterType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int.self),
            .field("name", String.self),
            .field("chapterNumber", Double.self),
            .field("scanlator", String?.self),
            .field("isRead", Bool.self),
            .field("isDownloaded", Bool.self),
            .field("uploadDate", TachideskAPI.LongString.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MangaDetailQuery.Data.Chapters.Node.self
          ] }

          var id: Int { __data["id"] }
          var name: String { __data["name"] }
          var chapterNumber: Double { __data["chapterNumber"] }
          var scanlator: String? { __data["scanlator"] }
          var isRead: Bool { __data["isRead"] }
          var isDownloaded: Bool { __data["isDownloaded"] }
          var uploadDate: TachideskAPI.LongString { __data["uploadDate"] }
        }
      }
    }
  }

}