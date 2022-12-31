FactoryBot.define do
    factory :user do
      username { "Pekka" }
      password { "Foobar1" }
      password_confirmation { "Foobar1" }
    end

    factory :brewery do
        name {"anonymous"}
        year { 1990 }
    end

    factory :style do
        name {"Lager"}
        description {"nami"}
    end

    factory :beer do 
        name { "anonymous" }
        style 
        brewery
    end

    factory :rating do
        score { 10 }
        beer
        user
    end
end