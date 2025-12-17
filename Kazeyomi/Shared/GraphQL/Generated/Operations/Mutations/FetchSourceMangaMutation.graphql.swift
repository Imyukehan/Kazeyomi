// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class FetchSourceMangaMutation: GraphQLMutation {
    static let operationName: String = "FetchSourceManga"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation FetchSourceManga($input: FetchSourceMangaInput!) { fetchSourceManga(input: $input) { __typename hasNextPage mangas { __typename id title thumbnailUrl inLibrary sourceId } } }"#
      ))

    public var input: FetchSourceMangaInput

    public init(input: FetchSourceMangaInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("fetchSourceManga", FetchSourceManga?.self, arguments: ["input": .variable("input")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        FetchSourceMangaMutation.Data.self
      ] }

      var fetchSourceManga: FetchSourceManga? { __data["fetchSourceManga"] }

      /// FetchSourceManga
      ///
      /// Parent Type: `FetchSourceMangaPayload`
      struct FetchSourceManga: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.FetchSourceMangaPayload }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("hasNextPage", Bool.self),
          .field("mangas", [Manga].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          FetchSourceMangaMutation.Data.FetchSourceManga.self
        ] }

        var hasNextPage: Bool { __data["hasNextPage"] }
        var mangas: [Manga] { __data["mangas"] }

        /// FetchSourceManga.Manga
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
            .field("inLibrary", Bool.self),
            .field("sourceId", TachideskAPI.LongString.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            FetchSourceMangaMutation.Data.FetchSourceManga.Manga.self
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