require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord
  # def initialize(options={})
  #   options.each do |property, value|
  #     self.send("#{property}=", value)
  #   end
  # end

  def initialize(options={})
    options.each do
      |property, value| self.send(`#{property}=`, value)
    end
  end

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql =  "pragma table_info('#{self.table_name}')"
    info_hash = DB[:conn].execute(sql)
    column_names = []
    info_hash.each do
      |column| column_names << column['name']

    end

    column_names.compact
  end

  def table_name_for_insert
    self.class.table_name.join(', ')
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(', ')
  end

  def find_by(attribute_hash)
    value = attribute_hash.values[0]
    formatted_value = (value.is_a? Integer) ? value : "'#{value}'"
    sql = "SELECT * FROM #{self.table_name} WHERE  #{attribute_hash.keys.first} = #{formatted_value} "

  end

end
