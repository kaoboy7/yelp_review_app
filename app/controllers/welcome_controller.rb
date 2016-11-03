class WelcomeController < ApplicationController

  @@phrases = File.read("phrases.json")
  # @@phrases_all = JSON.parse(@@phrases, {symbolize_names: true})
  @@phrases_all = JSON.parse(@@phrases, {symbolize_names: false})

  def show
    restaurant = params[:restaurant]
    overall= Array.wrap(params[:overall])

    # 1. Create hash of type: [options] based on user input
    @type_options_map = {ending: overall, intro: ['neutral']}.with_indifferent_access.merge(params)

    # 2. Create a map of all the variables
    @variables_map = {VAR_RESTAURANT_NAME: restaurant}.with_indifferent_access

    # 3. Generate the review
    review_template = ['intro', 'profile', 'dish', 'best', 'worst', 'ending']
    @results = generate_review(review_template, 'full_review', '')

  end

  def index

  end

  def type_options_map
    @type_options_map || {}
  end

  def variables_map
    @variables_map || {}
  end

  def generate_review(review_template, parent_type, review)
    subreview = ""
    review_template.each do |review_type|
      options_array = type_options_map[review_type] || 'default'

      # Most primitive
      if (review_type == "values")
        if type_options_map[parent_type].blank?
          return review
        end
        option = type_options_map[parent_type].sample
        puts 'TEST'
        puts parent_type
        puts option
        puts 'TEST END'
        sample = @@phrases_all["type_" + parent_type]["values"][option].sample
        normalize_sample!(sample)
        return review + " " + sample
      # Sub rules
      else
        template = @@phrases_all["type_" + review_type]["template"]
        subreview = subreview + generate_review(template, review_type, review)
      end
    end

    return review + subreview
  end

  def normalize_sample!(sample)
    variables_map.each do |key, value|
      sample.gsub!(key, value)
    end
  end
end
