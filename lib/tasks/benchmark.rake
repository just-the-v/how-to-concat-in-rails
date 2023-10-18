# frozen_string_literal: true

namespace :benchmark do
  desc 'Run benchmark'
  task run: :environment do

    Benchmark.bm do |x|
      x.report("Using .map") do
        Account.all.map do |account|
          "#{account.first_name} #{account.last_name} (#{account.role}), can be contacted at #{account.email} or #{account.phone}"
        end
      end

      x.report("Using .pluck") do
        Account.all.pluck(:first_name, :last_name, :role, :email, :phone).map do |account|
          "#{account[0]} #{account[1]} (#{account[2]}), can be contacted at #{account[3]} or #{account[4]}"
        end
      end

      x.report("Using Raw SQL") do
        Account.select(
          "CONCAT(first_name, ' ', last_name, ' (', role, '), can be contacted at ', email, ' or ', phone) as insql_concatenated_string"
        ).map(&:insql_concatenated_string)
      end

      x.report("Using Scenic") do
        AccountInformation.pluck(:concatenated_string)
      end

      x.report("Using virtual column") do
        Account.all.pluck(:account_information)
      end
    end
  end
end
