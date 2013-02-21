module Pod

  # Model class which describes a Pods library.
  #
  # The Library class stores and provides the information necessary for
  # working with a library in the Pods project and in the user projects
  # through the installation process.
  #
  class Library

    # @return [PBXNativeTarget] the target definition of the Podfile that
    #         generated this library.
    #
    attr_reader :target_definition

    # @param  [TargetDefinition] target_definition @see target_definition
    # @param  [PBXNativeTarget]  target @see target
    #
    def initialize(target_definition)
      @target_definition = target_definition
    end

    # @return [String] the label for the library.
    #
    def label
      target_definition.label.to_s
    end

    # @return [String] the name of the library.
    #
    def name
      target_definition.label.to_s
    end

    # @return [String] the name of the library.
    #
    def product_name
      "lib#{target_definition.label}.a"
    end

    # @return [String] A string suitable for debugging.
    #
    def inspect
      "<#{self.class} name=#{name} platform=#{platform}>"
    end

    #-------------------------------------------------------------------------#

    # @!group Information storage

    # @return [Pathname] the folder where to store the support files of this
    #         library.
    #
    attr_accessor :support_files_root

    # @return [Pathname] the path of the user project that this library will
    #         integrate as identified by the analyzer.
    #
    # @note   The project instance is not stored to prevent editing different
    #         instances.
    #
    attr_accessor :user_project_path

    # @return [String] the list of the UUIDs of the user targets that will be
    #         integrated by this library as identified by the analizer.
    #
    # @note   The target instances are not stored to prevent editing different
    #         instances.
    #
    attr_accessor :user_target_uuids

    # @return [Hash{String=>Symbol}] A hash representing the user build
    #         configurations where each key corresponds to the name of a
    #         configuration and its value to its type (`:debug` or `:release`).
    #
    attr_accessor :user_build_configurations

    # @return [Platform] the platform for this library.
    #
    attr_accessor :platform

    # @return [PBXNativeTarget] the target generated in the Pods project for
    #         this library.
    #
    attr_accessor :target

    # @return [Xcodeproj::Config] the configuration file of the library
    #
    # @note   The configuration is generated by the {TargetInstaller} and
    #         used by {UserProjectIntegrator} to check for any overridden
    #         values.
    #
    attr_accessor :xcconfig

    # @return [Array<Specification>] the specifications of this library.
    #
    attr_accessor :specs

    # @return [Array<Sandbox::FileAccessor>] the file accessors for the
    #         specifications of this library.
    #
    attr_accessor :file_accessors

    #-------------------------------------------------------------------------#

    # @!group Support files

    # @return [Pathname] the absolute path of the xcconfig file.
    #
    def xcconfig_path
      support_files_root + "#{label}.xcconfig"
    end

    # @return [Pathname] the absolute path of the copy resources script.
    #
    def copy_resources_script_path
      support_files_root + "#{label}-resources.sh"
    end

    # @return [Pathname] the absolute path of the header file which contains
    #         the information about the installed pods.
    #
    def target_header_path
      support_files_root + "#{label}-header.h"
    end

    # @return [Pathname] the absolute path of the prefix header file.
    #
    def prefix_header_path
      support_files_root + "#{label}-prefix.pch"
    end

    # @return [Pathname] the absolute path of the bridge support file.
    #
    def bridge_support_path
      support_files_root + "#{label}.bridgesupport"
    end

    # @return [Pathname] the absolute path of acknowledgements file.
    #
    # @note   The acknowledgements generators add the extension according to
    #         the file type.
    #
    def acknowledgements_basepath
      support_files_root + "#{label}-acknowledgements"
    end

    # @return [Pathname] the path of the dummy source generated by CocoaPods
    #
    def dummy_source_path
      support_files_root + "#{label}-dummy.m"
    end

    #--------------------------------------#

    # @return [String] The xcconfig path of the root from the `$(SRCROOT)`
    #         variable of the user's project.
    #
    def relative_pods_root
      "${SRCROOT}/#{support_files_root.relative_path_from(user_project_path.dirname)}"
    end

    # @return [String] the path of the xcconfig file relative to the root of
    #         the user project.
    #
    def xcconfig_relative_path
      relative_to_srcroot(xcconfig_path).to_s
    end

    # @return [String] the path of the copy resources script relative to the
    #         root of the user project.
    #
    def copy_resources_script_relative_path
      "${SRCROOT}/#{relative_to_srcroot(copy_resources_script_path)}"
    end

    #-------------------------------------------------------------------------#

    # @!group Private Helpers

    private

    # Computes the relative path of a sandboxed file from the `$(SRCROOT)`
    # variable of the user's project.
    #
    # @param  [Pathname] path
    #         A relative path from the root of the sandbox.
    #
    # @return [String] the computed path.
    #
    def relative_to_srcroot(path)
      path.relative_path_from(user_project_path.dirname).to_s
    end
  end
end