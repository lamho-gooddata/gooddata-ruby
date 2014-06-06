# encoding: UTF-8

require 'csv'

module GoodData
  module Helpers
    class << self
      # Read data from CSV
      #
      # @param [Hash] opts
      # @option opts [String] :path File to read data from
      # @option opts [Boolean] :header File to read data from
      # @return Array of rows with loaded data
      def csv_read(opts)
        path = opts[:path]
        res = []

        line = 0

        CSV.foreach(path) do |row|
          line += 1
          next if opts[:header] && line == 1

          tmp_user = yield row
          res << tmp_user if tmp_user
        end

        res
      end

      # Write data to CSV
      # @option opts [String] :path File to write data to
      # @option opts [Array] :data Mandatory array of data to write
      # @option opts [String] :header Optional Header row
      def csv_write(opts, &block)
        path = opts[:path]
        header = opts[:header]
        data = opts[:data]

        CSV.open(path, 'w') do |csv|
          csv << header unless header.nil?
          data.each do |entry|
            res = yield entry
            csv << res if res
          end
        end
      end
    end
  end
end
