# igt_assignment


## Seeds

There are multiple seeds for different things, run them all to get the default data

 - seeds_tags - for Product tags
 - seeds_transactions - required to see transactions in the Dashboard
 - seeds_users - creates a test user
 - seeds - creates 10 Products

## Logging in

You can use the test user that gets created by seeds_users:
email: admin@example.com
password: password123

## Endpoints

The homepage at http://localhost:4000/ will help you with navigation, but these are the main endpoints:

 - http://localhost:4000/products_live - for the LiveView of Products
 - http://localhost:4000/dashboard - for the LiveView of Dashboard
 - http://localhost:4000/live_feed - for LiveFeed via PubSub


