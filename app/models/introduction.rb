class Introduction
  include Neo4j::ActiveRel

  property :key, type: String, presence: true
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

  before_create do
    if self.key.nil?
      generate_key
    end

    # This is ugly, but seemingly the only solution
    # Potential race condition (not a problem for this application)
    # and possible bad performance at scale (likely not a problem)
    # Also, this will break of relationships are deleted
    self.serial = Person.all.introduced.count + 1
  end

  before_save do
    self.content.strip!
  end

  def generate_key
    key = rand(36**KEY_LENGHT).to_s(36)
    if Person.all.introduced_by(:person, :intro).rel_where(key: key).pluck(:intro).count == 0
      self.key = key
    else
      generate_key
    end
  end

  def self.find_by_key(key)
    introductions = Person.all.introduced(:person, :intro).rel_where(key: key.downcase).pluck(:intro).to_a

    if introductions.empty?
      raise ActiveRecord::RecordNotFound
    else
      return introductions[0]
    end
  end
end
