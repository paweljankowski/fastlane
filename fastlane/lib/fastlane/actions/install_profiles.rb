module Fastlane
  module Actions
    class InstallProfilesAction < Action
      def self.run(params)

        profiles_dir = Dir[params[:profiles_dir] + "/*.mobileprovision"]

        profiles_dir.each do |profile_path|
          install_profile(profile_path)
        end

      end

      def self.install_profile(profile_path)
        profile = Plist.parse_xml(`security cms -D -i '#{profile_path}' 2> /dev/null`)

        UI.message "Installing provisioning profile #{profile_path}..."

        destination_profiles_dir = File.expand_path("~") + "/Library/MobileDevice/Provisioning Profiles/"
        destination_path = destination_profiles_dir + profile['UUID'] + ".mobileprovision"

        FileUtils.copy profile_path, destination_path
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Copy provisioning profiles from specified dir"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :profiles_dir,
                                       env_name: "FL_INSTALL_PROFILES_DIR",
                                       description: "Directory where provisioning profiles are placed")
        ]
      end

      def self.authors
        ["paweljankowski"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
