class Account < ApplicationRecord
  enum role: [:admin, :user]
end
