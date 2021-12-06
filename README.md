# README

<h1>Specs</h1>

* Ruby version: ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux]

* Rails version: Rails 6.1.4.1

* Database: SQLite version 3.31.1

* Git commits are in the commits.txt file

* Git repository (using my personal github account): https://github.com/tvanginkel/emailClient

* Development: The project was developed using RubyMine 2021.3


<h1>About the project</h1>

The project is an email client for viewing and sending emails. It does not use SMTP or any actuall email account, but instead creates it's own users and only allows messaging between them.

The webpage has:

- An inbox page, where the user can view it's emails and change the mailbox they are stored in.

- A contact page to send emails to the owner of the webpage.

- A profile page to change account settings (password or delete the account)

- A page where the user can send an email to other accounts

- A login and register page through which the user can access the email client


<h1>Details</h1>

- All authentication is done manually, without the use of Device as I personally don't like bcrypt as a hashing function and used Argon2 instead.

- I used bootstrap for most of UI design
