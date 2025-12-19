// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class UpdateMangaCategoriesMutation: GraphQLMutation {
    static let operationName: String = "UpdateMangaCategories"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateMangaCategories($id: Int!, $patch: UpdateMangaCategoriesPatchInput!) { updateMangaCategories(input: { id: $id, patch: $patch }) { __typename manga { __typename id categories { __typename nodes { __typename id name order default } } } } }"#
      ))

    public var id: Int
    public var patch: UpdateMangaCategoriesPatchInput

    public init(
      id: Int,
      patch: UpdateMangaCategoriesPatchInput
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
        .field("updateMangaCategories", UpdateMangaCategories?.self, arguments: ["input": [
          "id": .variable("id"),
          "patch": .variable("patch")
        ]]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateMangaCategoriesMutation.Data.self
      ] }

      var updateMangaCategories: UpdateMangaCategories? { __data["updateMangaCategories"] }

      /// UpdateMangaCategories
      ///
      /// Parent Type: `UpdateMangaCategoriesPayload`
      struct UpdateMangaCategories: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.UpdateMangaCategoriesPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("manga", Manga.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          UpdateMangaCategoriesMutation.Data.UpdateMangaCategories.self
        ] }

        var manga: Manga { __data["manga"] }

        /// UpdateMangaCategories.Manga
        ///
        /// Parent Type: `MangaType`
        struct Manga: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.MangaType }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int.self),
            .field("categories", Categories.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            UpdateMangaCategoriesMutation.Data.UpdateMangaCategories.Manga.self
          ] }

          var id: Int { __data["id"] }
          var categories: Categories { __data["categories"] }

          /// UpdateMangaCategories.Manga.Categories
          ///
          /// Parent Type: `CategoryNodeList`
          struct Categories: TachideskAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.CategoryNodeList }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("nodes", [Node].self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              UpdateMangaCategoriesMutation.Data.UpdateMangaCategories.Manga.Categories.self
            ] }

            var nodes: [Node] { __data["nodes"] }

            /// UpdateMangaCategories.Manga.Categories.Node
            ///
            /// Parent Type: `CategoryType`
            struct Node: TachideskAPI.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.CategoryType }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("id", Int.self),
                .field("name", String.self),
                .field("order", Int.self),
                .field("default", Bool.self),
              ] }
              static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                UpdateMangaCategoriesMutation.Data.UpdateMangaCategories.Manga.Categories.Node.self
              ] }

              var id: Int { __data["id"] }
              var name: String { __data["name"] }
              var order: Int { __data["order"] }
              var `default`: Bool { __data["default"] }
            }
          }
        }
      }
    }
  }

}