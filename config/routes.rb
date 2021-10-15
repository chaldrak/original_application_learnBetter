Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/inbox"
  end
end
