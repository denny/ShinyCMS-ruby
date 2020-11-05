# ShinyCMS: dev notes

## Mailing Lists ( / Discussion Groups / Forums )

### (Warning! MASSIVE creature feep occurring here!)

Things which aren't optional:  
* Double opt-in subscriptions are a basic human right ;)
* Instantly-effective unsubscribe links and headers in all list emails
* Settings with privacy implications should default to the more private setting

General thoughts:  
* UUIDs for anything that doesn't have slugs - do not expose sequential IDs!
  * Good time to switch the whole system to UUIDs under the hood?
    * Having read around on this, not convinced it's a good idea
  * HashIDs instead? https://github.com/jcypret/hashid-rails

Lists / Groups:  
* Enabled (emails will be delivered): yes/no
* List details page
  * Useful info: description, owner/admins, etc
  * Useful links: sub/unsub, view archives, view subscribers, etc
    * Subscriber list is: visible/hidden
* Hidden: yes/no
* Publicised (listed on hub page of some sort): yes/no
* Open for subscriptions: yes/no / see 'List subscriptions' below

List categories:  
* e.g. Announcements/Promo/Discussion/etc
* Partly for display purposes, partly for potential ACL stuff (see 'Admins')

List subscriptions:  
* Can ask to subscribe: anybody / registered website users / nobody
* Subscriptions require approval: yes/no
  * Subscriptions can be approved by: any subscriber / established subscribers
    / >N/>N% subscribers / registered users / admins only
* Subscribers can be removed by: [ see previous list ]
* When somebody unsubscribes by any interface other than the 'manage all subs'
  page, we should include details of any other lists they are still subscribed
  to in the unsub confirmation email, and give them both the 'manage your
  subscriptions' link and also a one-click 'unsubscribe from everything' link
  (if they're leaving, they're leaving - making it harder for them is pointless)
* List is notified of subscriptions and unsubscriptions: yes/no

List archives:  
  * Web view of previous posts to a list
  * Provides 'view this email in your browser' functionality
  * Viewable by: anybody / subscribers / admins / nobody
    * Subscribers can see posts from before they subscribed: yes/no

List posts:  
* Can post to list: any subscriber / subscribers over X duration / subscribers
  over N previous posts / admins only
* Reply-to munging (trollolol): yes/no
* Show email of sender: yes/partial/obfuscated/no
* Show name of sender: yes/no

Moderation:  
* Posts to list require approval if they are from: anybody / unregistered
  users / new subscribers (<N posts / <X duration) / non-admins
* Posts to list can be approved by: anybody (except the original poster) /
  established subscribers / the collective vote of >N or >N% subscribers /
  registered users / admins only

Tracking (for marketing?) and Engagement (list quality/sender reputation):  
* Opens are tracked: yes/no
 * Is it possible to filter out 'opens' by spam-scanning software (etc) that
   downloads images (including our tracking pixels)? Look at user-agents maybe?
* Clicks are tracked: yes/no
  * Again, can we filter out link-following by software?
  * Track all the details of a click (probably for marketing) or just the fact
    that 'a click happened' (enough for engagement): detail/no detail
  * If opens and/or clicks are tracked, use them to disable emails to
    potentially-unengaged people after X duration / N emails: yes/no
    * Ask people before disabling emails to them: yes/no
* If people don't engage with emails OR web UI, disable their subscription
  entirely? (Do I want the word 'subscription' here or 'membership'- I'm back
  to wondering whether 'lists' and 'groups' are the same thing, or should be)


### Per subscriber per list config

* Receive emails sent to list: yes/no
  * Receive emails in digest format (daily/weekly?)  yes/no


## 'Admins'

(This is a near-fractal timesink of potential granularity and configurability -
it will definitely need its own ACL system/subsystem eventually.)

e.g.  
* A list/group can have: owner(s?) / admins / moderators
  * owners can create/remove admins
  * admins can delete list?
* Categories can have: ditto, and:
  * owners can edit category, create/remove admins
  * admins can create/delete lists
* The whole system has: same again? plus:
  * owners can create categories
  * etc


## Enhancements for later (because this list isn't long enough already)

* Web UI
  * 'Forum style' web interface that can be used to read and post to list too
  * Extension of 'view archives' above, or replacement for it?
    * Somewhere around here this turns from a mailing list feature into a 'groups' feature
* Ratings:
  * Rate posts (this is only really viable if there's a web interface I think)
  * Rate people (reputation systems omg)
* More options for posts:
  * Restrict post length to: NN characters
    * Posts over this length are: rejected/truncated
  * Only NN posts per subscriber per HH hours
  * Delay before distributing each post: NN minutes
* More options for subscriptions:
  * Pay to subscribe (once the system has payment handlers implemented)
  * Autoresponders
  * 'Timed series' emails
    * Could be triggered by
      * System (new user signs up -> triggers onboarding series
      * Admin *shrug*
      * User request
        * Via web UI
        * Via autoresponder
        * Via 'pay to subscribe' ("Buy our six week 'learn to cook' course!", etc)
