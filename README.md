# google recaptcha v3 c-sharp-example

This example code using the Google reCAPTCHA v3 from https://www.google.com/recaptcha/intro/v3.html to validate online form submissions to help reduce spam and bots.

You will need to generate a site key and secret from the admin console https://www.google.com/recaptcha/admin/ for each website.


Requires Newtonsoft.Json from https://www.newtonsoft.com/json

Install using package manager in Visual Studio using: 

Install-Package Newtonsoft.Json

Requires Jquery for client side code from https://jquery.com/


Files:

/App_Code/GoogleRecaptchia.cs 

Contains the functions to generate the client side javascript and server side processing of the response. 

/testform.aspx

Contains a demo web contact form which shows the responses and score from the Google reCAPTCHA v3.

