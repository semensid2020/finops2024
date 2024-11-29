# Generate Users
admin = User.find_or_initialize_by(email: 'admin@example.com')
admin.update(
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Admin',
  last_name: 'Adminson',
  role: :admin,
)

user1 = User.find_or_initialize_by(email: 'user1@example.com')
user1.update(
  password: 'password',
  password_confirmation: 'password',
  first_name: 'John',
  last_name: 'Doe',
  role: :customer,
)

user2 = User.find_or_initialize_by(email: 'user2@example.com')
user2.update(
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Mary',
  last_name: 'Smith',
  role: :customer,
)

user3 = User.find_or_initialize_by(email: 'user3@example.com')
user3.update(
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Vinnie',
  last_name: 'Jones',
  role: :customer,
)

user4 = User.find_or_initialize_by(email: 'user4@example.com')
user4.update(
  password: 'password',
  password_confirmation: 'password',
  first_name: 'Max',
  last_name: 'Volkov',
  role: :customer,
)


# Generate currencies
euro = Currency.find_or_initialize_by(code: 'EUR')
euro.update(
  name: 'Euro',
  code: 'EUR',
)

usd = Currency.find_or_initialize_by(code: 'USD')
usd.update(
  name: 'United States dollar',
  code: 'USD',
)

btc = Currency.find_or_initialize_by(code: 'BTC')
btc.update(
  name: 'Bitcoin',
  code: 'BTC',
)


# Generate User Accounts
acc11 = UserAccount.create(
  owner: user1,
  currency: euro,
  balance: 10000.0,
  status: :active,
)

acc12 = UserAccount.create(
  owner: user1,
  currency: usd,
  balance: 666,
  status: :active,
)

acc13 = UserAccount.create(
  owner: user1,
  currency: usd,
  balance: 0,
  status: :active,
)

acc21 = UserAccount.create(
  owner: user2,
  currency: euro,
  balance: 5000.0,
  status: :active,
)

acc22 = UserAccount.create(
  owner: user2,
  currency: usd,
  balance: 0,
  status: :active,
)

acc23 = UserAccount.create(
  owner: user2,
  currency: btc,
  balance: 0.93467,
  status: :active,
)

acc13 = UserAccount.create(
  owner: user3,
  currency: usd,
  balance: 60000.0,
  status: :active,
)

# Generate Operations
# op1 = Operation.create(
#   amount: 550,
#   currency: usd,
#   sender_: acc11,
#   recipient: acc21,
#   status: done,
#   temporal_type: immediate,
# )
