require 'chef/json_compat'
require 'chef/mash'
require 'chef/mixin/deep_merge'
require 'yaml'

class AppConfig < Mash
  include Chef::Mixin::DeepMerge

  def initialize(*args)
    args.reverse.each { |arg| deep_merge!(arg, self) }
  end

  # Take some attributes and return them on each line as:
  #
  #    export ATTR_NAME="attr_value"
  #
  # If the value is a String or Number and the attribute name is attr_name.
  # Used to write out environment variables to a file.
  def to_environment_variables
    reduce "" do |str, attr|
      if serializable_as_environment_variable?(attr[1])
        str << "export #{attr[0].upcase}=\"#{attr[1]}\"\n"
      end
      str
    end
  end

  # This is a silly hack to get around the fact that YAML will stick class
  # names on keys and other places where YAML is used will fail to be able to
  # load files with those kinds of keys. This converts the object to JSON and
  # then back. #to_hash won't work for this because we need to deep-convert
  # everything.
  def to_yaml
    Chef::JSONCompat.from_json(to_json).to_yaml
  end

  private

  def serializable_as_environment_variable?(value)
    value.is_a?(String) || value.is_a?(Numeric) || value == true || value == false
  end
end
