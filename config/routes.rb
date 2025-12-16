Rails.application.routes.draw do
  # 🏠 Головна сторінка
  root "home#index"

  # 📦 Товари
  resources :products, only: [:index, :show] do
    resources :reviews, only: :create
  end

  # 🛒 Кошик
  get    "cart",         to: "carts#show",   as: :cart
  post   "cart/add",     to: "carts#add",    as: :add_to_cart
  post   "cart/update",  to: "carts#update", as: :update_cart
  post   "cart/remove",  to: "carts#remove", as: :remove_from_cart
  delete "cart/clear",   to: "carts#clear",  as: :clear_cart

  # 🧾 Замовлення
  resources :orders do
    member do
      patch :pay              # 💳 Оплатити
      patch :cancel_order     # ❌ Скасувати
      patch :update_status    # 🔄 (для адміна)
      patch :request_refund   # ♻️ Повернення коштів (якщо буде)
    end
  end

  # 🚚 Доставка
  resources :deliveries, only: [:new, :create, :show]

  # 📄 Про нас
  get "about", to: "about#index", as: :about

  # 📞 Контакти
  get  "contacts", to: "contacts#new",    as: :contacts
  post "contacts", to: "contacts#create"

  # 👤 Користувачі
  resources :users, only: [:new, :create, :edit, :update]

  # 🔐 Авторизація
  get    "login",  to: "sessions#new",     as: :login
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # 👤 Профіль
  get "profile", to: "users#show", as: :profile

  # 👑 Адмін-панель
  namespace :admin do
    get "dashboard", to: "dashboard#index"

    resources :users, only: [:index]
    resources :products

    resources :orders do
      member do
        patch :update_status
      end
    end

    resources :feedbacks, only: [:index, :show, :update, :destroy]
  end

  # Перенаправлення на адмінку
  get "admin", to: redirect("/admin/dashboard")
end