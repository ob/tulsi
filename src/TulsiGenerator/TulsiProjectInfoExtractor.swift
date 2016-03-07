// Copyright 2016 The Tulsi Authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation


// Provides functionality to generate a TulsiGeneratorConfig from a TulsiProject.
public class TulsiProjectInfoExtractor {
  private let project: TulsiProject
  private let localizedMessageLogger: LocalizedMessageLogger
  private var workspaceInfoExtractor: WorkspaceInfoExtractorProtocol

  public var bazelURL: NSURL {
    get { return workspaceInfoExtractor.bazelURL }
    set { workspaceInfoExtractor.bazelURL = newValue }
  }

  public init(bazelURL: NSURL,
              project: TulsiProject,
              messageLogger: MessageLoggerProtocol? = nil) {
    self.project = project
    let bundle = NSBundle(forClass: self.dynamicType)
    localizedMessageLogger = LocalizedMessageLogger(messageLogger: messageLogger, bundle: bundle)

    workspaceInfoExtractor = BazelWorkspaceInfoExtractor(bazelURL: bazelURL,
                                                         workspaceRootURL: project.workspaceRootURL,
                                                         localizedMessageLogger: localizedMessageLogger)
  }

  public func extractTargetRules() -> [RuleEntry] {
    return workspaceInfoExtractor.extractTargetRulesFromProject(project)
  }

  // TODO(abaire): Remove this method in favor of ruleEntriesForLabels when aspects are the default.
  public func extractSourceRulesForRuleEntries(ruleEntries: [RuleEntry],
                                               startupOptions: TulsiOption,
                                               buildOptions: TulsiOption) -> [RuleEntry] {
    return workspaceInfoExtractor.extractSourceRulesForRuleEntries(ruleEntries,
                                                                   startupOptions: startupOptions,
                                                                   buildOptions: buildOptions)
  }

  public func ruleEntriesForLabels(labels: [String],
                                   startupOptions: TulsiOption,
                                   buildOptions: TulsiOption) -> [String: RuleEntry] {
    return workspaceInfoExtractor.ruleEntriesForLabels(labels,
                                                       startupOptions: startupOptions,
                                                       buildOptions: buildOptions)
  }
}