// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class ReadingHistoryQuery: GraphQLQuery {
    static let operationName: String = "ReadingHistory"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ReadingHistory($first: Int!, $offset: Int!) { chapters( first: $first offset: $offset filter: { lastReadAt: { isNull: false, greaterThan: "0" } or: [{ isRead: { equalTo: true } }, { lastPageRead: { greaterThan: 0 } }] } order: [{ by: LAST_READ_AT, byType: DESC }, { by: SOURCE_ORDER, byType: DESC }] ) { __typename nodes { __typename id name mangaId lastReadAt isRead lastPageRead isDownloaded scanlator manga { __typename id title thumbnailUrl unreadCount inLibrary } } pageInfo { __typename hasNextPage hasPreviousPage startCursor endCursor } totalCount } }"#
      ))

    public var first: Int
    public var offset: Int

    public init(
      first: Int,
      offset: Int
    ) {
      self.first = first
      self.offset = offset
    }

    public var __variables: Variables? { [
      "first": first,
      "offset": offset
    ] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("chapters", Chapters.self, arguments: [
          "first": .variable("first"),
          "offset": .variable("offset"),
          "filter": [
            "lastReadAt": [
              "isNull": false,
              "greaterThan": "0"
            ],
            "or": [["isRead": ["equalTo": true]], ["lastPageRead": ["greaterThan": 0]]]
          ],
          "order": [[
            "by": "LAST_READ_AT",
            "byType": "DESC"
          ], [
            "by": "SOURCE_ORDER",
            "byType": "DESC"
          ]]
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        ReadingHistoryQuery.Data.self
      ] }

      var chapters: Chapters { __data["chapters"] }

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
          .field("pageInfo", PageInfo.self),
          .field("totalCount", Int.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          ReadingHistoryQuery.Data.Chapters.self
        ] }

        var nodes: [Node] { __data["nodes"] }
        var pageInfo: PageInfo { __data["pageInfo"] }
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
            .field("mangaId", Int.self),
            .field("lastReadAt", TachideskAPI.LongString.self),
            .field("isRead", Bool.self),
            .field("lastPageRead", Int.self),
            .field("isDownloaded", Bool.self),
            .field("scanlator", String?.self),
            .field("manga", Manga.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            ReadingHistoryQuery.Data.Chapters.Node.self
          ] }

          var id: Int { __data["id"] }
          var name: String { __data["name"] }
          var mangaId: Int { __data["mangaId"] }
          var lastReadAt: TachideskAPI.LongString { __data["lastReadAt"] }
          var isRead: Bool { __data["isRead"] }
          var lastPageRead: Int { __data["lastPageRead"] }
          var isDownloaded: Bool { __data["isDownloaded"] }
          var scanlator: String? { __data["scanlator"] }
          var manga: Manga { __data["manga"] }

          /// Chapters.Node.Manga
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
              .field("unreadCount", Int.self),
              .field("inLibrary", Bool.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              ReadingHistoryQuery.Data.Chapters.Node.Manga.self
            ] }

            var id: Int { __data["id"] }
            var title: String { __data["title"] }
            var thumbnailUrl: String? { __data["thumbnailUrl"] }
            var unreadCount: Int { __data["unreadCount"] }
            var inLibrary: Bool { __data["inLibrary"] }
          }
        }

        /// Chapters.PageInfo
        ///
        /// Parent Type: `PageInfo`
        struct PageInfo: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.PageInfo }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("hasNextPage", Bool.self),
            .field("hasPreviousPage", Bool.self),
            .field("startCursor", TachideskAPI.Cursor?.self),
            .field("endCursor", TachideskAPI.Cursor?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            ReadingHistoryQuery.Data.Chapters.PageInfo.self
          ] }

          /// When paginating forwards, are there more items?
          var hasNextPage: Bool { __data["hasNextPage"] }
          /// When paginating backwards, are there more items?
          var hasPreviousPage: Bool { __data["hasPreviousPage"] }
          /// When paginating backwards, the cursor to continue.
          var startCursor: TachideskAPI.Cursor? { __data["startCursor"] }
          /// When paginating forwards, the cursor to continue.
          var endCursor: TachideskAPI.Cursor? { __data["endCursor"] }
        }
      }
    }
  }

}