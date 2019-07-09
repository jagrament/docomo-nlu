# frozen_string_literal: true

module DocomoNlu
  module Management
    autoload :Account,            "docomo_nlu/management/account"
    autoload :AIMLBase,           "docomo_nlu/management/aiml_base"
    autoload :Base,               "docomo_nlu/management/base"
    autoload :Bot,                "docomo_nlu/management/bot"
    autoload :BotLog,             "docomo_nlu/management/bot_log"
    autoload :Config,             "docomo_nlu/management/config"
    autoload :DefaultPredicate,   "docomo_nlu/management/default_predicate"
    autoload :Entry,              "docomo_nlu/management/entry"
    autoload :Log,                "docomo_nlu/management/log"
    autoload :MultipartBase,      "docomo_nlu/management/multipart_base"
    autoload :Map,                "docomo_nlu/management/map"
    autoload :NGWord,             "docomo_nlu/management/ng_word"
    autoload :OKWord,             "docomo_nlu/management/ok_word"
    autoload :OrganizationMember, "docomo_nlu/management/organization_member"
    autoload :Organization,       "docomo_nlu/management/organization"
    autoload :PredicateName,      "docomo_nlu/management/predicate_name"
    autoload :ProjectMember,      "docomo_nlu/management/project_member"
    autoload :Project,            "docomo_nlu/management/project"
    autoload :Property,           "docomo_nlu/management/property"
    autoload :Provider,           "docomo_nlu/management/provider"
    autoload :ScenarioProject,    "docomo_nlu/management/scenario_project"
    autoload :ScenarioUtil,       "docomo_nlu/management/scenario_util"
    autoload :Scenario,           "docomo_nlu/management/scenario"
    autoload :Set,                "docomo_nlu/management/set"
    autoload :TaskProject,        "docomo_nlu/management/task_project"
  end
end
