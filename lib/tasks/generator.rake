namespace :generator do
  # set up tasks that is not on the webpage, but can run in the background

  task :questions_and_answers => :environment do 

    question_count = ENV['question_count'] ? ENV['question_count'].to_i : 10
    answer_count = ENV['answer_count'] ? ENV['answer_count'].to_i : 5

    question_count.times do 
      question = Question.create(title: Faker::Company.bs, 
                                body: Faker::Lorem.sentence(10))
      answer_count.times do
        question.answers.create(body: Faker::Lorem.sentence(15))
      end
    end
  end

end
