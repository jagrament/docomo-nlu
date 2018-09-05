# frozen_string_literal: true

module DocomoNlu
  module Management
    autoload :Account,            'docomo-nlu/management/account'
    autoload :AIMLBase,           'docomo-nlu/management/aiml_base'
    autoload :Base,               'docomo-nlu/management/base'
    autoload :Bot,                'docomo-nlu/management/bot'
    autoload :Config,             'docomo-nlu/management/config'
    autoload :DefaultPredicate,   'docomo-nlu/management/default_predicate'
    autoload :MultipartBase,      'docomo-nlu/management/multipart_base'
    autoload :Map,                'docomo-nlu/management/map'
    autoload :NGWord,             'docomo-nlu/management/ng_word'
    autoload :OKWord,             'docomo-nlu/management/ok_word'
    autoload :OrganizationMember, 'docomo-nlu/management/organization_member'
    autoload :Organization,       'docomo-nlu/management/organization'
    autoload :PredicateName,      'docomo-nlu/management/predicate_name'
    autoload :ProjectMember,      'docomo-nlu/management/project_member'
    autoload :Project,            'docomo-nlu/management/project'
    autoload :Property,           'docomo-nlu/management/property'
    autoload :Provider,           'docomo-nlu/management/provider'
    autoload :ScenarioProject,    'docomo-nlu/management/scenario_project'
    autoload :ScenarioUtil,       'docomo-nlu/management/scenario_util'
    autoload :Scenario,           'docomo-nlu/management/scenario'
    autoload :Set,                'docomo-nlu/management/set'
    autoload :TaskProject,        'docomo-nlu/management/task_project'
  end
end
