class Introduction
  include Neo4j::ActiveRel
  before_save :generate_key

  property :content, type: String, presence: true
  property :key, type: String

  property :created_at
  property :updated_at

  type 'introduction'
  from_class Person
  to_class Person

  def generate_key
    self.key = rand(36**KEY_LENGHT).to_s(36)
  end
end
