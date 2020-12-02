# ShinyCMS Developer Documentation

## User personas

I sometimes get tangled up in worrying about what to call different types of people who could be a 'user' of this project... so I'm throwing some thoughts into this file to get them out of my head :)

In future, for each of these personas, it could be useful to think about:
* What features might they want
* What documentation might help them
* What tools might help them


### Developers / CMS Developers

People who are adding new features to ShinyCMS, or modifying existing features.

The main/direct 'users' for these people are Site Builders - but depending on what features they're working on, they almost certainly need to think about all the different types of Admins and Users as well.

#### Theme Developers

People who contribute ready-to-use themes (view templates, CSS and image assets, etc) to ShinyCMS.


### Site Builders / Site Developers

People who are building a site on top of ShinyCMS.

The main/direct 'users' for these people are Admins, although obviously they will need to think about Users as well.

Note: To a site admin, these are their 'developers'


### Admins

People with admin capabilities on a ShinyCMS site.

For these people, 'users' probably means a combination of logged-in Users and Visitors

#### Moderators

People with comment moderation capabilities on a ShinyCMS site (a 'low-powered' type of Admin).


### Users

#### Authenticated Users / Logged-in Users

People with (and logged into) a user account on a ShinyCMS site.

### Visitors

People visiting a ShinyCMS site who do not have a user account (or who are not logged into their user account).

#### Email recipients

People without a user account (Visitors) who have requested to receive emails from a ShinyCMS site (newsletters, comment reply notifications, etc).


#### Involuntary users (!)

People who receive email from a ShinyCMS site who did not request that email - whether through mistake (typos etc) or malice (DDoS inbox flooding, etc).

We should be aiming for this to be as non-terrible an experience for them as is possible under the circumstances:
* Reassuring default text in registration emails
    * ("If you do not click the link the account will be deleted in X days", etc)
* Clear signposting to the 'do not contact' feature in case they're being maliciously attacked
    * (or in case they want to block us 'just to be sure'; it's their inbox, if we've mistakenly invaded it then let's do our best to reassure them it won't happen again, however they prefer to achieve that)
