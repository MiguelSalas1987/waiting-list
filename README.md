#this has been implemented for this test specifications:
[test specifications](https://gist.github.com/dlupu/318763089c49ea44cfc5a70f403b3ca4)


Your Client is a French Coworking space that rents places by the month to freelancers. When someone is accepted into the coworking space, he signs a contrat that is renewed automatically every month. Because of the high demand, the Client needs to put in place a waiting list in order to keep track of people wanting to join the coworking. 

The main features that the Client has specified:
* A form to collect incoming requests (name, email, phone number, a paragraph about the person) with validations. Email adresses must be confirmed (requests with emails that have not been confirmed should not be taken into account in the waiting list)
* The requests will be accepted on a  [first-come, first served principle](https://en.wikipedia.org/wiki/First-come,_first-served)
* The requests in the waiting list must be reconfirmed every 3 months: an email should be sent to the people in the waiting list, informing them of their order in the waiting list and asking for confirmation that they are still interested, otherwise they request will  be removed from the waiting list (aka expired). 

For the scope of this test, An administration interface is not required. However you need to provide methods that the Client could use in `rails console` :
* `request.accept!` - method the will allow to accept a request (`request` being an instance of the class `Request`)
* list the requests by the their status using class methods or scopes
  * `Request.unconfirmed` - requests for which the email adresse has not been confirmed
  * `Request.confirmed` - requests in the waiting list
  * `Request.accepted` - requests that have been accepted by the client
  * `Request.expired` - requests that have not been reconfirmed

The app should be hosted on a free Heroku hosting plan.

To see the deployment to heroku [clik here](https://thawing-depths-93802.herokuapp.com/)
