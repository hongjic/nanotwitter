# nanotwitter 0.3



###nanotwitter 0.2
This version include login/logout/register and homepage display.

Since the author don't think cookie is secure enough and also consider session not good for scalability and will occupy too much memory on server, The login/logout functionality is implemented by the access_token principle.

By login, the user can get an access_token from the server by provding his username and password.
Then, all other interaction with server is authenticated by the access_token.

Access_token contains information like user_id, time to expire and so on. Client side can not decode the access_token. It is encoded on server side with a Token Secret by  "HS256" hashing algorithm.

###nanotwitter 0.3
updates:
1)users can now post tweets. 
2)improved the way to query homepage timeline.
3)improved the UI interface.
4)implemented some core web APIs, but not finished the front-end development so they are not accessible through nanotwitter now.