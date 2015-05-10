class Person
  include Neo4j::ActiveNode
  #before_create :guess_gender

  property :name, type: String

  property :email, type: String

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

  #GENDER_GUESS_PROBABILITY_THRESHOLD = 0.9

  #def guess_gender
    #response = Net::HTTP.get_response(URI.parse("https://api.genderize.io?name=#{self.given_name.downcase}"))

    #if response.kind_of? Net::HTTPSuccess
      #data = JSON.parse(response.body)

      #if data.has_key?("gender") and not data["gender"].nil? and data.has_key?("probability") and data["probability"].to_f > GENDER_GUESS_PROBABILITY_THRESHOLD
        #self.is_male = (data["gender"] == "male")
      #end
    #end

  #end
end
