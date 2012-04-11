module ElFinder

  class ::IsAFileValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "must be an instance of ElFinder::File (was #{value.class})" unless value.is_a?(ElFinder::File)
    end
  end

  class ::IsADirectoryValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "must be an instance of ElFinder::Directory (was #{value.class})" unless value.is_a?(ElFinder::Directory) || value.is_a?(ElFinder::Root)
    end
  end

  class ::IsAnEntryValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << "must be an instance of ElFinder::Entry (was #{value.class})" unless value.is_a?(ElFinder::Entry)
    end
  end

  class Command < Model

    attr_accessor :arguments, :error, :result, :root_path

    class Arguments < Model
      attr_accessor :command
      delegate :el_entry, :to => :command

      def entry
        el_entry(target)
      end

      def entries
        targets.map{|target| el_entry(target)}
      end
    end

    class Result < Model
      attr_accessor :arguments, :execute_command, :command
    end

    class_attribute :command_name

    class Error < Model
      attr_accessor :error
    end

    def initialize(init_params)
      self.root_path = init_params.delete(:root_path)
      self.arguments = "#{self.class.name}::Arguments".constantize.new(init_params.merge(:command => self))
    end

    def run
      begin
        self.result = "#{self.class.name}::Result".constantize.new(:arguments => arguments, :execute_command => execute_command, :command => self)
      rescue Exceptions::LockedEntry => e
        self.result = {error: e.message}
      end
    end

    def headers
      @headers ||= {}
    end

    def el_root
      @el_root ||= ElFinder::Root.for_path(root_path)
    end

    def json
      if result.respond_to? :el_hash
        result.el_hash.inject({}) do | result, values |
          key, value = values
          result[key] = transform(value)
          result
        end
      else
        result
      end
    end

    protected

      def transform(value)
        case value
        when RootEntry, DirectoryEntry, FileEntry then el_root.el_entry(value).el_hash
        when Array, ActiveRecord::Relation then value.map{|v| transform(v) }
        when Hash then value.inject({}) { |h, v| h[v[0]] = transform(v[1]); h }
        else value
        end
      end

      def el_entry(hash)
        el_root.find_el_entry_by_hash hash
      end

      def execute_command
      end

      def self.register_in_connector(command_name=nil)
        self.command_name = command_name || name.demodulize.underscore
        Connector.commands[self.command_name] = self
      end
  end
end
