// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TachideskAPI {
  class SourcePreferencesQuery: GraphQLQuery {
    static let operationName: String = "SourcePreferences"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query SourcePreferences($sourceId: LongString!) { source(id: $sourceId) { __typename id displayName isConfigurable preferences { __typename ... on CheckBoxPreference { checkBoxValue: currentValue checkBoxDefaultValue: default key summary checkBoxTitle: title visible } ... on SwitchPreference { switchValue: currentValue switchDefaultValue: default key summary switchTitle: title visible } ... on ListPreference { listValue: currentValue listDefaultValue: default key summary listTitle: title visible entries entryValues } ... on EditTextPreference { editTextValue: currentValue editTextDefaultValue: default key summary editTextTitle: title visible text dialogTitle dialogMessage } ... on MultiSelectListPreference { multiSelectValue: currentValue multiSelectDefaultValue: default key summary multiSelectTitle: title visible entries entryValues dialogTitle dialogMessage } } } }"#
      ))

    public var sourceId: LongString

    public init(sourceId: LongString) {
      self.sourceId = sourceId
    }

    public var __variables: Variables? { ["sourceId": sourceId] }

    struct Data: TachideskAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("source", Source.self, arguments: ["id": .variable("sourceId")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        SourcePreferencesQuery.Data.self
      ] }

      var source: Source { __data["source"] }

      /// Source
      ///
      /// Parent Type: `SourceType`
      struct Source: TachideskAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.SourceType }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", TachideskAPI.LongString.self),
          .field("displayName", String.self),
          .field("isConfigurable", Bool.self),
          .field("preferences", [Preference].self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          SourcePreferencesQuery.Data.Source.self
        ] }

        var id: TachideskAPI.LongString { __data["id"] }
        var displayName: String { __data["displayName"] }
        var isConfigurable: Bool { __data["isConfigurable"] }
        var preferences: [Preference] { __data["preferences"] }

        /// Source.Preference
        ///
        /// Parent Type: `Preference`
        struct Preference: TachideskAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Unions.Preference }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsCheckBoxPreference.self),
            .inlineFragment(AsSwitchPreference.self),
            .inlineFragment(AsListPreference.self),
            .inlineFragment(AsEditTextPreference.self),
            .inlineFragment(AsMultiSelectListPreference.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            SourcePreferencesQuery.Data.Source.Preference.self
          ] }

          var asCheckBoxPreference: AsCheckBoxPreference? { _asInlineFragment() }
          var asSwitchPreference: AsSwitchPreference? { _asInlineFragment() }
          var asListPreference: AsListPreference? { _asInlineFragment() }
          var asEditTextPreference: AsEditTextPreference? { _asInlineFragment() }
          var asMultiSelectListPreference: AsMultiSelectListPreference? { _asInlineFragment() }

          /// Source.Preference.AsCheckBoxPreference
          ///
          /// Parent Type: `CheckBoxPreference`
          struct AsCheckBoxPreference: TachideskAPI.InlineFragment {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            typealias RootEntityType = SourcePreferencesQuery.Data.Source.Preference
            static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.CheckBoxPreference }
            static var __selections: [ApolloAPI.Selection] { [
              .field("currentValue", alias: "checkBoxValue", Bool?.self),
              .field("default", alias: "checkBoxDefaultValue", Bool.self),
              .field("key", String.self),
              .field("summary", String?.self),
              .field("title", alias: "checkBoxTitle", String.self),
              .field("visible", Bool.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              SourcePreferencesQuery.Data.Source.Preference.self,
              SourcePreferencesQuery.Data.Source.Preference.AsCheckBoxPreference.self
            ] }

            var checkBoxValue: Bool? { __data["checkBoxValue"] }
            var checkBoxDefaultValue: Bool { __data["checkBoxDefaultValue"] }
            var key: String { __data["key"] }
            var summary: String? { __data["summary"] }
            var checkBoxTitle: String { __data["checkBoxTitle"] }
            var visible: Bool { __data["visible"] }
          }

          /// Source.Preference.AsSwitchPreference
          ///
          /// Parent Type: `SwitchPreference`
          struct AsSwitchPreference: TachideskAPI.InlineFragment {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            typealias RootEntityType = SourcePreferencesQuery.Data.Source.Preference
            static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.SwitchPreference }
            static var __selections: [ApolloAPI.Selection] { [
              .field("currentValue", alias: "switchValue", Bool?.self),
              .field("default", alias: "switchDefaultValue", Bool.self),
              .field("key", String.self),
              .field("summary", String?.self),
              .field("title", alias: "switchTitle", String.self),
              .field("visible", Bool.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              SourcePreferencesQuery.Data.Source.Preference.self,
              SourcePreferencesQuery.Data.Source.Preference.AsSwitchPreference.self
            ] }

            var switchValue: Bool? { __data["switchValue"] }
            var switchDefaultValue: Bool { __data["switchDefaultValue"] }
            var key: String { __data["key"] }
            var summary: String? { __data["summary"] }
            var switchTitle: String { __data["switchTitle"] }
            var visible: Bool { __data["visible"] }
          }

          /// Source.Preference.AsListPreference
          ///
          /// Parent Type: `ListPreference`
          struct AsListPreference: TachideskAPI.InlineFragment {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            typealias RootEntityType = SourcePreferencesQuery.Data.Source.Preference
            static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.ListPreference }
            static var __selections: [ApolloAPI.Selection] { [
              .field("currentValue", alias: "listValue", String?.self),
              .field("default", alias: "listDefaultValue", String?.self),
              .field("key", String.self),
              .field("summary", String?.self),
              .field("title", alias: "listTitle", String?.self),
              .field("visible", Bool.self),
              .field("entries", [String].self),
              .field("entryValues", [String].self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              SourcePreferencesQuery.Data.Source.Preference.self,
              SourcePreferencesQuery.Data.Source.Preference.AsListPreference.self
            ] }

            var listValue: String? { __data["listValue"] }
            var listDefaultValue: String? { __data["listDefaultValue"] }
            var key: String { __data["key"] }
            var summary: String? { __data["summary"] }
            var listTitle: String? { __data["listTitle"] }
            var visible: Bool { __data["visible"] }
            var entries: [String] { __data["entries"] }
            var entryValues: [String] { __data["entryValues"] }
          }

          /// Source.Preference.AsEditTextPreference
          ///
          /// Parent Type: `EditTextPreference`
          struct AsEditTextPreference: TachideskAPI.InlineFragment {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            typealias RootEntityType = SourcePreferencesQuery.Data.Source.Preference
            static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.EditTextPreference }
            static var __selections: [ApolloAPI.Selection] { [
              .field("currentValue", alias: "editTextValue", String?.self),
              .field("default", alias: "editTextDefaultValue", String?.self),
              .field("key", String.self),
              .field("summary", String?.self),
              .field("title", alias: "editTextTitle", String?.self),
              .field("visible", Bool.self),
              .field("text", String?.self),
              .field("dialogTitle", String?.self),
              .field("dialogMessage", String?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              SourcePreferencesQuery.Data.Source.Preference.self,
              SourcePreferencesQuery.Data.Source.Preference.AsEditTextPreference.self
            ] }

            var editTextValue: String? { __data["editTextValue"] }
            var editTextDefaultValue: String? { __data["editTextDefaultValue"] }
            var key: String { __data["key"] }
            var summary: String? { __data["summary"] }
            var editTextTitle: String? { __data["editTextTitle"] }
            var visible: Bool { __data["visible"] }
            var text: String? { __data["text"] }
            var dialogTitle: String? { __data["dialogTitle"] }
            var dialogMessage: String? { __data["dialogMessage"] }
          }

          /// Source.Preference.AsMultiSelectListPreference
          ///
          /// Parent Type: `MultiSelectListPreference`
          struct AsMultiSelectListPreference: TachideskAPI.InlineFragment {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            typealias RootEntityType = SourcePreferencesQuery.Data.Source.Preference
            static var __parentType: any ApolloAPI.ParentType { TachideskAPI.Objects.MultiSelectListPreference }
            static var __selections: [ApolloAPI.Selection] { [
              .field("currentValue", alias: "multiSelectValue", [String]?.self),
              .field("default", alias: "multiSelectDefaultValue", [String]?.self),
              .field("key", String.self),
              .field("summary", String?.self),
              .field("title", alias: "multiSelectTitle", String?.self),
              .field("visible", Bool.self),
              .field("entries", [String].self),
              .field("entryValues", [String].self),
              .field("dialogTitle", String?.self),
              .field("dialogMessage", String?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              SourcePreferencesQuery.Data.Source.Preference.self,
              SourcePreferencesQuery.Data.Source.Preference.AsMultiSelectListPreference.self
            ] }

            var multiSelectValue: [String]? { __data["multiSelectValue"] }
            var multiSelectDefaultValue: [String]? { __data["multiSelectDefaultValue"] }
            var key: String { __data["key"] }
            var summary: String? { __data["summary"] }
            var multiSelectTitle: String? { __data["multiSelectTitle"] }
            var visible: Bool { __data["visible"] }
            var entries: [String] { __data["entries"] }
            var entryValues: [String] { __data["entryValues"] }
            var dialogTitle: String? { __data["dialogTitle"] }
            var dialogMessage: String? { __data["dialogMessage"] }
          }
        }
      }
    }
  }

}