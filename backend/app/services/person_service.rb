# app/services/person_service.rb
class PersonService
  def self.paginate_people(page:, per_page:)
    people = Person.paginate(page: page, per_page: per_page)
    total_records = Person.count
    total_pages = (total_records / per_page.to_f).ceil

    {
      people: people,
      total_records: total_records,
      total_pages: total_pages
    }
  end

  def self.create_person(person_params)
    person = Person.new(person_params)
    if person.save
      { success: true, person: person }
    else
      { success: false, errors: person.errors }
    end
  end

  def self.update_person(person, person_params)
    if person.update(person_params)
      { success: true, person: person }
    else
      { success: false, errors: person.errors }
    end
  end

  def self.destroy_person(person)
    person.destroy
  end
end
