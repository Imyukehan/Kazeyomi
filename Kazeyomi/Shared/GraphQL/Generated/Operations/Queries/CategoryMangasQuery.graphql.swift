// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class CategoryMangasQuery: GraphQLQuery {
    static let operationName: String = "CategoryMangas"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query CategoryMangas($categoryId: Int!) { category(id: $categoryId) { __typename mangas { __typename nodes { __typename id title thumbnailUrl inLibrary sourceId } } } }"#
      ))

    public var categoryId: Int

    public init(categoryId: Int) {
      self.categoryId = categoryId
    }

    public var __variables: Variables? { ["categoryId": categoryId] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("category", Category.self, arguments: ["id": .variable("categoryId")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CategoryMangasQuery.Data.self
      ] }

      var category: Category { __data["category"] }

      /// Category
      ///
      /// Parent Type: `CategoryType`
      struct Category: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.CategoryType }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("mangas", Mangas.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          CategoryMangasQuery.Data.Category.self
        ] }

        var mangas: Mangas { __data["mangas"] }

        /// Category.Mangas
        ///
        /// Parent Type: `MangaNodeList`
        struct Mangas: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.MangaNodeList }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node].self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            CategoryMangasQuery.Data.Category.Mangas.self
          ] }

          var nodes: [Node] { __data["nodes"] }

          /// Category.Mangas.Node
          ///
          /// Parent Type: `MangaType`
          struct Node: TachideskAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.MangaType }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", Int.self),
              .field("title", String.self),
              .field("thumbnailUrl", String?.self),
              .field("inLibrary", Bool.self),
              .field("sourceId", TachideskAPI.LongString.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              CategoryMangasQuery.Data.Category.Mangas.Node.self
            ] }

            var id: Int { __data["id"] }
            var title: String { __data["title"] }
            var thumbnailUrl: String? { __data["thumbnailUrl"] }
            var inLibrary: Bool { __data["inLibrary"] }
            var sourceId: TachideskAPI.LongString { __data["sourceId"] }
          }
        }
      }
    }
  }

}