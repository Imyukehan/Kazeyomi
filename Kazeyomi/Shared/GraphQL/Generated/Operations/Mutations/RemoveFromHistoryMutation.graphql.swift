// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class RemoveFromHistoryMutation: GraphQLMutation {
    static let operationName: String = "RemoveFromHistory"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation RemoveFromHistory($chapterId: Int!) { updateChapter( input: { id: $chapterId, patch: { isRead: false, lastPageRead: 0 } } ) { __typename chapter { __typename id } } }"#
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
        .field("updateChapter", UpdateChapter?.self, arguments: ["input": [
          "id": .variable("chapterId"),
          "patch": [
            "isRead": false,
            "lastPageRead": 0
          ]
        ]]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        RemoveFromHistoryMutation.Data.self
      ] }

      var updateChapter: UpdateChapter? { __data["updateChapter"] }

      /// UpdateChapter
      ///
      /// Parent Type: `UpdateChapterPayload`
      struct UpdateChapter: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.UpdateChapterPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("chapter", Chapter.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          RemoveFromHistoryMutation.Data.UpdateChapter.self
        ] }

        var chapter: Chapter { __data["chapter"] }

        /// UpdateChapter.Chapter
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
            RemoveFromHistoryMutation.Data.UpdateChapter.Chapter.self
          ] }

          var id: Int { __data["id"] }
        }
      }
    }
  }

}