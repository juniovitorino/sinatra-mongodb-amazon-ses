Sinatra + MongoDB + AWS Simple Mail Service
==

Small Sinatra app that stores form messages in MongoDB (using Mongoid) and sends for an email through Amazon AWS SES.

Testing
--

1. Clone the repository
2. Install missing gems with ```bundle install```
3. Modify and rename the file server.sample to server (it have +x permissions already)
4. Type ```sh server```
5. Run the curl command ```curl -d "name=YOUR_NAME&email=YOUR_EMAIL&subject=YOUR_SUBJECT&message=YOUR_MESSAGE" http://127.0.0.1:9393/send```

**I don't write any haml file because this is a test app only, feel free to write your own.**