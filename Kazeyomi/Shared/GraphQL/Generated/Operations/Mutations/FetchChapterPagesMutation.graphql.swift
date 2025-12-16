// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class FetchChapterPagesMutation: GraphQLMutation {
    static let operationName: String = "FetchChapterPages"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation FetchChapterPages($chapterId: Int!) { fetchChapterPages(input: { chapterId: $chapterId }) { __typename pages chapter { __typename id name mangaId } } }"#
      ))

    public var chapterId: Int

    public init(chapterId: Int) {
      self.chapterId = chapterId
    }

    public var __variables: Variables? { ["chapterId": chapterId] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("fetchChapterPages", FetchChapterPages?.self, arguments: ["input": ["chapterId": .variable("chapterId")]]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        FetchChapterPagesMutation.Data.self
      ] }

      var fetchChapterPages: FetchChapterPages? { __data["fetchChapterPages"] }

      /// FetchChapterPages
      ///
      /// Parent Type: `FetchChapterPagesPayload`
      struct FetchChapterPages: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.FetchChapterPagesPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pages", [String].self),
          .field("chapter", Chapter.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          FetchChapterPagesMutation.Data.FetchChapterPages.self
        ] }

        var pages: [String] { __data["pages"] }
        var chapter: Chapter { __data["chapter"] }

        /// FetchChapterPages.Chapter
        ///
        /// Parent Type: `ChapterType`
        struct Chapter: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.ChapterType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int.self),
            .field("name", String.self),
            .field("mangaId", Int.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            FetchChapterPagesMutation.Data.FetchChapterPages.Chapter.self
          ] }

          var id: Int { __data["id"] }
          var name: String { __data["name"] }
          var mangaId: Int { __data["mangaId"] }
        }
      }
    }
  }

}