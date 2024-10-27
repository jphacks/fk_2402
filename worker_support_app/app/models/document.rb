class Document < ApplicationRecord
    validates :content, presence: true
end
