class Introduction
  include Neo4j::ActiveRel
  before_create :generate_key_and_serial

  property :key, type: String
  property :serial, type: Integer
  property :template, type: Integer

  property :content, type: String, presence: true

  property :obj_id, type: String
  property :thumbnail, type: String
  property :image, type: String
  property :job_id, type: String
  property :expected_delivery, type: Date

  property :created_at
  property :updated_at

  type 'introduction'
  from_class Person
  to_class Person

  validates :content, length: {minimum: 10, maximum: 100},
    format: { without: /…\z/, message: "is empty; enter an introduction" }

  def generate_key_and_serial
    # TODO: should regenerate if not unique
    self.key = rand(36**KEY_LENGHT).to_s(36)

    # This is ugly, but seemingly the only solution
    # Potential race condition (not a problem for this application)
    # and possible bad performance at scale (likely not a problem)
    # Also, this will break of a relationship is ever deleted
    self.serial = Person.all.introduced.count + 1
  end
end
