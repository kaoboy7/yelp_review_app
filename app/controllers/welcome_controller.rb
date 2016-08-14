require 'pry'

class WelcomeController < ApplicationController

  INTRO = ['I visited', 'The other, day I went to', 'I just came from', 'I went to']

  REVIEW_HASH = {
    overall_very_good: ['It was great!', 'I had an amazing time!', 'This place...WOW!', "I had a really good experience."],
    overall_good: ['It was pretty good.', "It wasn't too bad.", "I had a decent time.", "Overall, it was a good time."],
    overall_bad: ['I had a pretty bad experience.', 'Yea..It was pretty bad', 'Yea...I did not have a good time.'],
    food_very_good: ['The food tasted really good!', 'The food was delicious!', "The food was definitely one of the best I have had."],
    food_good: ["The food was okay.", "The food was only alright.", "The food tasted okay."],
    food_bad: ["The food was not good at all.", "The food wasn't really that great.", "The food didn't taste good."],
    portion_very_good: ['The portion was very generous.', 'The portion was a good amount.'],
    portion_good: ['The portion was enough to fill you.', 'The portion was enough to satisfy you.'],
    portion_bad: ["Don't come here if you're looking for big portions.", "One thing, I wish the portion was larger.", "The portion was really small."],
    groups_yes: ["This place is great for groups."],
    groups_no: ["Another thing, don't bring a big group here.", "The place is really small, not good for groups."],
    service_very_good: ["The service was very good. Staff was kind and friendly.", "Staff was very kind and courteous.", "Very professional and courteous. I was very pleased."],
    service_good: ["The service was very okay, could have been a little more professional.", "The service was so so but manageable."],
    service_bad: ["I was disappointed with the service", "The staff was rude and not courteous."],
    dish1_default: ["I ordered the ", "I got the ", "The main dish I ordered was the ", "After looking at the menu for a while, I decided to order the "],
    dish1_rating_very_good: ["The dish was delicious!", "But wow, it was definitely on point!", "Amazing...one of the best I ever had", "YUM! I though the dish had a perfect amount of consistency plus flavor. Not too overbearing."],
    dish1_rating_good: ["The dish was good but not amazing.", "The dish was good enough, nothing too special though.", "It was pretty good but did wish it had a little more flavor to it.", "The dish was good enough to satisfy a craiving, but not something I would make a special trip for."],
    dish1_rating_bad: ["Yea, I did not really enjoy the dish that much. It was okay.", "The dish was kind of bland. The texture was inconsistent."]
  }

  @@phrases = File.read("phrases.json")
  # @@phrases_all = JSON.parse(@@phrases, {symbolize_names: true})
  @@phrases_all = JSON.parse(@@phrases, {symbolize_names: false})
  @@phrases_all.merge!(REVIEW_HASH)

  def show
    # OVERALL_VERY_GOOD
    restaurant = params[:restaurant] || ''
    overall_value = params[:overall] || ''
    adjective_value = params[:adjective] || ''
    dishes_value = params[:dishes] || ''
    dish1_params = params[:dish1] || ''
    dish2_params = params[:dish2] || ''
    best_value = params[:best] || ''
    worst_value = params[:worst] || ''

    # @results = get_introduction(restaurant, overall_value)

    # 1. Create hash of type: [options] based on user input
    @type_options_map = {ending: ['good'], intro: ['neutral'], profile: ['empty', 'busy', 'quiet']}.with_indifferent_access

    review_template = ['intro', 'profile', 'ending']

    @results = generate_review(review_template, 'full_review', '')


    # + get_first_dish_review(dish1_params) + get_second_dish_review(dish2_params) + get_conclusion(best_value, worst_value) + get_review_snippet('ending', 'good')

  end

  def index

  end

  def type_options_map
    @type_options_map || {}
  end


  def generate_review(review_template, parent_type, review)
    subreview = ""
    review_template.each do |review_type|
      options_array = type_options_map[review_type] || 'default'

      # Most primitive
      if (review_type == "values")
        option = type_options_map[parent_type].sample
        return review + " " + @@phrases_all["type_" + parent_type]["values"][option].sample
      # Sub rules
      else
        template = @@phrases_all["type_" + review_type]["template"]
        subreview = subreview + generate_review(template, review_type, review)
      end
    end

    return review + subreview
  end


  def get_introduction(restaurant_name, overall_value)



    @@phrases_all[:intro_neutral].sample.sub('RESTAURANT_NAME', restaurant_name) + ' '

    # INTRO.sample + " " + restaurant_name + ". " + get_review_snippet('overall', overall_value) + " "
  end

  def get_post_introduction()

  end


  def get_first_dish_review(params)
    # I ordered the chicken salad. It was really good! I thought it was perfectly salted, and mildly chewey. I also order the chicken soup. It was a little too salty but very tastey. 
    name = params[:name]
    adjectives = params[:adjectives]
    overall = params[:overall]

    "The " + name.downcase + " was " + adjectives.join(' and ') + ". Overall the dish was " + overall.gsub('_', ' ').downcase + ". "
  end

  def get_second_dish_review(params)
    # I ordered the chicken salad. It was really good! I thought it was perfectly salted, and mildly chewey. I also order the chicken soup. It was a little too salty but very tastey. 
    name = params[:name]
    adjectives = params[:adjectives]
    overall = params[:overall]

    "The " + name.downcase + " was " + adjectives.join(' and ') + ". Overall the dish was " + overall.gsub('_', ' ').downcase + ". "
  end


  def get_conclusion(best, worst)
    "The best part was definitely the " + best.downcase + ". The worst part of the experience was the " + worst.downcase + ". "
  end

  def get_review_snippet(type, value)
    return "" if value == "na"
    return @@phrases_all[:dish1_default].sample + " " + value + ". " if type == "dish1_default"
    puts "Type: " + type + ", Value: " + value
    puts @@phrases_all
    # binding.pry
    @@phrases_all[:"#{type}_#{value}"].sample
  end

end
