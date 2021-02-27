# ShinyCMS Developer Documentation

## Supporting code: concerns, helpers, and other modules

There are a fairly large number of supporting modules provided with ShinyCMS (at the time of writing there are 25 model concerns, 6 controller concerns, 22 helpers, and 3 other support modules).

Most of these 'DRY up' functionality that is used (or that could be used) in multiple places - often in multiple feature plugins.

As well as that, they are intended to make it easier for other developers to build new feature plugins that work similarly to the existing features. This should help new plugins, and ShinyCMS as a whole, be '[less astonishing][1]' - for users, and for developers.

* [Model concerns](model-concerns.md)

* [Controller concerns](controller-concerns.md)

* [Helpers](helpers.md)

* [Other modules](other-modules.md)


> ["A user interface is well-designed when the program behaves exactly how the user thought it would."](http://www.joelonsoftware.com/uibook/chapters/fog0000000057.html) -- Joel on Software


[1]: https://en.wikipedia.org/wiki/Principle_of_least_astonishment 'Principle of Least Astonishment'
