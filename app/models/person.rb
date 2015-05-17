class Person
  include Neo4j::ActiveNode

  property :name, type: String

  property :email, type: String

  property :in_progress, type: String

  property :street_line1, type: String
  property :street_line2, type: String
  property :city, type: String
  property :state, type: String
  property :postal_code, type: String
  property :country, type: String

  property :created_at
  property :updated_at

  has_many :out, :introduced, model_class: Person, rel_class: Introduction
  has_many :in, :introduced_by, model_class: Person, rel_class: Introduction

  validates :email, email: true, :allow_blank => true

  validates :name, presence: true, :on => :update
  validates :street_line1, presence: true, :on => :update
  validates :city, presence: true, :on => :update
  validates :postal_code, presence: true, :on => :update

  validates :state, inclusion: {in: STATES.map { |state| state["short_name"] }, message: "%{value} is not valid" },
    :if => lambda { self.country == "US" }, :on => :update

  validates :country, inclusion: {in: COUNTRIES.map { |country| country["short_name"] }, message: "%{value} is not valid" }, :on => :update

  before_validation do
    # if the user enters a full state name, convert it to the abreviation automatically
    if not self.state.blank?
      STATES.each { |state|
        if self.state.downcase == state["name"].downcase
          self.state = state["short_name"]
          break
        end
      }

      self.state = self.state.upcase
    end
  end
end
