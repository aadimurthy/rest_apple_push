rest_apple_push
=====

This is Restful service written in Erlang to send apple push notifications. 


**Push Config:** 

Place your config in push_config() function of **push_pool_sup.erl**

Placen your push topic in **apple_push_pool.erl** 


To Run 
-----

    $ ./rebar3 run



**To test:**

`POST /sendnotification/{apple_device_id}`  

eg: If this service runs on localhost with port 8080 then rest call would be 

`curl -X POST -H 'Content-Type: application/json' -i http://localhost:8080/sendnotification/1A2345f567575f7 --data '{"Id":"Test"}'`




