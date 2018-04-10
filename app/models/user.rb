class User < Patron
  devise :invitable, :registerable, :confirmable
  has_many :sensors

  validates :name, length: { minimum: 2 }, allow_blank: true
end
