// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class UpdateMangaMutation: GraphQLMutation {
    static let operationName: String = "UpdateManga"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateManga($id: Int!, $patch: UpdateMangaPatchInput!) { updateManga(input: { id: $id, patch: $patch }) { __typename manga { __typename id inLibrary inLibraryAt } } }"#
      ))

    public var id: Int
    public var patch: UpdateMangaPatchInput

    public init(
      id: Int,
      patch: UpdateMangaPatchInput
    ) {
      self.id = id
      self.patch = patch
    }

    public var __variables: Variables? { [
      "id": id,
      "patch": patch
    ] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("updateManga", UpdateManga?.self, arguments: ["input": [
          "id": .variable("id"),
          "patch": .variable("patch")
        ]]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateMangaMutation.Data.self
      ] }

      var updateManga: UpdateManga? { __data["updateManga"] }

      /// UpdateManga
      ///
      /// Parent Type: `UpdateMangaPayload`
      struct UpdateManga: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.UpdateMangaPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("manga", Manga.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UpdateMangaMutation.Data.UpdateManga.self
        ] }

        var manga: Manga { __data["manga"] }

        /// UpdateManga.Manga
        ///
        /// Parent Type: `MangaType`
        struct Manga: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.MangaType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int.self),
            .field("inLibrary", Bool.self),
            .field("inLibraryAt", TachideskAPI.LongString.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            UpdateMangaMutation.Data.UpdateManga.Manga.self
          ] }

          var id: Int { __data["id"] }
          var inLibrary: Bool { __data["inLibrary"] }
          var inLibraryAt: TachideskAPI.LongString { __data["inLibraryAt"] }
        }
      }
    }
  }

}