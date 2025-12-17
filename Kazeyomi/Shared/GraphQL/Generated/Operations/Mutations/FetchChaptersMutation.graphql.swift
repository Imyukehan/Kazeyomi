// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class FetchChaptersMutation: GraphQLMutation {
    static let operationName: String = "FetchChapters"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation FetchChapters($mangaId: Int!) { fetchChapters(input: { mangaId: $mangaId }) { __typename chapters { __typename id } } }"#
      ))

    public var mangaId: Int

    public init(mangaId: Int) {
      self.mangaId = mangaId
    }

    public var __variables: Variables? { ["mangaId": mangaId] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("fetchChapters", FetchChapters?.self, arguments: ["input": ["mangaId": .variable("mangaId")]]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        FetchChaptersMutation.Data.self
      ] }

      var fetchChapters: FetchChapters? { __data["fetchChapters"] }

      /// FetchChapters
      ///
      /// Parent Type: `FetchChaptersPayload`
      struct FetchChapters: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.FetchChaptersPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("chapters", [Chapter].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          FetchChaptersMutation.Data.FetchChapters.self
        ] }

        var chapters: [Chapter] { __data["chapters"] }

        /// FetchChapters.Chapter
        ///
        /// Parent Type: `ChapterType`
        struct Chapter: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.ChapterType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            FetchChaptersMutation.Data.FetchChapters.Chapter.self
          ] }

          var id: Int { __data["id"] }
        }
      }
    }
  }

}