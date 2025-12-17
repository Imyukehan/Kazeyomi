// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension TachideskAPI {
  struct FetchSourceMangaInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      clientMutationId: GraphQLNullable<String> = nil,
      filters: GraphQLNullable<[FilterChangeInput]> = nil,
      page: Int,
      query: GraphQLNullable<String> = nil,
      source: LongString,
      type: GraphQLEnum<FetchSourceMangaType>
    ) {
      __data = InputDict([
        "clientMutationId": clientMutationId,
        "filters": filters,
        "page": page,
        "query": query,
        "source": source,
        "type": type
      ])
    }

    var clientMutationId: GraphQLNullable<String> {
      get { __data["clientMutationId"] }
      set { __data["clientMutationId"] = newValue }
    }

    var filters: GraphQLNullable<[FilterChangeInput]> {
      get { __data["filters"] }
      set { __data["filters"] = newValue }
    }

    var page: Int {
      get { __data["page"] }
      set { __data["page"] = newValue }
    }

    var query: GraphQLNullable<String> {
      get { __data["query"] }
      set { __data["query"] = newValue }
    }

    var source: LongString {
      get { __data["source"] }
      set { __data["source"] = newValue }
    }

    var type: GraphQLEnum<FetchSourceMangaType> {
      get { __data["type"] }
      set { __data["type"] = newValue }
    }
  }

}