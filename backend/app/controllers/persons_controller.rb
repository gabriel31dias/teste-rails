class PersonsController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy]
  before_action :set_person, only: [:show, :update, :destroy]

  def index
    per_page = 8
    pagination_data = PersonService.paginate_people(page: params[:page], per_page: per_page)

    render json: pagination_data
  end

  def show
    render json: @person
  end

  def create
    result = PersonService.create_person(person_params)

    if result[:success]
      render json: result[:person], status: :created, location: result[:person]
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  def update
    result = PersonService.update_person(@person, person_params)

    if result[:success]
      render json: result[:person]
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  def destroy
    PersonService.destroy_person(@person)
  end

  private

    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:name, :email, :phone, :birth_date)
    end
end
