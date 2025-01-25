alias ClothingDashboard.Repo
alias ClothingDashboard.Accounts.User

Repo.insert!(%User{
  email: "admin@example.com",
  password_hash: Pbkdf2.hash_pwd_salt("password123"),
  inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
  updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})
