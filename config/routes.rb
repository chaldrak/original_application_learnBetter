Rails.application.routes.draw do
  root 'home#index'
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/inbox"
  end
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
end
