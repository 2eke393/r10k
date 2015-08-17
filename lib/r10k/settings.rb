require 'etc'

module R10K
  module Settings
    require 'r10k/settings/container'
    require 'r10k/settings/mixin'

    require 'r10k/settings/collection'
    require 'r10k/settings/definition'

    def self.git_settings
      R10K::Settings::Collection.new(:git, [

        EnumDefinition.new(:provider, {
          :desc => "The Git provider to use. Valid values: 'shellgit', 'rugged'",
          :normalize => lambda { |input| input.to_sym },
          :enum => [:shellgit, :rugged],
        }),

        Definition.new(:username, {
          :desc => "The username to use for Git SSH remotes that do not specify a user.
                    Only used by the 'rugged' Git provider.
                    Default: the current user",
          :default => lambda { Etc.getlogin },
        }),

        Definition.new(:private_key, {
          :desc => "The path to the SSH private key for Git SSH remotes.
                    Only used by the 'rugged' Git provider.",
        })
      ])
    end

    def self.forge_settings
      R10K::Settings::Collection.new(:forge, [
        URIDefinition.new(:proxy, {
          :desc => "An optional proxy server to use when downloading modules from the forge.",
        }),

        URIDefinition.new(:baseurl, {
          :desc => "The URL to the Puppet Forge to use for downloading modules."
        }),
      ])
    end

    def self.global_settings
      R10K::Settings::Collection.new(:global, [
        Definition.new(:sources, {
          :desc => "Where r10k should retrieve sources when deploying environments.
                    Only used for r10k environment deployment.",
        }),

        Definition.new(:purgedirs, {
          :desc => "The purgedirs setting was deprecated in r10k 1.0.0 and is no longer respected.",
        }),

        Definition.new(:cachedir, {
          :desc => "Where r10k should store cached Git repositories.",
        }),

        Definition.new(:user, {
          :desc => "The user r10k should switch to when running as root."
        }),

        Definition.new(:group, {
          :desc => "The group r10k should switch to when running as root."
        }),

        R10K::Settings.forge_settings,

        R10K::Settings.git_settings,
      ])
    end
  end
end
